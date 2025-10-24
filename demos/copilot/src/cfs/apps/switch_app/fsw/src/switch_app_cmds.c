/************************************************************************
 * SPDX-License-Identifier: Apache-2.0
 *
 * NASA Docket No. GSC-18,719-1, and identified as “core Flight System: Bootes”
 *
 * Copyright (c) 2020 United States Government as represented by the
 * Administrator of the National Aeronautics and Space Administration.
 * All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License. You may obtain
 * a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 ************************************************************************/

/**
 * \file
 *   This file contains the source code for the Sample App Ground Command-handling functions
 */

/*
** Include Files:
*/
#include "switch_app.h"
#include "switch_app_cmds.h"
#include "switch_app_msgids.h"
#include "switch_app_eventids.h"
#include "switch_app_version.h"
#include "switch_app_tbl.h"
#include "switch_app_utils.h"
#include "switch_app_msg.h"

/* The sample_lib module provides the SAMPLE_Function() prototype */
#include "sample_lib.h"

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/*  Purpose:                                                                  */
/*         This function is triggered in response to a task telemetry request */
/*         from the housekeeping task. This function will gather the Apps     */
/*         telemetry, packetize it and send it to the housekeeping task via   */
/*         the software bus                                                   */
/* * * * * * * * * * * * * * * * * * * * * * * *  * * * * * * *  * *  * * * * */
CFE_Status_t SWITCH_APP_SendHkCmd(const SWITCH_APP_SendHkCmd_t *Msg)
{
    int i;

    /*
    ** Get command execution counters...
    */
    SWITCH_APP_Data.HkTlm.Payload.CommandErrorCounter = SWITCH_APP_Data.ErrCounter;
    SWITCH_APP_Data.HkTlm.Payload.CommandCounter      = SWITCH_APP_Data.CmdCounter;

    /*
    ** Send housekeeping telemetry packet...
    */
    CFE_SB_TimeStampMsg(CFE_MSG_PTR(SWITCH_APP_Data.HkTlm.TelemetryHeader));
    CFE_SB_TransmitMsg(CFE_MSG_PTR(SWITCH_APP_Data.HkTlm.TelemetryHeader), true);

    /*
    ** Manage any pending table loads, validations, etc.
    */
    for (i = 0; i < SWITCH_APP_NUMBER_OF_TABLES; i++)
    {
        CFE_TBL_Manage(SWITCH_APP_Data.TblHandles[i]);
    }

    return CFE_SUCCESS;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/* SAMPLE NOOP commands                                                       */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
CFE_Status_t SWITCH_APP_NoopCmd(const SWITCH_APP_NoopCmd_t *Msg)
{
    SWITCH_APP_Data.CmdCounter++;

    CFE_EVS_SendEvent(SWITCH_APP_NOOP_INF_EID, CFE_EVS_EventType_INFORMATION, "SAMPLE: NOOP command %s",
                      SWITCH_APP_VERSION);

    return CFE_SUCCESS;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/*  Purpose:                                                                  */
/*         This function resets all the global counter variables that are     */
/*         part of the task telemetry.                                        */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * *  * * * * * * *  * *  * * * * */
CFE_Status_t SWITCH_APP_ResetCountersCmd(const SWITCH_APP_ResetCountersCmd_t *Msg)
{
    SWITCH_APP_Data.CmdCounter = 0;
    SWITCH_APP_Data.ErrCounter = 0;

    CFE_EVS_SendEvent(SWITCH_APP_RESET_INF_EID, CFE_EVS_EventType_INFORMATION, "SAMPLE: RESET command");

    return CFE_SUCCESS;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/*  Purpose:                                                                  */
/*         This function Process Ground Station Command                       */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * *  * * * * * * *  * *  * * * * */
CFE_Status_t SWITCH_APP_ProcessCmd(const SWITCH_APP_ProcessCmd_t *Msg)
{
    CFE_Status_t               Status;
    void *                     TblAddr;
    SWITCH_APP_ExampleTable_t *TblPtr;
    const char *               TableName = "SWITCH_APP.ExampleTable";

    /* Sample Use of Example Table */
    SWITCH_APP_Data.CmdCounter++;
    Status = CFE_TBL_GetAddress(&TblAddr, SWITCH_APP_Data.TblHandles[0]);
    if (Status < CFE_SUCCESS)
    {
        CFE_ES_WriteToSysLog("Sample App: Fail to get table address: 0x%08lx", (unsigned long)Status);
    }
    else
    {
        TblPtr = TblAddr;
        CFE_ES_WriteToSysLog("Sample App: Example Table Value 1: %d  Value 2: %d", TblPtr->Int1, TblPtr->Int2);

        SWITCH_APP_GetCrc(TableName);

        Status = CFE_TBL_ReleaseAddress(SWITCH_APP_Data.TblHandles[0]);
        if (Status != CFE_SUCCESS)
        {
            CFE_ES_WriteToSysLog("Sample App: Fail to release table address: 0x%08lx", (unsigned long)Status);
        }
        else
        {
            /* Invoke a function provided by SWITCH_APP_LIB */
            SAMPLE_LIB_Function();
        }
    }

    return Status;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/* A simple example command that displays a passed-in value                   */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
CFE_Status_t SWITCH_APP_DisplayParamCmd(const SWITCH_APP_DisplayParamCmd_t *Msg)
{
    SWITCH_APP_Data.CmdCounter++;
    CFE_EVS_SendEvent(SWITCH_APP_VALUE_INF_EID, CFE_EVS_EventType_INFORMATION,
                      "SWITCH_APP: ValU32=%lu, ValI16=%d, ValStr=%s", (unsigned long)Msg->Payload.ValU32,
                      (int)Msg->Payload.ValI16, Msg->Payload.ValStr);

    return CFE_SUCCESS;
}

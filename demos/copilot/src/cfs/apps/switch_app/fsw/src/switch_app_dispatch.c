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
 *   This file contains the source code for the Sample App.
 */

/*
** Include Files:
*/
#include "switch_app.h"
#include "switch_app_dispatch.h"
#include "switch_app_cmds.h"
#include "switch_app_eventids.h"
#include "switch_app_msgids.h"
#include "switch_app_msg.h"

#include "extra.h"

lights_cmd_t lights_message;

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/* Verify command packet length                                               */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
bool SWITCH_APP_VerifyCmdLength(const CFE_MSG_Message_t *MsgPtr, size_t ExpectedLength)
{
    bool              result       = true;
    size_t            ActualLength = 0;
    CFE_SB_MsgId_t    MsgId        = CFE_SB_INVALID_MSG_ID;
    CFE_MSG_FcnCode_t FcnCode      = 0;

    CFE_MSG_GetSize(MsgPtr, &ActualLength);

    /*
    ** Verify the command packet length.
    */
    if (ExpectedLength != ActualLength)
    {
        CFE_MSG_GetMsgId(MsgPtr, &MsgId);
        CFE_MSG_GetFcnCode(MsgPtr, &FcnCode);

        CFE_EVS_SendEvent(SWITCH_APP_CMD_LEN_ERR_EID, CFE_EVS_EventType_ERROR,
                          "Invalid Msg length: ID = 0x%X,  CC = %u, Len = %u, Expected = %u",
                          (unsigned int)CFE_SB_MsgIdToValue(MsgId), (unsigned int)FcnCode, (unsigned int)ActualLength,
                          (unsigned int)ExpectedLength);

        result = false;

        SWITCH_APP_Data.ErrCounter++;
    }

    return result;
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/* SAMPLE ground commands                                                     */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
void SWITCH_APP_ProcessGroundCommand(const CFE_SB_Buffer_t *SBBufPtr)
{
    CFE_MSG_FcnCode_t CommandCode = 0;

    CFE_MSG_GetFcnCode(&SBBufPtr->Msg, &CommandCode);

    /*
    ** Process SAMPLE app ground commands
    */
    switch (CommandCode)
    {
        case SWITCH_APP_NOOP_CC:
            if (SWITCH_APP_VerifyCmdLength(&SBBufPtr->Msg, sizeof(SWITCH_APP_NoopCmd_t)))
            {
                SWITCH_APP_NoopCmd((const SWITCH_APP_NoopCmd_t *)SBBufPtr);
            }
            break;

        case SWITCH_APP_RESET_COUNTERS_CC:
            if (SWITCH_APP_VerifyCmdLength(&SBBufPtr->Msg, sizeof(SWITCH_APP_ResetCountersCmd_t)))
            {
                SWITCH_APP_ResetCountersCmd((const SWITCH_APP_ResetCountersCmd_t *)SBBufPtr);
            }
            break;

        case SWITCH_APP_PROCESS_CC:
            if (SWITCH_APP_VerifyCmdLength(&SBBufPtr->Msg, sizeof(SWITCH_APP_ProcessCmd_t)))
            {
                SWITCH_APP_ProcessCmd((const SWITCH_APP_ProcessCmd_t *)SBBufPtr);
            }
            break;

        case SWITCH_APP_DISPLAY_PARAM_CC:
            if (SWITCH_APP_VerifyCmdLength(&SBBufPtr->Msg, sizeof(SWITCH_APP_DisplayParamCmd_t)))
            {
                SWITCH_APP_DisplayParamCmd((const SWITCH_APP_DisplayParamCmd_t *)SBBufPtr);
            }
            break;

        /* default case already found during FC vs length test */
        default:
            CFE_EVS_SendEvent(SWITCH_APP_CC_ERR_EID, CFE_EVS_EventType_ERROR, "Invalid ground command code: CC = %d",
                              CommandCode);
            break;
    }
}

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * **/
/*                                                                            */
/*  Purpose:                                                                  */
/*     This routine will process any packet that is received on the SAMPLE    */
/*     command pipe.                                                          */
/*                                                                            */
/* * * * * * * * * * * * * * * * * * * * * * * *  * * * * * * *  * *  * * * * */
void SWITCH_APP_TaskPipe(const CFE_SB_Buffer_t *SBBufPtr)
{
    CFE_SB_MsgId_t MsgId = CFE_SB_INVALID_MSG_ID;

    CFE_MSG_GetMsgId(&SBBufPtr->Msg, &MsgId);

    switch (CFE_SB_MsgIdToValue(MsgId))
    {
        case SWITCH_APP_CMD_MID:
            SWITCH_APP_ProcessGroundCommand(SBBufPtr);
            break;

        case SWITCH_APP_SEND_HK_MID:
            SWITCH_APP_SendHkCmd((const SWITCH_APP_SendHkCmd_t *)SBBufPtr);
            break;

        case GROUND_LIGHTS_COMMAND:
            GROUND_ProcessLightsCommand(SBBufPtr);
            break;

        default:
            CFE_EVS_SendEvent(SWITCH_APP_MID_ERR_EID, CFE_EVS_EventType_ERROR,
                              "SAMPLE: invalid command packet,MID = 0x%x", (unsigned int)CFE_SB_MsgIdToValue(MsgId));
            break;
    }
}

/**
* Make received data available to Copilot and run monitors.
*/
void GROUND_ProcessLightsCommand(const CFE_SB_Buffer_t *SBBufPtr)
{
    ground_lights_cmd_t* msg;
    msg = (ground_lights_cmd_t*) (&SBBufPtr->Msg);

    CFE_MSG_Init(CFE_MSG_PTR(lights_message.CommandHeader), CFE_SB_ValueToMsgId(LIGHTS_COMMAND),
                 sizeof(lights_message));

    CFE_SB_TimeStampMsg(CFE_MSG_PTR(lights_message.CommandHeader));
    lights_message.payload = msg->payload;

    CFE_SB_TransmitMsg((CFE_MSG_Message_t *)&lights_message, true);

    CFE_EVS_SendEvent(SWITCH_APP_LIGHTS_CHANGE_EID, CFE_EVS_EventType_INFORMATION,
                      "SWITCH: requested to change light status to %d", (int32_t)msg->payload);
}

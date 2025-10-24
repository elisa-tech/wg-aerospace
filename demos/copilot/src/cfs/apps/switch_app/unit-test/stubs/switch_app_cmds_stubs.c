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
 * @file
 *
 * Auto-Generated stub implementations for functions defined in switch_app_cmds header
 */

#include "switch_app_cmds.h"
#include "utgenstub.h"

/*
 * ----------------------------------------------------
 * Generated stub function for SWITCH_APP_DisplayParamCmd()
 * ----------------------------------------------------
 */
CFE_Status_t SWITCH_APP_DisplayParamCmd(const SWITCH_APP_DisplayParamCmd_t *Msg)
{
    UT_GenStub_SetupReturnBuffer(SWITCH_APP_DisplayParamCmd, CFE_Status_t);

    UT_GenStub_AddParam(SWITCH_APP_DisplayParamCmd, const SWITCH_APP_DisplayParamCmd_t *, Msg);

    UT_GenStub_Execute(SWITCH_APP_DisplayParamCmd, Basic, NULL);

    return UT_GenStub_GetReturnValue(SWITCH_APP_DisplayParamCmd, CFE_Status_t);
}

/*
 * ----------------------------------------------------
 * Generated stub function for SWITCH_APP_NoopCmd()
 * ----------------------------------------------------
 */
CFE_Status_t SWITCH_APP_NoopCmd(const SWITCH_APP_NoopCmd_t *Msg)
{
    UT_GenStub_SetupReturnBuffer(SWITCH_APP_NoopCmd, CFE_Status_t);

    UT_GenStub_AddParam(SWITCH_APP_NoopCmd, const SWITCH_APP_NoopCmd_t *, Msg);

    UT_GenStub_Execute(SWITCH_APP_NoopCmd, Basic, NULL);

    return UT_GenStub_GetReturnValue(SWITCH_APP_NoopCmd, CFE_Status_t);
}

/*
 * ----------------------------------------------------
 * Generated stub function for SWITCH_APP_ProcessCmd()
 * ----------------------------------------------------
 */
CFE_Status_t SWITCH_APP_ProcessCmd(const SWITCH_APP_ProcessCmd_t *Msg)
{
    UT_GenStub_SetupReturnBuffer(SWITCH_APP_ProcessCmd, CFE_Status_t);

    UT_GenStub_AddParam(SWITCH_APP_ProcessCmd, const SWITCH_APP_ProcessCmd_t *, Msg);

    UT_GenStub_Execute(SWITCH_APP_ProcessCmd, Basic, NULL);

    return UT_GenStub_GetReturnValue(SWITCH_APP_ProcessCmd, CFE_Status_t);
}

/*
 * ----------------------------------------------------
 * Generated stub function for SWITCH_APP_ResetCountersCmd()
 * ----------------------------------------------------
 */
CFE_Status_t SWITCH_APP_ResetCountersCmd(const SWITCH_APP_ResetCountersCmd_t *Msg)
{
    UT_GenStub_SetupReturnBuffer(SWITCH_APP_ResetCountersCmd, CFE_Status_t);

    UT_GenStub_AddParam(SWITCH_APP_ResetCountersCmd, const SWITCH_APP_ResetCountersCmd_t *, Msg);

    UT_GenStub_Execute(SWITCH_APP_ResetCountersCmd, Basic, NULL);

    return UT_GenStub_GetReturnValue(SWITCH_APP_ResetCountersCmd, CFE_Status_t);
}

/*
 * ----------------------------------------------------
 * Generated stub function for SWITCH_APP_SendHkCmd()
 * ----------------------------------------------------
 */
CFE_Status_t SWITCH_APP_SendHkCmd(const SWITCH_APP_SendHkCmd_t *Msg)
{
    UT_GenStub_SetupReturnBuffer(SWITCH_APP_SendHkCmd, CFE_Status_t);

    UT_GenStub_AddParam(SWITCH_APP_SendHkCmd, const SWITCH_APP_SendHkCmd_t *, Msg);

    UT_GenStub_Execute(SWITCH_APP_SendHkCmd, Basic, NULL);

    return UT_GenStub_GetReturnValue(SWITCH_APP_SendHkCmd, CFE_Status_t);
}

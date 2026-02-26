// SPDX-License-Identifier: MIT

#define LIGHTS_COMMAND_TOPIC_ID 0x1878
#define LIGHTS_COMMAND CFE_PLATFORM_CMD_TOPICID_TO_MIDV(LIGHTS_COMMAND_TOPIC_ID)

#define LIGHTS_STATUS_TOPIC_ID 0x1978
#define LIGHTS_STATUS CFE_PLATFORM_CMD_TOPICID_TO_MIDV(LIGHTS_STATUS_TOPIC_ID)

typedef struct lights_cmd_t {
  CFE_MSG_CommandHeader_t CmdHeader;
  bool payload;
} lights_cmd_t;

typedef struct lights_status_t {
  CFE_MSG_TelemetryHeader_t TlmHeader;
  bool payload;
} lights_status_t;

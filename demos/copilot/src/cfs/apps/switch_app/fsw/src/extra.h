// SPDX-License-Identifier: Apache-2.0

#define GROUND_LIGHTS_COMMAND_TOPIC_ID 0x1A78
#define GROUND_LIGHTS_COMMAND CFE_PLATFORM_CMD_TOPICID_TO_MIDV(GROUND_LIGHTS_COMMAND_TOPIC_ID)

#define LIGHTS_COMMAND_TOPIC_ID 0x1878
#define LIGHTS_COMMAND CFE_PLATFORM_CMD_TOPICID_TO_MIDV(LIGHTS_COMMAND_TOPIC_ID)

typedef struct ground_lights_cmd_t {
   CFE_MSG_CommandHeader_t CommandHeader;
   bool payload;
} ground_lights_cmd_t;

typedef struct lights_cmd_t {
   CFE_MSG_CommandHeader_t CommandHeader;
   bool payload;
} lights_cmd_t;

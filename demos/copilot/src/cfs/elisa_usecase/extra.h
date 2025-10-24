#define SAMPLE_TOPIC_ID 0x1878
#define SAMPLE_MID CFE_PLATFORM_CMD_TOPICID_TO_MIDV(SAMPLE_TOPIC_ID)

typedef struct sample_msg {
   CFE_MSG_CommandHeader_t CmdHeader;
   int32_t payload;
} sample_msg_t;

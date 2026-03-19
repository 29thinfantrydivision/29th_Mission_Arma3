#define ROUND_IDLE (TN_round_state isEqualTo 0)
#define ROUND_SAFE (TN_round_state isEqualTo 1)
#define ROUND_LIVE (TN_round_state isEqualTo 2)

#define NOT_ROUND_IDLE (TN_round_state isNotEqualTo 0)
#define NOT_ROUND_SAFE (TN_round_state isNotEqualTo 1)
#define NOT_ROUND_LIVE (TN_round_state isNotEqualTo 2)

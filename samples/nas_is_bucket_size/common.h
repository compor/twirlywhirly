// Common parameters for both approaches.

// Parameters for class S:
/* #define NUM_KEYS 65536 */
/* #define SIZE_OF_BUFFERS NUM_KEYS */
/* #define NUM_BUCKETS 512 */
/* #define MAX_KEY_LOG_2 11 */
/* #define NUM_BUCKETS_LOG_2 9 */

// Reduced parameters, for feasibility:
#define NUM_KEYS 4
#define SIZE_OF_BUFFERS NUM_KEYS
#define NUM_BUCKETS 4
#define MAX_KEY_LOG_2 4
#define NUM_BUCKETS_LOG_2 2

// Swap parameters:
#define MAX_SWAPS 2

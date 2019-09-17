#ifndef SNET_INTERNAL_H__
#define SNET_INTERNAL_H__


#ifdef SNET_DEBUG
#define DEBUG(...)                                      \
    do {                                                \
        printf("%s:%d: ", __FILENAME__, __LINE__);      \
        printf(__VA_ARGS__);                            \
    } while (0)
#else
#define DEBUG(...)
#endif


#endif

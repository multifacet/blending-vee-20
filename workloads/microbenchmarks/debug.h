/************************************************************
 * debug.h -- helper functions for debugging
 * Author: Venkat
 *************************************************************/

#ifndef __DEBUG_H__
#define __DEBUG_H__

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE);	\
  } while (0)

#define errMsg(msg)  do { perror(msg); } while (0)


#define INFO

#ifndef ERROR
#define ERROR
#endif

#ifdef DEBUG
#define ERROR
#define INFO
#endif

#ifdef DEBUG
#define PDEBUG(fmt, ...) do { \
        fprintf(stderr, fmt, __VA_ARGS__); \
    } while (0)
#else
#define PDEBUG(fmt, ...) do {} while (0)
#endif

#ifdef INFO
#define PINFO(fmt, ...) do { \
        fprintf(stderr, fmt, __VA_ARGS__); \
    } while (0)
#else
#define PINFO(fmt, ...) do {} while (0)
#endif

#ifdef ERROR
#define PERR(fmt, ...) do { \
        fprintf(stderr, fmt, __VA_ARGS__); \
    } while (0)
#else
#define PERR(fmt, ...) do {} while (0)
#endif


#endif  //__DEBUG_H__

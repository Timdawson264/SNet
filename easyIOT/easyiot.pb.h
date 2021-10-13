/* Automatically generated nanopb header */
/* Generated by nanopb-0.4.5 */

#ifndef PB_EASYIOT_PB_H_INCLUDED
#define PB_EASYIOT_PB_H_INCLUDED
#include <pb.h>

#if PB_PROTO_HEADER_VERSION != 40
#error Regenerate this file with the current version of nanopb generator.
#endif

/* Enum definitions */
typedef enum _IO_TYPE { 
    IO_TYPE_digital_output = 0, /* type bool */
    IO_TYPE_digital_input = 1, /* type bool */
    IO_TYPE_analogue_input = 2, /* type float */
    IO_TYPE_analogue_output = 3, /* type float */
    IO_TYPE_data_output = 4, /* type [bytes] */
    IO_TYPE_data_input = 5, /* type [bytes] */
    IO_TYPE_rpc_type = 6 /* function call type. */
} IO_TYPE;

typedef enum _IO_ERROR { 
    IO_ERROR_incorrect_direction = 0, 
    IO_ERROR_out_of_range = 1 
} IO_ERROR;

/* Struct definitions */
/* Request status of an IO(s) 
If ids is empty, return all inputs */
typedef struct _get_ios { 
    pb_callback_t ids; 
} get_ios;

typedef struct _get_ios_resp { 
    pb_callback_t ios; 
} get_ios_resp;

/* Message to write to IO outputs */
typedef struct _set_ios { 
    pb_callback_t ios; 
} set_ios;

typedef struct _io_description { 
    char *description; 
    IO_TYPE type; 
} io_description;

/* Response to get_io */
typedef struct _io_val { 
    int8_t id; 
    bool has_error;
    IO_ERROR error; 
    pb_size_t which_io_value;
    union {
        bool d_val;
        float a_val;
    } io_value; 
} io_val;

typedef struct _device_description { 
    char *device_name; 
    pb_size_t ios_count;
    io_description ios[8]; 
} device_description;


/* Helper constants for enums */
#define _IO_TYPE_MIN IO_TYPE_digital_output
#define _IO_TYPE_MAX IO_TYPE_rpc_type
#define _IO_TYPE_ARRAYSIZE ((IO_TYPE)(IO_TYPE_rpc_type+1))

#define _IO_ERROR_MIN IO_ERROR_incorrect_direction
#define _IO_ERROR_MAX IO_ERROR_out_of_range
#define _IO_ERROR_ARRAYSIZE ((IO_ERROR)(IO_ERROR_out_of_range+1))


#ifdef __cplusplus
extern "C" {
#endif

/* Initializer values for message structs */
#define io_description_init_default              {NULL, _IO_TYPE_MIN}
#define device_description_init_default          {NULL, 0, {io_description_init_default, io_description_init_default, io_description_init_default, io_description_init_default, io_description_init_default, io_description_init_default, io_description_init_default, io_description_init_default}}
#define io_val_init_default                      {0, false, _IO_ERROR_MIN, 0, {0}}
#define get_ios_init_default                     {{{NULL}, NULL}}
#define get_ios_resp_init_default                {{{NULL}, NULL}}
#define set_ios_init_default                     {{{NULL}, NULL}}
#define io_description_init_zero                 {NULL, _IO_TYPE_MIN}
#define device_description_init_zero             {NULL, 0, {io_description_init_zero, io_description_init_zero, io_description_init_zero, io_description_init_zero, io_description_init_zero, io_description_init_zero, io_description_init_zero, io_description_init_zero}}
#define io_val_init_zero                         {0, false, _IO_ERROR_MIN, 0, {0}}
#define get_ios_init_zero                        {{{NULL}, NULL}}
#define get_ios_resp_init_zero                   {{{NULL}, NULL}}
#define set_ios_init_zero                        {{{NULL}, NULL}}

/* Field tags (for use in manual encoding/decoding) */
#define get_ios_ids_tag                          1
#define get_ios_resp_ios_tag                     1
#define set_ios_ios_tag                          1
#define io_description_description_tag           1
#define io_description_type_tag                  2
#define io_val_id_tag                            1
#define io_val_error_tag                         2
#define io_val_d_val_tag                         3
#define io_val_a_val_tag                         4
#define device_description_device_name_tag       1
#define device_description_ios_tag               2

/* Struct field encoding specification for nanopb */
#define io_description_FIELDLIST(X, a) \
X(a, POINTER,  REQUIRED, STRING,   description,       1) \
X(a, STATIC,   REQUIRED, UENUM,    type,              2)
#define io_description_CALLBACK NULL
#define io_description_DEFAULT NULL

#define device_description_FIELDLIST(X, a) \
X(a, POINTER,  REQUIRED, STRING,   device_name,       1) \
X(a, STATIC,   REPEATED, MESSAGE,  ios,               2)
#define device_description_CALLBACK NULL
#define device_description_DEFAULT NULL
#define device_description_ios_MSGTYPE io_description

#define io_val_FIELDLIST(X, a) \
X(a, STATIC,   REQUIRED, INT32,    id,                1) \
X(a, STATIC,   OPTIONAL, UENUM,    error,             2) \
X(a, STATIC,   ONEOF,    BOOL,     (io_value,d_val,io_value.d_val),   3) \
X(a, STATIC,   ONEOF,    FLOAT,    (io_value,a_val,io_value.a_val),   4)
#define io_val_CALLBACK NULL
#define io_val_DEFAULT NULL

#define get_ios_FIELDLIST(X, a) \
X(a, CALLBACK, REPEATED, INT32,    ids,               1)
#define get_ios_CALLBACK pb_default_field_callback
#define get_ios_DEFAULT NULL

#define get_ios_resp_FIELDLIST(X, a) \
X(a, CALLBACK, REPEATED, MESSAGE,  ios,               1)
#define get_ios_resp_CALLBACK pb_default_field_callback
#define get_ios_resp_DEFAULT NULL
#define get_ios_resp_ios_MSGTYPE io_val

#define set_ios_FIELDLIST(X, a) \
X(a, CALLBACK, REPEATED, MESSAGE,  ios,               1)
#define set_ios_CALLBACK pb_default_field_callback
#define set_ios_DEFAULT NULL
#define set_ios_ios_MSGTYPE io_val

extern const pb_msgdesc_t io_description_msg;
extern const pb_msgdesc_t device_description_msg;
extern const pb_msgdesc_t io_val_msg;
extern const pb_msgdesc_t get_ios_msg;
extern const pb_msgdesc_t get_ios_resp_msg;
extern const pb_msgdesc_t set_ios_msg;

/* Defines for backwards compatibility with code written before nanopb-0.4.0 */
#define io_description_fields &io_description_msg
#define device_description_fields &device_description_msg
#define io_val_fields &io_val_msg
#define get_ios_fields &get_ios_msg
#define get_ios_resp_fields &get_ios_resp_msg
#define set_ios_fields &set_ios_msg

/* Maximum encoded size of messages (where known) */
/* io_description_size depends on runtime parameters */
/* device_description_size depends on runtime parameters */
/* get_ios_size depends on runtime parameters */
/* get_ios_resp_size depends on runtime parameters */
/* set_ios_size depends on runtime parameters */
#define io_val_size                              18

#ifdef __cplusplus
} /* extern "C" */
#endif

#endif
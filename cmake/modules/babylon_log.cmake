################################################################################
# Babylon log wrappers
################################################################################
cmake_minimum_required(VERSION 3.20.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root project not found")
endif()

# info
macro(babylon_log_info msg)
    message(STATUS "[${PROJECT_NAME}] ${msg}")
endmacro()

# warning
macro(babylon_log_warn msg)
    message(WARNING "[${PROJECT_NAME}] ${msg}")
endmacro()

# error
macro(babylon_log_error msg)
    message(SEND_ERROR "[${PROJECT_NAME}] ${msg}")
endmacro()

# fatal error
macro(babylon_log_fatal msg)
    message(FATAL_ERROR "[${PROJECT_NAME}] ${msg}")
endmacro()

# debug
macro(babylon_log_debug msg)
    message(AUTHOR_WARNING "[${PROJECT_NAME}] ${msg}")
endmacro()

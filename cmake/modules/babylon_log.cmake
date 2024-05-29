################################################################################
# Babylon log wrappers
################################################################################
cmake_minimum_required(VERSION 3.29.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Info
macro(babylon_log_info msg)
    message(STATUS "[${PROJECT_NAME}] ${msg}")
endmacro()

# Warning
macro(babylon_log_warn msg)
    message(WARNING "[${PROJECT_NAME}] ${msg}")
endmacro()

# Error
macro(babylon_log_error msg)
    message(SEND_ERROR "[${PROJECT_NAME}] ${msg}")
endmacro()

# Fatal error
macro(babylon_log_fatal msg)
    message(FATAL_ERROR "[${PROJECT_NAME}] ${msg}")
endmacro()

# Debug
macro(babylon_log_debug msg)
    message(AUTHOR_WARNING "[${PROJECT_NAME}] ${msg}")
endmacro()

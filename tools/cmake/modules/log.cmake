################################################################################
# Babylon log wrappers
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BABYLON_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Info
macro(babylon_log_info MSG)
    message(STATUS "${MSG}")
endmacro()

# Warning
macro(babylon_log_warn MSG)
    message(WARNING "${MSG}")
endmacro()

# Error
macro(babylon_log_error MSG)
    message(SEND_ERROR "${MSG}")
endmacro()

# Fatal error
macro(babylon_log_fatal MSG)
    message(FATAL_ERROR "${MSG}")
endmacro()

# Debug
macro(babylon_log_debug MSG)
    message(AUTHOR_WARNING "${MSG}")
endmacro()

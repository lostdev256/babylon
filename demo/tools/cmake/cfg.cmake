################################################################################
# Babylon additional unit configuration (BUILD_CFG)
################################################################################
cmake_minimum_required(VERSION 3.30.0 FATAL_ERROR)

if(NOT BN_ROOT_DIR)
    message(FATAL_ERROR "Babylon root directory not found")
endif()

# Additional build configuration
function(bn_unit_external_configure_build UNIT_NAME)
    if(NOT TARGET ${UNIT_NAME})
        bn_log_fatal("Babylon unit (${UNIT_NAME}) doesn't exists")
        return()
    endif()
endfunction()

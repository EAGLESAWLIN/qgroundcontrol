function(qgc_setup_dw3000)
    if(NOT QGC_ENABLE_DW3000)
        return()
    endif()

    if(NOT QGC_DW3000_GIT_REPOSITORY)
        message(FATAL_ERROR "QGC_ENABLE_DW3000 is ON but QGC_DW3000_GIT_REPOSITORY is empty")
    endif()
    if(NOT QGC_DW3000_GIT_TAG)
        message(FATAL_ERROR "QGC_ENABLE_DW3000 is ON but QGC_DW3000_GIT_TAG is empty")
    endif()

    message(STATUS "Building DW3000")

    CPMAddPackage(
        NAME dw3000
        GIT_REPOSITORY ${QGC_DW3000_GIT_REPOSITORY}
        GIT_TAG ${QGC_DW3000_GIT_TAG}
    )

    set(_dw3000_target_name "")
    foreach(_dw3000_target dw3000 DW3000 dwt)
        if(TARGET ${_dw3000_target})
            set(_dw3000_target_name ${_dw3000_target})
            break()
        endif()
    endforeach()

    if(_dw3000_target_name STREQUAL "")
        message(FATAL_ERROR "DW3000 integration could not find a library target (tried: dw3000, DW3000, dwt)")
    endif()

    if(NOT TARGET QGC_DW3000)
        add_library(QGC_DW3000 INTERFACE)
        target_link_libraries(QGC_DW3000 INTERFACE ${_dw3000_target_name})
    endif()

    if(NOT TARGET QGC::DW3000)
        add_library(QGC::DW3000 ALIAS QGC_DW3000)
    endif()
endfunction()

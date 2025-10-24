# SPDX-License-Identifier: Apache-2.0

###########################################################
#
# LIGHTS_APP platform build setup
#
# This file is evaluated as part of the "prepare" stage
# and can be used to set up prerequisites for the build,
# such as generating header files
#
###########################################################

# The list of header files that control the LIGHTS_APP configuration
set(LIGHTS_APP_PLATFORM_CONFIG_FILE_LIST
  lights_app_internal_cfg.h
  lights_app_platform_cfg.h
  lights_app_perfids.h
  lights_app_msgids.h
)

# Create wrappers around the all the config header files
# This makes them individually overridable by the missions, without modifying
# the distribution default copies
foreach(LIGHTS_APP_CFGFILE ${LIGHTS_APP_PLATFORM_CONFIG_FILE_LIST})
  get_filename_component(CFGKEY "${LIGHTS_APP_CFGFILE}" NAME_WE)
  if (DEFINED LIGHTS_APP_CFGFILE_SRC_${CFGKEY})
    set(DEFAULT_SOURCE GENERATED_FILE "${LIGHTS_APP_CFGFILE_SRC_${CFGKEY}}")
  else()
    set(DEFAULT_SOURCE FALLBACK_FILE "${CMAKE_CURRENT_LIST_DIR}/config/default_${LIGHTS_APP_CFGFILE}")
  endif()
  generate_config_includefile(
    FILE_NAME           "${LIGHTS_APP_CFGFILE}"
    ${DEFAULT_SOURCE}
  )
endforeach()

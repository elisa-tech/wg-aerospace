# SPDX-License-Identifier: Apache-2.0

###########################################################
#
# SWITCH_APP mission build setup
#
# This file is evaluated as part of the "prepare" stage
# and can be used to set up prerequisites for the build,
# such as generating header files
#
###########################################################

# The list of header files that control the SWITCH_APP configuration
set(SWITCH_APP_MISSION_CONFIG_FILE_LIST
  switch_app_fcncodes.h
  switch_app_interface_cfg.h
  switch_app_mission_cfg.h
  switch_app_perfids.h
  switch_app_msg.h
  switch_app_msgdefs.h
  switch_app_msgstruct.h
  switch_app_tbl.h
  switch_app_tbldefs.h
  switch_app_tblstruct.h
  switch_app_topicids.h
)

if (CFE_EDS_ENABLED_BUILD)

  # In an EDS-based build, these files come generated from the EDS tool
  set(SWITCH_APP_CFGFILE_SRC_switch_app_interface_cfg "switch_app_eds_designparameters.h")
  set(SWITCH_APP_CFGFILE_SRC_switch_app_tbldefs       "switch_app_eds_typedefs.h")
  set(SWITCH_APP_CFGFILE_SRC_switch_app_tblstruct     "switch_app_eds_typedefs.h")
  set(SWITCH_APP_CFGFILE_SRC_switch_app_msgdefs       "switch_app_eds_typedefs.h")
  set(SWITCH_APP_CFGFILE_SRC_switch_app_msgstruct     "switch_app_eds_typedefs.h")
  set(SWITCH_APP_CFGFILE_SRC_switch_app_fcncodes      "switch_app_eds_cc.h")

endif(CFE_EDS_ENABLED_BUILD)

# Create wrappers around the all the config header files
# This makes them individually overridable by the missions, without modifying
# the distribution default copies
foreach(SWITCH_APP_CFGFILE ${SWITCH_APP_MISSION_CONFIG_FILE_LIST})
  get_filename_component(CFGKEY "${SWITCH_APP_CFGFILE}" NAME_WE)
  if (DEFINED SWITCH_APP_CFGFILE_SRC_${CFGKEY})
    set(DEFAULT_SOURCE GENERATED_FILE "${SWITCH_APP_CFGFILE_SRC_${CFGKEY}}")
  else()
    set(DEFAULT_SOURCE FALLBACK_FILE "${CMAKE_CURRENT_LIST_DIR}/config/default_${SWITCH_APP_CFGFILE}")
  endif()
  generate_config_includefile(
    FILE_NAME           "${SWITCH_APP_CFGFILE}"
    ${DEFAULT_SOURCE}
  )
endforeach()

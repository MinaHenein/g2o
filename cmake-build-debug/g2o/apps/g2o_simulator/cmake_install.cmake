# Install script for directory: /home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/lib/libg2o_simulator_d.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/lib" TYPE SHARED_LIBRARY FILES "/home/mina/data/mina/workspace/src/Git/g2o/lib/libg2o_simulator_d.so")
  if(EXISTS "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so"
         OLD_RPATH "/home/mina/data/mina/workspace/src/Git/g2o/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/lib/libg2o_simulator_d.so")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/g2o_simulator2d_d")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE EXECUTABLE FILES "/home/mina/data/mina/workspace/src/Git/g2o/bin/g2o_simulator2d_d")
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d"
         OLD_RPATH "/home/mina/data/mina/workspace/src/Git/g2o/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/bin/g2o_simulator2d_d")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/g2o_simulator3d_d")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE EXECUTABLE FILES "/home/mina/data/mina/workspace/src/Git/g2o/bin/g2o_simulator3d_d")
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d"
         OLD_RPATH "/home/mina/data/mina/workspace/src/Git/g2o/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/bin/g2o_simulator3d_d")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/bin/g2o_anonymize_observations_d")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/bin" TYPE EXECUTABLE FILES "/home/mina/data/mina/workspace/src/Git/g2o/bin/g2o_anonymize_observations_d")
  if(EXISTS "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d"
         OLD_RPATH "/home/mina/data/mina/workspace/src/Git/g2o/lib:"
         NEW_RPATH "")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/bin/g2o_anonymize_observations_d")
    endif()
  endif()
endif()

if("x${CMAKE_INSTALL_COMPONENT}x" STREQUAL "xUnspecifiedx" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/include/g2o/apps/g2o_simulator/g2o_simulator_api.h;/usr/local/include/g2o/apps/g2o_simulator/pointsensorparameters.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_line3d.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_odometry.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_odometry2d.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_odometry3d.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pointxy.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pointxy_bearing.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pointxy_offset.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pointxyz.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pointxyz_depth.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pointxyz_disparity.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pose2d.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pose3d.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_pose3d_offset.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_se3_prior.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_segment2d.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_segment2d_line.h;/usr/local/include/g2o/apps/g2o_simulator/sensor_segment2d_pointline.h;/usr/local/include/g2o/apps/g2o_simulator/simulator.h;/usr/local/include/g2o/apps/g2o_simulator/simulator2d.h;/usr/local/include/g2o/apps/g2o_simulator/simulator2d_base.h;/usr/local/include/g2o/apps/g2o_simulator/simulator3d.h;/usr/local/include/g2o/apps/g2o_simulator/simulator3d_base.h;/usr/local/include/g2o/apps/g2o_simulator/simutils.h")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/usr/local/include/g2o/apps/g2o_simulator" TYPE FILE FILES
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/g2o_simulator_api.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/pointsensorparameters.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_line3d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_odometry.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_odometry2d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_odometry3d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pointxy.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pointxy_bearing.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pointxy_offset.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pointxyz.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pointxyz_depth.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pointxyz_disparity.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pose2d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pose3d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_pose3d_offset.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_se3_prior.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_segment2d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_segment2d_line.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/sensor_segment2d_pointline.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/simulator.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/simulator2d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/simulator2d_base.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/simulator3d.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/simulator3d_base.h"
    "/home/mina/data/mina/workspace/src/Git/g2o/g2o/apps/g2o_simulator/simutils.h"
    )
endif()


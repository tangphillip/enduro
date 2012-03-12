# Install script for directory: /Users/phil/Downloads/wat/opencv/modules/flann

# Set the install prefix
IF(NOT DEFINED CMAKE_INSTALL_PREFIX)
  SET(CMAKE_INSTALL_PREFIX "/Users/phil/Downloads/wat/opencv_ios/tmp/install")
ENDIF(NOT DEFINED CMAKE_INSTALL_PREFIX)
STRING(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
IF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  IF(BUILD_TYPE)
    STRING(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  ELSE(BUILD_TYPE)
    SET(CMAKE_INSTALL_CONFIG_NAME "Release")
  ENDIF(BUILD_TYPE)
  MESSAGE(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
ENDIF(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)

# Set the component getting installed.
IF(NOT CMAKE_INSTALL_COMPONENT)
  IF(COMPONENT)
    MESSAGE(STATUS "Install component: \"${COMPONENT}\"")
    SET(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  ELSE(COMPONENT)
    SET(CMAKE_INSTALL_COMPONENT)
  ENDIF(COMPONENT)
ENDIF(NOT CMAKE_INSTALL_COMPONENT)

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")
  IF("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Dd][Ee][Bb][Uu][Gg])$")
    FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build/lib/Debug/libopencv_flann.a")
    IF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_flann.a" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_flann.a")
      EXECUTE_PROCESS(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_flann.a")
    ENDIF()
  ELSEIF("${CMAKE_INSTALL_CONFIG_NAME}" MATCHES "^([Rr][Ee][Ll][Ee][Aa][Ss][Ee])$")
    FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib" TYPE STATIC_LIBRARY FILES "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build/lib/Release/libopencv_flann.a")
    IF(EXISTS "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_flann.a" AND
       NOT IS_SYMLINK "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_flann.a")
      EXECUTE_PROCESS(COMMAND "/usr/bin/ranlib" "$ENV{DESTDIR}${CMAKE_INSTALL_PREFIX}/lib/libopencv_flann.a")
    ENDIF()
  ENDIF()
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/opencv2/flann" TYPE FILE FILES
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/flann.hpp"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/flann_base.hpp"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/miniflann.hpp"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/all_indices.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/allocator.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/any.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/autotuned_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/composite_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/config.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/defines.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/dist.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/dummy.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/dynamic_bitset.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/general.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/ground_truth.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/hdf5.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/heap.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/hierarchical_clustering_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/index_testing.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/kdtree_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/kdtree_single_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/kmeans_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/linear_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/logger.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/lsh_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/lsh_table.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/matrix.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/nn_index.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/object_factory.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/params.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/random.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/result_set.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/sampling.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/saving.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/simplex_downhill.h"
    "/Users/phil/Downloads/wat/opencv/modules/flann/include/opencv2/flann/timer.h"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")


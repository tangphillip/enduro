# Install script for directory: /Users/phil/Downloads/wat/opencv/doc

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
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/doc" TYPE FILE FILES
    "/Users/phil/Downloads/wat/opencv/doc/haartraining.htm"
    "/Users/phil/Downloads/wat/opencv/doc/check_docs_whitelist.txt"
    "/Users/phil/Downloads/wat/opencv/doc/CMakeLists.txt"
    "/Users/phil/Downloads/wat/opencv/doc/license.txt"
    "/Users/phil/Downloads/wat/opencv/doc/packaging.txt"
    "/Users/phil/Downloads/wat/opencv/doc/opencv.jpg"
    "/Users/phil/Downloads/wat/opencv/doc/acircles_pattern.png"
    "/Users/phil/Downloads/wat/opencv/doc/opencv-logo.png"
    "/Users/phil/Downloads/wat/opencv/doc/opencv-logo2.png"
    "/Users/phil/Downloads/wat/opencv/doc/pattern.png"
    "/Users/phil/Downloads/wat/opencv/doc/opencv2refman.pdf"
    "/Users/phil/Downloads/wat/opencv/doc/opencv_cheatsheet.pdf"
    "/Users/phil/Downloads/wat/opencv/doc/opencv_tutorials.pdf"
    "/Users/phil/Downloads/wat/opencv/doc/opencv_user.pdf"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")

IF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")
  FILE(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/OpenCV/doc/vidsurv" TYPE FILE FILES
    "/Users/phil/Downloads/wat/opencv/doc/vidsurv/Blob_Tracking_Modules.doc"
    "/Users/phil/Downloads/wat/opencv/doc/vidsurv/Blob_Tracking_Tests.doc"
    "/Users/phil/Downloads/wat/opencv/doc/vidsurv/TestSeq.doc"
    )
ENDIF(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "main")


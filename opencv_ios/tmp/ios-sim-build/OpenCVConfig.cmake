# ===================================================================================
#  The OpenCV CMake configuration file
#
#             ** File generated automatically, do not modify **
#
#  Usage from an external project:
#    In your CMakeLists.txt, add these lines:
#
#    FIND_PACKAGE(OpenCV REQUIRED)
#    TARGET_LINK_LIBRARIES(MY_TARGET_NAME ${OpenCV_LIBS})
#
#    Or you can search for specific OpenCV modules:
#
#    FIND_PACKAGE(OpenCV REQUIRED core highgui)
#
#    If the module found then OPENCV_<MODULE>_FOUND is set.
#
#    This file will define the following variables:
#      - 
#      - OpenCV_LIBS                     : The list of libraries to links against.
#      - OpenCV_LIB_DIR                  : The directory(es) where lib files are. Calling LINK_DIRECTORIES
#                                          with this path is NOT needed.
#      - OpenCV_INCLUDE_DIRS             : The OpenCV include directories.
#      - OpenCV_COMPUTE_CAPABILITIES     : The version of compute capability
#      - OpenCV_ANDROID_NATIVE_API_LEVEL : Minimum required level of Android API
#      - OpenCV_VERSION                  : The version of this OpenCV build. Example: "2.3.3"
#      - OpenCV_VERSION_MAJOR            : Major version part of OpenCV_VERSION. Example: "2"
#      - OpenCV_VERSION_MINOR            : Minor version part of OpenCV_VERSION. Example: "3"
#      - OpenCV_VERSION_PATCH            : Patch version part of OpenCV_VERSION. Example: "3"
#
#    Advanced variables:
#      - OpenCV_SHARED
#      - OpenCV_CONFIG_PATH
#      - OpenCV_INSTALL_PATH
#      - OpenCV_LIB_COMPONENTS
#      - OpenCV_USE_MANGLED_PATHS
#      - OpenCV_HAVE_ANDROID_CAMERA
#
# =================================================================================================

# Version Compute Capability from which OpenCV has been compiled is remembered
set(OpenCV_COMPUTE_CAPABILITIES "")

# Android API level from which OpenCV has been compiled is remembered
set(OpenCV_ANDROID_NATIVE_API_LEVEL 0)

# Some additional settings are required if OpenCV is built as static libs
set(OpenCV_SHARED OFF)

# Enables mangled install paths, that help with side by side installs
set(OpenCV_USE_MANGLED_PATHS FALSE)

# Extract the directory where *this* file has been installed (determined at cmake run-time)
get_filename_component(OpenCV_CONFIG_PATH "${CMAKE_CURRENT_LIST_FILE}" PATH)

# Get the absolute path with no ../.. relative marks, to eliminate implicit linker warnings
get_filename_component(OpenCV_INSTALL_PATH "${OpenCV_CONFIG_PATH}/../.." REALPATH)

# Presence of Android native camera wrappers
set(OpenCV_HAVE_ANDROID_CAMERA OFF)

# ======================================================
# Include directories to add to the user project:
# ======================================================

# Provide the include directories to the caller
set(OpenCV_INCLUDE_DIRS "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build" "/Users/phil/Downloads/wat/opencv/include" "/Users/phil/Downloads/wat/opencv/include/opencv")
include_directories(${OpenCV_INCLUDE_DIRS})

# ======================================================
# Link directories to add to the user project:
# ======================================================

# Provide the libs directories to the caller
set(OpenCV_LIB_DIR_OPT "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build/lib")
set(OpenCV_LIB_DIR_DBG "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build/lib")
set(OpenCV_3RDPARTY_LIB_DIR_OPT "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build/3rdparty/lib")
set(OpenCV_3RDPARTY_LIB_DIR_DBG "/Users/phil/Downloads/wat/opencv_ios/tmp/ios-sim-build/3rdparty/lib")

# ======================================================
#  Version variables:
# ======================================================
SET(OpenCV_VERSION 2.3.3)
SET(OpenCV_VERSION_MAJOR  2)
SET(OpenCV_VERSION_MINOR  3)
SET(OpenCV_VERSION_PATCH  3)

# ====================================================================
# Link libraries: e.g.   libopencv_core.so, opencv_imgproc220d.lib, etc...
# ====================================================================

SET(OpenCV_LIB_COMPONENTS opencv_core;opencv_imgproc;opencv_video;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_objdetect;opencv_stitching;opencv_ml;opencv_legacy;opencv_contrib)

set(OpenCV_opencv_core_LIBNAME_OPT "libopencv_core.a")
set(OpenCV_opencv_core_DEPS_OPT zlib)
set(OpenCV_opencv_core_EXTRA_DEPS_OPT )
set(OpenCV_opencv_imgproc_LIBNAME_OPT "libopencv_imgproc.a")
set(OpenCV_opencv_imgproc_DEPS_OPT zlib;opencv_core)
set(OpenCV_opencv_imgproc_EXTRA_DEPS_OPT )
set(OpenCV_opencv_video_LIBNAME_OPT "libopencv_video.a")
set(OpenCV_opencv_video_DEPS_OPT zlib;opencv_core;opencv_imgproc)
set(OpenCV_opencv_video_EXTRA_DEPS_OPT )
set(OpenCV_opencv_highgui_LIBNAME_OPT "libopencv_highgui.a")
set(OpenCV_opencv_highgui_DEPS_OPT zlib;opencv_core;opencv_imgproc)
set(OpenCV_opencv_highgui_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_flann_LIBNAME_OPT "libopencv_flann.a")
set(OpenCV_opencv_flann_DEPS_OPT zlib;opencv_core)
set(OpenCV_opencv_flann_EXTRA_DEPS_OPT )
set(OpenCV_opencv_features2d_LIBNAME_OPT "libopencv_features2d.a")
set(OpenCV_opencv_features2d_DEPS_OPT zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann)
set(OpenCV_opencv_features2d_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_calib3d_LIBNAME_OPT "libopencv_calib3d.a")
set(OpenCV_opencv_calib3d_DEPS_OPT zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d)
set(OpenCV_opencv_calib3d_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_objdetect_LIBNAME_OPT "libopencv_objdetect.a")
set(OpenCV_opencv_objdetect_DEPS_OPT zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d)
set(OpenCV_opencv_objdetect_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_stitching_LIBNAME_OPT "libopencv_stitching.a")
set(OpenCV_opencv_stitching_DEPS_OPT zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_objdetect)
set(OpenCV_opencv_stitching_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_ml_LIBNAME_OPT "libopencv_ml.a")
set(OpenCV_opencv_ml_DEPS_OPT zlib;opencv_core)
set(OpenCV_opencv_ml_EXTRA_DEPS_OPT )
set(OpenCV_opencv_legacy_LIBNAME_OPT "libopencv_legacy.a")
set(OpenCV_opencv_legacy_DEPS_OPT zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_video)
set(OpenCV_opencv_legacy_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_contrib_LIBNAME_OPT "libopencv_contrib.a")
set(OpenCV_opencv_contrib_DEPS_OPT zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_ml;opencv_video;opencv_objdetect)
set(OpenCV_opencv_contrib_EXTRA_DEPS_OPT bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_zlib_LIBNAME_OPT "libzlib.a")
set(OpenCV_zlib_DEPS_OPT )
set(OpenCV_zlib_EXTRA_DEPS_OPT )


set(OpenCV_opencv_core_LIBNAME_DBG "libopencv_core.a")
set(OpenCV_opencv_core_DEPS_DBG zlib)
set(OpenCV_opencv_core_EXTRA_DEPS_DBG )
set(OpenCV_opencv_imgproc_LIBNAME_DBG "libopencv_imgproc.a")
set(OpenCV_opencv_imgproc_DEPS_DBG zlib;opencv_core)
set(OpenCV_opencv_imgproc_EXTRA_DEPS_DBG )
set(OpenCV_opencv_video_LIBNAME_DBG "libopencv_video.a")
set(OpenCV_opencv_video_DEPS_DBG zlib;opencv_core;opencv_imgproc)
set(OpenCV_opencv_video_EXTRA_DEPS_DBG )
set(OpenCV_opencv_highgui_LIBNAME_DBG "libopencv_highgui.a")
set(OpenCV_opencv_highgui_DEPS_DBG zlib;opencv_core;opencv_imgproc)
set(OpenCV_opencv_highgui_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_flann_LIBNAME_DBG "libopencv_flann.a")
set(OpenCV_opencv_flann_DEPS_DBG zlib;opencv_core)
set(OpenCV_opencv_flann_EXTRA_DEPS_DBG )
set(OpenCV_opencv_features2d_LIBNAME_DBG "libopencv_features2d.a")
set(OpenCV_opencv_features2d_DEPS_DBG zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann)
set(OpenCV_opencv_features2d_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_calib3d_LIBNAME_DBG "libopencv_calib3d.a")
set(OpenCV_opencv_calib3d_DEPS_DBG zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d)
set(OpenCV_opencv_calib3d_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_objdetect_LIBNAME_DBG "libopencv_objdetect.a")
set(OpenCV_opencv_objdetect_DEPS_DBG zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d)
set(OpenCV_opencv_objdetect_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_stitching_LIBNAME_DBG "libopencv_stitching.a")
set(OpenCV_opencv_stitching_DEPS_DBG zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_objdetect)
set(OpenCV_opencv_stitching_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_ml_LIBNAME_DBG "libopencv_ml.a")
set(OpenCV_opencv_ml_DEPS_DBG zlib;opencv_core)
set(OpenCV_opencv_ml_EXTRA_DEPS_DBG )
set(OpenCV_opencv_legacy_LIBNAME_DBG "libopencv_legacy.a")
set(OpenCV_opencv_legacy_DEPS_DBG zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_video)
set(OpenCV_opencv_legacy_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_opencv_contrib_LIBNAME_DBG "libopencv_contrib.a")
set(OpenCV_opencv_contrib_DEPS_DBG zlib;opencv_core;opencv_imgproc;opencv_highgui;opencv_flann;opencv_features2d;opencv_calib3d;opencv_ml;opencv_video;opencv_objdetect)
set(OpenCV_opencv_contrib_EXTRA_DEPS_DBG bz2;-framework QuartzCore;-framework CoreFoundation;-framework ImageIO;-framework CoreGraphics;-framework AVFoundation)
set(OpenCV_zlib_LIBNAME_DBG "libzlib.a")
set(OpenCV_zlib_DEPS_DBG )
set(OpenCV_zlib_EXTRA_DEPS_DBG )


# ==============================================================
#  Extra include directories, needed by OpenCV 2 new structure
# ==============================================================
SET(OpenCV2_INCLUDE_DIRS /Users/phil/Downloads/wat/opencv/modules/calib3d/include;/Users/phil/Downloads/wat/opencv/modules/contrib/include;/Users/phil/Downloads/wat/opencv/modules/core/include;/Users/phil/Downloads/wat/opencv/modules/features2d/include;/Users/phil/Downloads/wat/opencv/modules/flann/include;/Users/phil/Downloads/wat/opencv/modules/highgui/include;/Users/phil/Downloads/wat/opencv/modules/imgproc/include;/Users/phil/Downloads/wat/opencv/modules/legacy/include;/Users/phil/Downloads/wat/opencv/modules/ml/include;/Users/phil/Downloads/wat/opencv/modules/objdetect/include;/Users/phil/Downloads/wat/opencv/modules/stitching/include;/Users/phil/Downloads/wat/opencv/modules/video/include)
if(OpenCV2_INCLUDE_DIRS)
  include_directories(${OpenCV2_INCLUDE_DIRS})
  list(APPEND OpenCV_INCLUDE_DIRS ${OpenCV2_INCLUDE_DIRS})
  
  set(OpenCV_AddDebugRelease FALSE)
  if(MSVC OR CMAKE_GENERATOR MATCHES Xcode)
    set(OpenCV_AddDebugRelease TRUE)
  endif()  
  
  if(OpenCV_AddDebugRelease)  
    set(OpenCV_LIB_DIR_OPT "${OpenCV_LIB_DIR_OPT}/Release")
    set(OpenCV_LIB_DIR_DBG "${OpenCV_LIB_DIR_DBG}/Debug")
    set(OpenCV_3RDPARTY_LIB_DIR_OPT "${OpenCV_3RDPARTY_LIB_DIR_OPT}/Release")
    set(OpenCV_3RDPARTY_LIB_DIR_DBG "${OpenCV_3RDPARTY_LIB_DIR_DBG}/Debug")
  endif()
endif()

# ==============================================================
#  Check OpenCV availability
# ==============================================================
if(ANDROID AND OpenCV_ANDROID_NATIVE_API_LEVEL GREATER ANDROID_NATIVE_API_LEVEL)
  message(FATAL_ERROR "Minimum required by OpenCV API level is android-${OpenCV_ANDROID_NATIVE_API_LEVEL}")
  #always FATAL_ERROR because we can't say to the caller that OpenCV is not found
  #http://www.mail-archive.com/cmake@cmake.org/msg37831.html
  if(OpenCV_FIND_REQUIRED)
    message(FATAL_ERROR "Minimum required by OpenCV API level is android-${OpenCV_ANDROID_NATIVE_API_LEVEL}")
  elseif(NOT OpenCV_FIND_QUIETLY)
    message(WARNING "Minimum required by OpenCV API level is android-${OpenCV_ANDROID_NATIVE_API_LEVEL}")
  endif()
  set(OpenCV_FOUND "OpenCV_FOUND-NOTFOUND")
  return()#Android toolchain requires CMake > 2.6
endif()

# ==============================================================
#  Form list of modules (components) to find
# ==============================================================
if(NOT OpenCV_FIND_COMPONENTS)
  set(OpenCV_FIND_COMPONENTS ${OpenCV_LIB_COMPONENTS})
endif()

# expand short module names and see if requested components exist
set(OpenCV_FIND_COMPONENTS_ "")
foreach(__cvcomponent ${OpenCV_FIND_COMPONENTS})
  if(NOT __cvcomponent MATCHES "^opencv_")
    set(__cvcomponent opencv_${__cvcomponent})
  endif()
  list(FIND OpenCV_LIB_COMPONENTS ${__cvcomponent} __cvcomponentIdx)
  if(__cvcomponentIdx LESS 0)
    #requested component is not found...
    if(OpenCV_FIND_REQUIRED)
      message(FATAL_ERROR "${__cvcomponent} is required but was not found")
    elseif(NOT OpenCV_FIND_QUIETLY)
      message(WARNING "${__cvcomponent} is required but was not found")
    endif()
    #indicate that module is NOT found
    string(TOUPPER "${__cvcomponent}" __cvcomponent)
    set(${__cvcomponent}_FOUND "${__cvcomponent}_FOUND-NOTFOUND")
  else()
    list(APPEND OpenCV_FIND_COMPONENTS_ ${__cvcomponent})
    #indicate that module is found
    string(TOUPPER "${__cvcomponent}" __cvcomponent)
    set(${__cvcomponent}_FOUND 1)
  endif()
endforeach()
set(OpenCV_FIND_COMPONENTS ${OpenCV_FIND_COMPONENTS_})

# ==============================================================
#  Resolve dependencies
# ==============================================================
if(OpenCV_USE_MANGLED_PATHS)
  set(OpenCV_LIB_SUFFIX ".${OpenCV_VERSION}")
else()
  set(OpenCV_LIB_SUFFIX "")
endif()

foreach(__opttype OPT DBG)
  SET(OpenCV_LIBS_${__opttype} "")
  SET(OpenCV_EXTRA_LIBS_${__opttype} "")
  foreach(__cvlib ${OpenCV_FIND_COMPONENTS})
    foreach(__cvdep ${OpenCV_${__cvlib}_DEPS_${__opttype}})
      if(__cvdep MATCHES "^opencv_")
        list(APPEND OpenCV_LIBS_${__opttype} "${OpenCV_LIB_DIR_${__opttype}}/${OpenCV_${__cvdep}_LIBNAME_${__opttype}}${OpenCV_LIB_SUFFIX}")
        #indicate that this module is also found
        string(TOUPPER "${__cvdep}" __cvdep)
        set(${__cvdep}_FOUND 1)
      else()
        list(APPEND OpenCV_LIBS_${__opttype} "${OpenCV_3RDPARTY_LIB_DIR_${__opttype}}/${OpenCV_${__cvdep}_LIBNAME_${__opttype}}")
      endif()
    endforeach()
    list(APPEND OpenCV_LIBS_${__opttype} "${OpenCV_LIB_DIR_${__opttype}}/${OpenCV_${__cvlib}_LIBNAME_${__opttype}}${OpenCV_LIB_SUFFIX}")
    list(APPEND OpenCV_EXTRA_LIBS_${__opttype} ${OpenCV_${__cvlib}_EXTRA_DEPS_${__opttype}})
  endforeach()

  if(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} VERSION_GREATER 2.4)
    if(OpenCV_LIBS_${__opttype})
      list(REMOVE_DUPLICATES OpenCV_LIBS_${__opttype})
    endif()
    if(OpenCV_EXTRA_LIBS_${__opttype})
      list(REMOVE_DUPLICATES OpenCV_EXTRA_LIBS_${__opttype})
    endif()
  else()
    #TODO: duplicates are annoying but they should not be the problem
  endif()
endforeach()

if(OpenCV_LIBS_DBG)
  list(REVERSE OpenCV_LIBS_DBG)
endif()

if(OpenCV_LIBS_OPT)
  list(REVERSE OpenCV_LIBS_OPT)
endif()

# CMake>=2.6 supports the notation "debug XXd optimized XX"
if(${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION} VERSION_GREATER 2.4)
  # Modern CMake:
  SET(OpenCV_LIBS "")
  foreach(__cvlib ${OpenCV_LIBS_DBG} ${OpenCV_EXTRA_LIBS_DBG})
    list(APPEND OpenCV_LIBS debug "${__cvlib}")
  endforeach()
  foreach(__cvlib ${OpenCV_LIBS_OPT} ${OpenCV_EXTRA_LIBS_OPT})
    list(APPEND OpenCV_LIBS optimized "${__cvlib}")
  endforeach()
else()
  # Old CMake:
  if(CMAKE_BUILD_TYPE MATCHES "Debug")
    SET(OpenCV_LIBS ${OpenCV_LIBS_DBG} ${OpenCV_EXTRA_LIBS_DBG})
  else()
    SET(OpenCV_LIBS ${OpenCV_LIBS_OPT} ${OpenCV_EXTRA_LIBS_OPT})
  endif()
endif()

# ==============================================================
#  Android camera helper macro
# ==============================================================
if(OpenCV_HAVE_ANDROID_CAMERA)
  macro(COPY_NATIVE_CAMERA_LIBS target)
    get_target_property(target_location ${target} LOCATION)
    get_filename_component(target_location "${target_location}" PATH)
    file(GLOB camera_wrappers "${OpenCV_LIB_DIR}/libnative_camera_r*.so")
    foreach(wrapper ${camera_wrappers})
      add_custom_command(
        TARGET ${target}
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${wrapper}" "${target_location}"
      )
    endforeach()
  endmacro()
endif()

# ==============================================================
# Compatibility stuff
# ==============================================================
if(CMAKE_BUILD_TYPE MATCHES "Debug")
  SET(OpenCV_LIB_DIR ${OpenCV_LIB_DIR_DBG} ${OpenCV_3RDPARTY_LIB_DIR_DBG})
else()
  SET(OpenCV_LIB_DIR ${OpenCV_LIB_DIR_OPT} ${OpenCV_3RDPARTY_LIB_DIR_OPT})
endif()
set(OpenCV_LIBRARIES ${OpenCV_LIBS})

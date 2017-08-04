cmake_minimum_required(VERSION 3.4.1)

set(LIB_NAME native-lib)

configure_file(include/curl/curlbuild.h.cmake
  ${CURL_BINARY_DIR}/include/curl/curlbuild.h)
configure_file(lib/curl_config.h.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/curl_config.h)

# Ugly (but functional) way to include "Makefile.inc" by transforming it (= regenerate it).
function(TRANSFORM_MAKEFILE_INC INPUT_FILE OUTPUT_FILE)
  file(READ ${INPUT_FILE} MAKEFILE_INC_TEXT)
  string(REPLACE "$(top_srcdir)"   "\${CURL_SOURCE_DIR}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})
  string(REPLACE "$(top_builddir)" "\${CURL_BINARY_DIR}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})

  string(REGEX REPLACE "\\\\\n" "�!�" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})
  string(REGEX REPLACE "([a-zA-Z_][a-zA-Z0-9_]*)[\t ]*=[\t ]*([^\n]*)" "SET(\\1 \\2)" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})
  string(REPLACE "�!�" "\n" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})

  string(REGEX REPLACE "\\$\\(([a-zA-Z_][a-zA-Z0-9_]*)\\)" "\${\\1}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})    # Replace $() with ${}
  string(REGEX REPLACE "@([a-zA-Z_][a-zA-Z0-9_]*)@" "\${\\1}" MAKEFILE_INC_TEXT ${MAKEFILE_INC_TEXT})    # Replace @@ with ${}, even if that may not be read by CMake scripts.
  file(WRITE ${OUTPUT_FILE} ${MAKEFILE_INC_TEXT})

endfunction()


transform_makefile_inc("lib/Makefile.inc" "${CMAKE_CURRENT_BINARY_DIR}/Makefile.inc.cmake")
include(${CMAKE_CURRENT_BINARY_DIR}/Makefile.inc.cmake)

list(APPEND HHEADERS
  ${CMAKE_CURRENT_BINARY_DIR}/curl_config.h
  ${CURL_BINARY_DIR}/include/curl/curlbuild.h
  )

include_directories(${CMAKE_CURRENT_BINARY_DIR}/../include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/..)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/../include)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/..)
include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_BINARY_DIR})
if(USE_ARES)
  include_directories(${CARES_INCLUDE_DIR})
endif()

file (GLOB_RECURSE LIB_VAUTH_CFILES "include/lib/vauth/*.c")
file (GLOB_RECURSE LIB_VTLS_CFILES "include/lib/vtls/*.c")
file (GLOB_RECURSE LIB_CFILES "include/lib/*.c")

add_library(
  native-lib02
  SHARED

   ${LIB_VAUTH_CFILES}
   ${LIB_VTLS_CFILES}
   ${LIB_CFILES}
  )
find_library( # Sets the name of the path variable.
              log-lib

              log )
target_link_libraries( # Specifies the target library.
                       native-lib02

                       ${log-lib} )

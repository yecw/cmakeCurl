cmake_minimum_required(VERSION 3.4.1)

set(LIB_NAME libcurl)

INCLUDE_DIRECTORIES(src/main/jni/lib)

file (GLOB_RECURSE LIB_VAUTH_CFILES "${CMAKE_CURRENT_SOURCE_DIR}/src/main/jni/lib/vauth/*.c")
file (GLOB_RECURSE LIB_VTLS_CFILES "${CMAKE_CURRENT_SOURCE_DIR}/src/main/jni/lib/vtls/*.c")
file (GLOB_RECURSE LIB_CFILES "${CMAKE_CURRENT_SOURCE_DIR}/src/main/jni/lib/*.c")
add_library( # Sets the name of the library.
             ${LIB_NAME}

             SHARED

             ${LIB_VAUTH_CFILES}
             ${LIB_VTLS_CFILES}
             ${LIB_CFILES}
             )


find_library( # Sets the name of the path variable.
              log-lib

              log )

target_link_libraries( # Specifies the target library.
                        ${LIB_NAME}

                       ${log-lib} )
# armyof2 - ReXGlue Recompiled Project
#
# SDK boilerplate lives in generated/rexglue.cmake.

cmake_minimum_required(VERSION 3.25)
project(armyof2 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

include(generated/rexglue.cmake)

# Sources
set(ARMYOF2_SOURCES
    src/main.cpp
)

if(WIN32)
    add_executable(armyof2 WIN32 ${ARMYOF2_SOURCES})
else()
    add_executable(armyof2 ${ARMYOF2_SOURCES})
endif()

rexglue_setup_target(armyof2 GPU_PLUGINS xenos)

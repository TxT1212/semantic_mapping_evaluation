cmake_minimum_required(VERSION 3.0.0)
project(general_fuctions VERSION 0.1.0)

include(CTest)
enable_testing()
find_package(OpenCV REQUIRED)
include_directories(${OpenCV_INCLUDE_DIRS})

add_executable(general_fuctions combine2images.cc)
target_link_libraries(general_fuctions
    ${OpenCV_LIBRARIES}
)
# add_executable(convertMask convertMask2Mask10.cc)
# target_link_libraries(convertMask
#     ${OpenCV_LIBRARIES}
# )

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)

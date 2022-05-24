cmake_minimum_required(VERSION 3.22)

project(walking-dog-telegram-bot)

set(CMAKE_CXX_STANDARD 17)

find_package(Git QUIET)

if (GIT_FOUND AND EXISTS "${PROJECT_SOURCE_DIR}/.git")
    # update submodules as needed
    option(GIT_SUBMODULE "update submodules before build" ON)
    if (GIT_SUBMODULE)
        message(STATUS "update submodules")
        execute_process(COMMAND ${GIT_EXECUTABLE} submodule update --init --recursive
                        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                        RESULT_VARIABLE GIT_SUBMOD_RESULT)
        if (NOT GIT_SUBMOD_RESULT EQUAL "0")
            message(FATAL_ERROR "can't update submodules")
        endif()
    endif()
endif()

if (NOT EXISTS "${PROJECT_SOURCE_DIR}/tgbot-cpp/CMakeLists.txt")
    message(FATAL_ERROR "The submodules were not downloaded!
            GIT_SUBMODULE was turned off or failed. Please update submodules and try again.")
endif()

add_subdirectory(tgbot-cpp)

add_executable(${PROJECT_NAME} src/main.cpp)

target_link_libraries(${PROJECT_NAME} TgBot)
target_link_directories(${PROJECT_NAME} PRIVATE ${PROJECT_SOURCE_DIR}/tgbot-cpp/include)
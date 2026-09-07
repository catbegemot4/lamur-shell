cmake_minimum_required(VERSION 3.16)
project(lamur-shell LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2)

add_executable(lamur-shell
    src/main.cpp
    src/appmodel.cpp
    resources.qrc
)

target_include_directories(lamur-shell PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

target_link_libraries(lamur-shell PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
)

install(TARGETS lamur-shell RUNTIME DESTINATION bin)

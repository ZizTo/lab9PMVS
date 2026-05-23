cmake_minimum_required(VERSION 3.16)

project(Task3QT VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia QuickControls2 Test)

if(FALSE)#ANDROID)
    find_package(Qt6 REQUIRED COMPONENTS CorePrivate)
endif()

qt_standard_project_setup(REQUIRES 6.5.3)

qt_add_executable(appTask3QT
    main.cpp
)

qt_add_qml_module(appTask3QT
    URI Task3QT
    QML_FILES
    Main.qml
        SOURCES playlistmodel.h
        SOURCES playlistmodel.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTask3QT PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTask3QT
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
)

target_link_libraries(appTask3QT
    PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Multimedia
    Qt6::QuickControls2
)

if(FALSE)#ANDROID)
    target_link_libraries(appTask3QT PRIVATE Qt6::CorePrivate)
endif()

install(TARGETS appTask3QT
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

qt_add_executable(MediaTests tests/test_playlistmodel.cpp
    tests/test_ui.qml playlistmodel.h playlistmodel.cpp)

target_link_libraries(MediaTests PRIVATE Qt6::Core Qt6::Test)

add_test(NAME MediaTest COMMAND MediaTests)

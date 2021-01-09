cmake_minimum_required(VERSION 3.14)

project(TODO_ANDROID LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check http://doc.qt.io/qt-5/deployment-android.html for more information.
# They need to be set before the find_package(Qt5 ...) call.

if(ANDROID)
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
    endif()
endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick AndroidExtras REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core Quick AndroidExtras REQUIRED)

if(ANDROID)
    add_library(TODO_ANDROID SHARED
      src/main.cpp
      qml/qml.qrc
      src/todomodel.cpp
      src/todolistviewmodel.cpp
    )
else()
    add_executable(TODO_ANDROID
      src/main.cpp
      qml/qml.qrc
      src/todomodel.cpp
      src/todolistviewmodel.cpp
    )
endif()

target_compile_definitions(TODO_ANDROID
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(TODO_ANDROID
  PRIVATE Qt${QT_VERSION_MAJOR}::Core Qt${QT_VERSION_MAJOR}::Quick Qt${QT_VERSION_MAJOR}::AndroidExtras)

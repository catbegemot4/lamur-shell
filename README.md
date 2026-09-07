# Lamur Shell — full shell integration

This branch adds a C++ AppModel (QAbstractListModel), main.cpp and CMakeLists to build a small QML-based shell demo.

How to build (Qt 6, Linux/macOS/Windows):

- Install Qt 6 and CMake
- mkdir build && cd build
- cmake ..
- cmake --build .
- Run: ./lamur-shell (or lamur-shell.exe on Windows)

Notes:
- The model persists a JSON file under the platform AppDataLocation (apps.json).
- App launching is currently a stub (logs to stdout). You can implement platform-specific launching in AppModel::launchApp.

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.12
import QtQuick.Layouts 1.15

Window {
    id: root
    visible: true
    width: 390
    height: 844
    color: "#f2f2f7" // light iOS background

    // Status bar
    Rectangle {
        id: statusBar
        anchors.top: parent.top
        height: 44
        width: parent.width
        color: "transparent"
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 12
            Text { text: "9:41"; font.pixelSize: 16; color: "#111" }
        }
    }

    // Background wallpaper
    Image {
        id: wallpaper
        anchors.fill: parent
        source: "qrc:/images/wallpaper.svg" // замените на вашу
        fillMode: Image.PreserveAspectCrop
    }

    // PageView for multiple home pages
    PageView {
        id: pages
        anchors.top: statusBar.bottom
        anchors.bottom: dock.top
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 0
        clip: true

        AppGrid {
            id: page0
            pageIndex: 0
            anchors.fill: parent
        }
        // Доп. страницы можно добавить здесь
    }

    // Dock at the bottom
    Dock {
        id: dock
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: parent.width
        height: 90
        y: parent.height - height - 20
    }

    // Placeholder for gestures
    MultiPointTouchArea {
        anchors.fill: parent
        onReleased: {
            // обработка жестов (Spotlight, Control Center) — по необходимости
        }
    }
}

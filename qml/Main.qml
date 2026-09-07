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
    color: theme === "dark" ? "#0b0b0f" : "#f2f2f7"

    property string theme: "light"

    // top bar with search and theme
    Row {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 56
        spacing: 8
        padding: 8

        TextField {
            id: searchField
            placeholderText: "Search"
            anchors.verticalCenter: parent.verticalCenter
            onTextChanged: searchResultsModel.model = appModel.search(text)
            width: parent.width * 0.7
        }

        Button {
            text: theme === "dark" ? "Light" : "Dark"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: theme = theme === "dark" ? "light" : "dark"
        }

        Button {
            text: "Save"
            anchors.verticalCenter: parent.verticalCenter
            onClicked: appModel.save()
        }
    }

    // Background wallpaper
    Image {
        id: wallpaper
        anchors.fill: parent
        source: "qrc:/resources/images/wallpaper.svg"
        fillMode: Image.PreserveAspectCrop
        opacity: theme === "dark" ? 0.6 : 1.0
    }

    // Spotlight area (search results)
    ListModel { id: searchResultsModel }
    Spotlight { id: spotlight; visible: searchResultsModel.count > 0; model: searchResultsModel }

    // PageView for multiple home pages
    PageView {
        id: pages
        anchors.top: parent.top
        anchors.topMargin: 56
        anchors.bottom: dock.top
        anchors.left: parent.left
        anchors.right: parent.right
        currentIndex: 0
        clip: true

        AppGrid {
            id: page0
            anchors.fill: parent
            model: appModel
        }
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

}

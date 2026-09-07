import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    width: parent ? parent.width : 390
    height: 90

    Rectangle {
        id: dockBg
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.92
        height: 72
        radius: 20
        y: 12
        color: Qt.rgba(1,1,1,0.5)
        border.color: Qt.rgba(1,1,1,0.12)
        border.width: 1
        smooth: true
        z: 0
    }

    Row {
        anchors.verticalCenter: dockBg.verticalCenter
        anchors.horizontalCenter: dockBg.horizontalCenter
        spacing: 24

        Repeater {
            model: appModel.getAllApps().filter(function(a){ return a.isDock; })
            Rectangle {
                width: 56; height: 56
                radius: 12
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: modelData.icon
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: appModel.launchApp(model.index)
                }
            }
        }
    }
}

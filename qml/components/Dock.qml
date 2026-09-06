import QtQuick 2.15
import QtGraphicalEffects 1.12
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

    // Blur effect for glass look
    ShaderEffectSource {
        id: bgSource
        sourceItem: dockBg
        hideSource: true
    }
    GaussianBlur {
        anchors.fill: dockBg
        source: bgSource
        radius: 18
        samples: 16
        transparentBorder: true
        z: 1
    }

    Row {
        anchors.verticalCenter: dockBg.verticalCenter
        anchors.horizontalCenter: dockBg.horizontalCenter
        spacing: 24

        Repeater {
            model: 4
            Rectangle {
                width: 56; height: 56
                radius: 12
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "qrc:/icons/dock" + (index+1) + ".svg"
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: console.log("Dock icon", index)
                }
            }
        }
    }
}

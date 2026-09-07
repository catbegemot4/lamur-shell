import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property alias model: listView.model
    visible: true

    ListView {
        id: listView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 8
        width: parent.width
        height: parent.height
        model: []
        delegate: Row {
            spacing: 8
            Image { source: modelData.icon; width: 36; height: 36 }
            Text { text: modelData.name }
            MouseArea { anchors.fill: parent; onClicked: appModel.launchApp(modelData.index) }
        }
    }
}

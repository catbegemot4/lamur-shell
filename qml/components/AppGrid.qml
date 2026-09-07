import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property var model: undefined

    GridView {
        id: grid
        anchors.fill: parent
        model: model
        delegate: Item {
            width: 90; height: 120

            property bool jiggle: false

            Column {
                anchors.centerIn: parent
                spacing: 8
                width: parent.width

                Image {
                    id: iconImg
                    source: model.icon
                    width: 72; height: 72
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    radius: 16
                    transform: Rotation { id: rot; origin.x: width/2; origin.y: height/2; angle: jiggle ? (Math.random() > 0.5 ? -3 : 3) : 0 }
                    Behavior on rotation { NumberAnimation { duration: 120 } }
                }

                Text {
                    text: model.name
                    font.pixelSize: 12
                    color: "#111"
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    width: parent.width
                }

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    property int pressTimerId: -1
                    onPressed: {
                        pressTimerId = Qt.createQmlObject('import QtQuick 2.0; Timer { interval: 350; repeat: false }', parent)
                        pressTimerId.running = true
                        pressTimerId.triggered.connect(function(){
                            // start jiggle
                            parent.jiggle = true
                        })
                    }
                    onReleased: {
                        if (parent.jiggle) {
                            parent.jiggle = false
                        } else {
                            // normal tap -> launch
                            appModel.launchApp(index)
                        }
                    }
                }
            }
        }

        cellWidth: 90
        cellHeight: 120
        spacing: 10
        padding: 16
        snapMode: GridView.SnapToItem
    }
}

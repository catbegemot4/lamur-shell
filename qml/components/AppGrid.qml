import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property int pageIndex: 0

    // Пример модели. В реальном проекте замените на модель из C++.
    ListModel {
        id: appsModel
        ListElement { name: "Phone"; icon: "qrc:/icons/phone.svg" }
        ListElement { name: "Messages"; icon: "qrc:/icons/messages.svg" }
        ListElement { name: "Safari"; icon: "qrc:/icons/safari.svg" }
        ListElement { name: "Settings"; icon: "qrc:/icons/settings.svg" }
        // добавьте элементы по необходимости
    }

    GridView {
        id: grid
        anchors.fill: parent
        model: appsModel
        cellWidth: 90
        cellHeight: 120
        spacing: 10
        padding: 16
        snapMode: GridView.SnapToItem
        interactive: true

        delegate: Item {
            width: grid.cellWidth
            height: grid.cellHeight

            Column {
                anchors.centerIn: parent
                spacing: 8
                width: parent.width
                Image {
                    id: iconImg
                    source: icon
                    width: 72; height: 72
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: iconImg.width; height: iconImg.height
                            radius: 16
                            color: "white"
                        }
                    }
                    transform: Scale {
                        id: hoverScale
                        origin.x: iconImg.width/2; origin.y: iconImg.height/2
                        xScale: 1.0; yScale: 1.0
                    }
                }

                Text {
                    text: name
                    font.pixelSize: 12
                    color: "#111"
                    horizontalAlignment: Text.AlignHCenter
                    elide: Text.ElideRight
                    width: parent.width
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        hoverScale.xScale = 0.95; hoverScale.yScale = 0.95
                    }
                    onReleased: {
                        hoverScale.xScale = 1.0; hoverScale.yScale = 1.0
                        console.log("Launch app:", name)
                        // Здесь можно вызвать сигнал/метод для запуска приложения
                    }
                }
            }

            Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
            Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
        }
    }
}

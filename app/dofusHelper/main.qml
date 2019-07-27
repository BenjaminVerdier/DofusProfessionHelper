import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 2.3
import QtQuick.Dialogs.qml 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 640
    height: 480
    title: qsTr("Dofus Helper")

    GridView {
        id: gridView
        x: 0
        y: 0
        width: 640
        height: 480
        cellHeight: 70
        cellWidth: 70

        Text {
            id: element
            x: 8
            y: 8
            width: 91
            height: 28
            text: qsTr("Profession:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
        }

        ComboBox {
            id: profCombo
            x: 113
            y: 2
            width: 200
            height: 40
            model: [ "Artificier", "Carver", "Jeweller", "Shoemaker", "Smith", "Tailor" ]
        }

        Button {
            id: button
            x: 379
            y: 53
            text: qsTr("Search")
            flat: false
            focusPolicy: Qt.WheelFocus
            spacing: 5
            onPressed: {
                myModel.updateData(levelLow.value, levelHigh.value, profCombo.currentText)

                searchListView;
            }
        }

        RangeSlider {
            id: levelRange
            x: 121
            y: 96
            to: 200
            from: 1
            stepSize: 1
            first.value: 1
            second.value: 200
            first.onValueChanged: levelLow.value = first.value;
            second.onValueChanged: levelHigh.value = second.value;
        }

        Text {
            id: element1
            x: 8
            y: 93
            width: 91
            height: 28
            text: qsTr("Level Range:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
        }

        ListView {
            id: searchListView
            x: 0
            y: 168
            width: 545
            height: 312
            model: myModel
            delegate: Item {
                x: 5
                width: 80
                height: 40
                property string itemName: name
                property int number: 0
                Row {
                    id: row1
                    spacing: 10
                    Text{
                        width: 50
                        text:level
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        id:itemName
                        width: 200
                        text:name
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    SpinBox {
                        id:spinItem
                        editable: true
                        to: 100
                        from: 0
                        value: 0
                        onValueChanged: {
                            parent.parent.number = value;
                        }
                    }
                }
            }
        }

        Button {
            id: button1
            x: 551
            y: 432
            width: 81
            height: 40
            text: qsTr("Export")
            spacing: 5
            focusPolicy: Qt.WheelFocus
            flat: false
            onPressed: {
                var names = [];
                var qties = [];
                for(var child in searchListView.contentItem.children) {
                    if (searchListView.contentItem.children[child].number > 0) {
                        names.push(searchListView.contentItem.children[child].itemName)
                        qties.push(searchListView.contentItem.children[child].number)
                    }

                }
                console.log(names)
                console.log(qties)
                myModel.saveResourceList(names,qties);
            }
        }

        SpinBox {
            id: levelLow
            x: 77
            y: 56
            width: 107
            height: 34
            editable: true
            to: 200
            from: 1
            value: 1
            onValueChanged: {
                if (value > levelHigh.value) {
                    levelHigh.value = value;
                }
                levelRange.first.value = value;
            }
        }

        SpinBox {
            id: levelHigh
            x: 248
            y: 56
            width: 107
            height: 34
            editable: true
            to: 200
            from: 1
            value: 200
            onValueChanged: {
                if (value < levelLow.value) {
                    levelLow.value = value;
                }
                levelRange.second.value = value;
            }
        }
    }
}

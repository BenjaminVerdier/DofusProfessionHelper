import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls.Material 2.0
import QtQuick.Controls 2.3
import QtQuick.Dialogs.qml 1.0

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1200
    height: 480
    title: qsTr("Dofus Helper")

    Component {
        id: itemHeader
        Row {

            Text {
                width: 50
                text: 'level'
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: 200
                text: 'item'
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                width: 190
                text: 'qty'
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    GridView {
        id: gridView
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
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
                dataH.updateItemData(levelLow.value, levelHigh.value, profCombo.currentText)
                searchListView.model.clear()
                var itemNames = dataH.itemNames();
                var itemLevels = dataH.itemLevels();
                for (var i = 0; i < itemNames.length; ++i) {
                    searchListView.model.append({'firstElement':itemNames[i], 'secondElement':itemLevels[i], 'thirdElement':0})
                }
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
            y: 102
            width: 91
            height: 28
            text: qsTr("Level Range:")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 12
        }

        ListView {
            id: searchListView
            x: 0
            width: 545
            anchors.top: parent.top
            anchors.topMargin: 168
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0


            model: ListModel {}
            delegate: Item {
                x: 5
                width: 80
                height: 40
                property string name: firstElement
                property int number: secondElement
                property int qty: thirdElement


                Row {
                    id: row1
                    spacing: 10

                    Text{
                        id: num
                        width: 50
                        text: parent.parent.number
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        id: nameLbl
                        width: 200
                        text: parent.parent.name
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    SpinBox {
                        editable: true
                        to: 9999
                        from: 0
                        value: parent.parent.qty
                        onValueChanged: {

                            var dif = value - parent.parent.qty;


                            for (var i = 0; i < searchListView.model.count; ++i) {
                                if (searchListView.model.get(i).firstElement === parent.parent.name) {
                                    searchListView.model.get(i).thirdElement = value
                                    break
                                }
                            }


                            var names = dataH.ingredientNamesForItem(parent.parent.name)
                            var qties = dataH.ingredientQtyForItem(parent.parent.name)

                            for (var j = 0; j < names.length; ++j) {
                                var foundIt = false
                                for (var k = 0; k < resourceList.model.count; ++k) {
                                    if (resourceList.model.get(k).firstElement === names[j]) {
                                        foundIt = true
                                        resourceList.model.get(k).secondElement += dif*qties[j]
                                        if (resourceList.model.get(k).secondElement <= 0) {
                                            resourceList.model.remove(k,1)
                                        }
                                    }
                                }
                                if (!foundIt) {
                                    resourceList.model.append({'firstElement':names[j], 'secondElement':dif*qties[j], 'thirdElement':0})
                                }
                            }


                        }
                    }
                }
            }
        }

        Button {
            id: exportBtn
            x: 551
            y: 53
            width: 81
            height: 40
            text: qsTr("Export")
            spacing: 5
            focusPolicy: Qt.WheelFocus
            flat: false
            onPressed: {
                //TODO
            }
        }

        SpinBox {
            id: levelLow
            x: 86
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

        ListView {
            id: resourceList
            x: 551
            width: 649
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 168
            model: ListModel {}
            delegate: Item {
                x: 5
                width: 80
                height: 40
                property string name: firstElement
                property int number: secondElement
                property int qty: thirdElement
                Rectangle {
                    width:mainWindow.width
                    height:40
                    color: parent.qty >= parent.number ? "grey" : "white"
                }


                Row {
                    id: row2
                    spacing: 10

                    Text{
                        id: resourceName
                        width: 200
                        text: parent.parent.name
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        id: resourceQty
                        width: 50
                        text: parent.parent.number
                        font.bold: true
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }
                    SpinBox {
                        editable: true
                        to: 9999
                        from: 0
                        value: parent.parent.qty
                        onValueChanged: {
                            for (var i = 0; i < searchListView.model.count; ++i) {
                                if (resourceList.model.get(i).firstElement === parent.parent.name) {
                                    resourceList.model.get(i).thirdElement = value
                                    break
                                }
                            }
                            parent.parent.qty = value;
                            qtyToBuy.text = Math.max(0,number - value)
                        }
                    }
                    Text {
                        id: qtyToBuy
                        width: 250
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter

                        text: number
                    }
                }
            }
        }
    }
}







/*##^## Designer {
    D{i:12;anchors_height:312;anchors_y:168}D{i:6;anchors_height:480;anchors_width:640;anchors_x:0;anchors_y:0}
}
 ##^##*/

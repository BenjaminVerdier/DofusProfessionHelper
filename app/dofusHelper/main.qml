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
                dataH.updateItemData(levelLow.value, levelHigh.value, profCombo.currentText)
                searchListView.model.clear()
                searchListView.itemMode = true;
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
            property bool itemMode: true


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
                        width: searchListView.itemMode ? 50 : 200
                        text: searchListView.itemMode ? parent.parent.number : parent.parent.name
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        id: nameLbl
                        width: searchListView.itemMode ? 200 : 50
                        text: searchListView.itemMode ? parent.parent.name : parent.parent.number
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
                                if (searchListView.model.get(i).firstElement === parent.parent.name) {
                                    searchListView.model.get(i).thirdElement = value
                                    break
                                }
                            }
                            parent.parent.qty = value;
                            if (!searchListView.itemMode) {
                                qtyToBuy.text = Math.max(0,number - value)
                            }
                        }
                    }
                    Text {
                        id: qtyToBuy
                        width: 250
                        anchors.verticalCenter: parent.verticalCenter
                        horizontalAlignment: Text.AlignHCenter

                        text: searchListView.itemMode ? "" : number
                    }
                }
            }
        }

        Button {
            id: exportBtn
            x: 551
            y: 432
            width: 81
            height: 40
            text: qsTr("Export")
            spacing: 5
            focusPolicy: Qt.WheelFocus
            flat: false
            onPressed: {

                var names = myModel.ingredientNames()
                for(var child in searchListView.contentItem.children) {
                    searchListView.model.insert({'name':names[child], 'qty':0})
                }
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

        Button {
            id: computeResourcesBtn
            x: 551
            y: 381
            width: 81
            height: 40
            text: qsTr("Resources")
            onPressed: {
                if (!searchListView.itemMode) {return}
                searchListView.itemMode = false
                var names = [];
                var qties = [];
                for(var i = 0; i < searchListView.model.count; ++i) {
                    if (searchListView.model.get(i).thirdElement > 0) {
                        names.push(searchListView.model.get(i).firstElement)
                        qties.push(searchListView.model.get(i).thirdElement)
                    }

                }
                console.log(names)
                console.log(qties)
                dataH.updateIngredientsData(names, qties);
                searchListView.model.clear()
                var ingredientNames = dataH.ingredientNames();
                var ingredientQties = dataH.ingredientQties();
                for (var i = 0; i < ingredientNames.length; ++i) {
                    searchListView.model.append({'firstElement':ingredientNames[i], 'secondElement':ingredientQties[i]})
                }
            }
        }
    }
}

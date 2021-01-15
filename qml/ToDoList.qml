import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import ToDo 1.0

Frame
{
    id: frame
    width: parent.width
    background: Rectangle
    {
        color: "#e1fffd"
    }

    property string globalClickedUuid: ""

    ColorChooseDialog
    {
        id: colorDialog
        width: frame.width - 100
        anchors.centerIn: parent

        Row
        {
            spacing: 20
            anchors.bottom: parent.bottom
            Button
            {
                background: Rectangle
                {
                    radius: 10
                    color: "#e1fffd"
                }
                text: "Ok"
                onClicked: {
                    if (colorDialog.choosed === true)
                    {
                        ToDoListViewModelContext.updateTaskColor(globalClickedUuid, colorDialog.choosedColor)
                        colorDialog.choosed = false
                    }
                    colorDialog.restoreColors()
                    colorDialog.close()
                }
            }
            Button
            {
                background: Rectangle
                {
                    radius: 10
                    color: "#e1fffd"
                }
                text: "Cancel"
                onClicked: {
                    colorDialog.choosed = false
                    colorDialog.restoreColors()
                    colorDialog.close()
                }
            }
        }
    }

    ListView
    {
        implicitHeight: 0.7 * parent.parent.parent.height //450
        width: parent.width
        spacing: 5

        clip: true

        model: ToDoListViewModelContext.model

        delegate: RowLayout
        {
            property string uuid: model.uuid

            Button
            {
                id: colorButton
                Layout.minimumWidth: 30
                Layout.preferredWidth: 40
                Layout.maximumWidth: 50
                Layout.fillHeight: true
                background: Rectangle
                {
                    radius: width
                    color: model.color
                }

                onClicked:
                {
                    globalClickedUuid = uuid
                    colorDialog.open()
                }
            }

            TextField
            {
                id: editText
                Layout.minimumWidth: frame.width - doneCheck.width - colorButton.width - removeButton.width - (4 * 20)
                Layout.maximumWidth: frame.width - doneCheck.width - colorButton.width - removeButton.width - (4 * 20)
                Layout.fillWidth: true
                Layout.fillHeight: true
                selectByMouse: true
                activeFocusOnPress : true
                text: model.description
                background: Rectangle
                {
                    radius: 10
                    width: parent.width
                    color: "#aadbd7"
                }

                onEditingFinished: ToDoListViewModelContext.updateTask(uuid, text, doneCheck.checked, model.color)
            }
            CheckBox
            {
                id: doneCheck
                Layout.fillHeight: true
                checked: model.done
                onCheckStateChanged: ToDoListViewModelContext.updateTask(uuid, editText.text, checked, model.color)
            }
            Button
            {
                id: removeButton
                text: "X"
                Layout.fillHeight: true
                Layout.minimumWidth: 30
                Layout.preferredWidth: 40
                Layout.maximumWidth: 50
                onClicked: ToDoListViewModelContext.removeElement(uuid)
                background: Rectangle
                {
                    color: "#e1fffd"
                    radius: 10
                }
            }
        }
    }
}

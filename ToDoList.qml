import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import ToDo 1.0


Frame
{
    id: frame
    width: parent.width

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
        implicitHeight: 400
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
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumWidth: 1000
                selectByMouse: true
                activeFocusOnPress : true
                text: model.description
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
            }
        }
    }
}

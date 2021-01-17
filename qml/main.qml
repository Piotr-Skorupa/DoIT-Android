import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.12
import QtQuick.Window 2.15

Rectangle {

    color: "#aadbd7"

    FileDialog
    {
        id: loadfileDialog
        title: "Z jakiego pliku wczytać listę?"
        folder: shortcuts.home
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            var path = loadfileDialog.fileUrl.toString()

            if (path === "")
            {
                var len = loadfileDialog.fileUrls.length
                path = loadfileDialog.fileUrls[len - 1].toString()
            }

            path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"")
            // unescape html codes like '%23' for '#'
            var cleanPath = decodeURIComponent(path)
            ToDoListViewModelContext.loadFromFile(cleanPath)
            loadfileDialog.fileUrl = ""
            loadfileDialog.close()
        }
        onRejected: {
            loadfileDialog.fileUrl = ""
            loadfileDialog.close()
        }
    }

    SimpleDialog
    {
        id: saveOkDialog
        width: toDoList.width - 100
        anchors.centerIn: parent

        information: "Plik został zapisany."

        Button
        {
            background: Rectangle
            {
                radius: 10
                color: "#e1fffd"
            }
            anchors.bottom: parent.bottom
            text: "Ok"
            onClicked: {
                saveOkDialog.close()
            }
        }
    }

    SimpleDialog
    {
        id: badFileDialog
        width: toDoList.width - 100
        anchors.centerIn: parent

        information: "Nie można wczytać pliku. Zły format!"

        Button
        {
            background: Rectangle
            {
                radius: 10
                color: "#e1fffd"
            }
            anchors.bottom: parent.bottom
            text: "Ok"
            onClicked: {
                badFileDialog.close()
            }
        }
    }

    SimpleDialog
    {
        id: helpDialog
        width: toDoList.width - 100
        implicitHeight: parent.height - 100
        anchors.centerIn: parent

        information: "Tutaj będzie pomoc!"

        Button
        {
            background: Rectangle
            {
                radius: 10
                color: "#e1fffd"
            }
            anchors.bottom: parent.bottom
            text: "Ok"
            onClicked: {
                helpDialog.close()
            }
        }
    }

    AddFromTextDialog
    {
        id: addFromTextDialog
        width: toDoList.width - 100
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
                    ToDoListViewModelContext.addFromText(addFromTextDialog.getText())
                    addFromTextDialog.clearText()
                    addFromTextDialog.close()
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
                    addFromTextDialog.clearText()
                    addFromTextDialog.close()
                }
            }
        }

    }

    ColumnLayout
    {
        id: mainColumnLayout
        height: parent.height
        width: parent.width

        ToolBar {
            id: toolBar
            Layout.fillWidth: true
            height: titleLabel.height
            background: Rectangle{
                color: "lightskyblue"
            }

            RowLayout
            {
                id: menuButtons
                height: parent.height
                width: parent.width

                Label {
                    id: titleLabel
                    text: "DoIT"
                    font.bold: true
                    font.pixelSize: 24
                }

                Button
                {
                    Layout.fillWidth: true
                    background: Rectangle
                    {
                        radius: 10
                        color: "#e1fffd"
                    }
                    text: "ZAPISZ"
                    onClicked:
                    {
                        ToDoListViewModelContext.saveToFile("")
                        saveOkDialog.open()
                    }
                }
                Button
                {
                    Layout.fillWidth: true
                    background: Rectangle
                    {
                        radius: 10
                        color: "#e1fffd"
                    }
                    text: "WCZYTAJ"
                    onClicked: loadfileDialog.open()
                }
                Button
                {
                    Layout.fillWidth: true
                    background: Rectangle
                    {
                        radius: 10
                        color: "#e1fffd"
                    }
                    text: "UDOSTĘPNIJ"
                    onClicked: ToDoListViewModelContext.send("")
                }
                Button{
                    background: Rectangle
                    {
                        radius: 10
                        color: "#e1fffd"
                    }
                    text: "?"
                    onClicked: helpDialog.open()
                }
            }
        }

        Row
        {
            id: listNameRow
            Layout.fillWidth: true
            spacing: 20
            TextInput
            {
                id: listName
                font.pointSize: 30
                text: ToDoListViewModelContext.currentList
                width: contentWidth + 10

                Connections
                {
                    target: ToDoListViewModelContext
                    function onCurrentListChange(newName)
                    {
                        console.log("Catched change name signal")
                        listName.text = newName
                    }

                    function onLoadingFileError()
                    {
                        console.log("Catched loading file error signal")
                        badFileDialog.open()
                    }
                }
            }

            Button
            {
                background: Rectangle
                {
                    radius: 10
                    color: "#e1fffd"
                }
                text: "ZMIEŃ"
                onClicked: ToDoListViewModelContext.changeListName(listName.text)
            }
        }

        ToDoList
        {
            id: toDoList
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        RowLayout
        {
            id: bottomButtons
            Layout.fillWidth: true
            spacing: 20
            Button
            {
                Layout.fillWidth: true
                background: Rectangle
                {
                    radius: 10
                    color: "#e1fffd"
                }
                id: addButton
                text: "DODAJ"
                onClicked: ToDoListViewModelContext.addElement()
            }

            Button
            {
                Layout.fillWidth: true
                background: Rectangle
                {
                    radius: 10
                    color: "#e1fffd"
                }
                id: addFromTextButton
                text: "DODAJ Z TEKSTU"
                onClicked: addFromTextDialog.open()
            }

            Button
            {
                Layout.fillWidth: true
                background: Rectangle
                {
                    radius: 10
                    color: "#e1fffd"
                }
                id: sortButton
                text: "UPORZĄDKUJ"
                onClicked: ToDoListViewModelContext.sort()
            }
        }
    }
}



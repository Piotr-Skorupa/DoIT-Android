import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3


Rectangle {

    color: "#fcfbe3"

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
                color: "#ececec"
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
                color: "#ececec"
            }
            anchors.bottom: parent.bottom
            text: "Ok"
            onClicked: {
                badFileDialog.close()
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
                    color: "#ececec"
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
                    color: "#ececec"
                }
                text: "Cancel"
                onClicked: {
                    addFromTextDialog.clearText()
                    addFromTextDialog.close()
                }
            }
        }

    }

    Row
    {
        id: menuButtons
        spacing: 5
        Button
        {
            background: Rectangle
            {
                radius: 10
                color: "#ececec"
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
            background: Rectangle
            {
                radius: 10
                color: "#ececec"
            }
            text: "WCZYTAJ"
            onClicked: loadfileDialog.open()
        }
        Button
        {
            background: Rectangle
            {
                radius: 10
                color: "#ececec"
            }
            text: "UDOSTĘPNIJ"
            onClicked: ToDoListViewModelContext.send("")
        }
    }

    Row
    {
        id: listNameRow
        x: 10
        y: menuButtons.height + 10
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
                color: "#ececec"
            }
            text: "ZMIEŃ"
            onClicked: ToDoListViewModelContext.changeListName(listName.text)
        }
    }

    ToDoList
    {
        id: toDoList
        y: listNameRow.y + listNameRow.height + 10
    }

    Button
    {
        background: Rectangle
        {
            radius: 10
            color: "#ececec"
        }
        id: addButton
        y: toDoList.y + toDoList.height + 20
        text: "DODAJ"
        onClicked: ToDoListViewModelContext.addElement()
    }

    Button
    {
        background: Rectangle
        {
            radius: 10
            color: "#ececec"
        }
        id: addFromTextButton
        x: addButton.x + addButton.width + 20
        y: toDoList.y + toDoList.height + 20
        text: "DODAJ Z TEKSTU"
        onClicked: addFromTextDialog.open()
    }

    Button
    {
        background: Rectangle
        {
            radius: 10
            color: "#ececec"
        }
        id: sortButton
        x: addFromTextButton.x + addFromTextButton.width + 20
        y: toDoList.y + toDoList.height + 20
        text: "UPORZĄDKUJ"
        onClicked: ToDoListViewModelContext.sort()
    }
}



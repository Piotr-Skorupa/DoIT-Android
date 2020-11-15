import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3


Rectangle {

    FileDialog
    {
        id: loadfileDialog
        title: "Z jakiego pliku wczytać listę?"
        folder: shortcuts.home
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            var path = loadfileDialog.fileUrl.toString();

            path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            // unescape html codes like '%23' for '#'
            var cleanPath = decodeURIComponent(path);
            ToDoListViewModelContext.loadFromFile(cleanPath)
            loadfileDialog.close()
        }
        onRejected: {
            loadfileDialog.close()
        }
    }

    Row
    {
        id: menuButtons
        spacing: 5
        Button
        {
            text: "ZAPISZ"
            onClicked: ToDoListViewModelContext.saveToFile("")
        }
        Button
        {
            text: "WCZYTAJ"
            onClicked: loadfileDialog.open()
        }
        Button
        {
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
            }
        }

        Button
        {
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
        y: toDoList.y + toDoList.height + 20
        text: "DODAJ"
        onClicked: ToDoListViewModelContext.addElement()
    }
}



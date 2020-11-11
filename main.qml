import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3


Rectangle {

    FileDialog
    {
        id: savefileDialog
        title: "lista_zadan.txt"
        folder: shortcuts.home
        selectExisting: false
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            var path = savefileDialog.fileUrl.toString();
            path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            // unescape html codes like '%23' for '#'
            var cleanPath = decodeURIComponent(path);
            ToDoListViewModelContext.saveToFile(cleanPath)
        }
        onRejected: {
        }
    }

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
        }
        onRejected: {
        }
    }

    FileDialog
    {
        id: sharefileDialog
        title: "Z jakiego pliku wczytać listę?"
        folder: shortcuts.home
        nameFilters: ["Text files (*.txt)"]
        onAccepted: {
            var path = sharefileDialog.fileUrl.toString();
            path= path.replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
            // unescape html codes like '%23' for '#'
            var cleanPath = decodeURIComponent(path);
            ToDoListViewModelContext.send(cleanPath)
        }
        onRejected: {
        }
    }

    Row
    {
        id: menuButtons
        spacing: 5
        Button
        {
            text: "ZAPISZ"
            onClicked: savefileDialog.open()
        }
        Button
        {
            text: "WCZYTAJ"
            onClicked: loadfileDialog.open()
        }
        Button
        {
            text: "UDOSTĘPNIJ"
            onClicked: sharefileDialog.open()
        }
    }

    ToDoList
    {
        id: toDoList
        y: menuButtons.height + 20
    }

    Button
    {
        y: toDoList.y + toDoList.height + 20
        text: "DODAJ"
        onClicked: ToDoListViewModelContext.addElement()
    }
}


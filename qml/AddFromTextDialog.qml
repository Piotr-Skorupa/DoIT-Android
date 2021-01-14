import QtQuick 2.0
import QtQuick.Controls 2.12

Dialog {
    title: "Dodaj z tekstu"

    property string information: "Dodaj elementy prosto z tekstu!\nPamietaj, żeby poszczególne elementy\nbyły oddzielone przecinkiem."

    background: Rectangle {
        color: "#fcfbe3"
    }
    contentItem: Rectangle {
        color: "#fcfbe3"
        implicitHeight: 200
        width: parent.width - 100

        Text {
            id: infoText
            text: information
        }

        TextArea
        {
            id: textArea
            y: infoText.y + infoText.height + 10
            width: infoText.width
            wrapMode: TextArea.WordWrap

            background: Rectangle
            {
                color: white
                width: infoText.width
                height: infoText.height + 20
            }
        }
    }

    function getText()
    {
        return textArea.text
    }

    function clearText()
    {
        return textArea.text = ""
    }
}

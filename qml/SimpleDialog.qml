import QtQuick 2.0
import QtQuick.Controls 2.12

Dialog {
    title: "Info"

    property string information: ""

    background: Rectangle {
        color: "#aadbd7"
    }
    contentItem: Rectangle {
        color: "#aadbd7"
        implicitHeight: 150
        width: parent.width - 100

        Text {
            id: infoText
            text: information
        }
    }
}

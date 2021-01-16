import QtQuick 2.0
import QtQuick.Controls 2.12

Dialog {
    title: "Wybierz kolor!"

    property color choosedColor: "#0000ff"
    property bool choosed: false

    background: Rectangle {
        color: "#aadbd7"
    }
    contentItem: Rectangle {
        implicitHeight: 150
        width: parent.width - 100
        color: "#aadbd7"

        Grid {
            Rectangle {
                id: orangeBox
                property color baseColor: "orange"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "orange"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: redBox
                property color baseColor: "red"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "red"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: yellowBox
                property color baseColor: "yellow"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "yellow"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: greenBox
                property color baseColor: "green"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "green"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: lightBlueBox
                property color baseColor: "lightskyblue"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "lightskyblue"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: darkBlueBox
                property color baseColor: "#0000ff"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "#0000ff"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: pinkBox
                property color baseColor: "pink"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "pink"
                        choosed = true
                    }
                }
            }

            Rectangle {
                id: lightGreenBox
                property color baseColor: "#b2ff59"
                width: 50
                height: 50
                color: baseColor

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        restoreColors()
                        parent.border.width = 5
                        choosedColor = "#b2ff59"
                        choosed = true
                    }
                }
            }
        }
    }

    function restoreColors()
    {
        orangeBox.border.width = 0
        redBox.border.width = 0
        yellowBox.border.width = 0
        greenBox.border.width = 0
        lightBlueBox.border.width = 0
        darkBlueBox.border.width = 0
        pinkBox.border.width = 0
        lightGreenBox.border.width = 0
    }
}

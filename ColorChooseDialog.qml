import QtQuick 2.0
import QtQuick.Controls 2.12

Dialog {
    title: "Wybierz kolor!"

    property color choosedColor: "#0000ff"
    property bool choosed: false

    contentItem: Rectangle {
        implicitHeight: 150
        width: parent.width - 100

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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
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
                        parent.color = "#ffffff"
                        choosedColor = "#b2ff59"
                        choosed = true
                    }
                }
            }
        }
    }

    function restoreColors()
    {
        orangeBox.color = orangeBox.baseColor
        redBox.color = redBox.baseColor
        yellowBox.color = yellowBox.baseColor
        greenBox.color = greenBox.baseColor
        lightBlueBox.color = lightBlueBox.baseColor
        darkBlueBox.color = darkBlueBox.baseColor
        pinkBox.color = pinkBox.baseColor
        lightGreenBox.color = lightGreenBox.baseColor
    }
}

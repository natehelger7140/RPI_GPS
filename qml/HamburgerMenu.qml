import QtQuick 2.0
import QtQuick.Controls.Fusion

import "components"

Drawer{
    id: hamburgerMenuRoot
    width: 300
    height: mainWindow.height
    visible: false
    modal: true
    contentItem: Rectangle{
        id: hamburgerMenuContent
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: fieldMenu.height

        color: "lightGray"
        ScrollViewExpandableColumn{

            // Initialize a standard width for botton configurations
            property int singleButtonWidth: (hamburgerMenuRoot.width * 0.8)
            property int buttonHeight: 50

            id: hamburgerMenuColumn
            //anchors.fill: parent
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 25
            anchors.leftMargin: ((parent.width - singleButtonWidth) / 2)
            ButtonColor{
                text: "Simulator On"
                property bool isChecked: settings.setMenu_isSimulatorOn
                onIsCheckedChanged: {
                    checked = isChecked
                }

                checkable: true
                checked: isChecked
                onCheckedChanged: {
                    settings.setMenu_isSimulatorOn = checked
                }
                width: hamburgerMenuColumn.singleButtonWidth
                height: hamburgerMenuColumn.buttonHeight
            }
        }
    }
}

import QtQuick
import QtQuick.Controls.Fusion

Button {
    implicitWidth: 120 * theme.scaleWidth
    implicitHeight: 65 * theme.scaleHeight
    id: icon_button
    text: ""
    hoverEnabled: true
    //checkable: true
    icon.source: ""
    icon.color: "transparent"

    property double iconHeightScaleText: 0.75
    property int border: 1

    property color color: "white"

    property color colorHover: "lightgray"

    property color colorChecked: "green"

    property color textColor: "black"  // Default text color

    property color textColorChecked: "lightgray"  // Text color when checked



    //For compatibility with the old IconButton and friends
    property bool isChecked: icon_button.checked
    property string buttonText: ""

    onButtonTextChanged: {
        text = buttonText
    }
    onIsCheckedChanged: {
        checked = isChecked;
    }

    //This is specific to this base type... must be re-implemented in subtypes
    onCheckedChanged: {
        isChecked = checked
    }


    property int radius: 10

    onWidthChanged: {
        //console.warn(text, "Width is now ", width)
    }

    onHeightChanged: {
        //console.warn(height)
    }

    background: Rectangle {
        border.width: icon_button.border
        border.color: icon_button.enabled ? "black" : "grey"
        radius: 10
        id: icon_button_background
        color: icon_button.checked ? icon_button.colorChecked : icon_button.color

    }

    contentItem: Text {
            text: icon_button.text
            color: icon_button.checked ? icon_button.textColorChecked : icon_button.textColor  // Change text color based on checked state
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
}

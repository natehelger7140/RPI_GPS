import QtQuick
import QtQuick.Window
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick.Effects
import QtMultimedia
import AgOpenGPS 1.0

import "interfaces"
import "boundary"
import "steerconfig"
import "config"
import "field"
import "tracks"
import "components"

Window {


    AOGTheme{
        id: theme
        objectName: "theme"
    }
    id: mainWindow
	height: theme.defaultHeight
	width: theme.defaultWidth



    onVisibleChanged: if(settings.setDisplay_isStartFullScreen){
                          mainWindow.showMaximized()
                      }


    signal save_everything()

    function close() {
		console.log("close called")
		if (areWindowsOpen()) {
			timedMessage.addMessage(2000,qsTr("Some windows are open. Close them first."))
			console.log("some windows are open. close them first")
			return
		}
        if (aog.autoBtnState + aog.manualBtnState  > 0) {
            timedMessage.addMessage(2000,qsTr("Section Control on. Shut off Section Control."))
            close.accepted = false
			console.log("Section Control on. Shut off Section Control.")
            return
        }
        if (mainWindow.visibility !== (Window.FullScreen) && mainWindow.visibility !== (Window.Maximized)){
            settings.setWindow_Size = ((mainWindow.width).toString() + ", "+  (mainWindow.height).toString())
        }

        if (aog.isJobStarted) {
            closeDialog.visible = true
            close.accepted = false
			console.log("job is running. close it first")
			return
        }
		Qt.quit()
    }
	function areWindowsOpen() {
		if (config.visible == true) {
			console.log("config visible") 
			return true
		}
		else if (headlandDesigner.visible == true) {
			console.log("headlandDesigner visible") 
			return true
		}
		else if (headacheDesigner.visible == true) {
			console.log("headacheDesigner visible") 
			return true
		}
		else if (steerConfigWindow.visible == true) {
			console.log("steerConfigWindow visible") 
			return true
		}
		else if (abLinePicker.visible == true) {
			console.log("abLinePicker visible") 
			return true
		}
		else if (tramLinesEditor.visible == true) {
			console.log("tramLinesEditor visible") 
			return true
		}
		else if (lineEditor.visible == true) {
			console.log("lineEditor visible") 
			return true
		}
		else if (setSimCoords.visible == true) {
			console.log("setSimCoords visible") 
			return true
		}
		else if (trackNew.visible == true) {
			console.log("trackNew visible") 
			return true
		}
		else if (fieldNew.visible == true) {
			console.log("FieldNew visible") 
			return true
		}
		else if (fieldOpen.visible == true) return true
		else return false
	}
    AOGInterface {
        id: aog
        objectName: "aog"
    }
    LinesInterface {
        objectName: "linesInterface"
        id: linesInterface
    }

    FieldInterface {
        id: fieldInterface
        objectName: "fieldInterface"
    }

    VehicleInterface {
        id: vehicleInterface
        objectName: "vehicleInterface"
    }

    BoundaryInterface {
        id: boundaryInterface
        objectName: "boundaryInterface"
    }

    RecordedPathInterface {
        id: recordedPathInterface
        objectName: "recordedPathInterface"
    }

    UnitConversion {
        id: utils
    }

    TimedMessage {
        //This is a popup message that dismisses itself after a timeout
        id: timedMessage
        objectName: "timedMessage"
    }

    SystemPalette {
        id: systemPalette
        colorGroup: SystemPalette.Active
    }


    Rectangle {
        id: background
        objectName: "background"
        anchors.top: topLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom:  parent.bottom

        color: "pink"
		 }

		 Rectangle{
        id: topLine
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: aog.backgroundColor
        height: 50 *theme.scaleHeight
        visible: true

        IconButtonTransparent {
            id: btnfileMenu
            height: parent.height
            width: 75 * theme.scaleWidth
            icon.source: "/images/fileMenu.png"
            onClicked: hamburgerMenu.visible = true
        }
        Text{
            anchors.top:parent.top
            anchors.left: parent.left
            anchors.leftMargin: leftColumn.width+20
            text: qsTr(aog.fixQuality ===1 ? "GPS Single":
                        aog.fixQuality ===2 ? "DGPS":
                        aog.fixQuality ===3 ? "RTK Float":
                        aog.fixQuality ===4 ? "RTK Fix":
                         "Invalid" + ": Age: "+ Math.round(aog.age, 1))
            font.bold: true
            font.pixelSize: 20
            anchors.bottom: parent.verticalCenter
        }
        Text {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 150
            text: qsTr("ac")
            anchors.top: parent.verticalCenter
            font.bold: true
            font.pixelSize: 15
        }
        Text {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("ab")
            font.bold: true
            font.pixelSize: 15
        }
        Row{
            id: topRowWindow
            width: childrenRect.width
            height: parent.height
            anchors.top: parent.top
            anchors.right: parent.right
			spacing: 5 * theme.scaleWidth
            IconButtonColor{
                id: rtkStatus
                icon.source: "/images/GPSQuality.png"
                implicitWidth: 75 * theme.scaleWidth
                implicitHeight: parent.height
                onClicked: {
                    gpsData.visible = !gpsData.visible
                    fieldData.visible = false
                }
            }

            Text{
                id: speed
                anchors.verticalCenter: parent.verticalCenter
                width: 75 * theme.scaleWidth
                height:parent.height
                text: utils.speed_to_unit_string(aog.speedKph, 1)
                font.bold: true
                font.pixelSize: 35
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            IconButtonTransparent{
                height: parent.height
                width: 75 * theme.scaleWidth
                icon.source: "/images/Help.png"
            }
            IconButtonTransparent{
                height: parent.height
                icon.source: "/images/WindowMinimize.png"
                width: 75 * theme.scaleWidth
                onClicked: mainWindow.showMinimized()
            }
            IconButtonTransparent{
				id: btnMaximize
                height: parent.height
                icon.source: "/images/WindowMaximize.png"
                width: 75 * theme.scaleWidth
                onClicked: {
                    console.debug("Visibility is " + mainWindow.visibility)
                    if (mainWindow.visibility == Window.FullScreen){
                        mainWindow.showNormal()
                }else{
                        settings.setWindow_Size = ((mainWindow.width).toString() + ", "+  (mainWindow.height).toString())
                        mainWindow.showFullScreen()
                    }
                }
            }
            IconButtonTransparent{
                height: parent.height
                width: 75 * theme.scaleWidth
                icon.source: "/images/WindowClose.png"
                onClicked: {
                    mainWindow.save_everything()
                    mainWindow.close()
                }
            }
        }
    }

    AOGRenderer {
        id: glcontrolrect
        objectName: "openglcontrol"

        anchors.top: topLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        //for moving the center of the view around
        property double shiftX: 0 //-1 left to 1 right
        property double shiftY: 0 //-1 down to 1 up

        signal clicked(var mouse)
        signal dragged(int fromX, int fromY, int toX, int toY)
        signal zoomOut()
        signal zoomIn()

        MouseArea {
            id: mainMouseArea
            anchors.fill: parent

            property int fromX: 0
            property int fromY: 0
            property Matrix4x4 clickModelView
            property Matrix4x4 clickProjection
            property Matrix4x4 panModelView
            property Matrix4x4 panProjection

            onClicked: {
                parent.clicked(mouse)
            }

            onPressed: if(aog.panMode){
                           //save a copy of the coordinates
                           fromX = mouseX
                           fromY = mouseY
                       }

            onPositionChanged: if(aog.panMode){
                                   parent.dragged(fromX, fromY, mouseX, mouseY)
                                   fromX = mouseX
                                   fromY = mouseY
                               }

            onWheel:(wheel)=>{
                if (wheel.angleDelta.y > 0) {
                    aog.zoomIn()
                } else if (wheel.angleDelta.y <0 ) {
                    aog.zoomOut()
                }
            }

            Image {
                id: reverseArrow
                x: aog.vehicle_xy.x - 150
                y: aog.vehicle_xy.y - height
                width: 70 * theme.scaleWidth
                height: 70 * theme.scaleHeight
                source: "/images/Images/z_ReverseArrow.png"
                visible: aog.isReverse
            }
            MouseArea{
                id: resetDirection
                onClicked: {
                    aog.reset_direction()
                    console.log("reset direction")
                }
                propagateComposedEvents: true
                x: aog.vehicle_bounding_box.x
                y: aog.vehicle_bounding_box.y
                width: aog.vehicle_bounding_box.width
                height: aog.vehicle_bounding_box.height
                onPressed: (mouse)=>{
                               aog.reset_direction()
                               console.log("pressed")
                               mouse.accepted = false

                           }
            }
        }

    }

    Rectangle{
        id: noGPS
        anchors.fill: glcontrolrect
        color: "#0d0d0d"
        visible: aog.sentenceCounter> 29
        onVisibleChanged: if(visible){
                              console.log("no gps now visible")
                          }

        Image {
            id: noGPSImage
            source: "/images/Images/z_NoGPS.png"
            anchors.centerIn: parent
            anchors.margins: 200
            visible: noGPS.visible
            height: parent.height /2
            width: height
        }
    }

    //----------------------------------------------------------------------------------------left column
    Item {

        id: buttonsArea
        anchors.top: parent.top
        anchors.topMargin: 2 //TODO: convert to scalable
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        ColumnLayout {
            id: leftColumn
            anchors.top: parent.top
            anchors.topMargin: topLine.height
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: 6
			onHeightChanged: {
				theme.btnSizes[2] = height / (children.length) 
				theme.buttonSizesChanged()
			}
			//Layout.maximumHeight: theme.buttonSize
            onVisibleChanged: if(visible == false)
                                  width = 0
                              else
                                  width = children.width
            Button {
                id: btnAcres
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                Layout.alignment: Qt.AlignCenter
                onClicked: {
                    aog.distanceUser = "0"
                    aog.workedAreaTotalUser = "0"
                }

                background: Rectangle{
                    anchors.fill: parent
                    color: aog.backgroundColor
                    radius: 10
                    Text{
                        anchors.top: parent.top
                        anchors.bottom: parent.verticalCenter
                        anchors.margins: 5
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: utils.m_to_unit_string(aog.distanceUser, 2)
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: parent.height * .33
                    }
                    Text{
                        anchors.top: parent.verticalCenter
                        anchors.bottom: parent.bottom
                        anchors.margins: 5
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: utils.area_to_unit_string(aog.workedAreaTotalUser, 2)
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: parent.height * .33
                    }
                }
            }
            IconButtonText {
                id: btnnavigationSettings
                buttonText: qsTr("Display")
                icon.source: "/images/NavigationSettings.png"
                onClicked: displayButtons.visible = !displayButtons.visible
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                Layout.alignment: Qt.AlignCenter
            }
            IconButtonText {
                id: btnSettings
                buttonText: qsTr("Settings")
                icon.source: "/images/Settings48.png"
                onClicked: config.open()
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                Layout.alignment: Qt.AlignCenter
            }
            IconButtonText {
                id: btnTools
                buttonText: qsTr("Tools")
                icon.source: "/images/SpecialFunctions.png"
                onClicked: toolsMenu.visible = true
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                Layout.alignment: Qt.AlignCenter
            }
            IconButtonText{
                id: btnFieldMenu
                buttonText: qsTr("Field")
                icon.source: "/images/JobActive.png"
                onClicked: fieldMenu.visible = true
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                Layout.alignment: Qt.AlignCenter
            }
            IconButtonText{
                id: btnFieldTools
                buttonText: qsTr("Field Tools")
                icon.source: "/images/FieldTools.png"
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                onClicked: fieldTools.visible = true
                enabled: aog.isJobStarted ? true : false
                Layout.alignment: Qt.AlignCenter
            }

            IconButtonText {
                id: btnAgIO
                buttonText: qsTr("AgIO")
                icon.source: "/images/AgIO.png"
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                Layout.alignment: Qt.AlignCenter
            }
            IconButtonText {
                id: btnautoSteerConf
                buttonText: qsTr("Steer config")
                icon.source: "/images/AutoSteerConf.png"
                Layout.alignment: Qt.AlignCenter
				implicitWidth: theme.buttonSize
				implicitHeight: theme.buttonSize
                onClicked: {
                    steerConfigWindow.visible = true
                    steerConfigWindow.show()
                }
            }
        }
        //------------------------------------------------------------------------------------------right
        ColumnLayout {
            id: rightColumn
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.topMargin: topLine.height + 6
            anchors.rightMargin: 6
        }

        Column {
            id: rightSubColumn
            anchors.top: parent.top
            anchors.topMargin: btnContour.height + 3
            anchors.right: rightColumn.left
            anchors.rightMargin: 3
            spacing: 3
        }
        RowLayout{
            id:bottomButtons
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.leftMargin: theme.buttonSize + 3
            anchors.right: parent.right
            anchors.rightMargin: theme.buttonSize + 3
            visible: aog.isJobStarted && leftColumn.visible

            //spacing: parent.rowSpacing
			onWidthChanged: {
				theme.btnSizes[1] = width / (children.length) 
				theme.buttonSizesChanged()
			}
			onVisibleChanged: {
				if (visible == false)
					height = 0
				else
					height = children.height				

			}
        }
        //----------------inside buttons-----------------------
        Item{
            //plan to move everything on top of the aogRenderer that isn't
            //in one of the buttons columns
            id: inner
            anchors.left: leftColumn.right
            anchors.top: parent.top
            anchors.topMargin: topLine.height
            anchors.right: rightColumn.left
            anchors.bottom: bottomButtons.top
            visible: !noGPS.visible
            IconButtonTransparent{
                id: pan
                implicitWidth: 50
                implicitHeight: 50 * theme.scaleHeight
                checkable: true
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.margins: 30
                icon.source: "/images/Pan.png"
                iconChecked: "/images/SwitchOff.png"
                onClicked: aog.panMode = !aog.panMode
            }
            OutlineText{
                id: simulatorOnText
                visible: settings.setMenu_isSimulatorOn
                anchors.top: parent.top
                anchors.topMargin: lightbar.height+ 10
                anchors.horizontalCenter: lightbar.horizontalCenter
                font.pixelSize: 30
                color: "#cc5200"
                text: qsTr("Simulator On")
            }

            OutlineText{
                property int age: aog.age
                id: ageAlarm
                visible: settings.setGPS_isRTK
                anchors.top: simulatorOnText.bottom
                anchors.topMargin: 30
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Lost RTK"
                font.pixelSize: 65
                color: "#cc5200"
                onAgeChanged: {
                    if (age < 20)
                        text = ""
                    else if (age> 20 && age < 60)
                        text = qsTr("Age: ")+age
                    else
                        text = "Lost RTK"
                }
                onTextChanged: if (text.length > 0)
                                   console.log("rtk alarm sound")

            }
			Grid{
				spacing: 10
				rows: 2
				columns: 2
				flow: Grid.LeftToRight
				anchors.top: lightbar.bottom
				anchors.left: parent.left
				anchors.topMargin: 30
				anchors.leftMargin: 150
			}
        LightBar {
            id: lightbar
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.margins: 5
            dotDistance: aog.avgPivDistance / 10 //avgPivotDistance is averaged
            visible: (aog.offlineDistance != 32000 &&
                      (settings.setMenu_isLightbarOn === true ||
                       settings.setMenu_isLightbarOn === "true")) ?
                         true : false
        }
        SimController{
            id: simBarRect
            anchors.bottom: timeText.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 8
            visible: utils.isTrue(settings.setMenu_isSimulatorOn)
			height: 60 * theme.scaleHeight
			onHeightChanged: anchors.bottomMargin = (8 * theme.scaleHeight)
        }
        OutlineText{
            id: timeText
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.rightMargin: (50 * theme.scaleWidth)
            font.pixelSize: 20
            color: "#cc5200"
            text: new Date().toLocaleTimeString(Qt.locale())
            Timer{
                interval: 100
                repeat: true
                running: true
                onTriggered: timeText.text = new Date().toLocaleTimeString(Qt.locale())
            }
        }
        Column{
            id: zoomBtns
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            spacing: 5
            width: children.width
            IconButton{
                implicitWidth: 30 * theme.scaleWidth
                implicitHeight: 30 * theme.scaleHeight
                radius: 0
                icon.source: "/images/ZoomIn48.png"
                onClicked: aog.zoomIn()
            }
            IconButton{
                implicitWidth: 30 * theme.scaleWidth
                implicitHeight: 30 * theme.scaleHeight
                radius: 0
                icon.source: "/images/ZoomOut48.png"
                onClicked: aog.zoomOut()
            }
        }
    }
        HamburgerMenu{
            id: hamburgerMenu
            visible: false
        }

        Config {
            id:config
			x: 0
			y: 0
			width: parent.width
			height: parent.height
            visible:false

            onAccepted: {
                console.debug("accepting settings and closing window.")
                aog.settings_save()
                aog.settings_reload()
            }
            onRejected: {
                console.debug("rejecing all settings changes.")
                aog.settings_revert()
                aog.settings_reload()
            }

        }

        HeadlandDesigner{
            id: headlandDesigner
            objectName: "headlandDesigner"
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            visible: false
        }
        HeadAcheDesigner{
            id: headacheDesigner
            objectName: "headacheDesigner"
            //anchors.horizontalCenter: parent.horizontalCenter
            //anchors.verticalCenter: parent.verticalCenter
            visible: false
        }

        SteerConfigWindow {
            id:steerConfigWindow
            visible: false
        }
		SteerConfigSettings{
			id: steerConfigSettings
			anchors.fill: parent
			visible: false
		}

        ABCurvePicker{
            id: abCurvePicker
            objectName: "abCurvePicker"
            visible: false
        }

        ABLinePicker{
            id: abLinePicker
            objectName: "abLinePicker"
            visible: false
        }
        TramLinesEditor{
            id: tramLinesEditor
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 150
            anchors.topMargin: 50
            visible: false
        }

        LineEditor{
            id: lineEditor
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: 150
            anchors.topMargin: 50
            visible: false
        }
        BoundaryMenu{
            id: boundaryMenu
            visible: false
        }

        LineDrawer {
            id:lineDrawer
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            height: 768
            width:1024
            visible:false
        }
        LineNudge{
            id: lineNudge
            visible: false
        }
        RefNudge{
            id: refNudge
            visible: false
        }
        SetSimCoords{
            id: setSimCoords
            anchors.fill: parent
        }

        TrackNew{
            id: trackNew
            visible: false
        }
        Item{
            id: windowsArea      //container for declaring all the windows
            anchors.fill: parent //that can be displayed on the main screen
            FieldFromExisting{
                id: fieldFromExisting
                x: 0
                y: 0
            }
            FieldNew{
                id: fieldNew
            }
            FieldFromKML{
                id: fieldFromKML
                x: 100
                y: 75
            }
            FieldOpen{
                id: fieldOpen
                x: 100
                y: 75
            }
        }
}
}

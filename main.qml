import QtQuick 2.12
import QtQuick.Window 2.10
import QtQuick.Controls 2.3
//import QtQuick.Dialogs.qml 1.0
import QtQuick.Dialogs 1.2

Window {
    id:mainWindow
    objectName:"mainWindow"
    visible: true
    width: 640
    height: 480
    color: "#729fcf"
    title: qsTr("Tail tracker for 2p-microscope constrained larva videos")
    signal qmlSignal(string msg)
    onSceneGraphInitialized: busyIndicator.running = false;
    //    onContentItemChanged: {
    //            qmlSignal("Change");
    //    }

    //    Connections {
    //        target: txtLog
    //        onTextChanged: txtLog.qmlSignal("onTextChanged")
    //    }


    FileDialog {
        id: fileDialogInput
        objectName: "fileDialogInput"
        title: "Please choose a video file"
        signal qmlInputFileSelectedSig(string msg)
        selectedNameFilter: "*.pgm *.tiff * mp4 *.avi "
        selectExisting: true
        folder: shortcuts.home
        onAccepted: {
            console.log("You chose: " + fileDialogInput.fileUrls)
            qmlInputFileSelectedSig(fileDialogInput.fileUrls);
            fileDialogOutput.setFolder(fileDialogInput.fileUrl); //Start Output dialog from where input ended
            Qt.quit()
        }
        onRejected: {
            console.log("Cancelled")
            Qt.quit()
        }
        //onCompleted: visible = false
    }
    Frame {
        id: frame_buttons
        x: 464
        width: 176
        height: 295
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 0
        transformOrigin: Item.TopRight

        Button {
            id: buttonSelectVideo
            x: 12
            y: 7
            width: 144
            height: 40
            onPressed: {
                fileDialogInput.setTitle("Select Video file");
                fileDialogInput.selectFolder = false;
                fileDialogInput.setNameFilters("*.avi *.mp4 *.mkv *.h264;; *.*");
                fileDialogInput.visible = true;

            }

            text: qsTr("Set Input Video")
        }

        Button {
            id: buttonOpenFolder
            x: 12
            y: 71
            width: 144
            height: 40
            text: qsTr("Set Input Folder")
            onPressed:
            {
                fileDialogInput.setTitle("Select Folder with image sequence");
                fileDialogInput.setNameFilters("*");
                fileDialogInput.selectNameFilter("*");
                fileDialogInput.setNameFilters("*");
                fileDialogInput.selectFolder = true;

                fileDialogInput.visible = true;
            }
        }

        Button {
            id: buttonTrack
            objectName: "buttonStartTrack"
            x: 12
            y: 206
            width: 140
            height: 40
            signal qmlStartTracking();
            text: qsTr("Start tracking")
            onPressed: {
                console.log("Starting Tracking...");
                qmlStartTracking();
            }
        }

        Button {
            id: buttonOutput
            x: 12
            y: 148
            width: 142
            height: 40
            onPressed: {
                fileDialogOutput.selectFolder = true;
                fileDialogOutput.visible = true;
            }
            text: qsTr("Set output folder")
        }






    }

    BusyIndicator {
        id: busyIndicator
        objectName: "BusyIndicator"
        running: true
        x: 290
        y: 210
        width: 159
        height: 135
        anchors.horizontalCenter: imgTracker.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 0
        anchors.horizontalCenterOffset: 0
    }

    MouseArea {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 102
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.top: parent.top
        anchors.topMargin: 8
        anchors.right: parent.right
        id: imgMouseArea
        objectName: "imgMouseArea"
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        anchors.rightMargin: 176
        hoverEnabled : true
        signal qmlMouseClickSig()
        signal qmlMouseDragSig()
        signal qmlMouseReleased()
        signal qmlMouseMoved()
        onClicked: {

            //console.log("irregular area clicked");
            //qmlMouseClickSig();
            //videoImage.source = "image://trackerframe/" + Math.random(1000)

        }
        //onDoubleClicked: qmlMouseClickSig()
        onPressAndHold:{
            cursorShape = Qt.CrossCursor;
            qmlMouseClickSig();
            hoverEnabled = true;
        }
        onPositionChanged: {
            //Draging Motion
            qmlMouseDragSig();
        }
        onReleased:{
            //Draging Motion
            qmlMouseReleased();
            //hoverEnabled = false;
            cursorShape = Qt.ArrowCursor;
        }

    }

    Image {
        id: imgTracker
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 102
        anchors.right: parent.right
        anchors.rightMargin: 182
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.top: parent.top
        anchors.topMargin: 19
        objectName: "imgTracker"
        fillMode: Image.PreserveAspectFit
        source: "qrc:/MeyerLogoIcon256x256.png"
        onStatusChanged: {
            if(status == Image.Ready)
                busyIndicator.running = false;
            //console.log("BG Calculation Done. Ready to track.")
        }



    }

    Text {
        id: txtLog
        objectName: "txtLog"
        y: 393
        width: 626
        height: 87
        text: qsTr("Tracker activity Log ")
        anchors.left: parent.left
        anchors.leftMargin: 7
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 9
        transformOrigin: Item.TopLeft
        styleColor: "#588076"
        opacity: 0.807
        font.pixelSize: 12
        signal qmlSignal(string msg)
    }

    FileDialog {
        id: fileDialogOutput
        objectName: "fileDialogOutput"
        title: "Set output file "
        folder: shortcuts.home
        //selectFile : "somefile.txt"
        signal qmlOutputFileSelectedSig(string msg)
        selectExisting: false
        onAccepted: {
            console.log("You chose: " + fileDialogOutput.fileUrls)
            qmlOutputFileSelectedSig(fileDialogOutput.fileUrls);
            Qt.quit()
        }
        onRejected: {
            console.log("Cancelled")
            Qt.quit()
        }



        //Component.onCompleted: visible = false
    }













}



/*##^##
Designer {
    D{i:2;anchors_y:8}D{i:8;anchors_height:370;anchors_width:457;anchors_x:7;anchors_y:8}
D{i:9;anchors_height:348;anchors_width:626;anchors_x:203;anchors_y:65}D{i:10;anchors_x:7}
}
##^##*/

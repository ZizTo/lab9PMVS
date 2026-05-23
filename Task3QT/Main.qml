import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtMultimedia
import com.media.player 1.0

ApplicationWindow {
    width: 800
    height: 600
    visible: true
    title: qsTr("Мультимедийный проигрыватель")

    property int currentTrackIndex: -1
    property bool isMobile: Qt.platform.os === "android" || Qt.platform.os === "ios"
    property string fallbackCover: ""

    PlaylistModel { id: playlistModel }

    MediaPlayer {
        id: player
        audioOutput: AudioOutput {}

        onErrorOccurred: (error, errorString) => {
                console.log("!!! ОШИБКА ПЛЕЕРА [" + error + "]:", errorString)
            }

        onPlaybackStateChanged: {
                console.log("Статус воспроизведения:", playbackState)
            }

        onMetaDataChanged: {
                console.log("Название из метаданных:", metaData.title)
                console.log("Ссылка на обложку:", metaData.coverArtUrl)
            }
    }

    FolderDialog {
        id: folderDialog
        title: qsTr("Выберите папку с музыкой")
        onAccepted: playlistModel.loadFolder(selectedFolder)
    }

    header: ToolBar {
        visible: !isMobile
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("Открыть папку")
                onClicked: folderDialog.open()
            }
        }
    }

    Drawer {
        id: drawer
        width: parent.width * 0.6
        height: parent.height
        visible: isMobile
        Column {
            anchors.fill: parent
            Button {
                width: parent.width
                text: qsTr("Открыть медиатеку")
                onClicked: {
                    //playlistModel.loadDeviceLibrary()
                    folderDialog.open()
                    drawer.close()
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: isMobile ? 250 : 300
            color: "#e0e0e0"
            radius: 10

            Image {
                anchors.fill: parent
                source: player.metaData.coverArtUrl || ""
                fillMode: Image.PreserveAspectFit
                visible: player.metaData.coverArtUrl !== undefined
            }

            Text {
                anchors.centerIn: parent
                text: qsTr("Нет обложки")
                visible: player.metaData.coverArtUrl === undefined
                color: "#757575"
            }
        }

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            text: {
                if (player.metaData.title) {
                    return player.metaData.title
                } else if (currentTrackIndex >= 0) {
                    return playlistModel.getTrackTitle(currentTrackIndex)
                } else {
                    return qsTr("Трек не выбран")
                }
            }
            font.pixelSize: 24
            font.bold: true
            elide: Text.ElideRight
        }

        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: playlistModel
            clip: true
            delegate: ItemDelegate {
                width: ListView.view.width
                text: model.title
                onClicked: {
                    currentTrackIndex = index
                    player.source = playlistModel.getTrackUrl(index)
                    player.play()
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Text { text: formatTime(player.position) }
            Slider {
                Layout.fillWidth: true
                from: 0
                to: player.duration
                value: player.position
                onMoved: player.position = value
            }
            Text { text: formatTime(player.duration) }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 20

            Button {
                text: "⏹"
                font.pixelSize: isMobile ? 30 : 20
                onClicked: player.stop()
            }
            Button {
                text: player.playbackState === MediaPlayer.PlayingState ? "⏸" : "▶"
                font.pixelSize: isMobile ? 36 : 24
                onClicked: {
                    if (player.playbackState === MediaPlayer.PlayingState) {
                        player.pause()
                    } else {
                        player.play()
                    }
                }
            }
        }
    }

    Button {
        text: "☰"
        visible: isMobile
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 10
        onClicked: drawer.open()
    }

    function formatTime(ms) {
        let totalSeconds = Math.floor(ms / 1000)
        let minutes = Math.floor(totalSeconds / 60)
        let seconds = totalSeconds % 60
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds
    }
}
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

ShellRoot {
    id: root

    // Theme colors Cyberpunk //Tokyonight
    property color colBg: "#210b4b" //"#1a1b26"
    property color colFg: "#ffffff"//"#a9b1d6"
    property color colMuted: "#444b6a"
    property color colCyan: "#00ccff" //"#0db9d7"
    property color colPurple: "#A42DB4" //"#ad8ee6"
    property color colRed:  "#FF3D94"//"#f7768e"
    property color colYellow: "#FFCC00" //"#e0af68"
    property color colBlue: "#7aa2f7"
    property color colGreen: "#00FFAA"

    /*
     Cyberpunk Yellow - #FFCC00
     Cyberpunk Pink - #FF3D94
     Neon Magenta - #FF00CC
     Cyberpunk Purple - #A42DB4 or #711D9A
     Synthwave Blue - #00CCFF
     Violet Cyberpunk - #210B4B
     Cyberpunk Green - #00FFAA*/


     // Font
     property string fontFamily: "JetBrainsMono Nerd Font"
     //property string fontFamily: "IosevkaMono Nerd Font"
     property int fontSize: 20

     // System info properties
     property string kernelVersion: "Linux"
     property string activeWindow: "Window"
     property string currentLayout: "Tile"

     // Kernel version
     Process {
         id: kernelProc
         command: ["uname", "-r"]
         stdout: SplitParser {
             onRead: data => {
                 if (data) kernelVersion = data.trim()
             }
         }
         Component.onCompleted: running = true
     }

      // Active window title
      Process {
          id: windowProc
          command: ["sh", "-c", "hyprctl activewindow -j | jq -r '.title // empty'"]
          stdout: SplitParser {
              onRead: data => {
                  if (data && data.trim()) {
                      activeWindow = data.trim()
                  }
              }
          }
          Component.onCompleted: running = true
      }

      // Current layout (Hyprland: dwindle/master/floating)
      Process {
          id: layoutProc
          command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .floating then \"Floating\" elif .fullscreen == 1 then \"Fullscreen\" else \"Tiled\" end'"]
          stdout: SplitParser {
              onRead: data => {
                  if (data && data.trim()) {
                      currentLayout = data.trim()
                  }
              }
          }
          Component.onCompleted: running = true
      }

        // Event-based updates for window/layout (instant)
      Connections {
          target: Hyprland
          function onRawEvent(event) {
              windowProc.running = true
              layoutProc.running = true
          }
      }

      // Backup timer for window/layout (catches edge cases)
      Timer {
          interval: 200
          running: true
          repeat: true
          onTriggered: {
              windowProc.running = true
              layoutProc.running = true
          }
      }

      Variants {
          model: Quickshell.screens

          PanelWindow {
              property var modelData
              screen: modelData

              anchors {
                  top: true
                  left: true
                  right: true
              }

              implicitHeight: 40
              color: root.colBg

              margins {
                  top: 0
                  bottom: 0
                  left: 0
                  right: 0
              }

              Rectangle {
                  anchors.fill: parent
                  color: root.colBg

                  RowLayout {
                      anchors.fill: parent
                      spacing: 0

                      Item { width: 8 }

                      Rectangle {
                          Layout.preferredWidth: 24
                          Layout.preferredHeight: 24
                          color: "transparent"

                          Image {
                              anchors.fill: parent
                              source: "file:///home/tommy/.config/quickshell/icons/NixOS.svg"
                              fillMode: Image.PreserveAspectFit
                          }
                      }

                      Item { width: 8 }

                      Repeater {
                          //model: 9
                          model: ["","","","󰺻","",""]

                          Rectangle {
                              Layout.preferredWidth: 24
                              Layout.preferredHeight: parent.height
                              color: "transparent"

                              property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
                              property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                              property bool hasWindows: workspace !== null

                              Text {
                                  //text: index + 1 //if you want numbers
                                  text: modelData
                                  color: parent.isActive ? root.colCyan : (parent.hasWindows ? root.colCyan : root.colMuted)
                                  font.pixelSize: root.fontSize
                                  font.family: root.fontFamily
                                  font.bold: true
                                  anchors.centerIn: parent
                              }

                              Rectangle {
                                  width: 20
                                  height: 3
                                  color: parent.isActive ? root.colYellow : root.colBg
                                  anchors.horizontalCenter: parent.horizontalCenter
                                  anchors.bottom: parent.bottom
                              }

                              MouseArea {
                                  anchors.fill: parent
                                  onClicked: Hyprland.dispatch("workspace " + (index + 1))
                              }
                          }
                      }

                      Rectangle {
                          Layout.preferredWidth: 1
                          Layout.preferredHeight: 16
                          Layout.alignment: Qt.AlignVCenter
                          Layout.leftMargin: 8
                          Layout.rightMargin: 8
                          color: root.colMuted
                      }

                      /*Text {
                           text: currentLayout
                           color: root.colFg
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.leftMargin: 5
                           Layout.rightMargin: 5
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 2
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }*/

                       Text {
                           text: activeWindow
                           color: root.colYellow
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.fillWidth: true
                           Layout.leftMargin: 8
                           elide: Text.ElideRight
                           maximumLineCount: 1
                       }

                       Text {
                           text: " " + kernelVersion
                           //text: Kernel.kernelVersion
                           color: root.colRed
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 0
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }

                       Text {
                           text: " " + Cpu.cpuUsage + "%"
                           //text: Cpu.cpuUsage
                           color: root.colGreen
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 0
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }


                       Text {
                           text: " " + Memory.memUsage + "%"
                           color: root.colCyan
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 0
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }

                       Text {
                           text: " " + Disk.diskUsage + "%"
                           color: root.colBlue
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 0
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }

                       Text {
                           text: " " + Vol.volumeLevel + "% " + Mic.micLevel + "%"
                           color: root.colYellow
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 0
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }

                       Text {
                           text: Battery.batUsage
                           color: root.colRed
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                       }

                       Rectangle {
                           Layout.preferredWidth: 1
                           Layout.preferredHeight: 16
                           Layout.alignment: Qt.AlignVCenter
                           Layout.leftMargin: 0
                           Layout.rightMargin: 8
                           color: root.colMuted
                       }

                       Text {
                           text: Time.time
                           color: root.colCyan
                           font.pixelSize: root.fontSize
                           font.family: root.fontFamily
                           font.bold: true
                           Layout.rightMargin: 8
                           }

                       Item { width: 8 }
                   }
               }
           }
       }
   }

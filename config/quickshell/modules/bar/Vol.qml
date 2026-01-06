// Vol.qml

// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string volumeLevel

  Process {
          id: volProc
          command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
          running: true
          
          stdout: SplitParser {
              onRead: data => {
                  if (!data) return
                  var match = data.match(/Volume:\s*([\d.]+)/)
                  if (match) {
                      volumeLevel = Math.round(parseFloat(match[1]) * 100)
                  }
              }
          }
          Component.onCompleted: running = true
      }

  Timer {
    interval: 500
    running: true
    repeat: true
    onTriggered: volProc.running = true
  }
}

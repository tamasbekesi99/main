// Memory.qml

// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string memUsage

  Process {
    id: memoryProc
    command: ["sh", "-c", "free | grep Mem"]
    running: true

    stdout: SplitParser {
              onRead: data => {
                  if (!data) return
                  var parts = data.trim().split(/\s+/)
                  var total = parseInt(parts[1]) || 1
                  var used = parseInt(parts[2]) || 0
                  memUsage = Math.round(100 * used / total)
              }
          }
    Component.onCompleted: running = true
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    onTriggered: memoryProc.running = true
  }
}

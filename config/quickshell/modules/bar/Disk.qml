// Disk.qml

// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string diskUsage

  Process {
          id: diskProc
          command: ["sh", "-c", "df / | tail -1"]
          running: true
          
          stdout: SplitParser {
              onRead: data => {
                  if (!data) return
                  var parts = data.trim().split(/\s+/)
                  var percentStr = parts[4] || "0%"
                  diskUsage = parseInt(percentStr.replace('%', '')) || 0
              }
          }
          Component.onCompleted: running = true
  }

  Timer {
    interval: 10000
    running: true
    repeat: true
    onTriggered: diskProc.running = true
  }
}

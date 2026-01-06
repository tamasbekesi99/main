// Battery.qml

// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string batUsage

   Process {
         id: batteryProc
         // Modify command to get both capacity and status in one call
         command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity"]
         running: true

         stdout: SplitParser {
             onRead: data => {
                 if (data) batUsage = data.trim()
              }
          }
          Component.onCompleted: running = true
      }

  Timer {
    interval: 120000
    running: true
    repeat: true
    onTriggered: batteryProc.running = true
  }
}

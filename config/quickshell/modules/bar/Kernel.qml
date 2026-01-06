// Kernel.qml

// with this line our type becomes a Singleton
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// your singletons should always have Singleton as the type
Singleton {
  id: root
  property string kernel

  Process {
    id: kernelProc
    command: ["uname", "-r"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.kernel = this.text
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: kernelProc.running = true
  }
}

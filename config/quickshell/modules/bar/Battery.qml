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
         command: ["sh", "-c", "echo $(cat /sys/class/power_supply/BAT0/capacity),$(cat /sys/class/power_supply/BAT0/status)"]
         running: true

        stdout: SplitParser {
			onRead: function(data) {
			const [capacityStr, status] = data.trim().split(',')
			const capacity = parseInt(capacityStr)
			let batteryIcon = "󰂂"
				if (capacity <= 20) batteryIcon = "󰁺"
				else if (capacity <= 40) batteryIcon = "󰁽"
				else if (capacity <= 60) batteryIcon = "󰁿"
				else if (capacity <= 80) batteryIcon = "󰂁"
			else batteryIcon = "󰂂"
        
        const symbol = status === "Charging" ? "󰂄" : batteryIcon
        batUsage = `${symbol}${capacity}%`
      }
       //   Component.onCompleted: running = true
      }
      }

  Timer {
    interval: 120000
    running: true
    repeat: true
    onTriggered: batteryProc.running = true
  }
}

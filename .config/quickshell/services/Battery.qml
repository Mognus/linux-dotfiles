pragma Singleton

import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root

    // First real laptop battery, null on machines without one (e.g. the desktop).
    readonly property var device: root.findBattery()
    readonly property bool present: root.device !== null
    // 0-100; Quickshell reports the device percentage as 0-1.
    readonly property int percent: root.present ? Math.round(root.device.percentage * 100) : 0
    readonly property bool charging: root.present && root.device.state === UPowerDeviceState.Charging

    function findBattery() {
        const devices = UPower.devices.values;
        for (let i = 0; i < devices.length; i++) {
            if (devices[i].isLaptopBattery) {
                return devices[i];
            }
        }
        return null;
    }
}

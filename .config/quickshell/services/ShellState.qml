pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool bottomBarVisible: true
    property bool tuxVisible: true

    IpcHandler {
        target: "bottombar"

        function toggle(): void {
            root.bottomBarVisible = !root.bottomBarVisible;
        }
    }

    IpcHandler {
        target: "tux"

        function toggle(): void {
            root.tuxVisible = !root.tuxVisible;
        }
    }
}

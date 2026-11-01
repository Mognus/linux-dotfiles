pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property bool bottomBarVisible: true
    property bool tuxVisible: true
    property bool themeSwitcherOpen: false

    function closeThemeSwitcher() {
        root.themeSwitcherOpen = false;
    }

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

    IpcHandler {
        target: "theme"

        function toggle(): void {
            root.themeSwitcherOpen = !root.themeSwitcherOpen;
        }

        function close(): void {
            root.closeThemeSwitcher();
        }
    }
}

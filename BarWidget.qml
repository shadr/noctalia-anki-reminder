import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Widgets
import qs.Services.UI

Rectangle {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    readonly property var pluginSettings: {
        return pluginApi && pluginApi.pluginSettings ? pluginApi.pluginSettings : {
        };
    }

    property bool didAnkiToday: false
    readonly property string ankiDatabasePath: root.pluginSettings.ankiDatabasePath
    readonly property string doColor: root.pluginSettings.doColor

    BarPill {
        id: pill

        visible: !root.didAnkiToday

        screen: root.screen
        autoHide: true

        oppositeDirection: BarService.getPillDirection(root)
        text: root.didAnkiToday ? "" : "Do your anki!!!"
        customTextColor: Color.resolveColorKeyOptional(doColor)

        forceOpen: true

        onRightClicked: {
            PanelService.showContextMenu(contextMenu, pill, screen);
        }

    }

    Process {
        id: scriptProc
        command: ["sqlite3", root.ankiDatabasePath, "SELECT c.mod FROM cards c JOIN decks d ON c.did == d.id WHERE d.name == 'Kaishi 1.5k' COLLATE NOCASE AND date(c.mod, 'unixepoch') > datetime('now', 'localtime', 'start of day', '-1 day')"]
        stdout: StdioCollector {
            onTextChanged: root.didAnkiToday = text.trim() !== ""
        }
    }

    Timer {
        interval: 30000; running: true; repeat: true; triggeredOnStart: true;
        onTriggered: {
            scriptProc.running = true;
        }
    }

    NPopupContextMenu {
        id: contextMenu

        model: [{
            "label": "Settings",
            "action": "plugin-settings",
            "icon": "settings"
        }]
        onTriggered: (action) => {
            contextMenu.close();
            PanelService.closeContextMenu(screen)
            if (action == "plugin-settings")
                BarService.openPluginSettings(screen, pluginApi.manifest)
        }
    }
}

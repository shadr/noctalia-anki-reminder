import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Modules.Bar.Extras
import qs.Widgets
import qs.Services.UI

Item {
    id: root

    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""

    readonly property string scriptPath: Qt.resolvedUrl("query-anki.sh").toString().replace("file://", "")

    readonly property var pluginSettings: {
        return pluginApi && pluginApi.pluginSettings ? pluginApi.pluginSettings : {
        };
    }

    property bool didAnkiToday: false
    readonly property string ankiDatabasePath: root.pluginSettings.ankiDatabasePath
    readonly property string deckName: root.pluginSettings.deckName
    readonly property string doColor: root.pluginSettings.doColor

    BarPill {
        id: pill

        visible: !root.didAnkiToday

        screen: root.screen
        autoHide: true

        oppositeDirection: BarService.getPillDirection(root)
        text: root.didAnkiToday ? "" : "Do your Anki"
        customTextColor: Color.resolveColorKeyOptional(doColor)

        forceOpen: true

        onRightClicked: {
            PanelService.showContextMenu(contextMenu, pill, screen);
        }

    }

    Process {
        id: scriptProc
        command: [root.scriptPath, root.ankiDatabasePath, root.deckName]
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

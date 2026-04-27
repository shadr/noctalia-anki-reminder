import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    // Plugin API (injected by the settings dialog system)
    property var pluginApi: null

    property string ankiDatabasePath: pluginApi?.pluginSettings?.ankiDatabasePath || ""
    property string deckName: pluginApi?.pluginSettings?.deckName || ""
    property string doColor: pluginApi?.pluginSettings?.doColor || ""
    property string newDayHourStr: String(pluginApi?.pluginSettings?.newDayHour ?? 3)
    property int newDayHour: parseInt(newDayHourStr) || 3

    NTextInput {
        Layout.fillWidth: true
        label: "Anki Database"
        description: "Path to the anki sqlite database file"
        placeholderText: "Anki Sqlite database path"
        text: root.ankiDatabasePath
        onTextChanged: root.ankiDatabasePath = text
    }

    NTextInput {
        Layout.fillWidth: true
        label: "Deck Name"
        description: "Name of the deck"
        placeholderText: "Deck"
        text: root.deckName
        onTextChanged: root.deckName = text
    }

    NColorChoice {
        label: "Do Color"
        description: "Text color when you still need to do your daily anki"
        currentKey: root.doColor
        onSelected: (key) => {
            root.doColor = key;
        }
    }

    NTextInput {
        Layout.fillWidth: true
        label: "New Day Hour"
        description: "Hour (0-23) when a new day starts in Anki"
        placeholderText: "3"
        text: root.newDayHourStr
        onTextChanged: {
            let val = parseInt(text)
            if (!isNaN(val) && val >= 0 && val <= 23) {
                root.newDayHourStr = text
            }
        }
    }

    // Required: Save function called by the dialog
    function saveSettings() {
        pluginApi.pluginSettings.ankiDatabasePath = root.ankiDatabasePath
        pluginApi.pluginSettings.deckName = root.deckName
        pluginApi.pluginSettings.doColor = root.doColor
        pluginApi.pluginSettings.newDayHour = root.newDayHour
        pluginApi.saveSettings()
    }
}

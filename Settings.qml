import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root

    // Plugin API (injected by the settings dialog system)
    property var pluginApi: null

    property string ankiDatabasePath: pluginApi?.pluginSettings?.ankiDatabasePath || ""
    property string doColor: pluginApi?.pluginSettings?.doColor || ""

    // Your settings controls here

    NTextInput {
        Layout.fillWidth: true
        label: "Anki Database"
        description: "Path to the anki sqlite database file"
        placeholderText: "Anki Sqlite database path"
        text: root.ankiDatabasePath
        onTextChanged: root.ankiDatabasePath = text
    }

    NColorChoice {
        label: "Do Color"
        description: "Text color when you still need to do your daily anki"
        currentKey: root.doColor
        onSelected: (key) => {
            root.doColor = key;
        }
    }

    // Required: Save function called by the dialog
    function saveSettings() {
        pluginApi.pluginSettings.ankiDatabasePath = root.ankiDatabasePath
        pluginApi.pluginSettings.doColor = root.doColor
        pluginApi.saveSettings()
    }
}

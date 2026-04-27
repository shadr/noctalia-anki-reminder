#!/usr/bin/env sh
databasePath=$1
deckName=$2
newDayHour=${3:-3}

querySqlite() {
    query="SELECT DISTINCT c.id FROM cards c LEFT JOIN decks d ON d.id == c.did JOIN revlog r ON c.id == r.cid WHERE d.name == '${deckName}' COLLATE NOCASE AND datetime(r.id / 1000, 'unixepoch', 'localtime') >= datetime('now', 'localtime', '-${newDayHour} hours', 'start of day', '+${newDayHour} hours')"
    sqlite3 "$databasePath" "$query" 2>/dev/null
}

queryConnect() {
    result=$(curl -s -X POST -H "Context-Type: application/json" -d "{\"action\": \"findCards\", \"version\": 6, \"params\": {\"query\": \"\\\"deck:${deckName}\\\" rated:1\"}}" localhost:8765)
    if [ ! "$result" = "" ]; then
        case $result in
        *'"result": []'*)
            return 1
            ;;
        *)
            echo "did"
            return 0
            ;;
        esac
    fi
    return 1
}

querySqlite || queryConnect

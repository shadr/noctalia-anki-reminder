#!/usr/bin/env sh
databasePath=$1
deckName=$2

querySqlite() {
    query="SELECT c.id FROM cards c JOIN decks d ON d.id == c.did JOIN revlog r ON c.id == r.cid WHERE d.name == '${deckName}' COLLATE NOCASE AND date(r.id / 1000, 'unixepoch') > datetime('now', 'localtime', 'start of day', '-1 day')"
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

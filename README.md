# Anki Reminder

A simple bar widget for [Noctalia](https://github.com/noctalia/noctalia) that reminds you to complete your daily Anki reviews.

## Features

- Displays a reminder pill in the Noctalia bar when you haven't reviewed your Anki deck today
- Supports both direct SQLite database access and AnkiConnect API

## Requirements

You must have at least one of the following:

- `sqlite3` for direct database queries
- [AnkiConnect](https://git.sr.ht/~foosoft/anki-connect) and `curl` for API-based queries

> **Note:** When Anki is open, the database is locked and the plugin cannot read it directly. When Anki is closed, AnkiConnect is not running and API-based queries won't work. For the plugin to work in both cases both dependencies are required.

## Installation

1. Clone or download this repository into your Noctalia plugins directory

``` sh
cd ~/.local/share/noctalia/plugins/
git clone https://github.com/shadr/noctalia-anki-reminder
```

2. Add the reminder widget to your bar (Noctalia Settings -> Bar -> Widgets)
3. Configure the reminder settings

## Configuration

- Database Path - path to your Anki collection database (e.g `~/.local/share/Anki2/User*`)
- Deck Name - name of the deck to track
- Do Color - color of the reminder text

## License

This projects is licensed under the MIT license. See [LICENSE](LICENSE) for details.

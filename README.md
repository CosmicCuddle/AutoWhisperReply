# Auto Whisper Reply

A lightweight World of Warcraft 3.3.5a addon that automatically replies to incoming whispers with a customisable message.

## Features

- Toggle automatic whisper replies on or off.
- Set your own automatic reply message.
- Configure a per-player reply cooldown to prevent whisper spam.
- Settings are saved separately for each character.
- Simple Interface Options panel.
- Slash commands for quick configuration.

## Compatibility

- World of Warcraft 3.3.5a
- Interface version: `30300`
- Designed for Wrath of the Lich King 3.3.5a clients.

## Installation

1. Download the addon.
2. Extract the `AutoWhisperReply` folder.
3. Place it inside your World of Warcraft addon directory:

   `World of Warcraft/Interface/AddOns/`

4. The final folder should look like:

   `Interface/AddOns/AutoWhisperReply/`

5. Start World of Warcraft and make sure **Auto Whisper Reply** is enabled in the AddOns menu.

## Usage

Open the settings panel with:

`/awr config`

You can also open it from **Interface > AddOns > Auto Whisper Reply**.

The addon is disabled by default. Enable it before automatic replies will be sent.

### Slash Commands

| Command | Description |
| --- | --- |
| `/awr on` | Enable automatic replies. |
| `/awr off` | Disable automatic replies. |
| `/awr toggle` | Toggle automatic replies on or off. |
| `/awr msg <message>` | Change the automatic reply message. |
| `/awr cooldown <seconds>` | Change the per-player reply cooldown. |
| `/awr status` | Show the current settings. |
| `/awr config` | Open the settings panel. |
| `/autoreply` | Alternative command for the addon. |

## Default Settings

- Automatic replies: **Off**
- Message: `I am currently AFK. I will reply when I am back.`
- Per-player cooldown: **300 seconds**

The cooldown prevents the same player repeatedly triggering the automatic response. Set the cooldown to `0` if you want the addon to answer every whisper.

## Version

**1.0.0**

Initial release of Auto Whisper Reply.

## Author

Cosmic Server

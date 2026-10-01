# Level 4 - La Terminal Cifrada

Flutter Team 1. Mobile only (Android and iOS).

Luna enters a dark room where only a terminal is lit. She has to solve three puzzles (binary message, Caesar cipher and final password) to open the door and get Key 4.

User stories, mockups and diagrams are in the Wiki page **Level 4 - La Terminal Cifrada**.

## Files

| File | What it has |
|---|---|
| `level_04_screen.dart` | Entry point of the level. Use `Level04Screen` to open it. |
| `dark_room.dart` | View 1. The dark room where Luna walks. |
| `locked_terminal.dart` | View 2. The terminal with ACCESS DENIED. |
| `terminal_frame.dart` | The terminal body and screen. The other terminal views reuse it. |
| `luna_sprite.dart` | Luna drawn in pixel art. |
| `system_message.dart` | System message banner and blinking hint. |

## How to try it

From the `frontend` folder:

```bash
flutter pub get
flutter run
```

To open the level from another screen:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const Level04Screen()),
);
```

## Views

1. Dark Room - done
2. Locked Terminal - done
3. Binary Message - pending
4. Caesar Cipher - pending
5. Wrong Password - pending
6. Access Granted - pending

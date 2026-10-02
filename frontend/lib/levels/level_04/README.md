# Level 4 - La Terminal Cifrada

Flutter Team 1. Mobile only (Android and iOS).

Luna enters a dark room where only a terminal is lit. She has to solve three puzzles (binary message, Caesar cipher and final password) to open the door and get Key 4.

User stories, mockups and diagrams are in the Wiki page **Level 4 - La Terminal Cifrada**.

## Files

| File | What it has |
|---|---|
| `level_04_screen.dart` | Entry point of the level. Use `Level04Screen` to open it. It connects the six views and runs the timer. |
| `dark_room.dart` | View 1. The dark room where Luna walks. |
| `locked_terminal.dart` | View 2. The terminal with ACCESS DENIED. |
| `binary_message.dart` | View 3. Puzzle 1, the binary message. |
| `caesar_cipher.dart` | View 4. Puzzle 2, the Caesar cipher. |
| `final_password.dart` | View 5. Puzzle 3, the final password and the error message. |
| `access_granted.dart` | View 6. The room with light, Key 4 and the open door. |
| `terminal_frame.dart` | The terminal body and screen. The terminal views reuse it. |
| `terminal_keypad.dart` | The keys of the terminal. The puzzles use it instead of the phone keyboard. |
| `luna_sprite.dart` | Luna drawn in pixel art. |
| `system_message.dart` | System message banner and blinking hint. |
| `TESTING.md` | Test report on an Android phone. |

## How to play

1. Tap the floor to move Luna. Tap the terminal when she is close.
2. Solve the three puzzles with the keys of the terminal. The **?** button gives hints and the **X** button goes back to the room.
3. When the password is right, pick up Key 4 and walk through the door.

The level has a limit of 5 minutes. Wrong answers do not take time away.

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
3. Binary Message - done
4. Caesar Cipher - done
5. Wrong Password - done
6. Access Granted - done

## Pending for the integration

- Open Level 4 from the game menu after Level 3.
- Open Level 5 when Luna leaves through the door (`_goToLevel5` in `level_04_screen.dart`).
- Save the progress in the backend.

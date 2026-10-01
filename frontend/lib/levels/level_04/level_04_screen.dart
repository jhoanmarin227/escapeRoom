import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dark_room.dart';
import 'locked_terminal.dart';

/// Entry screen of Level 4 - La Terminal Cifrada.
///
/// It starts in the dark room (view 1). When the player taps the
/// terminal, the locked terminal (view 2) opens on top of the room.
class Level04Screen extends StatefulWidget {
  const Level04Screen({super.key});

  @override
  State<Level04Screen> createState() => _Level04ScreenState();
}

class _Level04ScreenState extends State<Level04Screen> {
  bool _terminalOpen = false;

  @override
  void initState() {
    super.initState();
    // The level is played in landscape.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Give the orientation back to the rest of the app.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  void _startPuzzles() {
    // The binary message view (puzzle 1) will be opened from here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Puzzle 1: mensaje binario (pendiente)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050D1C),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // The room stays behind so Luna keeps her place.
            DarkRoom(
              onTerminalTap: () => setState(() => _terminalOpen = true),
            ),
            if (_terminalOpen)
              LockedTerminal(
                onClose: () => setState(() => _terminalOpen = false),
                onStart: _startPuzzles,
              ),
          ],
        ),
      ),
    );
  }
}

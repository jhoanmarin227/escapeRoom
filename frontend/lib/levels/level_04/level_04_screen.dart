import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'access_granted.dart';
import 'binary_message.dart';
import 'caesar_cipher.dart';
import 'dark_room.dart';
import 'final_password.dart';
import 'locked_terminal.dart';

/// Entry screen of Level 4 - La Terminal Cifrada.
///
/// Order of the level:
/// dark room -> locked terminal -> binary message -> Caesar cipher
/// -> final password -> access granted.
/// The terminal views open on top of the room. The X button goes back
/// to the room and the player keeps the puzzle where he was.
/// The level has a time limit. Wrong answers do not take time away.
class Level04Screen extends StatefulWidget {
  const Level04Screen({super.key});

  /// Time to finish the level, in seconds (5 minutes).
  static const int timeLimit = 300;

  @override
  State<Level04Screen> createState() => _Level04ScreenState();
}

class _Level04ScreenState extends State<Level04Screen> {
  bool _terminalOpen = false;

  // 0 = locked terminal, 1 = binary, 2 = Caesar, 3 = final password.
  int _puzzle = 0;

  // True when the password is right: the room lights up.
  bool _granted = false;

  int _secondsLeft = Level04Screen.timeLimit;
  Timer? _timer;

  // Changes on every retry so the room starts again from zero.
  int _attempt = 0;

  bool get _timeUp => _secondsLeft <= 0;

  @override
  void initState() {
    super.initState();
    // The level is played in landscape.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Full screen: hides the status bar and the navigation buttons.
    // They come back for a moment if the player swipes from the edge.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Give the orientation and the system bars back to the rest of the app.
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() {
          _secondsLeft = 0;
          _terminalOpen = false;
        });
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _retry() {
    setState(() {
      _secondsLeft = Level04Screen.timeLimit;
      _terminalOpen = false;
      _puzzle = 0;
      _granted = false;
      _attempt++;
    });
    _startTimer();
  }

  void _closeTerminal() => setState(() => _terminalOpen = false);

  void _nextPuzzle() => setState(() => _puzzle++);

  void _grantAccess() {
    // The timer stops when the level is solved.
    _timer?.cancel();
    setState(() {
      _granted = true;
      _terminalOpen = false;
    });
  }

  void _goToLevel5() {
    // Level 5 will be opened from here.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nivel 4 completado. Sigue el Nivel 5.')),
    );
  }

  /// The terminal view of the puzzle the player is on.
  Widget _terminalView() {
    switch (_puzzle) {
      case 0:
        return LockedTerminal(onClose: _closeTerminal, onStart: _nextPuzzle);
      case 1:
        return BinaryMessage(onClose: _closeTerminal, onSolved: _nextPuzzle);
      case 2:
        return CaesarCipher(onClose: _closeTerminal, onSolved: _nextPuzzle);
      default:
        return FinalPassword(onClose: _closeTerminal, onSolved: _grantAccess);
    }
  }

  /// Time left as mm:ss, for example 04:59.
  String get _clock {
    final minutes = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // The clock turns red in the last 30 seconds.
    final clockColor = _secondsLeft <= 30
        ? const Color(0xFFFF6B6B)
        : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: const Color(0xFF050D1C),
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (_granted)
              AccessGranted(onContinue: _goToLevel5)
            else
              // The room stays behind so Luna keeps her place.
              DarkRoom(
                key: ValueKey(_attempt),
                onTerminalTap: () => setState(() => _terminalOpen = true),
              ),
            if (_terminalOpen && !_granted) _terminalView(),

            // Level timer (top left)
            Positioned(
              left: 12,
              top: 12,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xE6111827),
                    border: Border.all(color: clockColor, width: 2),
                  ),
                  child: Text(
                    _clock,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontFamilyFallback: const ['Courier'],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: clockColor,
                    ),
                  ),
                ),
              ),
            ),

            // Time is over
            if (_timeUp && !_granted) _TimeUp(onRetry: _retry),
          ],
        ),
      ),
    );
  }
}

/// Covers the level when the time runs out.
class _TimeUp extends StatelessWidget {
  const _TimeUp({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    const red = Color(0xFFFF6B6B);
    const style = TextStyle(
      fontFamily: 'monospace',
      fontFamilyFallback: ['Courier'],
      fontWeight: FontWeight.bold,
      letterSpacing: 2,
    );
    return ColoredBox(
      color: const Color(0xE6050D1C),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'TIEMPO AGOTADO',
              style: style.copyWith(fontSize: 26, color: red),
            ),
            const SizedBox(height: 8),
            Text(
              'La terminal se bloqueó.',
              style: style.copyWith(
                fontSize: 13,
                letterSpacing: 1,
                color: const Color(0xFFE2E8F0),
              ),
            ),
            const SizedBox(height: 18),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  border: Border.all(color: const Color(0xFFFACC15), width: 2),
                ),
                child: Text(
                  'REINTENTAR',
                  style: style.copyWith(
                    fontSize: 14,
                    color: const Color(0xFFFACC15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

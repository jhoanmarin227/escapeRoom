import 'package:flutter/material.dart';

import 'terminal_frame.dart';

/// Level 4 - La Terminal Cifrada. View 2: locked terminal.
///
/// Shows the terminal with ACCESS DENIED and the empty password boxes.
/// - The X button calls [onClose] to go back to the dark room.
/// - Tapping the password boxes calls [onStart] to begin the puzzles.
class LockedTerminal extends StatelessWidget {
  const LockedTerminal({super.key, this.onClose, this.onStart});

  /// Called when the player closes the terminal.
  final VoidCallback? onClose;

  /// Called when the player taps the password boxes.
  final VoidCallback? onStart;

  // The final password has 5 characters (LUNA4).
  static const int passwordLength = 5;

  @override
  Widget build(BuildContext context) {
    return TerminalFrame(
      onClose: onClose,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '> NEXUS-9 // SECTOR 4',
            style: terminalText(size: 13, color: TerminalColors.blue),
          ),
          const SizedBox(height: 12),

          // ACCESS DENIED sign
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
            decoration: BoxDecoration(
              color: TerminalColors.redScreen,
              border: Border.all(color: TerminalColors.red, width: 2),
            ),
            child: Text(
              'ACCESS DENIED',
              style: terminalText(
                size: 22,
                color: TerminalColors.redText,
                spacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 14),

          Text('ENTER PASSWORD:', style: terminalText(size: 15)),
          const SizedBox(height: 10),

          // Empty password boxes. The first one has a blinking cursor.
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onStart,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < passwordLength; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _PasswordBox(active: i == 0),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tells the player what to do next.
          Text(
            'TOCA LAS CASILLAS PARA DESCIFRAR',
            style: terminalText(size: 11, color: TerminalColors.cyan),
          ),
        ],
      ),
    );
  }
}

/// One empty box of the password. The active one shows a blinking cursor.
class _PasswordBox extends StatelessWidget {
  const _PasswordBox({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 40,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: active ? TerminalColors.cyan : TerminalColors.dimBlue,
          width: 2,
        ),
      ),
      child: active ? const _Cursor() : null,
    );
  }
}

class _Cursor extends StatefulWidget {
  const _Cursor();

  @override
  State<_Cursor> createState() => _CursorState();
}

class _CursorState extends State<_Cursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blink = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _blink.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _blink,
      child: Container(width: 14, height: 4, color: TerminalColors.cyan),
    );
  }
}

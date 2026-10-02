import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'terminal_frame.dart';

/// Keys of the terminal, drawn inside the game.
///
/// The puzzles use these keys and not the phone keyboard, because in
/// landscape the phone keyboard covers half of the screen.
/// On a computer the real keyboard also works.
class TerminalKeypad extends StatelessWidget {
  const TerminalKeypad({
    super.key,
    required this.onKey,
    required this.onDelete,
    this.digits = false,
  });

  /// Called with the letter or number of the key.
  final ValueChanged<String> onKey;

  /// Called when the player taps the delete key.
  final VoidCallback onDelete;

  /// Shows a row with the numbers 0 to 9 (used by the final password).
  final bool digits;

  static const List<String> _rows = ['ABCDEF', 'GHIJKL', 'MNOPQR', 'STUVWX'];

  // Size of one key and the space between keys.
  static const double _key = 37;
  static const double _gap = 4;

  KeyEventResult _onHardwareKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      onDelete();
      return KeyEventResult.handled;
    }
    final typed = event.character;
    if (typed == null || typed.length != 1) return KeyEventResult.ignored;
    final isLetter = RegExp('[a-zA-Z]').hasMatch(typed);
    final isDigit = digits && RegExp('[0-9]').hasMatch(typed);
    if (!isLetter && !isDigit) return KeyEventResult.ignored;
    onKey(typed.toUpperCase());
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onHardwareKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (digits) ...[
            _row([for (final d in '01234'.split('')) _letterKey(d)]),
            _row([for (final d in '56789'.split('')) _letterKey(d)]),
          ],
          for (final letters in _rows)
            _row([for (final l in letters.split('')) _letterKey(l)]),
          // Last row: Y, Z and the delete key.
          _row([
            _letterKey('Y'),
            _letterKey('Z'),
            _KeyButton(
              label: 'BORRAR',
              width: _key * 4 + _gap * 3,
              height: _keyHeight,
              fontSize: 13,
              color: TerminalColors.redText,
              onTap: onDelete,
            ),
          ]),
        ],
      ),
    );
  }

  // With the numbers there are two more rows, so the keys are shorter.
  double get _keyHeight => digits ? 34 : _key;

  Widget _letterKey(String label) {
    return _KeyButton(
      label: label,
      width: _key,
      height: _keyHeight,
      fontSize: 16,
      color: TerminalColors.white,
      onTap: () => onKey(label),
    );
  }

  Widget _row(List<Widget> keys) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _gap),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < keys.length; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            keys[i],
          ],
        ],
      ),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.width,
    required this.height,
    required this.fontSize,
    required this.color,
    required this.onTap,
  });

  final String label;
  final double width;
  final double height;
  final double fontSize;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: TerminalColors.bodyDark,
          border: Border.all(color: TerminalColors.blue, width: 2),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          label,
          style: terminalText(size: fontSize, color: color, spacing: 0),
        ),
      ),
    );
  }
}

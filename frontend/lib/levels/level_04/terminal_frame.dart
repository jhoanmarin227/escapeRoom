import 'package:flutter/material.dart';

/// Colors of the terminal, taken from the Level 4 mockups.
class TerminalColors {
  static const wall = Color(0xFF0E1E3A);
  static const body = Color(0xFF1B3157);
  static const bodyDark = Color(0xFF12213F);
  static const screen = Color(0xFF06112A);
  static const cyan = Color(0xFF38BDF8);
  static const blue = Color(0xFF60A5FA);
  static const dimBlue = Color(0xFF1F5A8A);
  static const white = Color(0xFFE2E8F0);
  static const red = Color(0xFFEF4444);
  static const redText = Color(0xFFFF6B6B);
  static const redScreen = Color(0xFF2A0508);
}

/// Text style used inside the terminal.
TextStyle terminalText({
  double size = 14,
  Color color = TerminalColors.white,
  double spacing = 1,
  FontWeight weight = FontWeight.bold,
}) {
  return TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: const ['Courier'],
    fontSize: size,
    color: color,
    letterSpacing: spacing,
    fontWeight: weight,
  );
}

/// The terminal seen from the front: metal body, title and screen.
///
/// The other terminal views of Level 4 (binary message, Caesar cipher,
/// wrong password) can use this same frame and only change [child],
/// which is what is drawn inside the screen.
class TerminalFrame extends StatelessWidget {
  const TerminalFrame({super.key, required this.child, this.onClose});

  /// Content of the screen.
  final Widget child;

  /// Called when the player taps the X button. If null, no button.
  final VoidCallback? onClose;

  // Same base size as the dark room. FittedBox scales it to any screen.
  static const double width = 640;
  static const double height = 360;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF050D1C),
      child: Center(
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                // Wall behind the terminal
                const Positioned.fill(
                  child: ColoredBox(color: TerminalColors.wall),
                ),

                // Terminal body
                Positioned(
                  left: 72,
                  right: 72,
                  top: 22,
                  bottom: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: TerminalColors.body,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(6),
                      ),
                    ),
                  ),
                ),

                // Screws
                const Positioned(left: 84, top: 32, child: _Screw()),
                const Positioned(right: 84, top: 32, child: _Screw()),

                // Title
                Positioned(
                  left: 0,
                  right: 0,
                  top: 36,
                  child: Text(
                    'TERMINAL',
                    textAlign: TextAlign.center,
                    style: terminalText(
                      size: 18,
                      color: TerminalColors.blue,
                      spacing: 8,
                    ),
                  ),
                ),

                // Side vents
                const Positioned(left: 86, top: 172, child: _Vent()),
                const Positioned(right: 86, top: 172, child: _Vent()),

                // Screen
                Positioned(
                  left: 122,
                  right: 122,
                  top: 72,
                  bottom: 62,
                  child: Container(
                    decoration: BoxDecoration(
                      color: TerminalColors.screen,
                      border: Border.all(color: TerminalColors.cyan, width: 2),
                    ),
                    child: child,
                  ),
                ),

                // Slot under the screen
                Positioned(
                  left: 246,
                  right: 246,
                  bottom: 18,
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: TerminalColors.bodyDark,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),

                // Close button
                if (onClose != null)
                  Positioned(
                    right: 12,
                    top: 12,
                    child: GestureDetector(
                      onTap: onClose,
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: TerminalColors.bodyDark,
                          border: Border.all(
                            color: TerminalColors.blue,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          'X',
                          style: terminalText(
                            size: 18,
                            color: TerminalColors.blue,
                            spacing: 0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Screw extends StatelessWidget {
  const _Screw();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: TerminalColors.bodyDark,
        border: Border.all(color: const Color(0xFF2A4A7A), width: 2),
      ),
    );
  }
}

class _Vent extends StatelessWidget {
  const _Vent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < 5; i++)
          Container(
            width: 18,
            height: 4,
            margin: const EdgeInsets.only(bottom: 5),
            color: TerminalColors.bodyDark,
          ),
      ],
    );
  }
}

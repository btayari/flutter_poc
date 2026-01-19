import 'package:flutter/material.dart';

class PitchBackground extends StatelessWidget {
  const PitchBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a28),
        image: DecorationImage(
          image: const AssetImage('assets/pitch_pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.03,
          onError: (error, stackTrace) {
            // Fallback if image doesn't exist
          },
        ),
      ),
      child: CustomPaint(
        painter: PitchPainter(),
      ),
    );
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.12,
      paint,
    );

    // Penalty box top
    final penaltyBoxWidth = size.width * 0.6;
    final penaltyBoxHeight = size.height * 0.15;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        0,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );

    // Penalty box bottom
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        size.height - penaltyBoxHeight,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );

    // Goal box top
    final goalBoxWidth = size.width * 0.33;
    final goalBoxHeight = size.height * 0.06;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalBoxWidth) / 2,
        0,
        goalBoxWidth,
        goalBoxHeight,
      ),
      paint,
    );

    // Goal box bottom
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalBoxWidth) / 2,
        size.height - goalBoxHeight,
        goalBoxWidth,
        goalBoxHeight,
      ),
      paint,
    );

    // Corner arcs
    final cornerRadius = size.width * 0.08;

    // Top-left corner
    canvas.drawArc(
      Rect.fromLTWH(0, 0, cornerRadius * 2, cornerRadius * 2),
      0,
      1.57,
      false,
      paint,
    );

    // Top-right corner
    canvas.drawArc(
      Rect.fromLTWH(size.width - cornerRadius * 2, 0, cornerRadius * 2, cornerRadius * 2),
      1.57,
      1.57,
      false,
      paint,
    );

    // Bottom-left corner
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2),
      4.71,
      1.57,
      false,
      paint,
    );

    // Bottom-right corner
    canvas.drawArc(
      Rect.fromLTWH(
        size.width - cornerRadius * 2,
        size.height - cornerRadius * 2,
        cornerRadius * 2,
        cornerRadius * 2,
      ),
      3.14,
      1.57,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

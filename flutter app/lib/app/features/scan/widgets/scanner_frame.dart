//  Scanner Frame 

// ignore_for_file: unnecessary_underscores, deprecated_member_use

import 'package:flutter/material.dart';

class ScannerFrame extends StatefulWidget {
  const ScannerFrame({super.key});

  @override
  State<ScannerFrame> createState() => _ScannerFrameState();
}

class _ScannerFrameState extends State<ScannerFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scanAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _scanAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final frameW = size.width * 0.75;
    final frameH = frameW;

    return SizedBox(
      width: frameW,
      height: frameH,
      child: Stack(
        children: [
          // Corner brackets
          CustomPaint(
            size: Size(frameW, frameH),
            painter: _FramePainter(),
          ),
          // Animated scan line
          AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) => Positioned(
              top: _scanAnim.value * (frameH - 4),
              left: 16,
              right: 16,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.lightBlueAccent.withOpacity(0.9),
                      Colors.transparent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                  boxShadow: [
                    BoxShadow(color: Colors.lightBlueAccent.withOpacity(0.6), blurRadius: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const cornerLen = 28.0;
    final r = 6.0;

    // Top-left
    canvas.drawLine(Offset(0, cornerLen), Offset(0, r), paint);
    canvas.drawArc(Rect.fromLTWH(0, 0, r * 2, r * 2), 3.14, 1.57, false, paint);
    canvas.drawLine(Offset(r, 0), Offset(cornerLen, 0), paint);

    // Top-right
    canvas.drawLine(Offset(size.width - cornerLen, 0), Offset(size.width - r, 0), paint);
    canvas.drawArc(Rect.fromLTWH(size.width - r * 2, 0, r * 2, r * 2), 4.71, 1.57, false, paint);
    canvas.drawLine(Offset(size.width, r), Offset(size.width, cornerLen), paint);

    // Bottom-left
    canvas.drawLine(Offset(0, size.height - cornerLen), Offset(0, size.height - r), paint);
    canvas.drawArc(Rect.fromLTWH(0, size.height - r * 2, r * 2, r * 2), 1.57, 1.57, false, paint);
    canvas.drawLine(Offset(r, size.height), Offset(cornerLen, size.height), paint);

    // Bottom-right
    canvas.drawLine(Offset(size.width - cornerLen, size.height), Offset(size.width - r, size.height), paint);
    canvas.drawArc(Rect.fromLTWH(size.width - r * 2, size.height - r * 2, r * 2, r * 2), 0, 1.57, false, paint);
    canvas.drawLine(Offset(size.width, size.height - r), Offset(size.width, size.height - cornerLen), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

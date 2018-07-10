import 'dart:math';

import 'package:flutter/material.dart';

enum PainterStyle { Clock, Line }

class _Painter extends CustomPainter {
  Color lineColor;
  Color completeColor;
  double completeProgress;
  PainterStyle style;
  double lineWidth;

  _Painter(
      {this.lineColor,
      this.completeColor,
      this.completeProgress,
      this.style,
      this.lineWidth});

  @override
  void paint(Canvas canvas, Size size) {
    if (style == PainterStyle.Clock) {
      clock(canvas, size);
    } else {
      line(canvas, size);
    }
  }

  void clock(Canvas canvas, Size size) {
    double radius = min(size.width / 2, size.height / 2);
    var width = radius;
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * completeProgress;
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, true, complete);
  }

  void line(Canvas canvas, Size size) {
    var width = 5.0;
    Paint line = new Paint()
      ..color = lineColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Paint complete = new Paint()
      ..color = completeColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, line);
    double arcAngle = 2 * pi * completeProgress;
    canvas.drawArc(new Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, complete);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CircleProgress extends StatelessWidget {
  final double progress;
  final bool isAnimate;
  final Color color;
  final Color completeColor;
  final Widget child;
  final PainterStyle style;
  final double lineWidth;

  CircleProgress(this.progress,
      {this.isAnimate = false,
      this.color = Colors.amber,
      this.completeColor = Colors.blueAccent,
      this.style = PainterStyle.Clock,
      this.child = const SizedBox(),
      this.lineWidth = 5.0}) {
    assert(style == PainterStyle.Line ? lineWidth > 0.0 : true);
  }

  @override
  Widget build(BuildContext context) {
    return new CustomPaint(
      child: child,
      painter: _Painter(
          lineColor: color,
          style: style,
          lineWidth: lineWidth,
          completeColor: completeColor,
          completeProgress: progress),
    );
  }
}

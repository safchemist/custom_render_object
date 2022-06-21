import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomSingleChildRenderObjectWidget extends SingleChildRenderObjectWidget {
  final ScrollController controller;

  const CustomSingleChildRenderObjectWidget({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(child: child, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomRenderShiftedBox(
      controller: controller,
    );
  }
}

class CustomRenderShiftedBox extends RenderShiftedBox {
  final ScrollController controller;
  Offset _thumbPoint = const Offset(0, 0);
  double _maxScrollExtent = 0;
  final double _dotRadius = 10;

  CustomRenderShiftedBox({
    RenderBox? child,
    required this.controller,
  }) : super(child) {
    controller.addListener(_updateThumbPoint);
  }

  @override
  void dispose() {
    controller.removeListener(_updateThumbPoint);
    super.dispose();
  }

  void _updateThumbPoint() {
    _thumbPoint = Offset(size.width / 2, _getThumbVerticalOffset());
    markNeedsPaint();
    markNeedsSemanticsUpdate();
  }

  double _getThumbVerticalOffset() {
    if (_maxScrollExtent == 0 || _getScrollExtent() > _maxScrollExtent) {
      _maxScrollExtent = _getScrollExtent();
    }
    var scrollPosition = controller.position;
    var scrollOffset = (scrollPosition.pixels - scrollPosition.minScrollExtent) / _maxScrollExtent;
    return size.height * scrollOffset;
  }

  double _getScrollExtent() {
    return controller.position.maxScrollExtent;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child == null) return;
    context.paintChild(child!, offset);
    _resetThumbStartPointIfNeeded();
    _trackPaint(context, offset);
    _thumbPaint(context, offset);
  }

  void _resetThumbStartPointIfNeeded() {
    var scrollMaxExtent = _getScrollExtent();
    if (scrollMaxExtent == 0) {
      _thumbPoint = Offset(size.width / 2, 0);
    }
  }

  void _trackPaint(PaintingContext context, Offset offset) {
    final trackPaint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.yellow
      ..strokeWidth = 4;

    var points1 = <Offset>[];
    var points2 = <Offset>[];
    var points3 = <Offset>[];
    var points4 = <Offset>[];
    var points5 = <Offset>[];
    var points6 = <Offset>[];
    for (int i = 0; i < size.height.toInt(); i = i + 10) {
      var point1 = Offset(size.width / 2 - math.sin(i / 50) * 55, i + offset.dy + _dotRadius * 2);
      points1.add(point1);
      var point2 = Offset(size.width / 2 - math.cos(i / 50) * 20, i + offset.dy + _dotRadius);
      points2.add(point2);
      var point3 = Offset(size.width / 3 - math.sin(i / 40) * 50, i + offset.dy + _dotRadius * 2);
      points3.add(point3);
      var point4 = Offset(size.width / 3 - math.cos(i / 40) * 50, i + offset.dy + _dotRadius);
      points4.add(point4);
      var point5 = Offset(size.width / 1.5 - math.sin(i / 20) * 60, i + offset.dy + _dotRadius * 2);
      points5.add(point5);
      var point6 = Offset(size.width / 1.5 - math.cos(i / 20) * 60, i + offset.dy + _dotRadius);
      points6.add(point6);
    }

    for (var element in points1) {
      context.canvas.drawCircle(element, 2, trackPaint);
    }

    for (var element in points2) {
      context.canvas.drawCircle(element, 2, trackPaint);
    }

    for (var element in points3) {
      context.canvas.drawCircle(element, 2, trackPaint);
    }

    for (var element in points4) {
      context.canvas.drawCircle(element, 2, trackPaint);
    }

    for (var element in points5) {
      context.canvas.drawCircle(element, 2, trackPaint);
    }

    for (var element in points6) {
      context.canvas.drawCircle(element, 2, trackPaint);
    }
  }

  void _thumbPaint(PaintingContext context, Offset offset) {
    final paintThumb1 = Paint()
      ..strokeWidth = 8
      ..color = Colors.green
      ..strokeCap = StrokeCap.round;
    final paintThumb2 = Paint()
      ..strokeWidth = 8
      ..color = Colors.pink
      ..strokeCap = StrokeCap.round;

    final startPoint1 =
        Offset(size.width / 2 - math.sin(_thumbPoint.dy / 50) * 55, _thumbPoint.dy + offset.dy + _dotRadius * 2);
    final startPoint2 =
        Offset(size.width / 2 - math.cos(_thumbPoint.dy / 50) * 20, _thumbPoint.dy + offset.dy + _dotRadius);
    final startPoint3 =
        Offset(size.width / 3 - math.sin(_thumbPoint.dy / 40) * 50, _thumbPoint.dy + offset.dy + _dotRadius * 2);
    final startPoint4 =
        Offset(size.width / 3 - math.cos(_thumbPoint.dy / 40) * 50, _thumbPoint.dy + offset.dy + _dotRadius);
    final startPoint5 =
        Offset(size.width / 1.5 - math.sin(_thumbPoint.dy / 20) * 60, _thumbPoint.dy + offset.dy + _dotRadius * 2);
    final startPoint6 =
        Offset(size.width / 1.5 - math.cos(_thumbPoint.dy / 20) * 60, _thumbPoint.dy + offset.dy + _dotRadius);

    context.canvas.drawCircle(startPoint2, _dotRadius, paintThumb2);
    context.canvas.drawCircle(startPoint1, _dotRadius, paintThumb1);
    context.canvas.drawCircle(startPoint3, _dotRadius, paintThumb2);
    context.canvas.drawCircle(startPoint4, _dotRadius, paintThumb1);
    context.canvas.drawCircle(startPoint5, _dotRadius, paintThumb2);
    context.canvas.drawCircle(startPoint6, _dotRadius, paintThumb1);
  }

  @override
  void performLayout() {
    size = constraints.biggest;
    if (child == null) return;
    child!.layout(constraints.copyWith(maxWidth: constraints.maxWidth), parentUsesSize: !constraints.isTight);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset.zero;
  }
}

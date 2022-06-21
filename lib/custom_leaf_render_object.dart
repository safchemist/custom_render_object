import 'package:flutter/material.dart';

class CustomLeafRenderObjectWidget extends LeafRenderObjectWidget {
  const CustomLeafRenderObjectWidget({Key? key}) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomLeafRenderObject();
  }
}

class CustomLeafRenderObject extends RenderBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = Colors.yellow
      ..strokeWidth = 4;

    context.canvas.drawRect(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: 100,
          height: 100,
        ),
        paint);

    super.paint(context, offset);
  }

  @override
  void performLayout() {
    size = constraints.biggest;
  }
}

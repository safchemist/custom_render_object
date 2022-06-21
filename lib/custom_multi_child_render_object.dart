import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomMultiChildRenderObjectWidget extends MultiChildRenderObjectWidget {
  CustomMultiChildRenderObjectWidget({
    required List<Widget> children,
    Key? key,
  }) : super(children: children, key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return CustomMultiChildRenderObject();
  }
}

class CustomParentData extends ContainerBoxParentData<RenderBox> {}

class CustomExpand extends ParentDataWidget<CustomParentData> {
  const CustomExpand({
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  @override
  void applyParentData(RenderObject renderObject) {
    final parentData = renderObject.parentData as CustomParentData;

    //you can check something here and call markNeedLayout to update
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CustomMultiChildRenderObjectWidget;
}

class CustomMultiChildRenderObject extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomParentData) {
      child.parentData = CustomParentData();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  void performLayout() {
    double width = 0;
    double height = 0;

    RenderBox? child = firstChild;
    while (child != null) {
      var childParentData = child.parentData as CustomParentData;

      child.layout(
        BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );

      height += child.size.height;
      width = max(width, child.size.width);

      child = childParentData.nextSibling;
    }

    child = firstChild;
    var childOffset = Offset.zero;
    while (child != null) {
      var childParentData = child.parentData as CustomParentData;

      childParentData.offset = Offset(0, childOffset.dy);
      childOffset = Offset(0, child.size.height + 16);

      child = childParentData.nextSibling;
    }

    size = Size(width, height);
  }
}

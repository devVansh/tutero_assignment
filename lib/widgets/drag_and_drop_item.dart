import 'package:flutter/widgets.dart';
import 'package:tutero_assignment/drag_interface/drag_interface.dart';

class DragAndDropItem implements DragAndDropInterface {
  final Widget? child;
  final bool canDrag;

  final String keyStr;

  DragAndDropItem({required this.child, this.canDrag = true, this.keyStr = ""});
}

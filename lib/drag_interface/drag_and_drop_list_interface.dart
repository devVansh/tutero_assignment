import 'package:flutter/material.dart';
import 'package:tutero_assignment/drag_interface/drag_interface.dart';
import 'package:tutero_assignment/drag_param/drag_builder_parameters.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_item.dart';

abstract class DragAndDropListInterface implements DragAndDropInterface {
  List<DragAndDropItem> get children;

  bool get canDrag;

  Widget generateWidget(DragAndDropBuilderParameters params);
}

abstract class DragAndDropListExpansionInterface
    implements DragAndDropListInterface {
  @override
  final List<DragAndDropItem> children;

  DragAndDropListExpansionInterface({required this.children});

  get isExpanded;

  toggleExpanded();

  expand();

  collapse();
}

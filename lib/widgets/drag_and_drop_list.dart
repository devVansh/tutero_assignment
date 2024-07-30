import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutero_assignment/drag_interface/drag_and_drop_list_interface.dart';
import 'package:tutero_assignment/drag_param/drag_builder_parameters.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_item.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_item_target.dart';
import 'package:tutero_assignment/wrapper/drag_and_drop_item_wrapper.dart';

class DragAndDropList implements DragAndDropListInterface {
  final Widget? header;
  final Widget? footer;
  final Widget? leftSide;
  final Widget? rightSide;

  final Widget? contentsWhenEmpty;

  final Widget? lastTarget;

  final Decoration? decoration;

  final CrossAxisAlignment? verticalAlignment;

  final MainAxisAlignment? horizontalAlignment;

  @override
  final List<DragAndDropItem> children =
      List<DragAndDropItem>.empty(growable: true);

  @override
  final bool canDrag;

  bool enableAddNew;

  final String? keyAddress;

  final ScrollController? scrollController;

  final int? index;

  DragAndDropList(
      {List<DragAndDropItem>? children,
      this.header,
      this.footer,
      this.leftSide,
      this.rightSide,
      this.contentsWhenEmpty,
      this.lastTarget,
      this.decoration,
      this.horizontalAlignment = MainAxisAlignment.start,
      this.verticalAlignment = CrossAxisAlignment.start,
      this.enableAddNew = false,
      this.keyAddress,
      this.index,
      this.scrollController,
      this.canDrag = true}) {
    if (children != null) {
      for (var element in children) {
        this.children.add(element);
      }
    }
  }

  @override
  Widget generateWidget(DragAndDropBuilderParameters params) {
    List<Widget> contents = [];
    Widget intrinsicHeight = IntrinsicHeight(
      child: Row(
        mainAxisAlignment: horizontalAlignment!,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _generateDragAndDropListInnerContents(params),
      ),
    );
    if (params.axis == Axis.horizontal) {
      intrinsicHeight = SizedBox(
        width: params.listWidth,
        child: intrinsicHeight,
      );
    }
    if (params.listInnerDecoration != null) {
      intrinsicHeight = Container(
        decoration: params.listInnerDecoration,
        child: intrinsicHeight,
      );
    }
    contents.add(intrinsicHeight);

    return Container(
      width: params.axis == Axis.vertical
          ? double.infinity
          : params.listWidth! - params.listPadding!.horizontal,
      decoration: decoration ?? params.listDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: verticalAlignment!,
        children: [
          Flexible(child: header!),
          Container(
            constraints:
                BoxConstraints(minHeight: 10, maxHeight: Get.height * 0.6),
            child: ListView(
                controller: params.listChildrenScrollController?[index!] ??
                    ScrollController(),
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: contents),
          ),
          Flexible(child: footer!)
        ],
      ),
    );
  }

  List<Widget> _generateDragAndDropListInnerContents(
      DragAndDropBuilderParameters params) {
    var contents = List<Widget>.empty(growable: true);
    if (leftSide != null) {
      contents.add(leftSide!);
    }
    if (children.isNotEmpty) {
      List<Widget> allChildren = List<Widget>.empty(growable: true);
      if (params.addLastItemTargetHeightToTop!) {
        allChildren.add(Padding(
          padding: EdgeInsets.only(top: params.lastItemTargetHeight!),
        ));
      }
      for (int i = 0; i < children.length; i++) {
        allChildren.add(DragAndDropItemWrapper(
          child: children[i],
          parameters: params,
        ));
        if (params.itemDivider != null && i < children.length - 1) {
          allChildren.add(params.itemDivider!);
        }
      }
      allChildren.add(DragAndDropItemTarget(
        parent: this,
        parameters: params,
        onReorderOrAdd: params.onItemDropOnLastTarget!,
        child: lastTarget ??
            Container(
              height: params.lastItemTargetHeight,
            ),
      ));
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: verticalAlignment!,
              mainAxisSize: MainAxisSize.max,
              children: allChildren,
            ),
          ),
        ),
      );
    } else {
      contents.add(
        Expanded(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                contentsWhenEmpty ??
                    const Text(
                      'Empty list',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                DragAndDropItemTarget(
                  parent: this,
                  parameters: params,
                  onReorderOrAdd: params.onItemDropOnLastTarget!,
                  child: lastTarget ??
                      Container(
                        height: params.lastItemTargetHeight,
                      ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (rightSide != null) {
      contents.add(rightSide!);
    }
    return contents;
  }
}

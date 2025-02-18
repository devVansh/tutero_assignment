import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tutero_assignment/drag_interface/drag_and_drop_list_interface.dart';
import 'package:tutero_assignment/drag_param/drag_builder_parameters.dart';
import 'package:tutero_assignment/wrapper/drag_and_drop_list_wrapper.dart';

import 'drag_and_drop_item.dart';
import 'drag_and_drop_item_target.dart';

import 'drag_and_drop_list_target.dart';

typedef OnItemReorder = void Function(
  int oldItemIndex,
  int oldListIndex,
  int newItemIndex,
  int newListIndex,
);
typedef OnItemAdd = void Function(
  DragAndDropItem newItem,
  int listIndex,
  int newItemIndex,
);
typedef OnListAdd = void Function(DragAndDropListInterface newList, int newListIndex);
typedef OnListReorder = void Function(int oldListIndex, int newListIndex);
typedef OnListDraggingChanged = void Function(
  DragAndDropListInterface list,
  bool dragging,
);
typedef ListOnWillAccept = bool Function(
  DragAndDropListInterface incoming,
  DragAndDropListInterface target,
);
typedef ListOnAccept = void Function(
  DragAndDropListInterface incoming,
  DragAndDropListInterface target,
);
typedef ListTargetOnWillAccept = bool Function(
    DragAndDropListInterface incoming, DragAndDropListTarget target);
typedef ListTargetOnAccept = void Function(
    DragAndDropListInterface incoming, DragAndDropListTarget target);
typedef OnItemDraggingChanged = void Function(
  DragAndDropItem item,
  bool dragging,
);
typedef ItemOnWillAccept = bool Function(
  DragAndDropItem incoming,
  DragAndDropItem target,
);
typedef ItemOnAccept = void Function(
  DragAndDropItem incoming,
  DragAndDropItem target,
);
typedef ItemTargetOnWillAccept = bool Function(
    DragAndDropItem incoming, DragAndDropItemTarget target);
typedef ItemTargetOnAccept = void Function(
  DragAndDropItem incoming,
  DragAndDropListInterface parentList,
  DragAndDropItemTarget target,
);

class DragAndDropLists extends StatefulWidget {
  final List<DragAndDropListInterface>? children;

  final double? scrollAreaSize;

  final OnItemReorder? onItemReorder;

  final OnListReorder? onListReorder;

  final OnItemAdd? onItemAdd;

  final OnListAdd? onListAdd;

  final ListOnWillAccept? listOnWillAccept;

  final ListOnAccept? listOnAccept;

  final ListTargetOnWillAccept? listTargetOnWillAccept;

  final ListTargetOnAccept? listTargetOnAccept;

  final OnListDraggingChanged? onListDraggingChanged;

  final ItemOnWillAccept? itemOnWillAccept;

  final ItemOnAccept? itemOnAccept;

  final ItemTargetOnWillAccept? itemTargetOnWillAccept;

  final ItemTargetOnAccept? itemTargetOnAccept;

  final OnItemDraggingChanged? onItemDraggingChanged;

  final double? itemDraggingWidth;

  final Widget? itemGhost;

  final double? itemGhostOpacity;

  final int? itemSizeAnimationDurationMilliseconds;

  final bool? itemDragOnLongPress;

  final Decoration? itemDecorationWhileDragging;

  final Widget? itemDivider;

  final double? listDraggingWidth;

  final Widget? listTarget;

  final Widget? listGhost;

  final double? listGhostOpacity;

  final int? listSizeAnimationDurationMilliseconds;

  final bool? listDragOnLongPress;

  final Decoration? listDecoration;

  final Decoration? listDecorationWhileDragging;

  final Decoration? listInnerDecoration;

  final Widget? listDivider;

  final bool? listDividerOnLastChild;

  final EdgeInsets? listPadding;

  final EdgeInsets? contentPadding;

  final Widget? contentsWhenEmpty;

  final double? listWidth;

  final double? lastItemTargetHeight;

  final bool? addLastItemTargetHeightToTop;

  final double? lastListTargetSize;

  final CrossAxisAlignment? verticalAlignment;

  final MainAxisAlignment? horizontalAlignment;

  final Axis? axis;

  final bool? sliverList;

  final ScrollController? scrollController;

  final bool? disableScrolling;

  final Widget? dragHandle;

  final bool? dragHandleOnLeft;

  final DragHandleVerticalAlignment? listDragHandleVerticalAlignment;

  final DragHandleVerticalAlignment? itemDragHandleVerticalAlignment;

  final bool? constrainDraggingAxis;

  final Function(int)? tabIndexCallBack;

  DragAndDropLists({
    this.children,
    this.scrollAreaSize,
    this.onItemReorder,
    this.onListReorder,
    this.onItemAdd,
    this.onListAdd,
    this.onListDraggingChanged,
    this.listOnWillAccept,
    this.listOnAccept,
    this.listTargetOnWillAccept,
    this.listTargetOnAccept,
    this.onItemDraggingChanged,
    this.itemOnWillAccept,
    this.itemOnAccept,
    this.itemTargetOnWillAccept,
    this.itemTargetOnAccept,
    this.itemDraggingWidth,
    this.itemGhost,
    this.itemGhostOpacity = 0.3,
    this.itemSizeAnimationDurationMilliseconds = 150,
    this.itemDragOnLongPress = true,
    this.itemDecorationWhileDragging,
    this.itemDivider,
    this.listDraggingWidth,
    this.listTarget,
    this.listGhost,
    this.listGhostOpacity = 0.3,
    this.listSizeAnimationDurationMilliseconds = 150,
    this.listDragOnLongPress = true,
    this.listDecoration,
    this.listDecorationWhileDragging,
    this.listInnerDecoration,
    this.listDivider,
    this.listDividerOnLastChild = true,
    this.listPadding,
    this.contentPadding,
    this.contentsWhenEmpty,
    this.listWidth = double.infinity,
    this.lastItemTargetHeight = 20,
    this.addLastItemTargetHeightToTop = false,
    this.lastListTargetSize = 110,
    this.verticalAlignment = CrossAxisAlignment.start,
    this.horizontalAlignment = MainAxisAlignment.start,
    this.axis = Axis.vertical,
    this.sliverList = false,
    this.scrollController,
    this.disableScrolling = false,
    this.dragHandle,
    this.dragHandleOnLeft = false,
    this.listDragHandleVerticalAlignment = DragHandleVerticalAlignment.top,
    this.itemDragHandleVerticalAlignment = DragHandleVerticalAlignment.center,
    this.constrainDraggingAxis = true,
    this.tabIndexCallBack,
    super.key,
  }) {
    if (listGhost == null &&
        children!
            .whereType<DragAndDropListExpansionInterface>()
            .isNotEmpty) {
      throw Exception(
          'If using DragAndDropListExpansion, you must provide a non-null listGhost');
    }
    if (sliverList! && scrollController == null) {
      throw Exception(
          'A scroll controller must be provided when using sliver lists');
    }
    if (axis == Axis.horizontal && listWidth == double.infinity) {
      throw Exception(
          'A finite width must be provided when setting the axis to horizontal');
    }
    if (axis == Axis.horizontal && sliverList!) {
      throw Exception(
          'Combining a sliver list with a horizontal list is currently unsupported');
    }
  }

  @override
  State<StatefulWidget> createState() => DragAndDropListsState();
}

class DragAndDropListsState extends State<DragAndDropLists> {
  ScrollController? _scrollController;
  bool _pointerDown = false;
  double? _pointerYPosition;
  double? _pointerXPosition;
  bool _scrolling = false;
  final PageStorageBucket _pageStorageBucket = PageStorageBucket();

  List<ScrollController> listChildrenScrollController = [];
  int? tabIndexNow;

  @override
  void initState() {
    if (widget.scrollController != null) {
      _scrollController = widget.scrollController;
    } else {
      _scrollController = ScrollController();
    }

    _scrollController!.addListener(() async {
      double maxWidh = Get.size.width * 0.9 * (widget.children!.length - 1) -
          Get.size.width * 0.05;

      double ratio = _scrollController!.position.pixels == 0
          ? 0
          : _scrollController!.position.pixels / maxWidh;
      int index = (ratio * 5).toInt();
      if (index == widget.children!.length) index = index - 1;
      tabIndexNow = index;

      widget.tabIndexCallBack!(tabIndexNow!);
    });

    for (var element in widget.children!) {
      listChildrenScrollController.add(ScrollController());
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (var element in listChildrenScrollController) {
      element.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var parameters = DragAndDropBuilderParameters(
      listChildrenScrollController: listChildrenScrollController,
      listGhost: widget.listGhost,
      listGhostOpacity: widget.listGhostOpacity,
      listDraggingWidth: widget.listDraggingWidth,
      itemDraggingWidth: widget.itemDraggingWidth,
      listSizeAnimationDuration: widget.listSizeAnimationDurationMilliseconds,
      dragOnLongPress: widget.listDragOnLongPress,
      listPadding: widget.listPadding,
      itemSizeAnimationDuration: widget.itemSizeAnimationDurationMilliseconds,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerMove: _onPointerMove,
      onItemReordered: _internalOnItemReorder,
      onItemDropOnLastTarget: _internalOnItemDropOnLastTarget,
      onListReordered: _internalOnListReorder,
      onItemDraggingChanged: widget.onItemDraggingChanged,
      onListDraggingChanged: widget.onListDraggingChanged,
      listOnWillAccept: widget.listOnWillAccept,
      listTargetOnWillAccept: widget.listTargetOnWillAccept,
      itemOnWillAccept: widget.itemOnWillAccept,
      itemTargetOnWillAccept: widget.itemTargetOnWillAccept,
      itemGhostOpacity: widget.itemGhostOpacity,
      itemDivider: widget.itemDivider,
      itemDecorationWhileDragging: widget.itemDecorationWhileDragging,
      verticalAlignment: widget.verticalAlignment,
      axis: widget.axis,
      itemGhost: widget.itemGhost,
      listDecoration: widget.listDecoration,
      listDecorationWhileDragging: widget.listDecorationWhileDragging,
      listInnerDecoration: widget.listInnerDecoration,
      listWidth: widget.listWidth,
      lastItemTargetHeight: widget.lastItemTargetHeight,
      addLastItemTargetHeightToTop: widget.addLastItemTargetHeightToTop,
      dragHandle: widget.dragHandle,
      dragHandleOnLeft: widget.dragHandleOnLeft,
      itemDragHandleVerticalAlignment: widget.itemDragHandleVerticalAlignment,
      listDragHandleVerticalAlignment: widget.listDragHandleVerticalAlignment,
      constrainDraggingAxis: widget.constrainDraggingAxis,
      disableScrolling: widget.disableScrolling,
      contentPadding: widget.contentPadding,
    );

    DragAndDropListTarget dragAndDropListTarget = DragAndDropListTarget(
      parameters: parameters,
      onDropOnLastTarget: _internalOnListDropOnLastTarget,
      lastListTargetSize: widget.lastListTargetSize!,
      child: widget.listTarget,
    );

    if (widget.children != null && widget.children!.isNotEmpty) {
      Widget outerListHolder;

      if (widget.sliverList!) {
        outerListHolder = _buildSliverList(dragAndDropListTarget, parameters);
      } else if (widget.disableScrolling!) {
        outerListHolder =
            _buildUnscrollableList(dragAndDropListTarget, parameters);
      } else {
        outerListHolder = _buildListView(parameters, dragAndDropListTarget);
      }

      if (widget.children!
          .whereType<DragAndDropListExpansionInterface>()
          .isNotEmpty) {
        outerListHolder = PageStorage(
          bucket: _pageStorageBucket,
          child: outerListHolder,
        );
      }
      return outerListHolder;
    } else {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            widget.contentsWhenEmpty ?? const Text('Empty'),
            dragAndDropListTarget,
          ],
        ),
      );
    }
  }

  SliverList _buildSliverList(DragAndDropListTarget dragAndDropListTarget,
      DragAndDropBuilderParameters parameters) {
    bool includeSeparators = widget.listDivider != null;
    int childrenCount = _calculateChildrenCount(includeSeparators);

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildInnerList(index, childrenCount, dragAndDropListTarget,
              includeSeparators, parameters);
        },
        childCount: childrenCount,
      ),
    );
  }

  Widget _buildUnscrollableList(DragAndDropListTarget dragAndDropListTarget,
      DragAndDropBuilderParameters parameters) {
    if (widget.axis == Axis.vertical) {
      return Column(
        children: _buildOuterList(dragAndDropListTarget, parameters),
      );
    } else {
      return Row(
        children: _buildOuterList(dragAndDropListTarget, parameters),
      );
    }
  }

  ListView _buildListView(DragAndDropBuilderParameters parameters,
      DragAndDropListTarget dragAndDropListTarget) {
    return ListView(
      scrollDirection: widget.axis!,
      controller: _scrollController,
      children: _buildOuterList(dragAndDropListTarget, parameters),
    );
  }

  List<Widget> _buildOuterList(DragAndDropListTarget dragAndDropListTarget,
      DragAndDropBuilderParameters parameters) {
    bool includeSeparators = widget.listDivider != null;
    int childrenCount = _calculateChildrenCount(includeSeparators);

    return List.generate(childrenCount, (index) {
      return _buildInnerList(index, childrenCount, dragAndDropListTarget,
          includeSeparators, parameters);
    });
  }

  int _calculateChildrenCount(bool includeSeparators) {
    if (includeSeparators) {
      return ((widget.children?.length ?? 0) * 2) -
          (widget.listDividerOnLastChild! ? 0 : 1) +
          1;
    } else {
      return (widget.children?.length ?? 0) + 1;
    }
  }

  Widget _buildInnerList(
      int index,
      int childrenCount,
      DragAndDropListTarget dragAndDropListTarget,
      bool includeSeparators,
      DragAndDropBuilderParameters parameters) {
    if (index == childrenCount - 1) {
      return dragAndDropListTarget;
    } else if (includeSeparators && index.isOdd) {
      return widget.listDivider!;
    } else {
      return DragAndDropListWrapper(
        dragAndDropList:
            widget.children![(includeSeparators ? index / 2 : index).toInt()],
        parameters: parameters,
      );
    }
  }

  _internalOnItemReorder(DragAndDropItem reordered, DragAndDropItem receiver) {
    if (widget.itemOnAccept != null) {
      widget.itemOnAccept!(reordered, receiver);
    }

    int reorderedListIndex = -1;
    int reorderedItemIndex = -1;
    int receiverListIndex = -1;
    int receiverItemIndex = -1;

    for (int i = 0; i < widget.children!.length; i++) {
      if (reorderedItemIndex == -1) {
        reorderedItemIndex =
            widget.children![i].children.indexWhere((e) => reordered == e);
        if (reorderedItemIndex != -1) reorderedListIndex = i;
      }
      if (receiverItemIndex == -1) {
        receiverItemIndex =
            widget.children![i].children.indexWhere((e) => receiver == e);
        if (receiverItemIndex != -1) receiverListIndex = i;
      }
      if (reorderedItemIndex != -1 && receiverItemIndex != -1) {
        break;
      }
    }

    if (reorderedItemIndex == -1) {
      if (widget.onItemAdd != null) {
        widget.onItemAdd!(reordered, receiverListIndex, receiverItemIndex);
      }
    } else {
      if (reorderedListIndex == receiverListIndex &&
          receiverItemIndex > reorderedItemIndex) {
        receiverItemIndex--;
      }

      if (widget.onItemReorder != null) {
        widget.onItemReorder!(reorderedItemIndex, reorderedListIndex,
            receiverItemIndex, receiverListIndex);
      }
    }
  }

  _internalOnListReorder(
      DragAndDropListInterface reordered, DragAndDropListInterface receiver) {
    int reorderedListIndex = widget.children!.indexWhere((e) => reordered == e);
    int receiverListIndex = widget.children!.indexWhere((e) => receiver == e);

    int newListIndex = receiverListIndex;

    if (widget.listOnAccept != null) widget.listOnAccept!(reordered, receiver);

    if (reorderedListIndex == -1) {
      if (widget.onListAdd != null) widget.onListAdd!(reordered, newListIndex);
    } else {
      if (newListIndex > reorderedListIndex) {
        newListIndex--;
      }
      if (widget.onListReorder != null) {
        widget.onListReorder!(reorderedListIndex, newListIndex);
      }
    }
  }

  _internalOnItemDropOnLastTarget(DragAndDropItem newOrReordered,
      DragAndDropListInterface parentList, DragAndDropItemTarget receiver) {
    if (widget.itemTargetOnAccept != null) {
      widget.itemTargetOnAccept!(newOrReordered, parentList, receiver);
    }

    int reorderedListIndex = -1;
    int reorderedItemIndex = -1;
    int receiverListIndex = -1;
    int receiverItemIndex = -1;

    if (widget.children != null && widget.children!.isNotEmpty) {
      for (int i = 0; i < widget.children!.length; i++) {
        if (reorderedItemIndex == -1) {
          reorderedItemIndex = widget.children![i].children
                  .indexWhere((e) => newOrReordered == e) ??
              -1;
          if (reorderedItemIndex != -1) reorderedListIndex = i;
        }

        if (receiverItemIndex == -1 && widget.children![i] == parentList) {
          receiverListIndex = i;
          receiverItemIndex = widget.children![i].children.length ?? -1;
        }

        if (reorderedItemIndex != -1 && receiverItemIndex != -1) {
          break;
        }
      }
    }

    if (reorderedItemIndex == -1) {
      if (widget.onItemAdd != null) {
        widget.onItemAdd!(
            newOrReordered, receiverListIndex, reorderedItemIndex);
      }
    } else {
      if (reorderedListIndex == receiverListIndex &&
          receiverItemIndex > reorderedItemIndex) {
        receiverItemIndex--;
      }
      if (widget.onItemReorder != null) {
        widget.onItemReorder!(reorderedItemIndex, reorderedListIndex,
            receiverItemIndex, receiverListIndex);
      }
    }
  }

  _internalOnListDropOnLastTarget(
      DragAndDropListInterface newOrReordered, DragAndDropListTarget receiver) {
    int reorderedListIndex =
        widget.children!.indexWhere((e) => newOrReordered == e);

    if (widget.listOnAccept != null) {
      widget.listTargetOnAccept!(newOrReordered, receiver);
    }

    if (reorderedListIndex >= 0) {
      if (widget.onListReorder != null) {
        widget.onListReorder!(reorderedListIndex, widget.children!.length - 1);
      }
    } else {
      if (widget.onListAdd != null) {
        widget.onListAdd!(newOrReordered, reorderedListIndex);
      }
    }
  }

  _onPointerMove(PointerMoveEvent event) {
    if (_pointerDown) {
      _pointerYPosition = event.position.dy;
      _pointerXPosition = event.position.dx;

      print("_onPointerMove y:$_pointerYPosition -- x:$_pointerXPosition ");

      _scrollList();
    }
  }

  _onPointerDown(PointerDownEvent event) {
    _pointerDown = true;
    _pointerYPosition = event.position.dy;
    _pointerXPosition = event.position.dx;
    print("_onPointerDown y:$_pointerYPosition -- x:$_pointerXPosition ");
  }

  _onPointerUp(PointerUpEvent event) {
    _pointerDown = false;
  }

  _scrollList() async {
    if (!widget.disableScrolling! &&
        !_scrolling &&
        _pointerDown &&
        _pointerYPosition != null &&
        _pointerXPosition != null) {
      int duration = 30;
      int scrollAreaSize =
          widget.scrollAreaSize != null ? (widget.scrollAreaSize)!.toInt() : 25;
      double step = 1.5;
      double overDragMax = 20.0;
      double overDragCoefficient = 5.0;
      double? newOffset;

      double newOffsetListVertical;

      var rb = context.findRenderObject();
      Size? size;
      if (rb is RenderBox) {
        size = rb.size;
      } else if (rb is RenderSliver) size = rb.paintBounds.size;
      var topLeftOffset = localToGlobal(rb!, Offset.zero);
      var bottomRightOffset = localToGlobal(rb, size!.bottomRight(Offset.zero));

      if (widget.axis == Axis.vertical) {
        double top = topLeftOffset.dy;
        double bottom = bottomRightOffset.dy;

        if (_pointerYPosition! < (top + scrollAreaSize) &&
            _scrollController!.position.pixels >
                _scrollController!.position.minScrollExtent) {
          final overDrag =
              max((top + scrollAreaSize) - _pointerYPosition!, overDragMax);
          newOffset = max(
              _scrollController!.position.minScrollExtent,
              _scrollController!.position.pixels -
                  step * overDrag / overDragCoefficient);
        } else if (_pointerYPosition! > (bottom - scrollAreaSize) &&
            _scrollController!.position.pixels <
                _scrollController!.position.maxScrollExtent) {
          final overDrag = max<double>(
              _pointerYPosition! - (bottom - scrollAreaSize), overDragMax);
          newOffset = min(
              _scrollController!.position.maxScrollExtent,
              _scrollController!.position.pixels +
                  step * overDrag / overDragCoefficient);
        }
      } else {
        double left = topLeftOffset.dx;
        double right = bottomRightOffset.dx;

        if (_pointerXPosition! < (left + scrollAreaSize) &&
            _scrollController!.position.pixels >
                _scrollController!.position.minScrollExtent) {
          final overDrag =
              max((left + scrollAreaSize) - _pointerXPosition!, overDragMax);
          newOffset = max(
              _scrollController!.position.minScrollExtent,
              _scrollController!.position.pixels -
                  step * overDrag / overDragCoefficient);
        } else if (_pointerXPosition! > (right - scrollAreaSize) &&
            _scrollController!.position.pixels <
                _scrollController!.position.maxScrollExtent) {
          final overDrag = max<double>(
              _pointerYPosition! - (right - scrollAreaSize), overDragMax);
          newOffset = min(
              _scrollController!.position.maxScrollExtent,
              _scrollController!.position.pixels +
                  step * overDrag / overDragCoefficient);
        }
      }

      if (newOffset != null) {
        _scrolling = true;
        await _scrollController!.animateTo(newOffset,
            duration: Duration(milliseconds: duration), curve: Curves.linear);
        _scrolling = false;
        if (_pointerDown) _scrollList();
      }
    }
  }

  static Offset localToGlobal(RenderObject object, Offset point,
      {RenderObject? ancestor}) {
    return MatrixUtils.transformPoint(object.getTransformTo(ancestor), point);
  }
}

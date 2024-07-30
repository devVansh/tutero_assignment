import 'dart:async';

import 'package:tutero_assignment/drag_interface/drag_and_drop_list_interface.dart';
import 'package:tutero_assignment/drag_param/drag_builder_parameters.dart';
import 'package:tutero_assignment/utils/programmatic_expansion_tile.dart';
import 'package:tutero_assignment/wrapper/drag_and_drop_item_wrapper.dart';

import 'drag_and_drop_item.dart';
import 'drag_and_drop_item_target.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnExpansionChanged = void Function(bool expanded);

class DragAndDropListExpansion implements DragAndDropListExpansionInterface {
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final bool? initiallyExpanded;

  final Key? listKey;

  final OnExpansionChanged? onExpansionChanged;
  final Color? backgroundColor;
  @override
  final List<DragAndDropItem> children;
  final Widget? contentsWhenEmpty;
  final Widget? lastTarget;

  @override
  final bool canDrag;

  final bool disableTopAndBottomBorders;

  final ValueNotifier<bool> _expanded = ValueNotifier<bool>(true);
  final GlobalKey<ProgrammaticExpansionTileState> _expansionKey =
      GlobalKey<ProgrammaticExpansionTileState>();

  DragAndDropListExpansion({
    required this.children,
    this.title,
    this.subtitle,
    this.trailing,
    this.leading,
    this.initiallyExpanded = false,
    this.backgroundColor,
    this.onExpansionChanged,
    this.contentsWhenEmpty,
    this.lastTarget,
    this.listKey,
    this.canDrag = true,
    this.disableTopAndBottomBorders = false,
  }) : assert(listKey != null) {
    _expanded.value = initiallyExpanded!;
  }

  @override
  Widget generateWidget(DragAndDropBuilderParameters params) {
    var contents = _generateDragAndDropListInnerContents(params);

    Widget expandable = ProgrammaticExpansionTile(
      title: title!,
      listKey: listKey!,
      subtitle: subtitle!,
      trailing: trailing!,
      leading: leading!,
      disableTopAndBottomBorders: disableTopAndBottomBorders,
      backgroundColor: backgroundColor!,
      initiallyExpanded: initiallyExpanded!,
      onExpansionChanged: _onSetExpansion,
      key: _expansionKey,
      children: contents,
    );

    if (params.listDecoration != null) {
      expandable = Container(
        decoration: params.listDecoration,
        child: expandable,
      );
    }

    if (params.listPadding != null) {
      expandable = Padding(
        padding: params.listPadding!,
        child: expandable,
      );
    }

    Widget toReturn = ValueListenableBuilder(
      valueListenable: _expanded,
      child: expandable,
      builder: (context, error, child) {
        if (!_expanded.value) {
          return Stack(
            children: <Widget>[
              child!,
              Positioned.fill(
                child: DragTarget<DragAndDropItem>(
                  builder: (context, candidateData, rejectedData) {
                    if (candidateData.isNotEmpty) {}
                    return Container();
                  },
                  onWillAcceptWithDetails: (incoming) {
                    _startExpansionTimer();
                    return false;
                  },
                  onLeave: (incoming) {
                    _stopExpansionTimer();
                  },
                  onAcceptWithDetails: (incoming) {},
                ),
              )
            ],
          );
        } else {
          return child!;
        }
      },
    );

    return toReturn;
  }

  List<Widget> _generateDragAndDropListInnerContents(
      DragAndDropBuilderParameters params) {
    var contents = List<Widget>.empty(growable: true);
    if (children.isNotEmpty) {
      for (int i = 0; i < children.length; i++) {
        contents.add(DragAndDropItemWrapper(
          child: children[i],
          parameters: params,
        ));
        if (params.itemDivider != null && i < children.length - 1) {
          contents.add(params.itemDivider!);
        }
      }
      contents.add(DragAndDropItemTarget(
        parent: this,
        parameters: params,
        onReorderOrAdd: params.onItemDropOnLastTarget!,
        child: lastTarget ??
            Container(
              height: params.lastItemTargetHeight,
            ),
      ));
    } else {
      contents.add(
        contentsWhenEmpty ??
            const Text(
              'Empty list',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
      );
      contents.add(
        DragAndDropItemTarget(
          parent: this,
          parameters: params,
          onReorderOrAdd: params.onItemDropOnLastTarget!,
          child: lastTarget ??
              Container(
                height: params.lastItemTargetHeight,
              ),
        ),
      );
    }
    return contents;
  }

  @override
  toggleExpanded() {
    if (isExpanded) {
      collapse();
    } else {
      expand();
    }
  }

  @override
  collapse() {
    if (!isExpanded) {
      _expanded.value = false;
      _expansionKey.currentState!.collapse();
    }
  }

  @override
  expand() {
    if (!isExpanded) {
      _expanded.value = true;
      _expansionKey.currentState!.expand();
    }
  }

  _onSetExpansion(bool expanded) {
    _expanded.value = expanded;

    if (onExpansionChanged != null) onExpansionChanged!(expanded);
  }

  @override
  get isExpanded => _expanded.value;

  Timer? _expansionTimer;

  _startExpansionTimer() async {
    _expansionTimer = Timer(const Duration(milliseconds: 400), _expansionCallback);
  }

  _stopExpansionTimer() async {
    if (_expansionTimer!.isActive) {
      _expansionTimer!.cancel();
    }
  }

  _expansionCallback() {
    expand();
  }
}

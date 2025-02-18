import 'package:flutter/widgets.dart';
import 'package:tutero_assignment/drag_interface/drag_and_drop_list_interface.dart';
import 'package:tutero_assignment/drag_param/drag_builder_parameters.dart';
import 'package:tutero_assignment/widgets/drag_and_drop_item.dart';

class DragAndDropItemTarget extends StatefulWidget {
  final Widget child;
  final DragAndDropListInterface? parent;
  final DragAndDropBuilderParameters parameters;
  final OnItemDropOnLastTarget onReorderOrAdd;

  const DragAndDropItemTarget(
      {required this.child,
      required this.onReorderOrAdd,
      required this.parameters,
      this.parent,
      super.key});

  @override
  State<StatefulWidget> createState() => _DragAndDropItemTarget();
}

class _DragAndDropItemTarget extends State<DragAndDropItemTarget>
    with TickerProviderStateMixin {
  DragAndDropItem? _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: widget.parameters.verticalAlignment!,
          children: <Widget>[
            AnimatedSize(
              duration: Duration(
                  milliseconds: widget.parameters.itemSizeAnimationDuration!),
              alignment: Alignment.bottomCenter,
              child: _hoveredDraggable != null
                  ? Opacity(
                      opacity: widget.parameters.itemGhostOpacity!,
                      child: widget.parameters.itemGhost ??
                          _hoveredDraggable?.child,
                    )
                  : Container(),
            ),
            widget.child ,
          ],
        ),
        Positioned(
          child: DragTarget<DragAndDropItem>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAcceptWithDetails: (incoming) {
              bool accept = true;
              if (widget.parameters.itemTargetOnWillAccept != null) {
                accept = widget.parameters.itemTargetOnWillAccept!(
                    incoming.data, widget);
              }
              if (accept && mounted) {
                setState(() {
                  _hoveredDraggable = incoming.data;
                });
              }
              return accept;
            },
            onLeave: (incoming) {
              if (mounted) {
                setState(() {
                  _hoveredDraggable = null;
                });
              }
            },
            onAcceptWithDetails: (incoming) {
              if (mounted) {
                setState(() {
                  widget.onReorderOrAdd(incoming.data, widget.parent!, widget);
                                  _hoveredDraggable = null;
                });
              }
            },
          ),
        ),
      ],
    );
  }
}

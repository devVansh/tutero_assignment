import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tutero_assignment/drag_interface/drag_and_drop_list_interface.dart';
import 'package:tutero_assignment/drag_param/drag_builder_parameters.dart';

typedef OnDropOnLastTarget = void Function(
  DragAndDropListInterface newOrReordered,
  DragAndDropListTarget receiver,
);

class DragAndDropListTarget extends StatefulWidget {
  final Widget? child;
  final DragAndDropBuilderParameters parameters;
  final OnDropOnLastTarget onDropOnLastTarget;
  final double lastListTargetSize;

  const DragAndDropListTarget(
      {this.child,
      required this.parameters,
      required this.onDropOnLastTarget,
      this.lastListTargetSize = 110,
      super.key});

  @override
  State<StatefulWidget> createState() => _DragAndDropListTarget();
}

class _DragAndDropListTarget extends State<DragAndDropListTarget>
    with TickerProviderStateMixin {
  DragAndDropListInterface? _hoveredDraggable;

  @override
  Widget build(BuildContext context) {
    Widget visibleContents = Column(
      children: <Widget>[
        AnimatedSize(
          duration: Duration(
              milliseconds: widget.parameters.listSizeAnimationDuration!),
          alignment: widget.parameters.axis == Axis.vertical
              ? Alignment.bottomCenter
              : Alignment.centerLeft,
          child: _hoveredDraggable != null
              ? Opacity(
                  opacity: widget.parameters.listGhostOpacity!,
                  child: widget.parameters.listGhost ??
                      _hoveredDraggable!.generateWidget(widget.parameters),
                )
              : Container(),
        ),
        widget.child ??
            SizedBox(
              height: widget.parameters.axis == Axis.vertical
                  ? widget.lastListTargetSize
                  : null,
              width: widget.parameters.axis == Axis.horizontal
                  ? widget.lastListTargetSize
                  : 110,
            ),
      ],
    );

    if (widget.parameters.listPadding != null) {
      visibleContents = Padding(
        padding: widget.parameters.listPadding!,
        child: visibleContents,
      );
    }

    if (widget.parameters.axis == Axis.horizontal) {
      visibleContents = SingleChildScrollView(child: visibleContents);
    }

    return Stack(
      children: <Widget>[
        visibleContents,
        Positioned.fill(
          child: DragTarget<DragAndDropListInterface>(
            builder: (context, candidateData, rejectedData) {
              if (candidateData.isNotEmpty) {}
              return Container();
            },
            onWillAcceptWithDetails: (incoming) {
              bool accept = true;
              if (widget.parameters.listTargetOnWillAccept != null) {
                accept = widget.parameters.listTargetOnWillAccept!(
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
                  widget.onDropOnLastTarget(incoming.data, widget);
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
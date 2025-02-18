import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ProgrammaticExpansionTile extends StatefulWidget {
  const ProgrammaticExpansionTile({
    required Key key,
    required this.listKey,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.isThreeLine = false,
    required this.backgroundColor,
    required this.onExpansionChanged,
    this.children = const <Widget>[],
    required this.trailing,
    this.initiallyExpanded = false,
    this.disableTopAndBottomBorders = false,
  })  : super(key: key);

  final Key listKey;

  final Widget leading;

  final Widget title;

  final Widget subtitle;

  final bool isThreeLine;

  final ValueChanged<bool> onExpansionChanged;

  final List<Widget> children;

  final Color backgroundColor;

  final Widget trailing;

  final bool initiallyExpanded;

  final bool disableTopAndBottomBorders;

  @override
  ProgrammaticExpansionTileState createState() =>
      ProgrammaticExpansionTileState();
}

class ProgrammaticExpansionTileState extends State<ProgrammaticExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController? _controller;
  Animation<double>? _iconTurns;
  Animation<double>? _heightFactor;
  Animation<Color?>? _borderColor;
  Animation<Color?>? _headerColor;
  Animation<Color?>? _iconColor;
  Animation<Color?>? _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller!.drive(_easeInTween);
    _iconTurns = _controller!.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller!.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller!.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller!.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller!.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)
        .readState(context, identifier: widget.listKey) as bool;
    if (_isExpanded) _controller!.value = 1.0;

    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (_isExpanded != widget.initiallyExpanded) {
        widget.onExpansionChanged(_isExpanded);
      }
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool expanded) {
    if (_isExpanded != expanded) {
      setState(() {
        _isExpanded = expanded;
        if (_isExpanded) {
          _controller!.forward();
        } else {
          _controller!.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {});
          });
        }
        PageStorage.of(context)
            .writeState(context, _isExpanded, identifier: widget.listKey);
      });
      widget.onExpansionChanged(_isExpanded);
        }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final Color borderSideColor = _borderColor!.value ?? Colors.transparent;
    bool setBorder = !widget.disableTopAndBottomBorders;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor!.value ?? Colors.transparent,
        border: setBorder
            ? Border(
                top: BorderSide(color: borderSideColor),
                bottom: BorderSide(color: borderSideColor),
              )
            : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: _iconColor!.value,
            textColor: _headerColor!.value,
            child: ListTile(
                onTap: toggle,
                leading: widget.leading,
                title: widget.title,
                subtitle: widget.subtitle,
                isThreeLine: widget.isThreeLine,
                trailing: widget.trailing),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor!.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.titleSmall?.color
      ..end = theme.primaryColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.primaryColor;
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller!.isDismissed;
    return AnimatedBuilder(
      animation: _controller!.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}

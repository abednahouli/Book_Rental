import 'package:flutter/material.dart';

class TabFade extends StatefulWidget {
  final int index;
  final List<Widget> children;
  final Duration duration;

  const TabFade({
    Key key,
    this.index,
    this.children,
    this.duration = const Duration(
      milliseconds: 500,
    ),
  }) : super(key: key);

  @override
  _TabFadeState createState() => _TabFadeState();
}

class _TabFadeState extends State<TabFade> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void didUpdateWidget(covariant TabFade oldWidget) {
    // TODO: implement didUpdateWidget
    if (widget.index != oldWidget.index) {
      _controller.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: IndexedStack(
        children: widget.children,
        index: widget.index,
      ),
    );
  }
}

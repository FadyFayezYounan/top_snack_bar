import 'package:flutter/material.dart';

class TopSnackBarWidget extends StatefulWidget {
  const TopSnackBarWidget({
    super.key,
    this.backgroundColor,
    this.title,
    this.subtitle,
    this.trailingWidget,
    this.leadingWidget,
  });
  final Color? backgroundColor;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailingWidget;
  final Widget? leadingWidget;

  @override
  State<TopSnackBarWidget> createState() => TopSnackBarWidgetState();
}

class TopSnackBarWidgetState extends State<TopSnackBarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    showSnackbar();
  }

  TickerFuture showSnackbar() {
    return _animationController.forward();
  }

  TickerFuture hideSnackbar() {
    return _animationController.reverse();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor =
        widget.backgroundColor ?? Theme.of(context).colorScheme.primary;
    return Align(
      alignment: Alignment.topCenter,
      child: SlideTransition(
        position: _slideAnimation,
        child: Material(
          color: effectiveBackgroundColor,
          surfaceTintColor: effectiveBackgroundColor,
          child: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top,
            ),
            child: ListTile(
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: widget.trailingWidget,
              leading: widget.leadingWidget,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../top_snack_bar.dart';
import 'top_snack_overlay_entry.dart';

class OverlayLoadingBuilder extends StatefulWidget {
  /// Widget for building overlay with loading indicator
  const OverlayLoadingBuilder({
    super.key,
    this.child,
  });

  /// The child widget to display in the overlay
  final Widget? child;

  @override
  State<OverlayLoadingBuilder> createState() => _OverlayLoadingBuilderState();
}

class _OverlayLoadingBuilderState extends State<OverlayLoadingBuilder> {
  late final TopSnackOverlayEntry _overlayEntry;
  late final TopSnackBar _topSnackBar;
  @override
  void initState() {
    super.initState();
    _topSnackBar = TopSnackBar();
    _overlayEntry = TopSnackOverlayEntry(
      builder: (context) => _topSnackBar.snackBar ?? const SizedBox.shrink(),
    );
    _topSnackBar.overlayEntry = _overlayEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Overlay(
        initialEntries: [
          TopSnackOverlayEntry(
            builder: (context) => widget.child ?? const SizedBox.shrink(),
          ),
          _overlayEntry,
        ],
      ),
    );
  }
}

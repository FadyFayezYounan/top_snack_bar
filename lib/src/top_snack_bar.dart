import 'dart:async' show Timer;

import 'package:flutter/material.dart'
    show BuildContext, Color, GlobalKey, Widget;

import 'utils/utils.dart';
import 'widgets/widgets.dart';

final class TopSnackBar {
  static TopSnackBar? _instance;

  /// Private constructor for OverlayLoading.
  TopSnackBar._internal();

  factory TopSnackBar() {
    _instance ??= TopSnackBar._internal();
    return _instance!;
  }

  // Nullable widget indicator
  Widget? _snackBar;

  /// Getter for the indicator
  Widget? get snackBar => _snackBar;

  /// This entry is used to show the overlay loading indicator.
  TopSnackOverlayEntry? _overlayEntry;

  TopSnackBarStatusCallback? _statusCallback;

  GlobalKey<TopSnackBarWidgetState>? _key;

  SnackBarStatus? _status;

  Timer? _timer;

  /// Callback function for top snack bar status changed.
  ///
  /// [callback] is a function that will be called when the top snack bar status changes.
  ///
  /// This function is useful for listening to the top snack bar status changes and
  /// triggering specific actions.
  static void onStatusChanged(TopSnackBarStatusCallback callback) {
    // Set the status callback to the provided callback.
    _instance?._statusCallback = callback;
  }

  void _changeStatus(SnackBarStatus status) {
    _status = status;
    _statusCallback?.call(status);
  }

  set overlayEntry(TopSnackOverlayEntry? value) {
    _overlayEntry = value;
  }

  static TopSnackBarInitializationCallBack ensureInitialize({
    TopSnackBarInitializationCallBack? builder,
  }) {
    return (BuildContext context, Widget? child) {
      if (builder != null) {
        return builder(context, OverlayLoadingBuilder(child: child));
      } else {
        return OverlayLoadingBuilder(child: child);
      }
    };
  }

  /// Shows the TopSnackBar with the given [duration], [backgroundColor], [title],
  /// [subtitle], [trailingWidget], and [leadingWidget].
  ///
  /// If the [duration] is not null, the snackbar will automatically hide after the
  /// specified duration.
  ///
  /// If the snackbar is already visible, this function does nothing.
  static void show({
    Duration? duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Widget? title,
    Widget? subtitle,
    Widget? trailingWidget,
    Widget? leadingWidget,
  }) {
    return _instance?._show(
      duration: duration,
      backgroundColor: backgroundColor,
      title: title,
      subtitle: subtitle,
      trailingWidget: trailingWidget,
      leadingWidget: leadingWidget,
    );
  }

  /// Shows the TopSnackBar with the given [duration], [backgroundColor], [title],
  /// [subtitle], [trailingWidget], and [leadingWidget].
  ///
  /// If the [duration] is not null, the snackbar will automatically hide after the
  /// specified duration.
  ///
  /// If the snackbar is already visible, this function does nothing.
  void _show({
    Duration? duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Widget? title,
    Widget? subtitle,
    Widget? trailingWidget,
    Widget? leadingWidget,
  }) async {
    // Assert that the overlay entry is null.
    assert(
      _overlayEntry != null,
      '''You should call TopSnackBar.ensureInitialize() in your MaterialApp
         before calling TopSnackBar.show().
      ''',
    );

    // If the snackbar is already visible, do nothing and return.
    if (_status == SnackBarStatus.visible) {
      return;
    } else {
      // Create a new key for the snackbar widget.
      _key = GlobalKey<TopSnackBarWidgetState>();

      // Create the snackbar widget with the given parameters.
      _snackBar = TopSnackBarWidget(
        key: _key,
        backgroundColor: backgroundColor,
        title: title,
        subtitle: subtitle,
        trailingWidget: trailingWidget,
        leadingWidget: leadingWidget,
      );

      // Show the snackbar.
      await _key?.currentState?.showSnackbar();

      // Change the status to visible.
      _changeStatus(SnackBarStatus.visible);

      // Mark the overlay as needing rebuild.
      _overlayMarkNeedsBuild();

      // If a duration is specified, start a timer to automatically hide the snackbar.
      if (duration != null) {
        _cancelTimer();
        _timer = Timer(duration, () {
          _instance?._hide();
        });
      }
    }
  }

  /// Hides the TopSnackBar.
  static void hide() {
    return _instance?._hide();
  }

  /// If the snackbar is currently visible, it hides it and triggers the overlay
  /// to rebuild. If the snackbar is currently hidden, it does nothing.
  void _hide() {
    // Get the state of the snackbar widget
    final topSnackBarState = _key?.currentState;

    // If the snackbar is not visible, reset the indicator and loading status
    if (topSnackBarState == null) {
      _instance?._reset();
    } else {
      // If the snackbar is visible, hide it and reset the indicator and
      // loading status when the hiding process is complete
      topSnackBarState.hideSnackbar().whenComplete(
        () {
          _instance?._reset();
        },
      );
    }
  }

  /// This function hides the top snackbar, cancels the timer if it's active,
  /// marks the overlay as needing to rebuild, and changes the loading status to hidden.
  void _reset() {
    _snackBar = null;
    _key = null;
    _cancelTimer();
    _overlayMarkNeedsBuild();
    _changeStatus(SnackBarStatus.hidden);
  }

  /// Marks the overlay as needing to rebuild.
  ///
  /// This function calls the `markNeedsBuild` method of the `_overlayEntry` to
  /// indicate that the overlay needs to be rebuilt.
  void _overlayMarkNeedsBuild() {
    // If the overlay entry is not null, mark it as needing to be built.
    return _overlayEntry?.markNeedsBuild();
  }

  /// Cancels the timer, if it is active.
  ///
  /// This function cancels the timer and sets it to null. If the timer is not active,
  /// this function does nothing.
  void _cancelTimer() {
    // If the timer is not null, cancel it.
    _timer?.cancel();

    // Set the timer to null, indicating that the timer is not active.
    _timer = null;
  }
}

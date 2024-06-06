import 'package:flutter/material.dart' show BuildContext, Widget;

import 'snack_bar_status.dart';

/// Callback function for overlay initialization
typedef TopSnackBarInitializationCallBack = Widget Function(
  BuildContext context,
  Widget? child,
);

/// Callback for overlay loading status.
typedef TopSnackBarStatusCallback = void Function(
  SnackBarStatus status,
);

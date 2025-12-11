import 'package:flutter/material.dart';
import 'connect_monitor.dart';

class ConnectGuard extends StatefulWidget {
  /// The widget to show when the device is ONLINE.
  final WidgetBuilder builder;

  /// The widget to show when the device is OFFLINE.
  /// If null, the [builder] will be shown even when offline.
  final WidgetBuilder? offlineBuilder;

  /// The widget to show while the initial connection check is happening.
  /// Defaults to a minimal [SizedBox].
  final WidgetBuilder? loadingBuilder;

  /// Callback triggered when connection status changes.
  /// [isOnline] is true if connected.
  final Function(bool isOnline)? onConnectivityChanged;

  const ConnectGuard({
    Key? key,
    required this.builder,
    this.offlineBuilder,
    this.loadingBuilder,
    this.onConnectivityChanged,
  }) : super(key: key);

  @override
  State<ConnectGuard> createState() => _ConnectGuardState();
}

class _ConnectGuardState extends State<ConnectGuard> {
  late Stream<bool> _connectionStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream from our Core Logic
    _connectionStream = ConnectMonitor().connectionStream;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectionStream,
      builder: (context, snapshot) {
        // 1. Initial Loading State
        if (!snapshot.hasData) {
          if (widget.loadingBuilder != null) {
            return widget.loadingBuilder!(context);
          }
          return const SizedBox.shrink();
        }

        final bool isOnline = snapshot.data!;

        // 2. Trigger Callback (Side Effect)
        // We use addPostFrameCallback to ensure we don't trigger state updates
        // during the build phase.
        if (widget.onConnectivityChanged != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.onConnectivityChanged!(isOnline);
          });
        }

        // 3. Render Offline UI
        if (!isOnline && widget.offlineBuilder != null) {
          return widget.offlineBuilder!(context);
        }

        // 4. Render Online (Default) UI
        return widget.builder(context);
      },
    );
  }
}

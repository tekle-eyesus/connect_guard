# ConnectGuard 🌐

A lightweight, robust Flutter widget that simplifies handling offline/online network states. 

Unlike standard connectivity checks which only verify if Wi-Fi is connected, **ConnectGuard** verifies actual internet access by pinging a server, ensuring your users never see a "Connected" state when the router has no internet.

## Features

*   **Real Internet Check:** Verifies actual data connection, not just Wi-Fi status.
*   **Reactive Widget:** `ConnectGuard` automatically switches between your app content and an offline widget.
*   **Zero Boilerplate:** No need to manage Streams or `initState` manually.
*   **Callback Support:** Trigger Snackbars or alerts easily when the connection status changes.
*   **Customizable:** Provide your own "Offline" and "Loading" widgets.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  connect_guard: ^0.0.1
```
## Usage 

Simply wrap your screen (or specific widget) with **ConnectGuard**:

```dart
import 'package:connect_guard/connect_guard.dart';

ConnectGuard(
  // 1. The UI to show when Online
  builder: (context) {
    return Center(child: Text("You are Online!"));
  },

  // 2. The UI to show when Offline (Optional)
  offlineBuilder: (context) {
    return Center(child: Text("No Internet Connection"));
  },

  // 3. Callback for side effects (Optional)
  onConnectivityChanged: (isOnline) {
    if (!isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Connection lost!")),
      );
    }
  },
);
```
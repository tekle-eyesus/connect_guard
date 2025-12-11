import 'package:flutter/material.dart';
import 'package:connect_guard/connect_guard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectGuard Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ConnectGuard Demo")),
      body: ConnectGuard(
        // 1. Logic for when connection changes
        onConnectivityChanged: (isOnline) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isOnline ? "Back Online!" : "Lost Connection!"),
              backgroundColor: isOnline ? Colors.green : Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        },

        // 2. Custom Offline Widget (Optional)
        // If you remove this, it will just show the builder (and the snackbar)
        offlineBuilder: (context) {
          return Container(
            color: Colors.red.shade50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.wifi_off, size: 100, color: Colors.red),
                SizedBox(height: 20),
                Text("No Internet Connection", style: TextStyle(fontSize: 24)),
                Text("Please check your settings."),
              ],
            ),
          );
        },

        // 3. Main App Content (Online)
        builder: (context) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 100, color: Colors.green),
                const SizedBox(height: 20),
                const Text(
                  "You are Online!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Simulate an API call
                  },
                  child: const Text("Perform Action"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

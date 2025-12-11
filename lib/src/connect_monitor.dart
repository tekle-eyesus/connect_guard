import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:rxdart/rxdart.dart';

class ConnectMonitor {
  static final ConnectMonitor _instance = ConnectMonitor._internal();
  factory ConnectMonitor() => _instance;
  ConnectMonitor._internal();

  Stream<bool> get connectionStream {
    //  combine the hardware connectivity changes with an actual data check.
    return Connectivity()
        .onConnectivityChanged
        .switchMap((results) {
          return _checkInternet(results);
        })
        .startWith(false)
        .distinct();
  }

  /// Checks if there is actual internet access
  Stream<bool> _checkInternet(List<ConnectivityResult> results) async* {
    bool hasConnection = results.any((result) =>
        result != ConnectivityResult.none &&
        result != ConnectivityResult.bluetooth);

    if (hasConnection) {
      bool hasInternet = await InternetConnection().hasInternetAccess;
      yield hasInternet;
    } else {
      yield false;
    }
  }

  /// One-time check for current status
  Future<bool> get hasInternet async {
    return await InternetConnection().hasInternetAccess;
  }
}

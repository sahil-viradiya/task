import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../routes/app_routes.dart';
import '../routes/navigation_services.dart';

class MyConnectivity {
  MyConnectivity._();

  static final _instance = MyConnectivity._();

  static MyConnectivity get instance => _instance;

  final Connectivity _connectivity = Connectivity();
  final StreamController<Map<ConnectivityResult, bool>> _controller = StreamController<Map<ConnectivityResult, bool>>.broadcast();

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  ValueNotifier<bool> isOnline = ValueNotifier<bool>(true);
  String? _lastRoute;

  Stream<Map<ConnectivityResult, bool>> get myStream => _controller.stream;

  Future<void> initialise() async {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    await _updateConnectionStatus(await _connectivity.checkConnectivity());

    myStream.listen((event) {
      event.forEach((result, online) async {
        isOnline.value = online;
        print('Connectivity: $result, isOnline: $online');

        final currentRoute = NavigatorService.navigatorKey.currentState?.currentRoute?.settings.name;

        if (!online) {
          if (currentRoute != AppRoutes.noInternet) {
            _lastRoute = currentRoute;
            await NavigatorService.pushNamed(AppRoutes.noInternet);
          }
        } else {
          if (currentRoute == AppRoutes.noInternet && _lastRoute != null) {
            NavigatorService.navigatorKey.currentState?.pop();

            // Special handling for initial route
            if (_lastRoute == '/') {
              await NavigatorService.navigatorKey.currentState?.pushReplacementNamed(AppRoutes.splashScreen);
            } else {
              await NavigatorService.navigatorKey.currentState?.pushReplacementNamed(_lastRoute!);

              // await NavigatorService.pushReplacementNamedAnimated(_lastRoute!);
            }
          }
        }
      });
    });
  }

  Future<bool> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    await _updateConnectionStatus(result);
    return isOnline.value;
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    await _checkStatus(_connectionStatus[0]);
    print('Connectivity changed: ${_connectionStatus[0]}');
  }

  Future<void> _checkStatus(ConnectivityResult result) async {
    bool online = false;
    try {
      final lookupResult = await InternetAddress.lookup('example.com');
      online = lookupResult.isNotEmpty && lookupResult[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      online = false;
    }
    isOnline.value = online;
    _controller.sink.add({result: online});
  }

  void disposeStream() {
    _connectivitySubscription.cancel();
    _controller.close();
    isOnline.dispose();
  }
}

// Extension for NavigatorState to get current route
extension NavigatorStateExtension on NavigatorState {
  Route<dynamic>? get currentRoute {
    Route<dynamic>? currentRoute;
    popUntil((route) {
      currentRoute = route;
      return true;
    });
    return currentRoute;
  }
}

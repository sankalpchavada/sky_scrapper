import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../models/connectivity_model.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityModel connectivityModel =
      ConnectivityModel(connectivityStatus: 'Offline');

  Connectivity connectivity = Connectivity();

  void checkConnectivity() {
    connectivity.onConnectivityChanged
        .listen((ConnectivityResult connectivityResult) {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        connectivityModel.connectivityStatus = 'Online';
        notifyListeners();
      } else {
        connectivityModel.connectivityStatus = 'Offline';
        notifyListeners();
      }
    });
  }
}

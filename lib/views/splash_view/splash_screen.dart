import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../const/const_app_images.dart';
import '../../const/const_color.dart';
import '../../repository/check_internate_connection.dart';
import '../../routes/app_routes.dart';
import '../../routes/navigation_services.dart';
import 'splash_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SplashBloc()
        ..add(SplashLoaded()),
      child: const SplashScreen(),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is Loaded) {
            _checkConnectivityAndNavigate(context);
          }
        },
        builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Image.asset(AppImages.splash,  fit: BoxFit.contain,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return const SizedBox();
              }),
            ),
          ),
        );
      }
    );
  }
  /// ✅ **Properly handling delay and connectivity check**
  Future<void> _checkConnectivityAndNavigate(BuildContext context) async {
    // Ensure connectivity check happens **after** the delay
    await Future.delayed(const Duration(seconds: 3));

    // Re-check connectivity status
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.none)) {
      // No internet, navigate to No Internet Screen
      MyConnectivity.instance.initialise();
    } else {
      MyConnectivity.instance.initialise();
        NavigatorService.pushNamedAndRemoveUntil(AppRoutes.homeScreen);

    }
  }
}

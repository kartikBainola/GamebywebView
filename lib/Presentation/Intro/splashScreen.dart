import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pixamentory_online_services/Presentation/Screens/main_Screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: LottieBuilder.asset('assets/animations/SplashScreen.json'),
      ),
      nextScreen: MainScreen(),
      splashIconSize: 900,
      backgroundColor: Color(0xFF181C14),
    );
  }
}

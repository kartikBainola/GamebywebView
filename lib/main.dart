import 'package:flutter/material.dart';
import 'package:pixamentory_online_services/Presentation/Intro/splashScreen.dart';
import 'package:provider/provider.dart';
import 'Presentation/providers/webview_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WebViewProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaming Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
            actionsIconTheme: AppBarTheme.of(context).actionsIconTheme,
            backgroundColor: Colors.blueAccent.shade700,
            foregroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.blueAccent.shade100,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueAccent.shade700,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(
            color: Colors.green,
          ),
          unselectedLabelStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

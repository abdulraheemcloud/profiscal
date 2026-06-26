import 'package:flutter/material.dart';

import '../features/splash/splash_screen.dart';
import 'theme.dart';

class ProFiscalApp extends StatelessWidget {
  const ProFiscalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ProFiscal',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
import 'package:flutter/material.dart';
import 'core/router/app_router.dart';
import 'ui/theme/app_theme.dart';

class MyPerroApp extends StatelessWidget {
  const MyPerroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyPerro',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

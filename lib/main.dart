import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await GoogleFonts.pendingFonts([]);
  } catch (e) {
    debugPrint('Google Fonts initialization warning: $e');
  }
  
  runApp(
    const ProviderScope(
      child: MyPerroApp(),
    ),
  );
}

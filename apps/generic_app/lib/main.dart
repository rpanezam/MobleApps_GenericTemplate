import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_ui/shared_ui.dart';
import 'package:shared_database/shared_database.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the Supabase Client using the public credentials
  await Supabase.initialize(
    url: 'https://kmubhzdxgzvlqczdvywt.supabase.co',
    // ignore: deprecated_member_use
    anonKey: 'sb_publishable_JTsV-H0VL-V07CFTJ0ijCw_Sd7L8zBa',
  );

  final supabaseService = SupabaseService(Supabase.instance.client);

  runApp(
    ProviderScope(
      overrides: [
        supabaseServiceProvider.overrideWithValue(supabaseService),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Factory',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to the premium dark mode
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';
import 'package:karu/routing/go_routing.dart';
import 'package:karu/services/deeplinks_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");
  final String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  final String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';

  // Initialize Supabase client
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _appLinks = AppLinks();
  final DeepLinksConfig deepLinksConfig = DeepLinksConfig();
  @override
  void initState() {
    super.initState();
    deepLinksConfig.initDeepLinks(_appLinks);
  }

  @override
  void dispose() {
    deepLinksConfig.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'SafeReturn',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      // home: const DashboardPage(),
    );
  }
}

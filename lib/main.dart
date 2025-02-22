import 'package:cookethflow/core/utils/state_handler.dart';
import 'package:cookethflow/providers/dashboard_provider.dart';
import 'package:cookethflow/providers/flowmanage_provider.dart';
import 'package:cookethflow/providers/loading_provider.dart';
import 'package:cookethflow/screens/discarded/node_provider.dart';
import 'package:cookethflow/screens/dashboard.dart';
import 'package:cookethflow/providers/workspace_provider.dart';
import 'package:cookethflow/providers/authentication_provider.dart';
import 'package:cookethflow/screens/loading.dart';
import 'package:cookethflow/screens/log_in.dart';
import 'package:cookethflow/screens/sign_up.dart';
import 'package:cookethflow/screens/workspace.dart';
import 'package:cookethflow/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  String supabaseUrl = dotenv.env["SUPABASE_URL"] ?? "Url";
  String supabaseApiKey = dotenv.env["SUPABASE_KEY"] ?? "your_api_key";
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseApiKey);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<NodeProvider>(
          create: (_) => NodeProvider(ProviderState.loaded)),
      ChangeNotifierProvider<DashboardProvider>(
          create: (_) => DashboardProvider()),
      ChangeNotifierProvider<WorkspaceProvider>(
          create: (_) => WorkspaceProvider(ProviderState.loaded)),
      ChangeNotifierProvider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider<LoadingProvider>(create: (_) => LoadingProvider()),
      ChangeNotifierProvider<FlowmanageProvider>(
          create: (_) => FlowmanageProvider())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Workspace(flowId: "1"),
      // home: Dashboard(),
    );
  }
}

import 'package:crud_repository/crud_repository.dart';
import 'package:expenses_copilot_app/app.dart';
import 'package:expenses_copilot_app/config/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:authentication_repository/authentication_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: Environment.supabaseUrl,
    anonKey: Environment.supabaseApiKey,
  );

  final supabaseInstance = Supabase.instance;

  final AuthenticationRepository authRepository =
      SupabaseAuthenticationRepository(client: supabaseInstance.client);
  final CrudRepository queryRepository =
      SupabaseCrudRepository(client: supabaseInstance.client);
  await authRepository.getUser().first;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(ExpensesCopilotApp(
    authRepository: authRepository,
    queryRepository: queryRepository,
  ));
}

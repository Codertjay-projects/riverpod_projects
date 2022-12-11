import 'package:codertjay_gram/state/auth/models/auth_result.dart';
import 'package:codertjay_gram/state/auth/providers/auth_state_provider.dart';
import 'package:codertjay_gram/state/providers/is_loading_provider.dart';
import 'package:codertjay_gram/views/components/loading/loading_screen.dart';
import 'package:codertjay_gram/views/login/login_view.dart';
import 'package:codertjay_gram/views/main/main_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Codertjay Gram',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey,
          brightness: Brightness.dark),
      home: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          // take care of displaying the loading screen
          ref.listen<bool>(isLoadingProvider, (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });

          final isLoggedIn =
              ref.watch(authStateProvider).result == AuthResult.success;
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}


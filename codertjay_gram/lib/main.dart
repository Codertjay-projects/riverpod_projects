import "dart:developer" as devtools show log;

import 'package:codertjay_gram/state/auth/backend/authenticator.dart';
import 'package:codertjay_gram/state/auth/models/auth_result.dart';
import 'package:codertjay_gram/state/auth/providers/auth_state_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'firebase_options.dart';
//https://codertjay-gram.firebaseapp.com/__/auth/handler

extension Log on Object {
  void log() => devtools.log(toString());
}

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
          final isLoggedIn =
              ref.watch(authStateProvider).result == AuthResult.success;
          isLoggedIn.log();
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

// For when you are logged in
class MainView extends ConsumerWidget {
  const MainView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main View")),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return TextButton(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logOut();
            },
            child: const Text("Logout"),
          );
        },
      ),
    );
  }
}

// for when you are not logged in
class LoginView extends ConsumerWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login View"),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
            child: const Text("SigIn In with Google"),
          ),
          TextButton(
            onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
            child: const Text("SigIn In with Facebook"),
          ),
        ],
      ),
    );
  }
}

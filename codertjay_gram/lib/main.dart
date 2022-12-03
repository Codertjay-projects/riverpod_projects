import 'package:codertjay_gram/state/auth/backend/authenticator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import "dart:developer" as devtools show log;
//https://codertjay-gram.firebaseapp.com/__/auth/handler

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
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
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page")),
      body: Column(
        children: [
          TextButton(
            onPressed: () async {
              final result =await Authenticator().loginWithGoogle();
              result.log();
            },
            child: const Text("SigIn In with Google"),
          ),
          TextButton(
            onPressed: () async{
              final result = await Authenticator().loginWithFacebook();
              result.log();
            },
            child: const Text("SigIn In with Facebook"),
          ),
        ],
      ),
    );
  }
}

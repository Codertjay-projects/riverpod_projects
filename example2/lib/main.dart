import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;

  int? get value => state;
}

final counterProvider =
    StateNotifierProvider<Counter, int?>((ref) => Counter());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

extension OptionalInfixAddition<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

void testIt() {
  const int? int1 = 1;
  const int int2 = 1;
  const result = int1 + int2;
  print(result);
}

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Consumer(
            builder: (context, ref, child) {
              final count = ref.watch(counterProvider);
              final text =
                  count == null ? "Press the button " : count.toString();
              return Text(text);
            },
            child: const Text('Home Page')),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              child: const Text("Increment Counter"))
        ],
      ),
    );
  }
}

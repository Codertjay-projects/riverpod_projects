import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

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

enum City {
  stockholm,
  paris,
  tokyo,
}

typedef WeatherEmoji = String;

Future<WeatherEmoji> getWeather(City city) {
  return Future.delayed(
    const Duration(seconds: 1),
    () => {
      City.stockholm: "☀",
      City.paris: "🌨",
      City.tokyo: "🌧",
    }[city]!,
  );
}

const unknownWeatherEmoji = "😁";


// Ui writes to this
final currentCityProvider = StateProvider<City?>(
  (ref) => null,
);
// UI reads this to know what to display
final weatherProvider = FutureProvider<WeatherEmoji>((ref) {
  final city = ref.watch(currentCityProvider);

  if (city != null) {
    return getWeather(city);
  } else {
    return unknownWeatherEmoji;
  }
});

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(
      weatherProvider,
    );
    return Scaffold(
      appBar: AppBar(title: const Text("Weather")),
      body: Column(
        children: [
          currentWeather.when(
              data: (data) {
                return Text(data, style: const TextStyle(fontSize: 40));
              },
              error: (_, __) => const Text("Error 😥"),
              loading: () => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  )),
          Expanded(
              child: ListView.builder(
                  itemCount: City.values.length,
                  itemBuilder: (context, index) {
                    final city = City.values[index];
                    final isSelected = city == ref.watch(currentCityProvider);
                    return ListTile(
                      title: Text(
                        city.toString(),
                      ),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () {
                        ref.read(currentCityProvider.notifier).state = city;
                      },
                    );
                  }))
        ],
      ),
    );
  }
}

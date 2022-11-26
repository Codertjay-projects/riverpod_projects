import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavourite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavourite,
  });

  Film copy({required bool isFavourite}) {
    /*Create a copy but just change the isFavourite*/
    return Film(
      id: id,
      title: title,
      description: description,
      isFavourite: isFavourite,
    );
  }

  @override
  String toString() => "Film("
      "id: $id, "
      "title: $title, "
      "description: $description,"
      " isFavourite: $isFavourite)";

  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavourite == other.isFavourite;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hashAll([id, isFavourite]);
}

const allFilms = [
  Film(
      id: "1",
      title: 'The Shaw Redemption',
      description: "Description for the Shaw Redemption",
      isFavourite: false),
  Film(
      id: "2",
      title: 'Black Adam',
      description: "Description for the Black Adam",
      isFavourite: false),
  Film(
      id: "3",
      title: 'Adams Family',
      description: "Description for the Adams Family",
      isFavourite: false),
  Film(
      id: "4",
      title: 'The Chinese',
      description: "Description for the Chinese",
      isFavourite: false),
  Film(
      id: "5",
      title: 'The Nigeria',
      description: "Description for the Nigeria",
      isFavourite: false),
  Film(
      id: "6",
      title: 'The Lagos',
      description: "Description for the Lagos",
      isFavourite: false),
  Film(
      id: "7",
      title: 'The Iphone',
      description: "Description for the Iphone",
      isFavourite: false),
  Film(
      id: "8",
      title: 'The Music',
      description: "Description for the Music",
      isFavourite: false),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

  void update(Film film, bool isFavourite) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavourite: isFavourite)
            : thisFilm)
        .toList();
  }
}

enum FavouriteStatus {
  all,
  favourite,
  notFavourite,
}

// Favourite
final favouriteStatusProvider = StateProvider<FavouriteStatus>(
  (_) => FavouriteStatus.all,
);

//all films
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

final favouriteFilmsProvider = Provider<Iterable<Film>>(
    (ref) => ref.watch(allFilmsProvider).where((film) => film.isFavourite));

final notFavouriteFilmsProvider = Provider<Iterable<Film>>(
    (ref) => ref.watch(allFilmsProvider).where((film) => !film.isFavourite));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Person',
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

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Films")),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(builder: (context, ref, child) {
            final filter = ref.watch(favouriteStatusProvider);
            switch (filter) {
              case FavouriteStatus.all:
                return FilmsList(provider: allFilmsProvider);
              case FavouriteStatus.favourite:
                return FilmsList(provider: favouriteFilmsProvider);
              case FavouriteStatus.notFavourite:
                return FilmsList(provider: notFavouriteFilmsProvider);
            }
          }),
        ],
      ),
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;

  const FilmsList({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
        child: ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films.elementAt(index);
              final favouriteIcon = film.isFavourite
                  ? const Icon(Icons.favorite_border)
                  : const Icon(Icons.favorite);
              return ListTile(
                title: Text(film.title),
                subtitle: Text(film.description),
                trailing: IconButton(
                  icon: favouriteIcon,
                  onPressed: () {
                    final isFavourite = !film.isFavourite;
                    ref
                        .read(allFilmsProvider.notifier)
                        .update(film, isFavourite);
                  },
                ),
              );
            }));
  }
}

class FilterWidget extends StatelessWidget {
  const FilterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return DropdownButton(
        value: ref.watch(favouriteStatusProvider),
        items: FavouriteStatus.values
            .map(
                (status) => DropdownMenuItem(
                  value: status,
                child: Text(status.toString().split(".").last)))
            .toList(),
        onChanged: (fs) {
          ref.read(favouriteStatusProvider.state).state = fs!;
        },
      );
    });
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:uuid/uuid.dart";

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

@immutable
class Person {
  final String name;
  final int age;
  final String? uuid;

  Person({required this.name, required this.age, String? uuid})
      : uuid = uuid ?? const Uuid().v4();

  Person updated([String? name, int? age]) => Person(
        name: name ?? this.name,
        age: age ?? this.age,
        uuid: uuid,
      );

  String get displayName => "$name is ($age years old)";

  @override
  bool operator ==(covariant Person other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  @override
  String toString() => "Person (name: $name, age: $age, uuid: $uuid)";
}

class DataModel extends ChangeNotifier {
  final List<Person> _people = [];

  int get count => _people.length;

  UnmodifiableListView<Person> get people => UnmodifiableListView(_people);

  void addPerson(Person person) {
    _people.add(person);
    notifyListeners();
  }

  void removePerson(Person person) {
    _people.remove(person);
    notifyListeners();
  }

  void update(Person updatedPerson) {
    final index = _people.indexOf(updatedPerson);
    final oldPerson = _people[index];
    if (oldPerson.name != updatedPerson.name ||
        oldPerson.age != updatedPerson.age) {
      _people[index] = updatedPerson;
      notifyListeners();
    }
  }
}

final peopleProvider = ChangeNotifierProvider((_) => DataModel());

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
      appBar: AppBar(title: const Text("Home Page")),
      body: Consumer(builder: (context, ref, child) {
        final dataModel = ref.watch(peopleProvider);
        return ListView.builder(
          itemCount: dataModel.count,
          itemBuilder: (context, index) {
            final person = dataModel.people[index];
            return ListTile(
              title: GestureDetector(
                  onTap: () async {
                    final updatedPerson =
                        await createOrUpdatePersonDialog(context, person);
                    if (updatedPerson != null) {
                      dataModel.update(updatedPerson);
                    }
                  },
                  child: Text(person.displayName)),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final person = await createOrUpdatePersonDialog(
            context,
          );
          if (person != null) {
            final dataModel = ref.read(peopleProvider);
            dataModel.addPerson(person);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

final nameController = TextEditingController();
final ageController = TextEditingController();

Future<Person?> createOrUpdatePersonDialog(
  BuildContext context, [
  Person? existingPerson,
]) {
  String? name = existingPerson?.name;
  int? age = existingPerson?.age;

  ageController.text = age?.toString() ?? "";
  nameController.text = name?.toString() ?? "";

  return showDialog<Person>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create a person"),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: nameController,
              onChanged: (value) => name = value,
              decoration:
                  const InputDecoration(labelText: "Enter name here..."),
            ),
            TextField(
              controller: ageController,
              onChanged: (value) => age = int.tryParse(value),
              decoration: const InputDecoration(labelText: "Enter age here..."),
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(Person(
                      name: name!,
                      age: age!,
                    )),
                child: const Text("Cancel")),
            TextButton(
                onPressed: () {
                  if (name != null && age != null) {
                    if (existingPerson != null) {
                      print("Exist");
                      final newPerson = existingPerson.updated(name, age);
                      Navigator.of(context).pop(newPerson);
                    } else {
                      //  No existing person, create a new one
                      print("heer");
                      Navigator.of(context).pop(Person(
                        name: name!,
                        age: age!,
                      ));
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Text("Save")),
          ],
        );
      });
}

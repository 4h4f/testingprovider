import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BreadCrumbProvider(),
      child: MaterialApp(
        title: "Flutter Provider",
        theme: ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        routes: {
          '/new': (context) => const Material(),
        },
      ),
    ),
  );
}

//------------------------Model--------------------------
class BreadCrumb {
  final String uuid;
  bool isActive;
  final String name;

  BreadCrumb({required this.name, required this.isActive})
      : uuid = const Uuid().v4();

  void active() {
    isActive = true;
  }

  @override
  bool operator ==(covariant BreadCrumb other) => uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;

  String get title => name + (isActive ? ' > ' : '');
}
//-----------------------------Model Ends--------------------

//-----------------BreadCrumb Provider starts-----------------
class BreadCrumbProvider extends ChangeNotifier {
  final List<BreadCrumb> _items = [BreadCrumb(isActive: false, name: "abdo")];
  UnmodifiableListView<BreadCrumb> get item => UnmodifiableListView(_items);
  void add(BreadCrumb breadCrumb) {
    for (final item in _items) {
      item.active();
    }
    _items.add(breadCrumb);
    notifyListeners();
  }

  void reset() {
    _items.clear();
    notifyListeners();
  }
}

class BreadCrumbsWidget extends StatelessWidget {
  final UnmodifiableListView<BreadCrumb> breadCrumbs;
  const BreadCrumbsWidget({Key? key, required this.breadCrumbs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: breadCrumbs.map((bcrumb) {
        return Text(
          bcrumb.title,
          style: TextStyle(color: bcrumb.isActive ? Colors.blue : Colors.black),
        );
      }).toList(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("my app")),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/new');
            },
            child: const Text("Add new bread crumb"),
          ),
//Between two buttons
          TextButton(
            onPressed: () {
              context.read<BreadCrumbProvider>().reset();
            },
            child: const Text("Reset"),
          ),
        ],
      ),
    );
  }
}

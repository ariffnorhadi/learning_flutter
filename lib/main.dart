import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Learning App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var currentWord = WordPair.random();

  void newWord() {
    currentWord = WordPair.random();
    notifyListeners();
  }

  List<WordPair> favourite = [];

  void updateFavourite() {
    if (favourite.contains(currentWord)) {
      favourite.remove(currentWord);
    } else {
      favourite.add(currentWord);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var currentIndex = 0;
  var items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favourite',
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  StatelessWidget pageBuilder(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return FavoritesPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Learning App',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: pageBuilder(currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            items: items, currentIndex: currentIndex, onTap: onItemTapped),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentWord = appState.currentWord;
    var icon = Icon(Icons.favorite_border);
    icon = appState.favourite.contains(currentWord)
        ? Icon(Icons.favorite)
        : Icon(Icons.favorite_border);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              WordCard(currentWord: currentWord),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.updateFavourite();
                },
                icon: icon,
                label: Text('Love ${currentWord.asPascalCase}'),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.newWord();
                  },
                  label: Text('Next'),
                  icon: Icon(Icons.arrow_forward)),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var favourite = appState.favourite;

    return ListView.builder(
      itemCount: favourite.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(favourite[index].asPascalCase),
        );
      },
    );
  }
}

class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.currentWord,
  });

  final WordPair currentWord;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        'Your word is ${currentWord.asPascalCase}',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary),
      ),
    );
  }
}

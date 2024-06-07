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
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var currentWord = appState.currentWord;

    Icon icon = Icon(Icons.favorite_border);
    icon = appState.favourite.contains(currentWord)
        ? Icon(Icons.favorite)
        : Icon(Icons.favorite_border);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        appState.newWord();
                      },
                      child: Text('New Word')),
                  Text(currentWord.asPascalCase),
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
                    label: Text(
                        'Love current word which is ${currentWord.asPascalCase}'),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

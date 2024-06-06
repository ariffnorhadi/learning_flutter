import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Everything is a widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Build method is called when the widget is rendered, every widget has a build method
    // telling us like this widget and what it contains or how it looks
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // create state for the whole app
      child: MaterialApp(
        title: 'Easy App',
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
  // whenever got changes, notify the listeners
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<MyAppState>(); // watch the state, also acts as a listener
    var wordPairFromState = appState
        .current; // so that we do not use the whole appState.current again and again

    Icon icon = appState.favorites.contains(wordPairFromState)
        ? Icon(Icons.favorite)
        : Icon(Icons.favorite_border);

    return Scaffold(
      // every build method should return a widget (which also has nested widgets)
      // provides a default layout for the top-level pages of your app (just nice to have)
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('hi finix:'),
            ElevatedButton(
              onPressed: () {
                print('button pressed!');
              },
              child: Text('Testing Button 123'),
            ),
            SizedBox(
                height: 20), // add some space between the text and the buttons
            Row(
              mainAxisSize: MainAxisSize
                  .min, // already center from mainAxisAlignment under Column, so we ask it to be as small as possible (from the center)
              children: [
                ElevatedButton(
                  onPressed: () {
                    appState.getNext();
                  },
                  child: Icon(Icons.refresh),
                ),
                SizedBox(width: 15), // add some space between the buttons
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: icon,
                  label: Text('Favorite'),
                ),
              ],
            ),
            SizedBox(
                height: 20), // add some space between the buttons and the card
            BigCard(wordPairFromState: wordPairFromState),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.wordPairFromState,
  });

  final WordPair wordPairFromState;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context); // get the theme of the app
    final style = theme.textTheme.displayMedium!.copyWith(
      // theme.textTheme accesses the text theme of the app
      // displayMedium is a text style that is used for big text
      color: theme.colorScheme.onSecondary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Text(
          wordPairFromState.asPascalCase,
          style: style,
          semanticsLabel: wordPairFromState.asPascalCase,
        ),
      ),
    );
  }
}

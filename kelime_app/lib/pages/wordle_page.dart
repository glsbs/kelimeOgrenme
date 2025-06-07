import 'package:flutter/material.dart';
import 'package:kelime_app/models/word_model.dart';
import 'package:kelime_app/pages/services/wordle_service.dart';

class Wordle extends StatefulWidget {
  const Wordle({super.key});

  @override
  State<Wordle> createState() => _WordleState();
}

class _WordleState extends State<Wordle> {
  final WordleService _wordleService = WordleService();
  Word? firebaseWord;

  String guess = '';
  List<String> guesses = [];

  List<List<Color>> boxColors = [];

  final int maxGiris = 6;
  final _controller = TextEditingController();
  bool wordNotFound = false;
  bool loading = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadWord();
  }

  void _loadWord() async {
    final word = await _wordleService.getRandomKnownWord();
    setState(() {
      firebaseWord = word;
      loading = false;
      wordNotFound = word == null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: AppBar(title: Text("Wordlle")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (wordNotFound) {
      return Scaffold(
        appBar: AppBar(title: Text("Wordle")),
        body: Center(
          child: Text(
            "Henüz Öğrendiğiniz Bir Kelime Yok",
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    String word = firebaseWord!.ingWord.toLowerCase();
    int wordLength = word.length;

    return Scaffold(
      appBar: AppBar(title: Text("Wordle")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Column(
              children: List.generate(maxGiris, (row) {
                String displayWord = '';
                List<Color> colors = List.filled(
                  wordLength,
                  Colors.grey.shade300,
                );

                if (row < guesses.length) {
                  displayWord = guesses[row];
                  colors = boxColors[row];
                } else if (row == guesses.length) {
                  displayWord = guess;
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(wordLength, (index) {
                    String letter =
                        displayWord.length > index
                            ? displayWord[index].toUpperCase()
                            : '';
                    Color color = colors[index];

                    return Container(
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: color,
                        border: Border.all(color: Colors.black),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),

            SizedBox(height: 30),
            if (guesses.length < maxGiris &&
                (guesses.isEmpty || guesses.last != word)) ...[
              TextField(
                controller: _controller,
                maxLength: wordLength,
                onChanged: (value) {
                  setState(() {
                    guess = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  labelText: "Tahmininiz",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed:
                    guess.length == word.length
                        ? () {
                          setState(() {
                            guesses.add(guess);
                            boxColors.add(checkGuess(guess, word));
                            guess = '';
                            _controller.clear();
                          });
                        }
                        : null,
                child: Text("Kontrol Et"),
              ),
            ],
            if (guesses.contains(word))
              Padding(
                padding: EdgeInsets.all(12),

                child: Text(
                  "Tebrikler Doğru Bildiniz 🎉",
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
              ),
            if (guesses.length == maxGiris && !guesses.contains(word))
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  "Hakkınız Bitti.\nDoğru kelime :$word",
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<Color> checkGuess(String guess, String answer) {
  final length = answer.length;
  List<Color> colors = List.filled(length, Colors.grey);
  List<bool> used = List.filled(length, false);

  for (int i = 0; i < length; i++) {
    if (guess[i] == answer[i]) {
      colors[i] = Colors.green;
      used[i] = true;
    }
  }

  for (int i = 0; i < length; i++) {
    if (colors[i] == Colors.green) continue;
    for (int j = 0; j < length; j++) {
      if (!used[j] && guess[i] == answer[j]) {
        colors[i] = Colors.yellow;
        used[j] = true;
        break;
      }
    }
  }
  return colors;
}

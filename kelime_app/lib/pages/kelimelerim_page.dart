import 'package:flutter/material.dart';
import 'package:kelime_app/models/word_model.dart';
import 'package:kelime_app/pages/services/word_services.dart';
import 'package:audioplayers/audioplayers.dart';

class Kelimelerim extends StatefulWidget {
  const Kelimelerim({super.key});

  @override
  State<Kelimelerim> createState() => _KelimelerimState();
}

class _KelimelerimState extends State<Kelimelerim> {
  List<Word> _words = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  void playAudio(String url) async {
    if (url.isNotEmpty) {
      try {
        await _audioPlayer.play(UrlSource(url));
      } catch (e) {
        print("Ses hatası: $e");
      }
    } else {
      print("Ses urlsi boş");
    }
  }

  @override
  void initState() {
    super.initState();
    loadWords();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> loadWords() async {
    final service = WordService();
    final words = await service.getCombinedWords();
    setState(() {
      _words = words;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kelimelerim")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _words.length,
          itemBuilder: (context, index) {
            final word = _words[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              word.ingWord,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color.fromARGB(255, 12, 12, 162),
                              ),
                            ),
                          ),
                          if (word.audioUrl != null &&
                              word.audioUrl!.isNotEmpty)
                            IconButton(
                              icon: Icon(
                                Icons.volume_up,
                                color: Color.fromARGB(215, 143, 2, 2),
                              ),
                              onPressed: () {
                                // Ses çalma fonksiyonu burada çağrılır
                                playAudio(word.audioUrl!);
                              },
                            ),
                        ],
                      ),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tür:${word.type}",
                            style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(height: 4),

                          Text(
                            "Türkçe:  ${word.turkWord}",
                            style: TextStyle(fontSize: 14),
                          ),
                          SizedBox(height: 4),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.arrow_forward_sharp, size: 20),
                              Expanded(
                                child: Text(
                                  "Örnek: ${word.samples}",
                                  softWrap: true,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AyarlarPage extends StatefulWidget {
  const AyarlarPage({super.key});

  @override
  State<AyarlarPage> createState() => _AyarlarPageState();
}

class _AyarlarPageState extends State<AyarlarPage> {
  double _kelimeCikmaSayisi = 10;

  final _database = FirebaseDatabase.instance.ref();

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchCurrentValue();
  }

  Future<void> _fetchCurrentValue() async {
    final user = _auth.currentUser;
    if (user != null) {
      final snapshot =
          await _database.child("users/${user.uid}/newWordCount").get();

      if (snapshot.exists) {
        double fetchedValue = double.tryParse(snapshot.value.toString()) ?? 10;

        fetchedValue = fetchedValue.clamp(10.0, 20.0);

        setState(() {
          _kelimeCikmaSayisi = fetchedValue;
        });
      }
    }
  }

  Future<void> _updateWordCount(double value) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _database.child("users/${user.uid}").update({
        "newWordCount": value.round(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        title: Text("Ayarlar"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        color: AppColors.body,
        padding: EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Yeni Kelime Çıkma Sayısı",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    activeColor: AppColors.focusedBorder,
                    value: _kelimeCikmaSayisi,
                    min: 10,
                    max: 20,
                    divisions: 5,
                    label: _kelimeCikmaSayisi.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _kelimeCikmaSayisi = value;
                      });
                      _updateWordCount(value);
                    },
                  ),
                ),

                Text(
                  _kelimeCikmaSayisi.round().toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

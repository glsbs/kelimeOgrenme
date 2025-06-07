import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:kelime_app/pages/services/auth_services.dart';
import 'package:kelime_app/pages/services/cloudinary_service.dart';
import 'package:kelime_app/pages/services/user_words_service.dart';

class KelimeEkle extends StatefulWidget {
  const KelimeEkle({super.key});

  @override
  State<KelimeEkle> createState() => _KelimeEkleState();
}

class _KelimeEkleState extends State<KelimeEkle> {
  final _formKey = GlobalKey<FormState>();
  final _ingilizceKontrol = TextEditingController();
  final _turkceKontrol = TextEditingController();
  final _storyKontrol = TextEditingController();
  String _selectedWordType = "Noun";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<String> _wordType = [
    'Noun',
    'Adjective',
    'Verb',
    'Adverb',
    'Pharasal Verb',
    'Idiom',
  ];

  @override
  void dispose() {
    _ingilizceKontrol.dispose();
    _turkceKontrol.dispose();
    _storyKontrol.dispose();

    super.dispose();
  }

  Future<void> _resimSec() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _kelimeKaydet() async {
    if (_formKey.currentState!.validate()) {
      final uid = authService.value.currentUser?.uid;

      if (uid == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Lütfen giriş yapın.")));
        return;
      }

      var ingilizceKelime = _ingilizceKontrol.text;
      var turkceKelime = _turkceKontrol.text;
      var aciklama = _storyKontrol.text;
      String imageUrl = '';

      if (_imageFile != null) {
        String? uploadedUrl = await CloudinaryService().uploadImage(
          _imageFile!,
        );
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }

      Map<String, dynamic> yeniKelime = {
        'ingWord': ingilizceKelime,
        'turkWord': turkceKelime,
        'samples': aciklama,
        'wordType': _selectedWordType,
        'imageUrl': imageUrl,
      };
      await UserWords().kelimeEkle(uid, yeniKelime);
      _formKey.currentState?.reset();
      _ingilizceKontrol.clear();
      _turkceKontrol.clear();
      _storyKontrol.clear();
      setState(() {
        _imageFile = null;
        _selectedWordType = 'Noun';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kelime başarıyla eklenmiştir")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.body,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Boş Bırakılamaz";
                  }
                  return null;
                },
                controller: _ingilizceKontrol,
                decoration: InputDecoration(
                  labelText: 'İngilizce Kelime',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Boş Bırakılamaz";
                  }
                  return null;
                },
                controller: _turkceKontrol,
                decoration: InputDecoration(
                  labelText: 'Türkçe Anlamı',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedWordType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Kelime Türü'),
                ),
                items:
                    _wordType.map((e) {
                      return DropdownMenuItem(value: e, child: Text(e));
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWordType = value!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _storyKontrol,
                decoration: InputDecoration(
                  labelText: 'Kelime açıklaması',

                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _resimSec,
                label: Text("Resim Ekle"),
                icon: Icon(Icons.image),
              ),
              SizedBox(height: 8),
              if (_imageFile != null)
                Image.file(_imageFile!, height: 150, fit: BoxFit.cover),
              SizedBox(height: 18),
              ElevatedButton(onPressed: _kelimeKaydet, child: Text("Kaydet")),
            ],
          ),
        ),
      ),
    );
  }
}

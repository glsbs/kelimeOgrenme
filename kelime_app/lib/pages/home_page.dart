import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kelime_app/constants/colors.dart';
import 'package:kelime_app/pages/kelime_ekle.dart';
import 'package:kelime_app/pages/services/auth_services.dart';
import 'package:kelime_app/pages/services/user_database_service.dart';
import 'package:kelime_app/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<_MenuItem> menuItems = [
    _MenuItem('assets/images/test.png', 'Quiz', AppRoutes.quiz),

    _MenuItem(
      'assets/images/istatistik.png',
      'İstatistik',
      AppRoutes.istatistik,
    ),
    _MenuItem('assets/images/wordle.png', 'Wordle', AppRoutes.wordle),

    _MenuItem(
      'assets/images/kelimeler.png',
      'Kelimelerim',
      AppRoutes.kelimelerim,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: Drawer(
        child: FutureBuilder<String?>(
          future: UserDatabaseService().getUserName(
            FirebaseAuth.instance.currentUser!.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              final userName = snapshot.data ?? "Kullanıcı";

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: AppColors.appBar),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        Text(
                          userName,
                          style: TextStyle(
                            color: AppColors.formTitle,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Ana Sayfa'),
                    onTap: () => Navigator.pushNamed(context, "/HomePage"),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Ayarlar'),
                    onTap: () => Navigator.pushNamed(context, "/Ayarlar"),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text("Çıkış Yap"),
                    onTap: () async {
                      await authService.value.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                        (route) => false,
                      );
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.formTitle),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.body,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: AppColors.focusedBorder,
        unselectedItemColor: AppColors.customInputcolor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Kelime Ekle',
          ),
        ],
      ),

      /// SAYFALAR
      body: IndexedStack(
        index: _selectedIndex,
        children: [homePageContent(), KelimeEkle()],
      ),
    );
  }

  /// Ana sayfa widget
  Widget homePageContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
          colors: [AppColors.backgroundPrimary, AppColors.backgroundSecondary],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 96.0),
            child: Center(
              child: Image.asset(
                'assets/images/hello.png',
                width: 65,
                height: 66,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.body,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                children:
                    menuItems.map((item) => _buildMenuCard(item)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Menü Kartları
  Widget _buildMenuCard(_MenuItem item) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, item.routes);
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 4,
        margin: const EdgeInsets.all(12),
        color: AppColors.body,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item.imagePath, height: 90, width: 90),
            const SizedBox(height: 10),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final String imagePath;
  final String title;
  final String routes;
  _MenuItem(this.imagePath, this.title, this.routes);
}

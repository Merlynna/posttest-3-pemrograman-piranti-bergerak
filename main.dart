// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';

// Variabel global sederhana untuk menyimpan status sign up
bool sudahSignUp = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restoran Jepang',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Arial"),
      home: const OnboardingScreen(),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  final List<String> _images = [
    "https://cdn.pixabay.com/photo/2022/02/11/05/54/food-7006591_1280.jpg",
    "https://cdn.pixabay.com/photo/2017/06/29/19/57/sushi-2455981_1280.jpg",
    "https://cdn.pixabay.com/photo/2022/02/11/07/03/bento-7006665_1280.jpg",
    "https://cdn.pixabay.com/photo/2016/05/21/14/09/food-1406883_1280.jpg",
    "https://cdn.pixabay.com/photo/2018/05/26/18/55/sushi-3432021_1280.jpg",
  ];

  @override
  void initState() {
    super.initState();
    // Carousel auto-scroll setiap 3 detik
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentIndex < _images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double borderRadiusValue = 35.0; // radius padding dan image sama
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // Padding
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Container(
              padding: const EdgeInsets.all(5), // dikurangi agar pas
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(borderRadiusValue),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadiusValue),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    SizedBox(
                      height: 376, // dikurangi 24px
                      width: double.infinity,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Image.network(
                            _images[index],
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                          );
                        },
                      ),
                    ),

                    // Indikator tetap di bawah gambar
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _images.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentIndex == index ? 20 : 12,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentIndex == index
                                  ? Colors.red.shade900
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 25), // tombol tepat di bawah padding
          // Tombol menuju Login
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 5,
            ),
            child: const Text(
              "Selamat Datang! Silakan Masuk!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),

            // Judul utama
            const Text(
              "Selamat datang di Japanese Restaurant and Co.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),

            // Subjudul
            const Text(
              "Silakan pencet button di bawah!",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),

            // Avatar (lingkaran besar di tengah)
            Expanded(
              child: Center(
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.red.shade500,
                              width: 4,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 100,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Tombol LOGIN
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (sudahSignUp) {
                      // jika sudah daftar, masuk ke Home dan tampilkan pesan selamat datang
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      ).then((_) {
                        // setelah masuk ke home, tampilkan alert dialog selamat datang
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: Colors.red[100],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            title: const Text(
                              "Selamat Datang!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: const Text(
                              "Anda berhasil masuk ke aplikasi Japanese Restaurant and Co.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    } else {
                      // jika belum daftar, tampilkan pesan "TIDAK PUNYA"
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.red[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          title: const Text(
                            "TIDAK PUNYA",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            "Anda belum memiliki akun. Silakan SIGN UP terlebih dahulu!",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "LOGIN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            // Tombol SIGN UP
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
                vertical: 8,
              ),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final result = await SignUpDialog.show(context);
                    if (result == true) {
                      sudahSignUp = true;

                      // tampilkan alert sukses daftar
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.red[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          title: const Text(
                            "Pendaftaran Berhasil!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: const Text(
                            "Akun Anda telah dibuat. Silakan tekan LOGIN untuk masuk.",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "OK",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  child: const Text(
                    "SIGN UP",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Page Sign Up
class SignUpDialog {
  static Future<bool?> show(BuildContext context) {
    final TextEditingController namaController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmController = TextEditingController();

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
        title: const Center(
          child: Text(
            "SIGN UP",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              _buildField("Nama", "Masukkan nama Anda", namaController),
              const SizedBox(height: 10),
              _buildField("Username", "Masukkan username", usernameController),
              const SizedBox(height: 10),
              _buildField(
                "Password",
                "Masukkan password",
                passwordController,
                obscure: true,
              ),
              const SizedBox(height: 10),
              _buildField(
                "Konfirmasi Password",
                "Ketik ulang password",
                confirmController,
                obscure: true,
              ),
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {
              if (passwordController.text == confirmController.text &&
                  namaController.text.isNotEmpty &&
                  usernameController.text.isNotEmpty) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Pastikan semua data benar dan password cocok!",
                    ),
                  ),
                );
              }
            },
            child: const Text("DAFTAR", style: TextStyle(color: Colors.white)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("BATAL", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  static Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(fontSize: 15, color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
        labelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

// Home
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(), // menampilkan Home
    const MenuPage(), // menampilkan Menu
    const PesananPage(), // menampilkan Pesanan
    const SouvenirPage(), // menampilkan Souvenir
    const ProfilePage(), // menampilkan Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Center(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.red,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: "Menu",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Reservasi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: "Souvenir",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final PageController carouselController = PageController(initialPage: 0);
  final PageController _menuController = PageController(initialPage: 0);
  int _currentCarouselPage = 0;
  int _currentMenuPage = 0;

  List<Map<String, dynamic>> purchaseHistory = []; // histori pembelian

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Carousel
            SizedBox(
              height: 180,
              width: 460,
              child: PageView.builder(
                controller: carouselController,
                itemCount: 10,
                onPageChanged: (index) =>
                    setState(() => _currentCarouselPage = index),
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 80, color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                10,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 6,
                  ),
                  width: _currentCarouselPage == index ? 14 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _currentCarouselPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Menu Langganan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 130,
              child: PageView.builder(
                controller: _menuController,
                itemCount: (20 / 5).ceil(),
                onPageChanged: (index) =>
                    setState(() => _currentMenuPage = index),
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * 5;
                  final end = (start + 5).clamp(0, 20);
                  final items = List.generate(end - start, (i) => start + i);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: items.map((index) {
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.image,
                              size: 35,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Menu ${index + 1}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (20 / 5).ceil(),
                (index) => Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 6,
                  ),
                  width: _currentMenuPage == index ? 14 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: _currentMenuPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Histori Pembelian",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Kotak besar untuk histori pembelian
            purchaseHistory.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        "Belum ada histori pembelian",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 250,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: purchaseHistory.length,
                      itemBuilder: (context, index) {
                        final item = purchaseHistory[index];
                        return Container(
                          width: 180,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image,
                                size: 80,
                                color: Colors.white,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item["nama"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Rp ${item["harga"]}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    purchaseHistory.removeAt(index);
                                  });
                                },
                                child: const Text("Hapus"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Map<String, dynamic>> makananItems = [
    {"nama": "Sushi", "asal": "Tokyo", "harga": 200000},
    {"nama": "Ramen", "asal": "Fukuoka", "harga": 150000},
    {"nama": "Tempura", "asal": "Tokyo", "harga": 180000},
    {"nama": "Takoyaki", "asal": "Osaka", "harga": 120000},
    {"nama": "Okonomiyaki", "asal": "Hiroshima", "harga": 140000},
    {"nama": "Udon", "asal": "Kagawa", "harga": 130000},
    {"nama": "Sashimi", "asal": "Hokkaido", "harga": 250000},
    {"nama": "Katsu Don", "asal": "Nagoya", "harga": 160000},
    {"nama": "Yakitori", "asal": "Tokyo", "harga": 110000},
    {"nama": "Onigiri", "asal": "Kyoto", "harga": 50000},
    {"nama": "Tonkatsu", "asal": "Nagoya", "harga": 170000},
    {"nama": "Karaage", "asal": "Fukuoka", "harga": 120000},
    {"nama": "Shabu Shabu", "asal": "Osaka", "harga": 220000},
    {"nama": "Miso Soup", "asal": "Hokkaido", "harga": 40000},
    {"nama": "Gyoza", "asal": "Osaka", "harga": 90000},
    {"nama": "Chawanmushi", "asal": "Kyoto", "harga": 80000},
    {"nama": "Nabe", "asal": "Nagoya", "harga": 150000},
    {"nama": "Soba", "asal": "Tokyo", "harga": 100000},
    {"nama": "Onsen Tamago", "asal": "Gunma", "harga": 60000},
    {"nama": "Takikomi Gohan", "asal": "Niigata", "harga": 90000},
  ];

  List<Map<String, dynamic>> minumanItems = [
    {"nama": "Matcha Latte", "asal": "Uji", "harga": 70000},
    {"nama": "Sake", "asal": "Niigata", "harga": 250000},
    {"nama": "Ramune", "asal": "Osaka", "harga": 40000},
    {"nama": "Mugicha", "asal": "Kyoto", "harga": 30000},
    {"nama": "Calpis", "asal": "Tokyo", "harga": 35000},
    {"nama": "Genmaicha", "asal": "Kyoto", "harga": 60000},
    {"nama": "Hojicha", "asal": "Kyoto", "harga": 60000},
    {"nama": "Amazake", "asal": "Osaka", "harga": 70000},
    {"nama": "Shochu", "asal": "Kagoshima", "harga": 200000},
    {"nama": "Umeshu", "asal": "Wakayama", "harga": 150000},
    {"nama": "Hot Green Tea", "asal": "Shizuoka", "harga": 50000},
    {"nama": "Iced Green Tea", "asal": "Shizuoka", "harga": 50000},
    {"nama": "Yuzu Juice", "asal": "Tokushima", "harga": 80000},
    {"nama": "Kombucha", "asal": "Tokyo", "harga": 90000},
    {"nama": "Soda Yoghurt", "asal": "Hokkaido", "harga": 70000},
    {"nama": "Black Tea", "asal": "Kyoto", "harga": 50000},
    {"nama": "Coffee Latte", "asal": "Tokyo", "harga": 60000},
    {"nama": "Espresso", "asal": "Tokyo", "harga": 50000},
    {"nama": "Milk Tea", "asal": "Osaka", "harga": 40000},
    {"nama": "Lemonade", "asal": "Hokkaido", "harga": 45000},
  ];

  String searchQuery = "";

  List<Map<String, dynamic>> filterItems(List<Map<String, dynamic>> items) {
    return items
        .where(
          (item) =>
              item["nama"].toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void sortByName(bool ascending) {
    setState(() {
      makananItems.sort(
        (a, b) => ascending
            ? a["nama"].compareTo(b["nama"])
            : b["nama"].compareTo(a["nama"]),
      );
      minumanItems.sort(
        (a, b) => ascending
            ? a["nama"].compareTo(b["nama"])
            : b["nama"].compareTo(a["nama"]),
      );
    });
  }

  void sortByAsal(bool ascending) {
    setState(() {
      makananItems.sort(
        (a, b) => ascending
            ? a["asal"].compareTo(b["asal"])
            : b["asal"].compareTo(a["asal"]),
      );
      minumanItems.sort(
        (a, b) => ascending
            ? a["asal"].compareTo(b["asal"])
            : b["asal"].compareTo(a["asal"]),
      );
    });
  }

  void sortByHarga(bool ascending) {
    setState(() {
      makananItems.sort(
        (a, b) => ascending ? a["harga"] - b["harga"] : b["harga"] - a["harga"],
      );
      minumanItems.sort(
        (a, b) => ascending ? a["harga"] - b["harga"] : b["harga"] - a["harga"],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.red[900],
        appBar: AppBar(
          backgroundColor: Colors.red,
          centerTitle: true, // teks berada di tengah
          title: const Text("Menu Restoran Jepang"),
          bottom: const TabBar(
            indicatorColor: Colors.black, // warna garis bawah tab yang dipilih
            labelColor: Colors.black, // warna teks tab yang dipilih
            unselectedLabelColor:
                Colors.black, // warna teks tab yang tidak dipilih
            tabs: [
              Tab(text: "Makanan"),
              Tab(text: "Minuman"),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari menu...",
                  hintStyle: const TextStyle(color: Colors.white60),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.red[700],
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Makanan
                  buildListView(filterItems(makananItems)),
                  // Minuman
                  buildListView(filterItems(minumanItems)),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.add, color: Color.fromARGB(207, 0, 0, 0)),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget buildListView(List<Map<String, dynamic>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: Colors.red[700],
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: const Icon(Icons.image, size: 40, color: Colors.white),
            title: Text(
              item["nama"],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "${item["asal"]} - Rp ${item["harga"]}",
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

// Pesanan / Reservasi
class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final TextEditingController makananController = TextEditingController();
  final TextEditingController minumanController = TextEditingController();
  final TextEditingController souvenirController = TextEditingController();

  // 20 item makanan
  Map<String, int> hargaMakanan = {
    "Sushi": 200000,
    "Ramen": 150000,
    "Tempura": 180000,
    "Takoyaki": 120000,
    "Okonomiyaki": 140000,
    "Udon": 130000,
    "Sashimi": 250000,
    "Katsu Don": 160000,
    "Yakitori": 110000,
    "Onigiri": 50000,
    "Tonkatsu": 170000,
    "Karaage": 120000,
    "Shabu Shabu": 220000,
    "Miso Soup": 40000,
    "Gyoza": 90000,
    "Chawanmushi": 80000,
    "Nabe": 150000,
    "Soba": 100000,
    "Onsen Tamago": 60000,
    "Takikomi Gohan": 90000,
  };

  // 20 item minuman
  Map<String, int> hargaMinuman = {
    "Matcha Latte": 70000,
    "Sake": 250000,
    "Ramune": 40000,
    "Mugicha": 30000,
    "Calpis": 35000,
    "Genmaicha": 60000,
    "Hojicha": 60000,
    "Amazake": 70000,
    "Shochu": 200000,
    "Umeshu": 150000,
    "Hot Green Tea": 50000,
    "Iced Green Tea": 50000,
    "Yuzu Juice": 80000,
    "Kombucha": 90000,
    "Soda Yoghurt": 70000,
    "Black Tea": 50000,
    "Coffee Latte": 60000,
    "Espresso": 50000,
    "Milk Tea": 40000,
    "Lemonade": 45000,
  };

  // 20 item souvenir
  Map<String, int> hargaSouvenir = {
    "Gantungan Kunci": 50000,
    "Mug Jepang": 70000,
    "Poster Anime": 60000,
    "Bantal Karakter": 120000,
    "Tas Kanvas": 80000,
    "Payung Jepang": 90000,
    "Sendok Sushi": 30000,
    "Kotak Bento": 150000,
    "Chopstick Set": 40000,
    "T-shirt Anime": 120000,
    "Pin Koleksi": 50000,
    "Kalender Jepang": 70000,
    "Notebook": 60000,
    "Sticker Set": 30000,
    "Mini Figure": 180000,
    "Lampu Hias": 200000,
    "Topi Jepang": 90000,
    "Mug Kopi": 70000,
    "Dompet Karakter": 80000,
    "Tas Mini": 100000,
  };

  int totalHarga = 0;

  void hitungTotalHarga() {
    int makanan = hargaMakanan[makananController.text] ?? 0;
    int minuman = hargaMinuman[minumanController.text] ?? 0;
    int souvenir = hargaSouvenir[souvenirController.text] ?? 0;
    setState(() {
      totalHarga = makanan + minuman + souvenir;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      appBar: AppBar(
        title: const Text("Pesanan"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildOrderField("Nama Makanan", makananController, hargaMakanan),
            const SizedBox(height: 16),
            buildOrderField("Nama Minuman", minumanController, hargaMinuman),
            const SizedBox(height: 16),
            buildOrderField("Nama Souvenir", souvenirController, hargaSouvenir),
            const SizedBox(height: 20),
            Text(
              "Total Harga: Rp $totalHarga",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  hitungTotalHarga();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Pesanan berhasil ditambahkan!"),
                    ),
                  );
                },
                child: const Text(
                  "Pesan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildOrderField(
    String label,
    TextEditingController controller,
    Map<String, int> harga,
  ) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        floatingLabelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.red[700],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        suffixText: controller.text.isNotEmpty
            ? "Rp ${harga[controller.text] ?? 0}"
            : null,
        suffixStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onChanged: (value) {
        setState(() {}); // update harga otomatis
      },
    );
  }
}

// Souvenir
class SouvenirPage extends StatefulWidget {
  const SouvenirPage({super.key});

  @override
  State<SouvenirPage> createState() => _SouvenirPageState();
}

class _SouvenirPageState extends State<SouvenirPage> {
  List<Map<String, dynamic>> souvenirs = [
    {"nama": "Gantungan Kunci", "asal": "Tokyo", "harga": 50000},
    {"nama": "Mug Jepang", "asal": "Kyoto", "harga": 80000},
    {"nama": "Poster Anime", "asal": "Osaka", "harga": 60000},
    {"nama": "Topi Samurai", "asal": "Nagoya", "harga": 120000},
    {"nama": "Buku Masak Jepang", "asal": "Hokkaido", "harga": 90000},
    {"nama": "Payung Kertas", "asal": "Kyoto", "harga": 70000},
    {"nama": "Tas Kanvas", "asal": "Tokyo", "harga": 110000},
    {"nama": "Kaos Kimono", "asal": "Osaka", "harga": 95000},
    {"nama": "Miniatur Kuil", "asal": "Nara", "harga": 150000},
    {"nama": "Sticker Pack", "asal": "Tokyo", "harga": 40000},
    {"nama": "Lampion Mini", "asal": "Kyoto", "harga": 85000},
    {"nama": "Tatami Coaster", "asal": "Hokkaido", "harga": 30000},
    {"nama": "Boneka Daruma", "asal": "Tokyo", "harga": 70000},
    {"nama": "Sapu Jepang", "asal": "Osaka", "harga": 45000},
    {"nama": "Set Teh", "asal": "Kyoto", "harga": 130000},
    {"nama": "Mini Kimono", "asal": "Nagoya", "harga": 100000},
    {"nama": "Kipas Lipat", "asal": "Tokyo", "harga": 60000},
    {"nama": "Kalender Jepang", "asal": "Hokkaido", "harga": 35000},
    {"nama": "Dompet Koin", "asal": "Osaka", "harga": 50000},
    {"nama": "Mini Samurai Sword", "asal": "Kyoto", "harga": 200000},
  ];

  String searchQuery = "";
  bool ascending = true;

  List<Map<String, dynamic>> get filteredSouvenirs {
    // filter by search query
    List<Map<String, dynamic>> filtered = souvenirs
        .where(
          (item) =>
              item["nama"].toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    // sort by nama
    filtered.sort(
      (a, b) => ascending
          ? a["nama"].compareTo(b["nama"])
          : b["nama"].compareTo(a["nama"]),
    );
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Souvenir",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      ascending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        ascending = !ascending;
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Cari souvenir...",
                  hintStyle: const TextStyle(color: Colors.white60),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.red[700],
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: filteredSouvenirs.length,
                itemBuilder: (context, index) {
                  final item = filteredSouvenirs[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.card_giftcard,
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item["nama"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${item["asal"]}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Rp ${item["harga"]}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${item["nama"]} ditambahkan ke keranjang!',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            "Beli",
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> userData = {
    // data tetap
    "Nama": "Taro Yamada",
    "Tanggal Lahir": "01 Januari 1995",
    "Email": "taro@example.com",
    "Nomor Telepon": "+62 8123456789",
    "Asal": "Tokyo, Jepang",
  };

  void showEditProfileDialog() {
    final TextEditingController namaController = TextEditingController(
      text: userData["Nama"],
    );
    final TextEditingController tanggalController = TextEditingController(
      text: userData["Tanggal Lahir"],
    );
    final TextEditingController emailController = TextEditingController(
      text: userData["Email"],
    );
    final TextEditingController numberController = TextEditingController(
      text: userData["Nomor Telepon"],
    );
    final TextEditingController fromController = TextEditingController(
      text: userData["Asal"],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.red[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          "Edit Profil",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField("Nama", "Masukkan Nama", namaController),
              const SizedBox(height: 10),
              buildTextField(
                "Tanggal Lahir",
                "Masukkan Tanggal Lahir",
                tanggalController,
              ),
              const SizedBox(height: 10),
              buildTextField("Email", "Masukkan Email", emailController),
              const SizedBox(height: 10),
              buildTextField(
                "Nomor Telepon",
                "Masukkan Nomor Telepon",
                numberController,
              ),
              const SizedBox(height: 10),
              buildTextField("Asal", "Masukkan Asal", fromController),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              setState(() {
                userData["Nama"] = namaController.text;
                userData["Tanggal Lahir"] = tanggalController.text;
                userData["Email"] = emailController.text;
                userData["Nomor Telepon"] = numberController.text;
                userData["Asal"] = fromController.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Ubah Data"),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return SizedBox(
      height: 60,
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label, // floating label
          labelStyle: const TextStyle(color: Colors.white70),
          floatingLabelStyle: const TextStyle(color: Colors.white),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.red.shade700,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.red,
              child: Icon(Icons.person_rounded, size: 80, color: Colors.black),
            ),
            const SizedBox(height: 10),
            const Text(
              "Profil Pengguna",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: userData.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.black,
                        width: 1,
                      ), // pinggiran hitam
                    ),
                    child: ListTile(
                      title: Text(
                        entry.key,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: showEditProfileDialog,
                  child: const Text(
                    "Edit Profil",
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

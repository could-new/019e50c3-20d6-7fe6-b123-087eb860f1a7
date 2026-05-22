import 'package:flutter/material.dart';

void main() {
  runApp(const NasKurdishApp());
}

class NasKurdishApp extends StatelessWidget {
  const NasKurdishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'فێربوونی کوردی',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF87CEEB), // Sky blue background from HTML
          primary: const Color(0xFF87CEEB),
          secondary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF87CEEB),
        fontFamily: 'NotoNaskhArabic', // Fallback for Arabic scripts, assumes system font if not present
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/flashcards': (context) => const FlashCardScreen(),
        '/matching': (context) => const MatchingScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'فێربوونی کوردی بۆ منداڵان 🎮',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildCard(
                    context: context,
                    title: '1. Flash Cards',
                    route: '/flashcards',
                  ),
                  _buildCard(
                    context: context,
                    title: '2. Matching',
                    route: '/matching',
                  ),
                  _buildCard(
                    context: context,
                    title: '3. دەنگی پیتەکان',
                    route: null,
                  ),
                  _buildCard(
                    context: context,
                    title: '4. نووسین',
                    route: null,
                  ),
                  _buildCard(
                    context: context,
                    title: '5. خوێندن',
                    route: null,
                  ),
                  _buildCard(
                    context: context,
                    title: '6. بینگۆ',
                    route: null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required String title,
    String? route,
  }) {
    return InkWell(
      onTap: route != null
          ? () {
              Navigator.pushNamed(context, route);
            }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('بەمنزیکانە بەردەست دەبێت!')),
              );
            },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({super.key});

  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen> {
  final List<String> letters = ['ا', 'ب', 'پ', 'ت', 'ج', 'چ', 'ح', 'خ'];
  int currentIndex = 0;

  void nextLetter() {
    setState(() {
      currentIndex = (currentIndex + 1) % letters.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flash Cards 🔤', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Text(
                letters[currentIndex],
                style: const TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: nextLetter,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class MatchingScreen extends StatefulWidget {
  const MatchingScreen({super.key});

  @override
  State<MatchingScreen> createState() => _MatchingScreenState();
}

class _MatchingScreenState extends State<MatchingScreen> {
  String? lastLetter;
  final List<String> options = ['ا', 'ب', 'ا', 'پ', 'ب', 'پ'];
  late List<String> shuffledOptions;
  List<bool> matched = List.filled(6, false);
  List<bool> selected = List.filled(6, false);
  int? lastIndex;

  @override
  void initState() {
    super.initState();
    shuffledOptions = List.from(options)..shuffle();
  }

  void _onTileTap(int index) {
    if (matched[index] || selected[index]) return;

    setState(() {
      selected[index] = true;
    });

    if (lastIndex == null) {
      lastIndex = index;
    } else {
      if (shuffledOptions[lastIndex!] == shuffledOptions[index]) {
        // Match found
        matched[lastIndex!] = true;
        matched[index] = true;
        lastIndex = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('باشە 🎉'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // No match
        final int prevIndex = lastIndex!;
        lastIndex = null;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('هەوڵ بدە دوبارە ❌'),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.red,
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              selected[prevIndex] = false;
              selected[index] = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matching 🎯', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'کرتە لە هەمان پیت بکە',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemCount: shuffledOptions.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onTileTap(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: matched[index]
                            ? Colors.green.shade200
                            : selected[index]
                                ? Colors.blue.shade100
                                : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          selected[index] || matched[index] ? shuffledOptions[index] : '?',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: matched[index] || selected[index]
                                ? Colors.black87
                                : Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

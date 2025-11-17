import 'package:flutter/material.dart';

class MusicPlayerPage extends StatelessWidget {
  final Map<String, String> track;

  const MusicPlayerPage({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF150303),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(track['title']!, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                track['cover']!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(track['title']!, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text(track['artist']!, style: const TextStyle(color: Colors.white70, fontSize: 18)),
            const SizedBox(height: 40),
            // Boutons Play/Pause simulés
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                  onPressed: () {},
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.play_circle_outline, color: Colors.white, size: 60),
                  onPressed: () {
                    // Ici tu pourrais intégrer un lecteur audio réel
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:ui';

class MusicPlayerPage extends StatefulWidget {
  final Map<String, String> track;
  const MusicPlayerPage({super.key, required this.track});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _isDownloaded = false;
  double _currentPosition = 0.4;
  int _loopMode = 0; // 0=repeat, 1=shuffle, 2=repeat_one

  final String _currentTime = '1:34';
  final String _totalTime = '3:45';

  @override
  Widget build(BuildContext context) {
    const Color cardColor = Color(0xFF2E2E33);
    const Color skipColor = Color(0xFFEEEEEE);

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        endDrawer: _buildEndDrawer(),
        body: Stack(
          children: [
            // Fond noir fixe derrière tout pour éviter l'écran blanc
            Positioned.fill(
              child: Container(color: Colors.black),
            ),
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF551515),
                    Color(0xFF230606),
                    Color(0xFF000000),
                    Colors.black
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Blur background
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(color: Color(0xFF531010).withOpacity(0.2)),
              ),
            ),
            // Page content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 30),
                    _buildAlbumArt(cardColor),
                    const SizedBox(height: 30),
                    _buildTrackInfo(),
                    const SizedBox(height: 40),
                    _buildProgressSlider(Colors.white),
                    const SizedBox(height: 30),
                    _buildPlaybackControls(skipColor),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            _buildLyricsDraggableSheet(cardColor),
          ],
        ),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          // Overflow menu (3 points)
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_outlined, color: Colors.white, size: 28),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- DRAWER ----------------
  Widget _buildEndDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF2E2E33).withOpacity(0.95),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF531010),
            ),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Paramètres', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('À propos', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ---------------- TRACK INFO ----------------
  Widget _buildTrackInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.track['title']!,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                widget.track['artist']!,
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.playlist_add, color: Colors.white, size: 30),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? const Color(0xFFFFE7C2) : Colors.white70,
            size: 30,
          ),
          onPressed: () => setState(() => _isFavorite = !_isFavorite),
        ),
      ],
    );
  }

  // ---------------- PLAYBACK CONTROLS ----------------
  Widget _buildPlaybackControls(Color skipColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            _isDownloaded ? Icons.download_done : Icons.file_download_outlined,
            color: _isDownloaded ? const Color(0xFF338FA5) : Colors.white,
            size: 36,
          ),
          onPressed: () => setState(() => _isDownloaded = !_isDownloaded),
        ),
        IconButton(
          icon: Icon(Icons.skip_previous_rounded, color: skipColor, size: 45),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause_circle_rounded : Icons.play_circle_fill_rounded, color: Colors.white, size: 70),
          onPressed: () => setState(() => _isPlaying = !_isPlaying),
        ),
        IconButton(
          icon: Icon(Icons.skip_next_rounded, color: skipColor, size: 45),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            _loopMode == 0
                ? Icons.repeat
                : _loopMode == 1
                ? Icons.shuffle
                : Icons.repeat_one,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => setState(() => _loopMode = (_loopMode + 1) % 3),
        ),
      ],
    );
  }

  // ---------------- ALBUM ART ----------------
  Widget _buildAlbumArt(Color cardColor) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cardColor.withOpacity(0.5),
        border: Border.all(color: Colors.white10),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 25, offset: const Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          widget.track['cover'] ?? '',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
              child: Text("Image non trouvée", style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }

  // ---------------- SLIDER ----------------
  Widget _buildProgressSlider(Color accentColor) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 2,
        thumbColor: accentColor,
        activeTrackColor: accentColor,
        inactiveTrackColor: Colors.white12,
        overlayColor: accentColor.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Slider(
            value: _currentPosition,
            min: 0,
            max: 1,
            onChanged: (value) => setState(() => _currentPosition = value),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_currentTime, style: const TextStyle(color: Colors.white54)),
              Text(_totalTime, style: const TextStyle(color: Colors.white54)),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- LYRICS DRAGGABLE SHEET ----------------
  Widget _buildLyricsDraggableSheet(Color cardColor) {
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.45),
                border: Border.all(color: Colors.white12),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Text(
                    'Paroles',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text('I\'m singing in the rain', style: TextStyle(color: Colors.white, fontSize: 20)),
                  const Text('Just singing in the rain', style: TextStyle(color: Colors.white, fontSize: 20)),
                  const SizedBox(height: 20),
                  const Text('What a glorious feeling', style: TextStyle(color: Colors.white70, fontSize: 18)),
                  const Text('I\'m happy again', style: TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 20),
                  const Text('The sun\'s in my heart', style: TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 300),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
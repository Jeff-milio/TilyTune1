import 'package:flutter/material.dart';
import '../data.dart';
import '../AlbumPage/albumpage.dart';

class Liste extends StatefulWidget {
  @override
  _ListeState createState() => _ListeState();
}

class _ListeState extends State<Liste> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFF150303),
      appBar: AppBar(
        toolbarHeight: 25,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A0F12),
                Color(0xFF501C1F),
                Color(0xF4000000)],
              begin: Alignment.bottomCenter,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        title: Text(
          "Listes",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            fontFamily: 'SpecialGothic'
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFFFCFA0),
          labelColor: Color(0xFFFFCFA0),
          unselectedLabelColor: Colors.grey[400],
          labelStyle: TextStyle(fontWeight: FontWeight.bold , fontSize: 15),
          tabs: [
            Tab(text: "Playlists"),
            Tab(text: "Albums"),
            Tab(text: "Artistes"),
            Tab(text: "Genres"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          PlaylistsTab(),
          AlbumsTab(),
          ArtistesTab(),
          GenresTab(),
        ],
      ),

    );
  }
}
class PlaylistsTab extends StatelessWidget {
  final double cardWidth = 160;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(12).copyWith(bottom: 100),
      children: playlistsData.entries.map((entry) {
        String category = entry.key;
        List<Map<String, dynamic>> playlists = entry.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Momotrust'
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: 220,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                separatorBuilder: (_, __) => SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final Map<String, dynamic> playlist = playlists[index];

                  // Conversion des tracks en List<Map<String, String>>
                  final List<Map<String, String>> tracks = (playlist['tracks'] as List)
                      .map((track) => Map<String, String>.from(track))
                      .toList();

                  final firstCover = tracks.isNotEmpty
                      ? tracks[0]['cover'] ?? 'assets/images/placeholder.jpg'
                      : 'assets/images/placeholder.jpg';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AlbumPage(
                                    title: playlist["title"] ?? 'Titre inconnu',
                                    artist: playlist["artist"] ?? 'Artiste inconnu',
                                    tracks: tracks,
                                    album: {},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: cardWidth,
                              height: cardWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(firstCover),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Dégradé bas
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 60,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(8.0)),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Color(0xA6000000),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Bouton download
                          Positioned(
                            bottom: 3,
                            right: 5,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Color(0xFF295A65),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.file_download_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  print('Téléchargement de ${playlist["title"]}');
                                },
                                padding: const EdgeInsets.all(1),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),



                          // Icône bibliothèque
                          Positioned(
                            bottom: -2,
                            left: -4,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.video_library_outlined,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AlbumPage(
                                        title: playlist["title"] ?? 'Titre inconnu',
                                        artist: playlist["artist"] ?? 'Artiste inconnu',
                                        tracks: tracks,
                                        album: {},
                                      ),
                                    ),
                                  );
                                },
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: cardWidth,
                        child: Text(
                          playlist["title"] ?? 'Titre inconnu',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 2),
                      SizedBox(
                        width: cardWidth,
                        child: Text(
                          playlist["artist"] ?? 'Artiste inconnu',
                          style: TextStyle(color: Colors.grey[400], fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}



// ---------------------- Albums ----------------------
class AlbumsTab extends StatelessWidget {
  final List<Map<String, String>> albums = List.generate(10, (index) {
    return {
      "title": "Album ${index + 1}",
      "cover": "https://picsum.photos/200?random=${index + 10}",
      "artist": "Artiste ${index + 1}"
    };
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: albums.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final album = albums[index];
          return GestureDetector(
            onTap: () {},
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: NetworkImage(album["cover"]!),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(15),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        album["title"]!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        album["artist"]!,
                        style:
                        TextStyle(color: Colors.grey[400], fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(Icons.download_rounded,
                              color: Colors.white, size: 18),
                          SizedBox(width: 6),
                          Icon(Icons.playlist_play_rounded,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ---------------------- Artistes ----------------------
class ArtistesTab extends StatelessWidget {
  final List<Map<String, String>> artistes = List.generate(10, (index) {
    return {
      "name": "Artiste ${index + 1}",
      "avatar": "https://picsum.photos/100?random=${index + 20}"
    };
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: artistes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          final artiste = artistes[index];
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(artiste["avatar"]!),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                left: 4,
                right: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        artiste["name"]!,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.download_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 4),
                        Icon(Icons.playlist_play_rounded,
                            color: Colors.white, size: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------- Genres ----------------------
class GenresTab extends StatelessWidget {
  final List<String> genres = [
    "Rap",
    "Afro",
    "Gasy",
    "Pop",
    "Lo-fi",
    "Gospel",
    "R&B",
    "Jazz"
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: genres.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1, // carré
        ),
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4)),
              ],
            ),
            child: Center(
              child: Text(
                genre,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
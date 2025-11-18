import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../data.dart';
import '../musiquePlayerPage/musiqueplayerPage.dart';

class Moi extends StatefulWidget {
  @override
  State<Moi> createState() => _MoiState();
}

class _MoiState extends State<Moi> {
  void moveTrackToTop(Map<String, String> track) {
    setState(() {
      recentTracks.remove(track); // Supprime de sa position actuelle
      recentTracks.insert(0, track); // Ajoute à la première position
    });
  }

  final List<Map<String, String>> recentlyPlayed = [
    {'title': 'Night Drive', 'artist': 'Artist X', 'duration': '3:45'},
    {'title': 'Rhythm of the Rain', 'artist': 'Singer Y', 'duration': '4:12'},
    {'title': 'Electric Dreams', 'artist': 'Band Z', 'duration': '2:59'},
    {'title': 'Acoustic Soul', 'artist': 'Solo Guy', 'duration': '5:01'},
  ];

  XFile? _image;

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? img = await picker.pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          // 1. Header avec Dégradé et Infos de Profil
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF5C1616), // Rouge Bordeaux
                      Colors.black,
                    ],
                  ),
                ),
                child: Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        // ---- PHOTO + STYLO ----
                        SizedBox(
                          width: 110,
                          height: 110,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // PHOTO
                              GestureDetector(
                                onTap: pickImage,
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundImage:
                                  _image != null
                                      ? FileImage(File(_image!.path))
                                      : null,
                                  child: _image == null
                                      ? const Icon(Icons.person, size: 45)
                                      : null,
                                ),
                              ),

                              // STYLO
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(7),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF212121),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ---- NOM + USERNAME ----
                        const SizedBox(width: 15),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Nigara Manoa',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '@ManoaNigara',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),

          // 2. Options de navigation (Téléchargements, Favoris) et le GRAND Bouton Playlist
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileOption(context, Icons.file_download_outlined,
                          'Téléchargements', () {}),
                      _buildProfileOption(
                          context, Icons.favorite_border, 'Mes Favoris', () {

                      }),
                      SizedBox(height: 30),
                      _buildGiantPlaylistButton(context),
                      SizedBox(height: 30),
                      _buildSectionHeader('Musiques Récemment Écoutées'),
                      // pas de bouton
                      _buildRecentTracksScrollable(recentTracks),
                      const SizedBox(height: 100),
                      // LE NOUVEAU GRAND BOUTON PLAYLIST

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGiantPlaylistButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Créer une nouvelle playlist');
      },
      child: SizedBox(
        height: 100, // Hauteur personnalisée pour le rendre grand
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add_circle, color: Color(0xFF2E8C95), size: 70),
            // Icône plus grande
            SizedBox(
              width: 15,
              height: 50,

            ),
            Text(
              'Créer Mon Playlist',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22, // Texte plus grand
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onVoirTout}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontFamily: 'Momotrust',
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTracksScrollable(List<Map<String, String>> list) {
    return Container(
      height: 300, // tu peux ajuster la hauteur selon ton écran
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        shrinkWrap: false,
        physics: BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final track = list[index];
          return GestureDetector(
            onTap: () {
              moveTrackToTop(track);
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: MusicPlayerPage(track: track),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.slideUp,
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      track['cover']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(track['title']!, style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                        Text(track['artist']!, style: TextStyle(
                            color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      color: Color(0xFF295A65),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                        Icons.file_download_outlined, color: Colors.white,
                        size: 22),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  // Widget pour les options de profil classiques
  Widget _buildProfileOption(BuildContext context, IconData icon, String title,
      VoidCallback onTap) {
    return Card(
      color: Colors.grey[900],
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

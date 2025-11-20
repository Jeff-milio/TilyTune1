import 'package:flutter/material.dart';

// ------------------------------------
// 1. La page d'accueil des paramètres
// ------------------------------------

class Parametre extends StatefulWidget {
  const Parametre({super.key});

  @override
  State<Parametre> createState() => _ParametreScreenState();
}

class _ParametreScreenState extends State<Parametre> {
  // Simule l'état de la langue (true = Malagasy, false = Français)
  bool isMalagasy = false;

  // Définition de la couleur de fond sombre pour le corps
  final Color darkBackground = const Color(0xFF120202);

  // Style de titre pour les sections
  final TextStyle sectionHeaderStyle = const TextStyle(
    color: Colors.grey,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  // --- Fonctions d'action ---

  // 1. Changer la langue
  void _changeLanguage(BuildContext context) {
    setState(() {
      isMalagasy = !isMalagasy;
    });

    String message = isMalagasy
        ? "Langue changée en Malagasy (Simulé)"
        : "Langue changée en Français (Simulé)";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor:Color(0xFF454545),
        duration: const Duration(seconds: 2),
      ),
    );

    // REMARQUE: Dans une vraie application, le code de l'API de localisation irait ici.
  }

  // 2. Inviter des amis (Simulé)
  void _inviteFriends(BuildContext context) {
    // REMARQUE: Dans une vraie application, vous utiliseriez un package comme 'share_plus' ou 'url_launcher'
    // pour ouvrir la feuille de partage du système ou envoyer un lien par SMS/e-mail.

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkBackground,
          title: const Text("Inviter des amis", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Ceci simule l'ouverture de la feuille de partage système pour envoyer le lien de l'application.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // 3. Déconnexion
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkBackground,
          title: const Text("Déconnexion", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Êtes-vous sûr de vouloir vous déconnecter ?",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // REMARQUE: Le code réel de déconnexion de Firebase/l'API irait ici.
                print("ACTION: Utilisateur déconnecté.");
              },
              child: const Text('Déconnexion', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  // 4. Supprimer le compte
  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: darkBackground,
          title: const Text("Supprimer le compte", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          content: const Text(
            "ATTENTION: Cette action est irréversible. Voulez-vous vraiment supprimer votre compte ? Toutes les données seront perdues.",
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Annuler', style: TextStyle(color: Colors.white70)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // REMARQUE: Le code réel de suppression du compte irait ici.
                print("ACTION: Compte utilisateur supprimé.");
              },
              child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0101),
        title: const Text(
          "Paramètre",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Couleur de la flèche de retour
      ),
      body: Container(
        color: darkBackground,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          children: <Widget>[
            // --- Section Général ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 10.0),
              child: Text("PRÉFÉRENCES", style: sectionHeaderStyle),
            ),
            _buildSettingsTile(
              icon: Icons.language,
              title: "Langue",
              trailing: Text(
                isMalagasy ? "Malagasy" : "Français",
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
              ),
              onTap: () => _changeLanguage(context),
            ),
            _buildSettingsTile(
              icon: Icons.share,
              title: "Inviter des amis",
              onTap: () => _inviteFriends(context),
            ),
            _buildSettingsTile(
              icon: Icons.info_outline,
              title: "À propos",
              onTap: () {
                // Naviguer vers la page À propos
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AproposPage()),
                );
              },
            ),

            // --- Section Compte ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 30.0),
              child: Text("COMPTE", style: sectionHeaderStyle),
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: "Déconnexion",
              color: Color(-9060), // Pour mettre en évidence l'action
              onTap: () => _logout(context),
            ),
            _buildSettingsTile(
              icon: Icons.delete_forever,
              title: "Supprimer le compte",
              color: Colors.redAccent, // Alerte, action dangereuse
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  // Widget helper pour les tuiles de paramètres
  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
    Color? color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
        ),
      ),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.white30, size: 16),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      // Ajoute un séparateur visuel entre les tuiles
      tileColor: darkBackground,
    );
  }
}

// ------------------------------------
// 2. La page "À propos" (AproposPage)
// ------------------------------------

class AproposPage extends StatelessWidget {
  const AproposPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkBackground = Color(0xFF120202);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0101),
        title: const Text(
          "À propos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: darkBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.asset('assets/images/logo2_tilytune.png', height: 30 ),
              ),
              SizedBox(height: 10),

              Center(
                child: Text(
                "Version Beta (Build 20241020)",
                style: TextStyle(fontSize: 14, color: Colors.white54 ),
              ),),
            Divider(height: 40, color: Colors.white12),
            Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Application de streaming musicale scout.....",
              style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
            ),
            SizedBox(height: 30),
            Text(
              "Mentions Légales",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "© 2025 MonEntreprise. Tous droits réservés.\n"
                  "Conditions d'utilisation et Politique de confidentialité "
                  "disponibles sur notre site web (Atoo eeeeeee)."
                  ""
                  "Mampiasa finaritra eeeeeeh",
              style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
            ),],
      ),
      )
    );
  }
}
import 'package:flutter/material.dart';
import '../CRUD/Crud_Users/signup_page.dart';

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation; // Nouvelle animation de translation
  late Animation<Color?> _colorAnimation;

  final Color _startColor = const Color(0xFF3A1415);
  final Color _endColor = const Color(0xFF852E33);
  final Color _logoColor = const Color(0xFFFFDFAE);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Durée totale de l'animation
    );

    // 1. Animation d'Opacité (apparaît progressivement)
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeIn))); // Commence tôt, se termine un peu avant

    // 2. Animation d'Échelle (zoom avec un léger rebond)
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0)
        .animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.elasticOut))); // Commence un peu plus tard pour un effet décalé

    // 3. Animation de Translation (vient du bas vers le centre)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5), // Commence à 0.5 de hauteur sous le centre
      end: Offset.zero,             // Termine au centre (Offset.zero)
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic))); // Courbe plus douce et rapide au début

    // 4. Animation de Couleur du Dégradé (transition douce)
    _colorAnimation = ColorTween(
      begin: _startColor,
      end: _endColor,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    _startAppLoading();
  }

  void _startAppLoading() async {
    await Future.delayed(const Duration(milliseconds: 3500));

    if (mounted) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignupPage())
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          Color gradientColor1 = _colorAnimation.value ?? _startColor;
          Color gradientColor2 = _logoColor;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [gradientColor1, gradientColor2],
                stops: const [0.0, 1.0],
              ),
            ),
            child: Center(
              // Empile les animations pour un effet combiné
              child: SlideTransition( // Animation de translation
                position: _slideAnimation,
                child: ScaleTransition( // Animation de zoom
                  scale: _scaleAnimation,
                  child: FadeTransition( // Animation d'opacité
                    opacity: _opacityAnimation,
                    child: Image.asset(
                      'assets/images/logo_TilyTune.png',
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
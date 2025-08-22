import 'package:flutter/material.dart';
import 'package:sage/app/utils/extensions/general_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';
import 'package:sage/services/views/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _startSplashSequence();
  }

  Future<void> _startSplashSequence() async {
    // Run authentication check and wait for it to complete
    await SplashServices().checkAuthentication(context);

    // Start fade-out after it finishes
    if (mounted) {
      setState(() {
        _opacity = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              child: SizedBox(
                width: context.mediaQueryWidth,
                child: Assets.images.splashBg.svg(fit: BoxFit.fill),
              ),
            ),
            Center(
              child: Assets.images.logo.greenLogo.svg(),
            ),
          ],
        ),
      ),
    );
  }
}

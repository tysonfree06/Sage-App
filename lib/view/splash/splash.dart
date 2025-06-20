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
  @override
  void initState() {
    super.initState();
    SplashServices().goToWelcome(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
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
    );
  }
}

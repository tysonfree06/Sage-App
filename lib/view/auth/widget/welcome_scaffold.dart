import 'package:flutter/material.dart';
import 'package:sage/generated/assets/assets.gen.dart';

class WelcomeScaffold extends StatefulWidget {
  const WelcomeScaffold({
    required this.body,
    super.key,
  });

  final Widget body;

  @override
  State<WelcomeScaffold> createState() => _WelcomeScaffoldState();
}

class _WelcomeScaffoldState extends State<WelcomeScaffold> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Delay fade-in by 2 seconds
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      // backgroundColor: const Color.fromRGBO(34, 51, 53, 1),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 500),
        curve: Curves.linear,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Assets.images.onboardingBg.path,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child:
                // AnimatedOpacity(
                //   opacity: _opacity,
                //   duration: const Duration(milliseconds: 800),
                //   curve: Curves.easeInOut,
                // child:
                widget.body,
            // ),
          ),
        ),
      ),
    );
  }
}

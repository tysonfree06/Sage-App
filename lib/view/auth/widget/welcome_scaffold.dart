import 'package:flutter/material.dart';
import 'package:sage/app/components/status_bar_style.dart';
import 'package:sage/generated/assets/assets.gen.dart';

class WelcomeScaffold extends StatefulWidget {
  const WelcomeScaffold({
    super.key,
    this.body,
    this.appBar,
    this.drawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.endDrawer,
    this.resizeToAvoidBottomInset,
    this.primary,
    this.extendBody,
    this.extendBodyBehindAppBar,
  });
  final Widget? body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Widget? bottomSheet;
  final Widget? persistentFooterButtons;
  final Widget? endDrawer;
  final bool? resizeToAvoidBottomInset;
  final bool? primary;
  final bool? extendBody;
  final bool? extendBodyBehindAppBar;

  @override
  State<WelcomeScaffold> createState() => _WelcomeScaffoldState();
}

class _WelcomeScaffoldState extends State<WelcomeScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Assets.images.onboardingBg.path,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: DarkStatusBar(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(child: widget.body ?? const SizedBox.shrink()),
          appBar: widget.appBar,
          drawer: widget.drawer,
          bottomNavigationBar: widget.bottomNavigationBar,
          floatingActionButton: widget.floatingActionButton,
          bottomSheet: widget.bottomSheet,
          persistentFooterButtons: widget.persistentFooterButtons != null
              ? [widget.persistentFooterButtons!]
              : null,
          endDrawer: widget.endDrawer,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          primary: widget.primary ?? true,
          extendBody: widget.extendBody ?? false,
          extendBodyBehindAppBar: widget.extendBodyBehindAppBar ?? false,
        ),
      ),
    );
  }
}

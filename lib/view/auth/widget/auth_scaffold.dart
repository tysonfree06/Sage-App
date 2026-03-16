import 'package:flutter/material.dart';
import 'package:sage/app/styles/app_dimensions.dart';
import 'package:sage/app/utils/extensions/context_extensions.dart';
import 'package:sage/generated/assets/assets.gen.dart';

class AuthScaffold extends StatefulWidget {
  const AuthScaffold({
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
    this.contentHeight,
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
  final double? contentHeight;

  @override
  State<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends State<AuthScaffold> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, context.colors.white],
        ),
        image: DecorationImage(
          image: AssetImage(
            Assets.images.authBgImage.path,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: widget.contentHeight,
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.small),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimensions.extraLarge),
                  topRight: Radius.circular(AppDimensions.extraLarge),
                ),
                color: context.colors.white,
              ),
              child: widget.body ?? const SizedBox.shrink(),
            ),
          ),
        ),
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
    );
  }
}

// lib/modules/splash/views/splash_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );
  @override
  void initState() {
    super.initState();
    Get.put(SplashController());
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.asset(
                'assets/images/applogo.jpeg',
                width: 290,
                height: 95,
                fit: BoxFit.contain,
              ),
          ),
        ),
      ),
    );
  }
}
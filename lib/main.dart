// #docregion ShakeCurve
import 'dart:math';

// #enddocregion ShakeCurve
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

void main() => runApp(LogoApp());

// #docregion diff
class AnimatedLogo extends AnimatedWidget {
  // Make the Tweens static because they don't change.
  static final _opacityTween = Tween<double>(begin: 0, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 125);
  static final _colorTween = ColorTween(begin: Color.fromRGBO(255, 0, 0, 1), end: Color.fromRGBO(0, 255, 0, 1));

  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return MaterialApp(
      title: 'Flutter Animation demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Animation demo'),
        ),
        body: SizedBox(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text('Simple Size Animation', style: TextStyle(fontWeight: FontWeight.w500))
            ),
            Center(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical:(125-_sizeTween.evaluate(animation))/2,),
                  height: _sizeTween.evaluate(animation),
                  width: _sizeTween.evaluate(animation),
                  child: FlutterLogo(),
                  ),
                ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text('Simple Fading Animation', style: TextStyle(fontWeight: FontWeight.w500))
            ),
            Center(
              child: Opacity(
                opacity: _opacityTween.evaluate(animation),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: 125,
                  width: 125,
                  child: FlutterLogo(),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text('Simple Color Animation', style: TextStyle(fontWeight: FontWeight.w500))
            ),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                height: 125,
                width: 125,
                color: _colorTween.evaluate(animation),
              ),
            ),
              ]
          ),
        ),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  _LogoAppState createState() {
    return _LogoAppState();
  }
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    // #docregion AnimationController, tweens
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    // #enddocregion AnimationController, tweens
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
// #enddocregion diff

// #docregion ShakeCurve
class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() => runApp(MaterialApp(home: LogoApp(), title: "Flutter Animation Demo"));

class LogoApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Duration _duration = Duration(seconds: 2);
  Color _begin =  Color.fromRGBO(255, 0, 0, 1);
  Color _end = Color.fromRGBO(0, 255, 0, 1);

  void _handleBeginChanged(Color newValue) {
    setState(() {
      _begin = newValue;
    });
  }

  void _handleEndChanged(Color newValue) {
    setState(() {
      _end = newValue;
    });
  }

  void _handleDurationChanged(Duration newValue) {
    setState(() {
      _duration = newValue;
      controller.duration = _duration;
    });
  }

  @override
  void initState() {
    super.initState();
    // #docregion AnimationController, tweens
    controller = AnimationController(duration: _duration, vsync: this);
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
  Widget build(BuildContext context) => AnimatedLogo(animation: animation, onBeginChanged: _handleBeginChanged, onEndChanged: _handleEndChanged, onDurationChanged: _handleDurationChanged, duration: _duration, begin: _begin, end: _end);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class AnimatedLogo extends AnimatedWidget {
  // Make the Tweens static because they don't change.
  final Duration duration;
  final  Color begin;
  final Color end;
  final ValueChanged<Color> onBeginChanged;
  final ValueChanged<Color> onEndChanged;
  final ValueChanged<Duration> onDurationChanged;

  AnimatedLogo({Key key, Animation<double> animation, this.onBeginChanged, this.onEndChanged, this.onDurationChanged, this.duration,  this.begin, this.end})
  :super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Tween _opacityTween = Tween<double>(begin: 0, end: 1);
    final Tween _sizeTween = Tween<double>(begin: 0, end: 125);
    final ColorTween _colorTween = ColorTween(begin: begin, end: end);
    final animation = listenable as Animation<double>;
    return
      Scaffold(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: begin,
                                onColorChanged: onBeginChanged,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('Begin Color'),
                    color: begin,
                    textColor: useWhiteForeground(begin)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  ),
                  RaisedButton(
                    elevation: 3.0,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.all(0.0),
                            contentPadding: const EdgeInsets.all(0.0),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: end,
                                onColorChanged: onEndChanged,
                                colorPickerWidth: 300.0,
                                pickerAreaHeightPercent: 0.7,
                                enableAlpha: true,
                                displayThumbColor: true,
                                showLabel: true,
                                paletteType: PaletteType.hsv,
                                pickerAreaBorderRadius: const BorderRadius.only(
                                  topLeft: const Radius.circular(2.0),
                                  topRight: const Radius.circular(2.0),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('End Color'),
                    color: end,
                    textColor: useWhiteForeground(end)
                        ? const Color(0xffffffff)
                        : const Color(0xff000000),
                  )
              ])
            ]),
        ),
      );
  }
}

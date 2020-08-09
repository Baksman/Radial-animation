import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: RadialMenu(),
      ),
    );
  }
}

class RadialMenu extends StatefulWidget {
  @override
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  Animation<double> rotation;
  Animation<double> translation;
  // Animation animation;
  @override
  void initState() {
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 1.5, end: 0).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn));
    translation = Tween<double>()
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInSine));
    rotation = Tween<double>(begin: 0, end: 360).animate(CurvedAnimation(
        parent: controller, curve: Interval(0, 0.7, curve: Curves.easeInBack)));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RadialAnimation(
      controller: controller,
      animation: animation,
      rotation: rotation,
    );
  }
}

class RadialAnimation extends StatelessWidget {
  final AnimationController controller;
  final Animation animation;
  final Animation translation;
  final Animation rotation;
  const RadialAnimation(
      {Key key,
      this.controller,
      this.translation,
      this.animation,
      this.rotation})
      : super(key: key);
  _open() {
    controller.forward();
  }

  _close() {
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (ctx, _) {
          return Transform.rotate(
            angle: radians(rotation.value),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildButton(0, color: Colors.red, icon: FontAwesomeIcons.ad),
                _buildButton(45,
                    color: Colors.black, icon: FontAwesomeIcons.ad),
                _buildButton(90,
                    color: Colors.purple, icon: FontAwesomeIcons.affiliatetheme),
                _buildButton(135,
                    color: Colors.orange, icon: FontAwesomeIcons.addressBook),
                _buildButton(180,
                    color: Colors.teal, icon: FontAwesomeIcons.xRay),
                _buildButton(225,
                    color: Colors.blue, icon: FontAwesomeIcons.footballBall),
                _buildButton(270,
                    color: Colors.indigo, icon: FontAwesomeIcons.cocktail),
                _buildButton(315,
                    color: Colors.amberAccent, icon: FontAwesomeIcons.democrat),
                Transform.scale(
                  scale: animation.value - 1,
                  child: FloatingActionButton(
                    onPressed: _close,
                    backgroundColor: Colors.red,
                    child: Icon(FontAwesomeIcons.timesCircle),
                  ),
                ),
                Transform.scale(
                  scale: animation.value,
                  child: FloatingActionButton(
                    onPressed: _open,
                    backgroundColor:Colors.blue,
                    child: Icon(FontAwesomeIcons.solidDotCircle),
                  ),
                ),
              ],
            ),
          );
        });
  }

  _buildButton(double angle, {Color color, IconData icon}) {
    final double rad = radians(angle);
    return Transform(
        child: FloatingActionButton(
            child: Icon(icon), backgroundColor: color, onPressed: _close),
        transform: Matrix4.identity()
          ..translate(
              translation.value * cos(rad), translation.value * sin(rad)));
  }
}

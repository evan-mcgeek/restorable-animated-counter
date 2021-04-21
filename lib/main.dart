import 'package:flutter/material.dart';
import 'animated_counter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',
      title: 'Animated Restorable Counter',
      theme: ThemeData.dark(),
      home: AnimatedRestorableCounter(restorationId: 'counter'),
    );
  }
}

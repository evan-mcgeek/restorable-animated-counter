import 'package:flutter/material.dart';

class AnimatedRestorableCounter extends StatefulWidget {
  AnimatedRestorableCounter({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  _AnimatedRestorableCounterState createState() =>
      _AnimatedRestorableCounterState();
}

class _AnimatedRestorableCounterState extends State<AnimatedRestorableCounter>
    with SingleTickerProviderStateMixin, RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;
  final RestorableInt _counter = RestorableInt(0);
  TextStyle _textStyle = TextStyle(color: Colors.white, fontSize: 100);
  Color? _color;
  final Color _green = Colors.greenAccent;
  final Color _red = Colors.redAccent;
  final Color _white = Colors.white;

  late AnimationController _animationController = AnimationController(
    duration: Duration(milliseconds: 1000),
    vsync: this,
  );

  late Animation _animation = IntTween(begin: 0, end: 100).animate(
    CurvedAnimation(
      parent: _animationController,
      curve: Curves.ease,
    ),
  );

  bool _buttonIsPressed = false;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, 'count');
  }

  void _incrementCounter() {
    setState(() {
      if (_counter.value >= 0) {
        _buttonIsPressed = false;
        _animationController.forward(from: 0);
        _color = _green;
        Future.delayed(Duration(milliseconds: 950), () {
          _counter.value++;
          _color = _white;
        });
      } else {
        _animationController
            .animateTo(0)
            .then((value) => _animationController.value = 100);

        Future.delayed(Duration(milliseconds: 100), () {
          _counter.value++;
          _color = _green;
        });
        Future.delayed(Duration(milliseconds: 950), () {
          _color = _white;
        });
      }
    });
  }

  void _incrementLongPress() {
    setState(() {
      _counter.value++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter.value <= 0) {
        _buttonIsPressed = true;
        _animationController.forward(from: 0);
        _color = _red;
        Future.delayed(Duration(milliseconds: 950), () {
          _counter.value--;
          _color = _white;
        });
      } else {
        _animationController
            .animateTo(0)
            .then((value) => _animationController.value = 100);

        Future.delayed(Duration(milliseconds: 100), () {
          _counter.value--;
          _color = _red;
        });
        Future.delayed(Duration(milliseconds: 950), () {
          _color = _white;
        });
      }
    });
  }

  void _decrementLongPress() {
    setState(() {
      _counter.value--;
    });
  }

  @override
  void dispose() {
    _counter.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Animated Counter'),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext? context, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _counter.value == 0 &&
                              _animation.status != AnimationStatus.completed &&
                              _buttonIsPressed
                          ? '-${_counter.value}'
                          : _counter.value.toString(),
                      style: _textStyle.copyWith(
                        color: _color,
                      ),
                    ),
                    Text(
                      _animation.value == 100 || _animation.value == 0
                          ? ''
                          : '.${_animation.value.toString().padLeft(2, '0')}',
                      style: _textStyle.copyWith(
                        color: _color,
                        fontSize: _animation.value.toInt() / 1,
                      ),
                    ),
                  ],
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  icon: Icon(Icons.arrow_downward_rounded, color: _red),
                  onPressed: _decrementCounter,
                  onLongPress: _decrementLongPress,
                  label: Text(
                    'Decrease Value'.toUpperCase(),
                    style: TextStyle(color: _red),
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: _red,
                    side: BorderSide(width: 2.0, color: _red),
                    minimumSize: Size(100, 50),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  icon: Icon(Icons.arrow_upward_rounded, color: _green),
                  onPressed: _incrementCounter,
                  onLongPress: _incrementLongPress,
                  label: Text(
                    'Increase Value'.toUpperCase(),
                    style: TextStyle(color: _green),
                  ),
                  style: ElevatedButton.styleFrom(
                    onPrimary: _green,
                    side: BorderSide(width: 2.0, color: _green),
                    minimumSize: Size(100, 50),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

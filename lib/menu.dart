// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:yomo/main.dart';

class SliderExample extends StatefulWidget {
  final YomoGame game;
  const SliderExample({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<SliderExample> createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentSliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        Slider(
          value: _currentSliderValue,
          max: 100,
          divisions: 10,
          label: _currentSliderValue.round().toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
              widget.game.characterSizeAdjustment = value.toDouble();
            });
          },
        ),
      ],
    );
  }
}

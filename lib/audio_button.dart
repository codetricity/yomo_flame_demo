import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AudioButton extends StatefulWidget {
  const AudioButton({super.key});

  @override
  State<AudioButton> createState() => _AudioButtonState();
}

class _AudioButtonState extends State<AudioButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 32,
      color: Colors.grey,
      icon: Icon(Icons.volume_up),
      onPressed: () {},
    );
  }
}

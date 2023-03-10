import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:yomo/audio_button.dart';

import 'menu.dart';

enum YomoState { stop, left, right, front, back }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscapeLeftOnly();
  YomoGame game = YomoGame();
  runApp(MaterialApp(
      home: Scaffold(
          body: Stack(
    children: [
      GameWidget(
        game: game,
      ),
      Row(
        children: [
          const AudioButton(),
          SliderExample(
            game: game,
          ),
        ],
      ),
    ],
  ))));
}

class YomoGame extends FlameGame with HasDraggables {
  late final JoystickComponent joystick;
  late final SpriteAnimationGroupComponent yomoCharacter;
  double characterDefaultSize = 300.0;
  double characterSizeAdjustment = 50.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(SpriteComponent(
        sprite: await loadSprite('background.jpg'), size: size));
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    joystick = JoystickComponent(
      knob: CircleComponent(radius: 30, paint: knobPaint),
      background: CircleComponent(radius: 100, paint: backgroundPaint),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    add(joystick);
    List<Sprite> frontSprites = [];
    List<Sprite> leftSprites = [];
    List<Sprite> rightSprites = [];
    List<Sprite> backSprites = [];

    for (int i = 0; i < 10; i++) {
      frontSprites.add(await Sprite.load('front/front_$i.png'));
    }
    final frontAnimation =
        SpriteAnimation.spriteList(frontSprites, stepTime: 0.1);

    for (int i = 0; i < 9; i++) {
      backSprites.add(await Sprite.load('back/back_$i.png'));
    }
    final backAnimation =
        SpriteAnimation.spriteList(backSprites, stepTime: 0.1);

    for (int i = 0; i < 9; i++) {
      rightSprites.add(await Sprite.load('right/right_$i.png'));
    }
    final rightAnimation =
        SpriteAnimation.spriteList(rightSprites, stepTime: 0.1);

    for (int i = 0; i < 9; i++) {
      leftSprites.add(await Sprite.load('left/left_$i.png'));
    }
    final leftAnimation =
        SpriteAnimation.spriteList(leftSprites, stepTime: 0.1);
    final stopAnimation = SpriteAnimation.spriteList(
        [await loadSprite('front/front_0.png')],
        stepTime: 0.1);

    yomoCharacter = SpriteAnimationGroupComponent(
        animations: {
          YomoState.back: backAnimation,
          YomoState.front: frontAnimation,
          YomoState.left: leftAnimation,
          YomoState.right: rightAnimation,
          YomoState.stop: stopAnimation
        },
        current: YomoState.stop,
        size: Vector2.all(characterDefaultSize),
        anchor: Anchor.center,
        position: size / 2);
    add(yomoCharacter);

    // audio
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('smile.mp3', volume: 0.2);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick.relativeDelta.y > 0.4) {
      yomoCharacter.y += joystick.relativeDelta.y;
      yomoCharacter.current = YomoState.front;
    } else if (joystick.relativeDelta.y < -0.4) {
      yomoCharacter.y += joystick.relativeDelta.y;
      yomoCharacter.current = YomoState.back;
    } else if (joystick.relativeDelta.x < -0.4) {
      yomoCharacter.x += joystick.relativeDelta.x;
      yomoCharacter.current = YomoState.left;
      // print('left');
    } else if (joystick.relativeDelta.x > 0.4) {
      yomoCharacter.x += joystick.relativeDelta.x;
      yomoCharacter.current = YomoState.right;
      // print('right');
    } else {
      yomoCharacter.current = YomoState.stop;
    }
    // print((characterSizeAdjustment - 50) * 5);
    yomoCharacter.size = Vector2.all(
        characterDefaultSize + ((characterSizeAdjustment - 50) * 5));
  }
}

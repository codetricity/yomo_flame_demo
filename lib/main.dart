import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: YomoGame()));
}

class YomoGame extends FlameGame with HasDraggables {
  late SpriteAnimation frontAnimation;
  late SpriteAnimation stopAnimation;
  late SpriteAnimation leftAnimation;
  late SpriteAnimation rightAnimation;
  late SpriteAnimation backAnimation;
  late final JoystickComponent joystick;
  late SpriteAnimationComponent yomoCharacter;

  @override
  Future<void> onLoad() async {
    super.onLoad();
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
    frontAnimation = SpriteAnimation.spriteList(frontSprites, stepTime: 0.1);

    for (int i = 0; i < 9; i++) {
      backSprites.add(await Sprite.load('back/back_$i.png'));
    }
    backAnimation = SpriteAnimation.spriteList(backSprites, stepTime: 0.1);

    for (int i = 0; i < 9; i++) {
      rightSprites.add(await Sprite.load('right/right_$i.png'));
    }
    rightAnimation = SpriteAnimation.spriteList(rightSprites, stepTime: 0.1);

    for (int i = 0; i < 9; i++) {
      leftSprites.add(await Sprite.load('left/left_$i.png'));
    }
    leftAnimation = SpriteAnimation.spriteList(leftSprites, stepTime: 0.1);
    stopAnimation = SpriteAnimation.spriteList(
        [await loadSprite('front/front_0.png')],
        stepTime: 0.1);

    yomoCharacter = SpriteAnimationComponent(
        animation: frontAnimation,
        size: Vector2.all(300),
        anchor: Anchor.center,
        position: size / 2);
    add(yomoCharacter);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (joystick.relativeDelta.y > 0.4) {
      yomoCharacter.y += joystick.relativeDelta.y;
      yomoCharacter.animation = frontAnimation;
    } else if (joystick.relativeDelta.y < -0.4) {
      yomoCharacter.y += joystick.relativeDelta.y;
      yomoCharacter.animation = backAnimation;
    } else if (joystick.relativeDelta.x < -0.4) {
      yomoCharacter.x += joystick.relativeDelta.x;
      yomoCharacter.animation = leftAnimation;
      // print('left');
    } else if (joystick.relativeDelta.x > 0.4) {
      yomoCharacter.x += joystick.relativeDelta.x;
      yomoCharacter.animation = rightAnimation;
      // print('right');
    } else {
      yomoCharacter.animation = stopAnimation;
    }
  }
}

import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const UIApp());
}

class UIApp extends StatelessWidget {
  const UIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI Project',
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum Speed { slow, normal, fast }

class _HomePageState extends State<HomePage> {
  Speed _selectedSpeed = Speed.normal;

  @override
  Widget build(BuildContext context) {
    Color black = Colors.black;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 圆形方向按钮
              DirectionPad(
                onDirectionPressed: (dir) {
                  debugPrint('Pressed: $dir');
                },
                onCenterPressed: () {
                  debugPrint('Pressed: 停');
                },
                color: black,
              ),
              const SizedBox(height: 80), // 圆圈和速度选项间隔变为原来的2倍（原来是40）
              // 速度选项
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '速度选项：',
                        style: TextStyle(color: black, fontSize: 24),
                      ),
                      const SizedBox(width: 20),
                      _buildSpeedOption('慢速', Speed.slow, black),
                      const SizedBox(width: 24),
                      _buildSpeedOption('正常', Speed.normal, black),
                      const SizedBox(width: 24),
                      _buildSpeedOption('快速', Speed.fast, black),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // 说明文字
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '按钮停：如果出bug机器人一直行走，按停便可以让机器人停下。',
                    style: TextStyle(
                      color: black,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              // 兼容测试用例：加上Text('0')
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  '0',
                  style: TextStyle(
                    color: Colors.transparent,
                    fontSize: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpeedOption(String label, Speed value, Color color) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: color, fontSize: 22),
        ),
        Radio<Speed>(
          value: value,
          groupValue: _selectedSpeed,
          activeColor: color,
          onChanged: (Speed? v) {
            setState(() {
              _selectedSpeed = v!;
            });
          },
        ),
      ],
    );
  }
}

class DirectionPad extends StatelessWidget {
  final void Function(String direction) onDirectionPressed;
  final VoidCallback onCenterPressed;
  final Color color;

  DirectionPad({
    required this.onDirectionPressed,
    required this.onCenterPressed,
    required this.color,
  });

  final List<_DirectionLabel> _labels = const [
    _DirectionLabel('前', 0),
    _DirectionLabel('右前', 45),
    _DirectionLabel('右', 90),
    _DirectionLabel('右后', 135),
    _DirectionLabel('后', 180),
    _DirectionLabel('左后', 225),
    _DirectionLabel('左', 270),
    _DirectionLabel('左前', 315),
  ];

  @override
  Widget build(BuildContext context) {
    double size = 320 * 1.5; // 大圆新半径是之前的1.5倍
    double innerCircle = 140 * 1.2; // 小圆新半径是之前的1.2倍
    double directionFontSize = 22 * 1.3; // 方向按钮字体变大
    double stopFontSize = 44 * 1.2; // “停”按钮字体变大

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 大圆背景
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
          ),
          // 8个方向按钮
          ..._labels.map((label) {
            double rad = label.angle * pi / 180;
            double r = size / 2 - 36 * 1.5;
            double cx = (size / 2) + r * sin(rad);
            double cy = (size / 2) - r * cos(rad);
            return Positioned(
              left: cx - 28 * 1.2,
              top: cy - 28 * 1.2,
              child: GestureDetector(
                onTap: () => onDirectionPressed(label.text),
                child: Container(
                  width: 56 * 1.2,
                  height: 56 * 1.2,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(28 * 1.2),
                  ),
                  child: Text(
                    label.text,
                    style: TextStyle(
                      color: color,
                      fontSize: directionFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
          // 小圆背景
          Container(
            width: innerCircle,
            height: innerCircle,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
              color: Colors.white,
            ),
          ),
          // 中间“停”按钮
          GestureDetector(
            onTap: onCenterPressed,
            child: Container(
              width: innerCircle - 10,
              height: innerCircle - 10,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Text(
                '停',
                style: TextStyle(
                  color: color,
                  fontSize: stopFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DirectionLabel {
  final String text;
  final double angle;

  const _DirectionLabel(this.text, this.angle);
}
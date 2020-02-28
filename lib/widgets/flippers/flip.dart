/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2020 Sjoerd van den Berg
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

import 'package:vector_math/vector_math_64.dart' as Math;
import 'package:flutter/widgets.dart';

import '../../utils/perspective.dart';
import '../../utils/animator.dart';

class Flip extends StatefulWidget {
  final Widget child;
  final Duration offset;
  final Duration duration;
  final AnimationStatusListener animationStatusListener;

  Flip({
    @required this.child,
    this.offset = Duration.zero,
    this.duration = const Duration(seconds: 1),
    this.animationStatusListener,
  }) {
    assert(child != null, 'Error: child in $this cannot be null');
    assert(offset != null, 'Error: offset in $this cannot be null');
    assert(duration != null, 'Error: duration in $this cannot be null');
  }

  @override
  _FlipState createState() => _FlipState();
}

class _FlipState extends State<Flip> with SingleAnimatorStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation.controller,
      child: widget.child,
      builder: (BuildContext context, Widget child) => Transform(
        transform: Perspective.matrix(4.0) *
            Matrix4.translationValues(
                0.0, 0.0, animation.get("translateZ").value) *
            Matrix4.rotationY(-animation.get("rotateY").value) *
            Matrix4.identity().scaled(animation.get("scale").value),
        child: widget.child,
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Animator createAnimation() {
    final cIn = Curves.easeIn;
    final cOut = Curves.easeOut;

    return Animator.sync(this)
        .at(offset: widget.offset, duration: widget.duration)
        .add(
          key: "scale",
          tweens: TweenList<double>(
            [
              TweenPercentage(percent: 0, value: 1.0, curve: cOut),
              TweenPercentage(percent: 40, value: 1.0, curve: cOut),
              TweenPercentage(percent: 50, value: 1.0, curve: cIn),
              TweenPercentage(percent: 80, value: 0.95, curve: cIn),
              TweenPercentage(percent: 100, value: 1.0, curve: cIn),
            ],
          ),
        )
        .add(
          key: "translateZ",
          tweens: TweenList<double>(
            [
              TweenPercentage(percent: 0, value: 0.0, curve: cOut),
              TweenPercentage(percent: 40, value: -150.0, curve: cOut),
              TweenPercentage(percent: 50, value: -150.0, curve: cIn),
              TweenPercentage(percent: 80, value: 0.0, curve: cIn),
            ],
          ),
        )
        .add(
          key: "rotateY",
          tweens: TweenList<double>(
            [
              TweenPercentage(
                  percent: 0, value: Math.radians(-360.0), curve: cOut),
              TweenPercentage(
                  percent: 40, value: Math.radians(-190.0), curve: cOut),
              TweenPercentage(
                  percent: 50, value: Math.radians(-170.0), curve: cIn),
              TweenPercentage(percent: 80, value: 0.0, curve: cIn),
            ],
          ),
        )
        .addStatusListener(widget.animationStatusListener)
        .generate();
  }
}
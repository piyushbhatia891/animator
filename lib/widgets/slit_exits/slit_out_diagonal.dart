import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart';

import '../../flutter_animator.dart';

///Used by [SlitOutDiagonal] widget.
///Note: You can also pass this into an [InOutAnimation] widget to define the
///in/out animation.
class SlitOutDiagonalAnimation extends AnimationDefinition {
  SlitOutDiagonalAnimation({
    AnimationPreferences preferences =
        const AnimationPreferences(duration: Duration(milliseconds: 750)),
  }) : super(preferences: preferences);

  @override
  Widget build(BuildContext context, Animator animator, Widget child) {
    return FadeTransition(
      opacity: animator.get('opacity'),
      child: AnimatedBuilder(
        animation: animator.controller,
        child: child,
        builder: (BuildContext context, Widget child) => Transform(
          child: child,
          transform: Perspective.matrix(1.5) *
              Matrix4.translationValues(
                  0.0, 0.0, animator.get("translateZ").value) *
              Matrix4.identity()
            ..rotate(
              Vector3(1.0, 1.0, 0.0),
              animator.get('rotation').value,
            ),
          alignment: Alignment.center,
        ),
      ),
    );
  }

  @override
  Map<String, TweenList> getDefinition({Size screenSize, Size widgetSize}) {
    return {
      'opacity': TweenList<double>(
        [
          TweenPercentage(percent: 54, value: 1.0),
          TweenPercentage(percent: 100, value: 0.0),
        ],
      ),
      'translateZ': TweenList<double>(
        [
          TweenPercentage(percent: 0, value: 0.0),
          TweenPercentage(percent: 54, value: 160.0),
          TweenPercentage(percent: 100, value: 800.0),
        ],
      ),
      'rotation': TweenList<double>(
        [
          TweenPercentage(percent: 0, value: 0.0 * toRad),
          TweenPercentage(percent: 54, value: 87.0 * toRad),
          TweenPercentage(percent: 100, value: 90.0 * toRad),
        ],
      ),
    };
  }
}

/// Example of using SlitOutDiagonal:
///
/// ```dart
/// class ExampleWidget extends StatelessWidget {
///
///   @override
///   Widget build(BuildContext context) {
///     return SlitOutDiagonal(child: Text('Bounce'));
///   }
///
/// }
/// ```
class SlitOutDiagonal extends AnimatorWidget {
  SlitOutDiagonal({
    Key key,
    @required Widget child,
    AnimationPreferences preferences =
        const AnimationPreferences(duration: Duration(milliseconds: 750)),
  }) : super(
            key: key,
            child: child,
            definition: SlitOutDiagonalAnimation(preferences: preferences));
}

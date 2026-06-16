import 'package:flutter/cupertino.dart';

Route smoothTransition(Widget page) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 600),
    reverseTransitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (_, animation, secondaryAnimation) => page,
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      // PUSH: right -> left
      final inAnimation = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

      // POP: left -> right
      final outAnimation =
          Tween<Offset>(
            begin: Offset.zero,
            end: const Offset(0.0, 1.0),
          ).animate(
            CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
          );

      return SlideTransition(
        position: animation.status == AnimationStatus.reverse
            ? outAnimation
            : inAnimation,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}

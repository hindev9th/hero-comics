import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class Constants {
  static void showToastError(
      String title, String message, BuildContext context) {
    toastification.show(
      context: context,
      icon: const Icon(Icons.error),
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(100.0),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  static void showToastSuccess(
      String title, String message, BuildContext context) {
    toastification.show(
      context: context,
      icon: const Icon(Icons.check),
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(100.0),
      showProgressBar: true,
      dragToClose: true,
    );
  }

  static void showToastInfo(
      String title, String message, BuildContext context) {
    toastification.show(
      context: context,
      icon: const Icon(Icons.info),
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: const Duration(seconds: 4),
      animationBuilder: (
        context,
        animation,
        alignment,
        child,
      ) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      borderRadius: BorderRadius.circular(100.0),
      showProgressBar: true,
      dragToClose: true,
    );
  }
}

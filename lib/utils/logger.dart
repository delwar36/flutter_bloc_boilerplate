import 'dart:developer' as developer;

import 'package:bloc_boilerplate/configs/config.dart';

class UtilLogger {
  static log([String tag = "LOGGER", dynamic msg]) {
    if (Application.debug) {
      developer.log('$msg', name: tag);
    }
  }

  static Future<void> logError(
    String tag,
    dynamic msg, {
    StackTrace? stackTrace,
  }) async {
    // Always log to console in debug
    if (Application.debug) {
      developer.log('$msg', name: tag, error: msg, stackTrace: stackTrace);
    }

    // In production, send to server via callback to avoid circular dependency
    if (!Application.debug && onRemoteLog != null) {
      try {
        await onRemoteLog!(
          tag,
          msg.toString(),
          stackTrace?.toString(),
          Application.device?.toJson(),
        );
      } catch (e) {
        // Fail silently or locally
      }
    }
  }

  static Future<void> Function(
    String tag,
    String message,
    String? stackTrace,
    Map<String, dynamic>? device,
  )?
  onRemoteLog;

  ///Singleton factory
  static final _instance = UtilLogger._internal();

  factory UtilLogger() {
    return _instance;
  }

  UtilLogger._internal();
}

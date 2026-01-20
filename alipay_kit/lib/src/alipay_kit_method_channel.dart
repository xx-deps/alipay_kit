import 'dart:async';
import 'dart:io';

import 'package:alipay_kit/src/model/auth_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'alipay_kit_platform_interface.dart';
import 'constant.dart';
import 'model/resp.dart';

/// An implementation of [AlipayKitPlatform] that uses method channels.
class MethodChannelAlipayKit extends AlipayKitPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final MethodChannel methodChannel = const MethodChannel(
    'v7lin.github.io/alipay_kit',
  )..setMethodCallHandler(_handleMethod);

  final StreamController<AlipayResp> _payRespStreamController =
      StreamController<AlipayResp>.broadcast();

  final StreamController<AlipayAuthResult> _authRespStreamController =
      StreamController<AlipayAuthResult>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onPayResp':
        _payRespStreamController.add(
          AlipayResp.fromJson(
            (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>(),
          ),
        );
      case 'onAuthResp':
        if (Platform.isAndroid) {
          _authRespStreamController.add(
            AlipayAuthResultAndroid.fromMap(
              (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>(),
            ),
          );
        } else {
          _authRespStreamController.add(
            AlipayAuthResultIos.fromMap(
              (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>(),
            ),
          );
        }
    }
  }

  @override
  Stream<AlipayResp> payResp() {
    return _payRespStreamController.stream;
  }

  @override
  Stream<AlipayAuthResult> authResp() {
    return _authRespStreamController.stream;
  }

  @override
  Future<bool> isInstalled() async {
    return await methodChannel.invokeMethod<bool?>('isInstalled') ?? false;
  }

  @override
  Future<void> setEnv({required AlipayEnv env}) {
    assert(Platform.isAndroid);
    return methodChannel.invokeMethod<void>('setEnv', <String, dynamic>{
      'env': env.index,
    });
  }

  @override
  Future<void> pay({
    required String orderInfo,
    bool dynamicLaunch = false,
    bool isShowLoading = true,
  }) {
    return methodChannel.invokeMethod<void>('pay', <String, dynamic>{
      'orderInfo': orderInfo,
      'dynamicLaunch': dynamicLaunch,
      'isShowLoading': isShowLoading,
    });
  }

  @override
  Future<void> auth({required String authInfo, bool isShowLoading = true}) {
    return methodChannel.invokeMethod<void>('auth', <String, dynamic>{
      'authInfo': authInfo,
      'isShowLoading': isShowLoading,
    });
  }
}

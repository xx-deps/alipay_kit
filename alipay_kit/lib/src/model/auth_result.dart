class AlipayAuthResult {
  const AlipayAuthResult({required this.data});

  factory AlipayAuthResult.fromJson(Map<String, dynamic> data) {
    return AlipayAuthResult(data: data);
  }
  final Map<String, Object?> data;
}

class AlipayAuthResultAndroid extends AlipayAuthResult {
  const AlipayAuthResultAndroid({required super.data});

  factory AlipayAuthResultAndroid.fromMap(Map<String, Object?> data) {
    return AlipayAuthResultAndroid(data: data);
  }

  /// 支付状态，参考支付宝的文档https://docs.open.alipay.com/204/105695/
  /// 返回码，标识支付状态，含义如下：
  /// 9000——订单支付成功         下面的result有值
  /// 8000——正在处理中
  /// 4000——订单支付失败
  /// 5000——重复请求
  /// 6001——用户中途取消
  /// 6002——网络连接出错
  int? get resultStatus => int.tryParse(data.parseString('resultStatus'));

  /// 结果
  String? get result => data.parseString('result');

  String? get memo => data.parseString('memo');

  Map<String, String> resultMap() {
    if (isSuccessful) {
      if (result?.isNotEmpty ?? false) {
        final Map<String, String> params = Uri.parse(
          'alipay://alipay?$result',
        ).queryParameters;
        return params;
      }
    }
    return <String, String>{};
  }

  bool get isSuccessful => resultStatus == 9000;

  bool get isCancelled => resultStatus == 6001;

  bool get success =>
      resultMap().parseString('success').toLowerCase() == true.toString();

  /// 200 业务处理成功，会返回authCode
  /// 1005 账户已冻结，如有疑问，请联系支付宝技术支持
  /// 202 系统异常，请稍后再试或联系支付宝技术支持
  int? get resultCode => int.tryParse(resultMap().parseString('result_code'));

  String get authCode => resultMap().parseString('auth_code');
  String get userId => resultMap().parseString('user_id');
  @override
  String toString() {
    return 'AlipayAuthResultAndroid(resultStatus: $resultStatus, result: $result, memo: $memo, isSuccessful: $isSuccessful, isCancelled: $isCancelled, success: $success, resultCode: $resultCode, authCode: $authCode, userId: $userId)';
  }
}

class AlipayAuthResultIos extends AlipayAuthResult {
  const AlipayAuthResultIos({required super.data});

  factory AlipayAuthResultIos.fromMap(Map<String, Object?> data) {
    return AlipayAuthResultIos(data: data);
  }

  String get authCode => data.parseString('auth_code');
  String get scope => data.parseString('scope');
  String get state => data.parseString('state');
  String get resultCode => data.parseString('result_code');
  String get appId => data.parseString('app_id');
  @override
  String toString() {
    return 'AlipayAuthResultIos(authCode: $authCode, scope: $scope, state: $state, resultCode: $resultCode, appId: $appId)';
  }
}

extension on Map<String, Object?> {
  String parseString(String key) {
    final Object? result = this[key];
    if (result == null) {
      return '';
    }
    if (result is String) {
      return result;
    }
    return result.toString();
  }
}

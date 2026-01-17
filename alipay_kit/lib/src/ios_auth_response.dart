

class AlipayIosAuthResponse {

  const AlipayIosAuthResponse({
    required this.authCode,
    required this.resultCode,
    required this.appId,
    required this.scope,
    required this.state,
  });
  final String authCode;
  final String scope;
  final String state;
  final String resultCode;
  final String appId;
}

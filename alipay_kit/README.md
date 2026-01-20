# alipay_kit

[![Pub Package](https://img.shields.io/pub/v/alipay_kit.svg)](https://pub.dev/packages/alipay_kit)
[![License](https://img.shields.io/github/license/RxReader/alipay_kit)](https://github.com/RxReader/alipay_kit/blob/master/LICENSE)

Flutter 版支付宝SDK

## 相关工具

- [Flutter版微信SDK](https://github.com/RxReader/wechat_kit)
- [Flutter版腾讯(QQ)SDK](https://github.com/RxReader/tencent_kit)
- [Flutter版新浪微博SDK](https://github.com/RxReader/weibo_kit)
- [Flutter版支付宝SDK](https://github.com/RxReader/alipay_kit)
- [Flutter版深度链接](https://github.com/RxReader/link_kit)
- [Flutter版walle渠道打包工具](https://github.com/RxReader/walle_kit)

## Dart/Flutter Pub 私服

- [simple_pub_server](https://github.com/RxReader/simple_pub_server)

## 相关文档

- [蚂蚁金服开放平台](https://openhome.alipay.com/platform/appManage.htm)
- [支付宝支付](https://docs.open.alipay.com/204/105051/)
- [支付宝登录](https://docs.open.alipay.com/218/105329/)
- [应用签名工具](https://opendocs.alipay.com/open/common/104062)

## 开始使用

### Android

```
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

- [获取 Android 签名信息](https://github.com/RxReader/wechat_kit#android)

### iOS

- 配置alipay url binding

```
# 使用 xcode 打开 项目 runner
# Project -> Targets -> Runner -> Info
# URL Types 中增加 alipay 一览
# Identifier alipay
# Icon None
# URL Schemes alipayauthbinding
# Role Editor
```

### Flutter

> [周期扣款](https://github.com/RxReader/alipay_kit/issues/55)

- 配置

```yaml
dependencies:
  alipay_kit: ^${latestTag} # 默认不包含iOS支付
#  alipay_kit_ios: ^${latestTag} # iOS支付

alipay_kit:
  # iOS 使用极简版sdk
  scheme: ${your alipay scheme} # scheme 不能为纯数字，推荐：alipay${appId}
```

- 安装（仅iOS）

```shell
# step.1 安装必要依赖
sudo gem install plist
# step.2 切换工作目录，插件里为 example/ios/，普通项目为 ios/
cd example/ios/
# step.3 执行脚本
pod install
```

## 示例

[示例](./example/lib/main.dart)

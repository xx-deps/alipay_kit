# alipay_kit

[![Pub Package](https://img.shields.io/pub/v/alipay_kit.svg)](https://pub.dev/packages/alipay_kit)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/RxReader/alipay_kit/blob/master/alipay_kit/LICENSE)

flutter版支付宝SDK

## 相关工具

* [flutter版微信SDK](https://github.com/rxreader/wechat_kit)
* [flutter版腾讯(QQ)SDK](https://github.com/rxreader/tencent_kit)
* [flutter版新浪微博SDK](https://github.com/rxreader/weibo_kit)
* [flutter版支付宝SDK](https://github.com/rxreader/alipay_kit)
* [flutter版walle渠道打包工具](https://github.com/rxreader/walle_kit)

## dart/flutter 私服

* [simple_pub_server](https://github.com/rxreader/simple_pub_server)

## docs

* [蚂蚁金服开放平台](https://openhome.alipay.com/platform/appManage.htm)
* [支付宝支付](https://docs.open.alipay.com/204/105051/)
* [支付宝登录](https://docs.open.alipay.com/218/105329/)
* [应用签名工具](https://opendocs.alipay.com/open/common/104062)

## android

```
# 不需要做任何额外接入工作
# 混淆已打入 Library，随 Library 引用，自动添加到 apk 打包混淆
```

#### UTDID冲突的问题解决方案

```shell
java.lang.RuntimeException: Duplicate class com.ta.utdid2.a.a.a found in modules alicloud-android-utdid-2.5.1-proguard.jar
```

* alipay_kit_android: ^4.0.2 修改 pubspec.yaml

```diff
+alipay_kit:
+  android: noutdid # 默认 utdid
```

* alipay_kit_android: ^4.0.1 修改 android/build.gradle

```diff
// 5.x.y 版本将删除
buildscript {
+    ext.alipay_kit_flavor = "noutdid" // 默认 "utdid"
}
```

[示例](example/android/build.gradle)

#### 获取 android 微信签名信息

非官方方法 -> 反编译 GenSignature_0630.apk 所得

命令：

```shell
keytool -list -v -keystore ${your_keystore_path} -storepass ${your_keystore_password} 2>/dev/null | grep -p 'MD5:.*' -o | sed 's/MD5://' | sed 's/ //g' | sed 's/://g' | awk '{print tolower($0)}'
```

示例：

```shell
keytool -list -v -keystore example/android/app/infos/dev.jks -storepass 123456 2>/dev/null | grep -p 'MD5:.*' -o | sed 's/MD5://' | sed 's/ //g' | sed 's/://g' | awk '{print tolower($0)}'
```

```shell
28424130a4416d519e00946651d53a46
```

## ios

```
在Xcode中，选择你的工程设置项，选中“TARGETS”一栏，在“info”标签栏的“URL type“添加“URL scheme”为你所注册的应用程序id

URL Types
alipay: identifier=alipay schemes=${your app scheme name} # schemes 不能为纯数字，推荐：alipay${appId}
```

```
iOS 9系统策略更新，限制了http协议的访问，此外应用需要在“Info.plist”中将要使用的URL Schemes列为白名单，才可正常检查其他应用是否安装。

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>alipay</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

#### noutdid

* alipay_kit_ios: ^4.0.2 修改 pubspec.yaml

```diff
+alipay_kit:
+  ios: noutdid # 默认 utdid
```

* alipay_kit_ios: ^4.0.1 修改 ios/Podfile

```diff
# 5.x.y 版本将删除
+ $AlipayKitSubspec = 'noutdid' # 默认 utdid
```

[示例](example/ios/Podfile)

## flutter

* break change
  * 4.0.0: 按标准插件书写重构
    * 默认集成 Android 实现
    * iOS 实现需手动添加依赖：alipay_kit_ios
  * 3.1.0: android:minSdkVersion="19"
  * 3.0.0: 重构
  * 2.2.0: Alipay 单例
  * 2.1.0: nullsafety & 不再支持 Android embedding v1

* release

```diff
dependencies:
  alipay_kit: ^${latestTag} # 默认不包含iOS支付
+  alipay_kit_ios: ^${latestTag} # iOS支付
```

* example

[示例](./example/lib/main.dart)


## Star History

![stars](https://starchart.cc/rxreader/alipay_kit.svg)
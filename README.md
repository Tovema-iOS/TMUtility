# TMUtility

This is an iOS utility library, contains sandbox file manager, KVO receptionist, normal device info and some common macro.

此库分模块，默认仅包含 Core 子模块。

## 模块说明

### Core 子模块

* TMDeviceInfo 设备信息封装
* TMFileManager 便捷沙盒访问
* TMReceptionist KVO、Notification中转类
* TMMacro 常用宏定义

### ThreadSafeArray 子模块

基于 YYThreadSafeArray 封装的线程安全 array，自带模型转换和缓存列表到plist功能。

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS8, ARC

## Installation

TMUtility is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
source 'https://github.com/Tovema-iOS/Specs.git'
pod "TMUtility", '~> 1.0'
```

## Author

CodingPub, lxb_0605@qq.com

## License

TMUtility is available under the MIT license. See the LICENSE file for more info.

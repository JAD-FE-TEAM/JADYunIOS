# JADYunIOS
京东广告联盟 京准通SDK 

JD  Ad SDK pod support


## 如何开始

*下载[Demo](https://github.com/JAD-FE-TEAM/JADYunIOS/tree/master/Demo) 到本地，进入下载路径，进入Example路径。

*打开终端 Terminal ，运行 `pod install` 进行安装 。

*使用Xcode13.0及以上版本，运行`JADYun.xcworkspace` 


## CocoaPods安装

在使用前需要安装CocoaPods到您的电脑上

```
gem install cocoapods
```

### Podfile

在您的Podfile文件中，按如下添加即可

```object-c
use_frameworks!

platform :ios, '9.0'

target 'JADYun_Example' do

  #方式一、全功能包集成
  pod 'JADYun'
  
  #方式二、多子包集成，可按需集成
#   pod 'JADYunCore'
#   pod 'JADYunNative'
#   pod 'JADYunSplash'
#   pod 'JADYunBanner'
#   pod 'JADYunFeed'
#   pod 'JADYunInterstitial'
  
  target 'JADYun_Tests' do
    inherit! :search_paths
  end
end

```


## License
MIT License


## FAQ



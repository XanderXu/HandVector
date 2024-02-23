<p align="center">
  <img src="http://yannickloriot.com/resources/splitflap-logo.gif" alt="Splitflap">
</p>
<p align="center">
  <a href="https://github.com/apple/swift-package-manager"><img alt="Swift Package Manager compatible" src="https://img.shields.io/badge/SPM-%E2%9C%93-brightgreen.svg?style=flat"/></a>
  <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" alt="Swift 5.9" />
</p>

***HandVector*** is a simple to use component to present changeable alphanumeric text like often used as a public transport timetable in airports or railway stations or with some flip clocks.

<p align="center">
    <a href="#requirements">Requirements</a> • <a href="#usage">Usage</a> • <a href="#installation">Installation</a> • <a href="#contribution">Contribution</a> • <a href="#contact">Contact</a> • <a href="#license-mit">License</a>
</p>

## Requirements

- visionOS 1.0+
- Xcode 15.2+
- Swift 5.9+

## Usage

### Match hand gesture

`HandVector` allows you to track your hands, and calculate the similarity of current gesture to another recorded hand gesture:

```swift
import HandVector

//load recorded hand gesture from json file
model.handEmojiDict = HandEmojiParameter.generateParametersDict(fileName: "HandEmojiTotalJson")!
guard let okVector = model.handEmojiDict["👌"]?.convertToHandVectorMatcher(), let leftOKVector = okVector.left else { return }

//update current handTracking from HandTrackingProvider
for await update in handTracking.anchorUpdates {
    switch update.event {
    case .added:
        ...
    case .updated:
        let anchor = update.anchor
        guard anchor.isTracked else { continue }
        await latestHandTracking.updateHand(from: anchor)
    case .removed:
        ...
    }
}


//calculate the similarity
let leftScore = model.latestHandTracking.leftHandVector?.similarity(to: leftOKVector) ?? 0
model.leftScore = Int(abs(leftScore) * 100)
let rightScore = model.latestHandTracking.rightHandVector?.similarity(to: leftOKVector) ?? 0
model.rightScore = Int(abs(rightScore) * 100)
```

### Test on simulator

`HandVector` allows you to test hand tracking on visionOS simulator:





### And many more...

To go further, take a look at the documentation and the demo project.

*Note: All contributions are welcome*

## Installation

#### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `Splitflap` by adding the proper description to your `Package.swift` file:
```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    targets: [],
    dependencies: [
        .Package(url: "https://github.com/XanderXu/HandVector.git", versions: "0.1.0" ..< Version.max)
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

#### Manually

[Download](https://github.com/YannickL/Splitflap/archive/master.zip) the project and copy the `HandVector` folder into your project to use it in.

## Contribution

Contributions are welcomed and encouraged *♡*.

## Contact

Xander-API 搬运工
 - [https://juejin.cn/user/2629687543092056](https://juejin.cn/user/2629687543092056)
 - [https://twitter.com/XanderARKit](https://twitter.com/XanderARKit)

## License (MIT)

Copyright (c) 2015-present

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

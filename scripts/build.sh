pod install
pod update

xcodebuild clean -workspace sdk-objectmodel-swift.xcworkspace -scheme "sdk-objectmodel-swift"

xcodebuild build -workspace sdk-objectmodel-swift.xcworkspace -scheme "sdk-objectmodel-swift"


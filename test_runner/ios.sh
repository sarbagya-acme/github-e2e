output="../build/ios_integration"
product="build/ios_integration/Build/Products"
dev_target="15.2"
ios_sdk="15.4"
dev_model="iphone13pro"

flutter build ios integration_test/app_test.dart --release

cd ../ios || exit
xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Flutter/Release.xcconfig -derivedDataPath $output -sdk iphoneos clean build-for-testing

cd ../$product || exit
zip -r "ios_tests.zip" "Release-iphoneos" "Runner_iphoneos$ios_sdk-arm64.xctestrun"

gcloud firebase test ios run --test "ios_tests.zip" \
  --device model=$dev_model,version=$dev_target,locale=en_GB,orientation=portrait \
  --timeout 3m
# Prototype

[![Version](https://img.shields.io/cocoapods/v/Prototype.svg?style=flat)](http://cocoapods.org/pods/Prototype)
[![License](https://img.shields.io/cocoapods/l/Prototype.svg?style=flat)](http://cocoapods.org/pods/Prototype)
[![Platform](https://img.shields.io/cocoapods/p/Prototype.svg?style=flat)](http://cocoapods.org/pods/Prototype)

The prototype framework allows you to integrate .prototype files created with the macOS Prototype-Application into your iOS, macOS or tvOS application. You can configure and inspect the `PrototypeView` using the Xcode Interface Builder with ease.

## Example

Run `pod install` from the Example directory first and open the PrototypeExample.workspace and select one of the three provided targets (iOS, macOS, and tvOS) and run the project.

## Requirements

Create a .prototype file that can be displayed using the Prototype Framework you need to download the Prototype-Application available for macOS.
Create a .prototype file based on a prototype created with [Marvel App](https://marvelapp.com) using the macOS Prototype-Application.

## Installation

1. Integrate the Prototype Framework using CocoaPods

    ```
    pod 'Prototype'
    ```

    To guarantee that you can configure the `PrototypeView` directly in the Xcode Interface Builder add the following lines at the end of your Podfile:

    ```
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.new_shell_script_build_phase.shell_script = "mkdir -p $PODS_CONFIGURATION_BUILD_DIR/#{target.name}"
            target.build_configurations.each do |config|
                config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
            end
        end

        installer.pods_project.build_configurations.each do |config|
            config.build_settings.delete('CODE_SIGNING_ALLOWED')
            config.build_settings.delete('CODE_SIGNING_REQUIRED')
        end
    end
    ```

2. Add the .prototype file created with the Prototype-Application to your Xcode project and the corresponding target.
3. Add a `PrototypeView` to the corresponding interface using the Xcode Interface Builder or code. You can completely configure the `PrototyperView` in the Xcode Interface Builder's Attributes Inspector. You need to set the `prototypeName` and optionally the `startPage` of the prototype.
4. You can immediately see the result displayed in the Xcode Interface Builder. To inspect if you configured the right prototype page you can enable the `showButtonsInIB` attribute in the Xcode Interface Builder's Attributes Inspector.
5. Build and run your application.

## Author

Paul Schmiedmayer, [@PSchmiedmayer](https://twitter.com/PSchmiedmayer), Chair for Applied Software Engineering, ios@in.tum.de

## License

Prototyper is available under the MIT license. See the LICENSE file for more info.

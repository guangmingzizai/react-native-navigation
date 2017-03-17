
<h1 align="center">
  <img src="./logo.png"/><br>
  React Native Navigation
</h1>

[![NPM Version](https://img.shields.io/npm/v/react-native-navigation.svg?style=flat)](https://www.npmjs.com/package/react-native-navigation)
[![NPM Downloads](https://img.shields.io/npm/dm/react-native-navigation.svg?style=flat)](https://www.npmjs.com/package/react-native-navigation)
[![Build Status](https://travis-ci.org/wix/react-native-navigation.svg?branch=master)](https://travis-ci.org/wix/react-native-navigation)
[![Join us on Discord](https://img.shields.io/badge/discord-react--native--navigation-738bd7.svg?style=flat)](https://discord.gg/DhkZjq2)

App-wide support for 100% native navigation with an easy cross-platform interface. For iOS, this package is a wrapper around [react-native-controllers](https://github.com/wix/react-native-controllers), but provides a simplified more abstract API over it. It also fully supports redux if you use it.

<img src="https://github.com/wix/react-native/blob/master/src/videos/demo.gif?raw=true" width="240">

----

> ### Important
> We are currently working hard on redesigning and refactoring this project with high quality and robustness in mind. As a result, issues and pull requests will take more time to process.

> To avoid any confusion and breaking existing projects, all continuous development is published under the npm tag `next`, with version `2.0.0-experimental.x`. Once stable, we will publish it as `2.0.0`. **This version supports react-native `0.40.0 and above`**.

> The last stable version is `1.30.x` with npm tag `latest`. **This version supports react-native `0.25.1`**. It's installation instructions are [here](https://github.com/wix/react-native-navigation/blob/v1.x.x/README.md#installation---ios).

>If you don't want your code to break on a daily basis and don't need the new features ASAP please use the `latest` version or just specify a specific version number.

## Wiki

* [Overview](https://github.com/wix/react-native-navigation/wiki)
* [Why use this package](https://github.com/wix/react-native-navigation/wiki#why-use-this-package)
* [Installation - iOS](https://github.com/wix/react-native-navigation/wiki/Installation---iOS#installation---ios)
* [Installation - Android](https://github.com/wix/react-native-navigation/wiki/Installation---Android)
* [Usage](https://github.com/wix/react-native-navigation/wiki/Usage)
* [Top Level API](https://github.com/wix/react-native-navigation/wiki/Top-Level-API)
* [Screen API](https://github.com/wix/react-native-navigation/wiki/Screen-API)
* [Styling the navigator](https://github.com/wix/react-native-navigation/wiki/Styling-the-navigator)
* [Adding buttons to the navigator](https://github.com/wix/react-native-navigation/wiki/Adding-buttons-to-the-navigator)
* [Styling the tab bar](https://github.com/wix/react-native-navigation/wiki/Styling-the-tab-bar)
* [Deep links](https://github.com/wix/react-native-navigation/wiki/Deep-links)
* [Third party libraries support](https://github.com/wix/react-native-navigation/wiki/Third-party-libraries-support)
* [Milestones](https://github.com/wix/react-native-navigation/wiki/Milestones)
* [Contributing](https://github.com/wix/react-native-navigation/wiki/Contributing)
* [License](https://github.com/wix/react-native-navigation/wiki#license)

## Why use this package

One of the major things missing from React Native core is fully featured native navigation. Navigation includes the entire skeleton of your app with critical components like nav bars, tab bars and side menu drawers.

If you're trying to deliver a user experience that's on par with the best native apps out there, you simply can't compromise on JS-based components trying to fake the real thing.

For example, this package replaces the native [NavigatorIOS](https://facebook.github.io/react-native/docs/navigatorios.html) that has been [abandoned](https://facebook.github.io/react-native/docs/navigator-comparison.html) in favor of JS-based solutions that are easier to maintain. For more details see in-depth discussion [here](https://github.com/wix/react-native-controllers#why-do-we-need-this-package).


## License

The MIT License.

See [LICENSE](LICENSE)

## Customization

#### 1. Add badgeDot to tabBarItem

```javascript
this.props.navigator.setTabBadge({
  tabIndex: 0, // (optional) if missing, the badge will be added to this screen's tab
  badge: 17, // badge value, null to remove badge
  showBadgeDot: true,
});
```

*If badge exists, the badgeDot is hidden.*

#### 2. Add animation to tabBarItem icon

```javascript
tabsStyle: {
    animateTabBarItem: true,
}
```

*default is false*

#### 3. Support tabBarItem no title

If the title of tabBarItem is empty, it will not show title.

#### 4. Support remove the tabBar top border line

```javascript
tabsStyle: {
    removeBorderLine: true,
}
```

*must set the backgroundColor*

#### 5. Support change the top border color

```javascript
tabsStyle: {
    shadowImageColor: '#555555',
}
```

#### 6. Support change badge color

```javascript
this.props.navigator.setTabBadge({
  tabIndex: 0, // (optional) if missing, the badge will be added to this screen's tab
  badge: 17, // badge value, null to remove badge
  showBadgeDot: true,
  badgeColor: 'green',
});
```

#### 7. Use showModal for android showLightBox

Now `showLightBox` only support iOS, so add `showLightBox` to android for convenience.

#### 8. Add default style to lightBox

Default style is:

```javascript
 {
      backgroundBlur: "none",
      backgroundColor: "transparent",
    }
```

#### 9. Support transparent modal

```javascript
static navigatorStyle = {
    screenTransparent: true,
    screenBackgroundColor: '#FFFFFFEE',
  }
```

If `screenTransparent` is true, it will be presented in the current context.

#### 10. Deep link support custom params

Deep link only support `link` param, but I need some other params, so I not need to encode params to `link`, then decode params out.
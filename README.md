# AIR Cookbook

[![Cookbook Version](http://img.shields.io/cookbook/v/air.svg?style=flat-square)][supermarket]
[![Build Status](http://img.shields.io/travis/dhoer/chef-air.svg?style=flat-square)][travis]

[supermarket]: https://supermarket.chef.io/cookbooks/air
[travis]: https://travis-ci.org/dhoer/chef-air

Installs/Configures Adobe AIR Runtime and AIR Application (if path specified).

Please submit a Pull Request if you would like to add support for Mac OS X, Linux, SDK, or ARH.

## Requirements

- Chef 11+

### Platforms

- Windows

### Cookbooks

- windows

## Usage

By including this cookbook in a recipe or a run list, your organization has agreed to the 
[Adobe end-user license agreement (EULA)](http://www.adobe.com/products/eula/tools/flashplayer_usage.html).

### Attributes
* `node['air']['update_disabled']` - Disable the AIR update feature.  Default `false`.
* `node['air']['path']` - Specifies the URI to the AIR file to install. The AIR application 
installer installs the correct version of Adobe AIR on the target computer, as required by the AIR application 
to be installed. To install or update the runtime only, don't specify a path.
* `node['air']['pingback_allowed']` - Allows the installer to check for updates to the AIR runtime and report a 
successful install to Adobe over the Internet. No identifying information is transmitted.  Ignored if path 
attribute is not specified. Default `true`.
* `node['air']['location']` - Provides the location (an absolute file system path) to install the AIR 
application. The default location is the standard application installation location. Ignored if path attribute
is not specified.
* `node['air']['desktop_shortcut']` - Install a desktop shortcut for the installed AIR application. Ignored if
path attribute is not specified. Default `true`.
* `node['air]['program_menu']` - Install a program menu shortcut for the installed application 
(on Windows). Ignored if path attribute is not specified. Default `true`.

### Examples

Install Adobe AIR Runtime only

```ruby
include_recipe 'air'
```

Install Adobe AIR Runtime, Bee [sample app](http://www.adobe.com/devnet/air/samples_javascript.html), and disable 
AIR updates

```ruby
node.set['air']['path'] = 'http://download.macromedia.com/pub/developer/air/sample_apps/Bee.air'
node.set['air']['location'] = 'C:\air\sample_apps' 
node.set['air']['update_disabled'] = true
        
include_recipe 'air'
```

## Getting Help

- Ask specific questions on [Stack Overflow](http://stackoverflow.com/questions/tagged/air).
- Report bugs and discuss potential features in [Github issues](https://github.com/dhoer/chef-air/issues).

## Contributing

Please refer to [CONTRIBUTING](https://github.com/dhoer/chef-air/blob/master/CONTRIBUTING.md).

## License

MIT - see the accompanying [LICENSE](https://github.com/dhoer/chef-air/blob/master/LICENSE.md) file for details.

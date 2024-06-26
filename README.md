# SwiftBar Technitium DNS Block Control

## Overview
This SwiftBar plugin allows you to manage Technitium DNS ad blocking directly from your macOS menu bar. You can temporarily disable ad blocking for specified durations, reactivate it, and clear your local DNS cache.

## Features
- Temporarily Disable Ad Blocking: Choose from several time durations to disable ad blocking.
- Reactivate Ad Blocking: Reactivate ad blocking immediately.
- Clear Local DNS Cache: Clear the DNS cache on your macOS machine to ensure you're using the latest DNS information.
## Installation
### Clone the Repository
```
git clone git@github.com
/swiftbar-technitium-block-control.git
cd swiftbar-technitium-block-control
```

### Make the Script Executable:
```
chmod +x disable_ad_blocking.10m.sh
```

### Move the Script to SwiftBar Plugins Directory:
```
mv disable_ad_blocking.10m.sh ~/Library/Application\ Support/SwiftBar/Plugins/
```
(get your SwiftBar plugin directory first from SwiftBar)

### Restart SwiftBar:
If SwiftBar is running, restart it to load the new plugin.
## Script Configuration
The script uses the following configuration variables:

`server_url`: URL of your Technitium DNS server.
`token`: Your Technitium DNS API token.

Generate an API token in Technitium by clicking your username in the top right corner of the Technitium dashboard and selecting "Create API Token". Then edit the script to match your Technitium DNS server configuration.

### Example configuration

```
server_url="http://192.168.13.201:5380"
token="a2e25f22e0d4ec0869bee7093bc3573216fff5ca00dd191948ac91c285052213"
```
## Usage
### Menu Options
#### Disable Blocklist:
- 1 minute
- 2 minutes
- 5 minutes
- 10 minutes
- 30 minutes
- 1 hour
- 2 hours
#### Reactivate Blocklist: Immediately reactivate the blocklist.

#### Clear Local DNS Cache: Clear the DNS cache on your macOS machine.

## Contributing
If you find any issues or have suggestions for improvements, feel free to open an issue or create a pull request. Contributions are always welcome!

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements
- Technitium DNS Server - The DNS server that this plugin manages.
- SwiftBar - The macOS menu bar tool used to display this plugin.

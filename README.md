:warning: *Use of this software is subject to important terms and conditions as set forth in the License file* :warning:

# iOS demo applications for the Zendesk SDK

## Description
This repository provides you with demo Apps to help learn how to use [Zendesk SDK](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/) on iOS.

We hope you'll find those sample Apps useful and encourage you to re-use some of this code in your own Apps.

## Owners
Please submit a ticket to [Zendesk](https://support.zendesk.com/hc/en-us/articles/4408843597850).
 
## Getting Started
Each demo app's instructions are included below. 

## Hello World
This app features two buttons, one to initiliaze Zendesk and another to start & display the conversation. It requires a channel key from your Zendesk account. Instructions on how to get one can be found [here.](https://support.zendesk.com/hc/en-us/articles/4408834810394#topic_cbc_x1t_xnb) The key must be placed in the "channel_key" variable in the MainViewController.

## JWT Auth
This app features three buttons, the first two from the Hello World app and an additional one to authenticate the user with a JWT token. It requires a channel key from your Zendesk account and a service that can generate JWT tokens. See the guide for the Hello World app above for instructions on how to get and use the channel key. For instructions on how to create a JWT authentication service for the iOS SDK, please [refer to this guide.](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/web/enabling_auth_visitors/) Once you have a valid token, it must be provided to the "jwt_token" variable in the MainViewController prior to running the app. The account must be initialized before attempting to log in with the JWT token.
 
## Bugs
Please submit bug reports to [Zendesk](https://support.zendesk.com/hc/en-us/articles/4408843597850) and be sure to consult our [Getting help section](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/getting_support_on_zendesk_mobile_sdks/) of our documentation.
 

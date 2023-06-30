:warning: *Use of this software is subject to important terms and conditions as set forth in the License file* :warning:

# iOS demo applications for the Zendesk SDK

## Description
This repository provides you with demo Apps to help learn how to use [Zendesk SDK](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/) on iOS.

We hope you'll find those sample Apps useful and encourage you to re-use some of this code in your own Apps.

## Owners
Please submit a ticket to [Zendesk](https://support.zendesk.com/hc/en-us/articles/4408843597850).
 
## Getting Started
Each demo app's instructions are included below. 

## The Basics
Each app features two buttons, one to initiliaze Zendesk and another to start & display the conversation. It requires a channel key from your Zendesk account. Instructions on how to get one can be found [here.](https://support.zendesk.com/hc/en-us/articles/4408834810394#topic_cbc_x1t_xnb) The key must be placed in the "channel_key" variable in the MainViewController.

## Hello World
This app simply features the two buttons described above. If you want to just get a Zendesk SDK conversation going right away, this is the one to start with.

## JWT Auth
This app features an additional button to authenticate the user with a JWT token. It requires a channel key from your Zendesk account and a service that can generate JWT tokens. For instructions on how to create a JWT authentication service for the iOS SDK, please [refer to this guide.](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/web/enabling_auth_visitors/) Once you have a valid token, it must be provided to the "jwt_token" variable in the MainViewController prior to running the app. The account must be initialized before attempting to log in with the JWT token.

## Clickable links
This app allows you to handle a specified URL in a custom way. See the **cell.clickHandler** closure in the MainViewController, and the **messaging** function beneath it, for the relevant code. The default behavior is to return false, which will result in a normal browser opening experience. You can set it to return true along with custom code to change the behavior. More information at our documentation [here.](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#clickable-links-delegate)

## Unread messages
This app has an additional button that will display the number of unread messages (i.e. any messages sent by the Zendesk agent while the end user was not in the conversation view). The unread count will also show as badges on the app icon. Note that you must allow the app notification permissions for the unread messages API to work. More information at our documentation [here.](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#unreadmessagecountchanged)

## Visitor path
This app allows you to send information to the pageView event API, which will appear in the agent's sidebar in the Agent Workspace. See the **cell.clickHandler** closure within the **presentCell** function in the MainViewController for the relevant code. More information [here.](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/advanced_integration/#visitor-path)

## Push notifications
This app allows you to configure push notifications that can appear when the end user is outside of the app, as well as inside the app but not in the conversation view. The notification banner will take you back to the convesation when tapped. There is an extra "registration" button that must be tapped and the user must allow notification permissions in order for this to work. The code is based on our documentation [here.](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/sdks/ios/push_notifications/) As the documentation suggests, much of the configuration must be done on Apple's end, and requires an Apple developer account. Please ensure that you have a properly configured [provisioning profile](https://developer.apple.com/help/account/manage-profiles/create-a-development-provisioning-profile/).

## Bugs
Please submit bug reports to [Zendesk](https://support.zendesk.com/hc/en-us/articles/4408843597850) and be sure to consult our [Getting help section](https://developer.zendesk.com/documentation/zendesk-web-widget-sdks/getting_support_on_zendesk_mobile_sdks/) of our documentation.
 

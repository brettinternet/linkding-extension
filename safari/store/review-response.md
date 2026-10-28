# App Review response

Paste the text below into the App Store Connect reply and into App Review Information › Notes. Attach the screen recording to the reply.

## Screen recording checklist

Record on a physical iPhone (and ideally a Mac) on the latest OS. QuickTime › New Movie Recording works for iPhone over USB; use Shift-Cmd-5 on Mac.

1. Start from the Home Screen: show the Linkding Extension app icon and launch it (shows the enable-extension instructions).
2. Settings › Apps › Safari › Extensions › enable Linkding Extension and allow it on all websites or the chosen site.
3. In Safari, open any page, open the extension from the aA menu (Mac: toolbar button).
4. Enter the server URL and API token, save, and allow server access when prompted.
5. Reopen the extension on a page, show the title, description and tag suggestions, add a tag and a note, tap Save.
6. Open the same page again to show "already bookmarked", then edit and delete it.
7. Mac only: right-click a link › Save to linkding.
8. Show the bookmark appearing in the linkding web UI.

No account creation, login, user-generated content, or paid features exist in the app, so none are recorded.

## Text to submit

**1. Screen recording**
Attached. Recorded on a physical device on the latest OS, beginning at app launch and showing setup, saving, editing, and deleting a bookmark.

**2. Purpose and audience**
Linkding Extension is a Safari extension for linkding (https://github.com/sissbruecker/linkding), an open source, self-hosted bookmark manager. It lets people who run their own linkding server save the page they are viewing in Safari to that server in one tap, with the title and description prefilled and their existing tags suggested. It also shows whether a page is already bookmarked and lets them edit or delete it. The audience is self-hosters and privacy-minded users who keep bookmarks on their own server instead of a third-party service. The app is a thin client: it has no accounts, content, or purchases of its own.

**3. Setup and access**
1. Enable the extension. iOS: Settings › Apps › Safari › Extensions › Linkding Extension. Mac: Safari › Settings › Extensions.
2. In Safari, open the extension, enter the server URL and API token below, and save. Allow access to the server when Safari asks.
3. Open any web page, open the extension, and tap Save. The bookmark appears on the server.

Server URL: <demo server URL>
API token: <demo account API token>

The demo server is a linkding instance run by the developer for review. No sample files are needed.

**4. External services**
Only the user's own linkding server, reached through its REST API at the URL the user enters. No analytics, advertising, authentication, payment, data provider, or AI services. The developer receives no data.

**5. Regional differences**
None. The app behaves the same in all regions. It is free, with no in-app purchases.

**6. Regulated industry or third-party material**
Not applicable. The app is not in a regulated industry and includes no protected third-party material. It is based on the MIT-licensed open source linkding extension by Sascha Ißbrücker.

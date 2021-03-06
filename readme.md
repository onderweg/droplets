# Droplets: a simple Digital Ocean Droplet manager

Experimental hybrid app (HTML/JS wrapped in a native app with WKWebview), build with Swift.
I chose to use the Digital Ocean API as a use case.

Idea:

- Run local webserver in nodejs, which serves static files (HTML/JS/CSS)
- Load static site, build with AngularJS, in a webview embeded in a native OS X app

So, Droplets is essentially a OS X app build with Angular.

The app shows your Digital Ocean droplets.

![image](screenshot1.png)

Consider this an alpha version. This project is not activly maintained. I make no guarantees or warranties whatsoever.

##Building/Running

- Make sure NodeJS is installed and runnable from `/usr/local/bin/node`. A NodeJS script serves statics files to the WKWebview in the app.
- Build the project in XCode. (tested wit 6.1.1)
- After startup, you need to enter your Digital Ocean oAuth token in the settings screen (cog wheel icon). You need a token with read+write access.
 
Note: Breaking changes are introduced regularly in the Swift language. This project might not be up to date with the latest version.

##Thanks to

- [practicalswift.com](http://practicalswift.com/2014/06/27/a-minimal-webkit-browser-in-30-lines-of-swift/) for webview tutorial in Swift.
- [Santosh Rajan](https://medium.com/swift-programming/http-in-swift-693b3a7bf086) for tutorial on HTTP/JSON requests in Swift

##Similar

Similar (and more mature :) ) projects:

- [node-webkit](https://github.com/rogerwang/node-webkit): "write native apps in HTML and JavaScript
- [electron](https://github.com/atom/electron): "lets you write cross-platform desktop applications using JavaScript, HTML and CSS". Formerly known as "atom-shell"
- [MacGap](https://github.com/MacGapProject): "Desktop WebKit wrapper for HTML/CSS/JS applications."

##Attributions/Credits

- Icon "Drop" by Márcio Pinhole from The Noun Project, licensed under Creative
Commons Attribution

# VideoCacheDeepLinkApp
An app with functions to handle deeplinking URLs and cache videos.

Contains a class called `DeepLinkManagerImpl` which is a concrete implementation of the protocol `DeepLinkManagerProtocol`.

Also contains a `URLSessionVideoCacheManager` which is a concrete implementation of the protocol `VideoCacheManager`.

**How to use the app**

When you press the Fetch Video button, the URLSessionVideoCacheManager starts to load the video from the network.
When you press the Fetch Video button next time, the video is loaded from the cache.

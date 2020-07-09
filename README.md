# pull_to_refresh_notification

[![pub package](https://img.shields.io/pub/v/pull_to_refresh_notification.svg)](https://pub.dartlang.org/packages/pull_to_refresh_notification) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/network)  [![GitHub license](https://img.shields.io/github/license/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/issues) <a target="_blank" href="https://jq.qq.com/?_wv=1027&k=5bcc0gy"><img border="0" src="https://pub.idqqimg.com/wpa/images/group.png" alt="flutter-candies" title="flutter-candies"></a>

Language: [English](README.md) | [中文简体](README-ZH.md)

widget to build  pull to refresh effects.

[Web demo for PullToRefreshNotification](https://fluttercandies.github.io/pull_to_refresh_notification/)

[Chinese blog](https://juejin.im/post/5bebcc44f265da61682aedb8)

- [pull_to_refresh_notification](#pulltorefreshnotification)
- [RefreshIndicatorMode](#refreshindicatormode)
- [Sample 1 appbar](#sample-1-appbar)
- [Sample 2 header](#sample-2-header)
- [Sample 3 image](#sample-3-image)
- [Sample 4 candies](#sample-4-candies)
- [refresh with code](#refresh-with-code)

# RefreshIndicatorMode

```dart
enum RefreshIndicatorMode {
  drag, // Pointer is down.
  armed, // Dragged far enough that an up event will run the onRefresh callback.
  snap, // Animating to the indicator's final "displacement".
  refresh, // Running the refresh callback.
  done, // Animating the indicator's fade-out after refreshing.
  canceled, // Animating the indicator's fade-out after not arming.
  error, //refresh failed
}
```

# Sample 1 appbar
build appbar to pull to refresh with PullToRefreshContainer

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/pull_to_refresh/appbar.gif)
```dart
   Widget build(BuildContext context) {
 return PullToRefreshNotification(
      color: Colors.blue,
      pullBackOnRefresh: true,
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: <Widget>[
          PullToRefreshContainer(buildPulltoRefreshAppbar),
          SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.only(bottom: 4.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      "List item : ${listlength - index}",
                      style: TextStyle(fontSize: 15.0, inherit: false),
                    ),
                    Divider(
                      color: Colors.grey,
                      height: 2.0,
                    )
                  ],
                ));
          }, childCount: listlength)),
        ],
      ),
    );
}
    
     Widget buildPulltoRefreshAppbar(PullToRefreshScrollNotificationInfo info) {
        print(info?.mode);
        print(info?.dragOffset);
    //    print("------------");
        var action = Padding(
          child: info?.refreshWiget ?? Icon(Icons.more_horiz),
          padding: EdgeInsets.all(15.0),
        );
        var offset = info?.dragOffset ?? 0.0;
        return SliverAppBar(
            pinned: true,
            title: Text("PullToRefreshAppbar"),
            centerTitle: true,
            expandedHeight: 200.0 + offset,
            actions: <Widget>[action],
            flexibleSpace: FlexibleSpaceBar(
                //centerTitle: true,
                title: Text(
                  info?.mode?.toString() ?? "",
                  style: TextStyle(fontSize: 10.0),
                ),
                collapseMode: CollapseMode.pin,
                background: Image.asset(
                  "assets/467141054.jpg",
                  //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
                  fit: BoxFit.cover,
                )));
      }
```

[see demo](https://github.com/fluttercandies/pull_to_refresh_notification/blob/master/example/lib/pages/pull_to_refresh_appbar.dart)

# Sample 2 header
build header to pull to refresh with PullToRefreshContainer.
and you can easy to handle the status in pulling.

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/pull_to_refresh/header.gif)
```dart
  Widget build(BuildContext context) {
    return PullToRefreshNotification(
       color: Colors.blue,
       onRefresh: onRefresh,
       maxDragOffset: 80.0,
       child: CustomScrollView(
         slivers: <Widget>[
           SliverAppBar(
             pinned: true,
             title: Text("PullToRefreshHeader"),
           ),
           PullToRefreshContainer(buildPulltoRefreshHeader),
           SliverList(
               delegate:
                   SliverChildBuilderDelegate((BuildContext context, int index) {
             return Container(
                 padding: EdgeInsets.only(bottom: 4.0),
                 child: Column(
                   children: <Widget>[
                     Text(
                       "List item : ${listlength - index}",
                       style: TextStyle(fontSize: 15.0, inherit: false),
                     ),
                     Divider(
                       color: Colors.grey,
                       height: 2.0,
                     )
                   ],
                 ));
           }, childCount: listlength)),
         ],
       ),
     );
   }
 
   Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
     //print(info?.mode);
     //print(info?.dragOffset);
 //    print("------------");
     var offset = info?.dragOffset ?? 0.0;
     var mode = info?.mode;
     Widget refreshWiget = Container();
     //it should more than 18, so that RefreshProgressIndicator can be shown fully
     if (info?.refreshWiget != null &&
         offset > 18.0 &&
         mode != RefreshIndicatorMode.error) {
       refreshWiget = info.refreshWiget;
     }
 
     Widget child = null;
     if (mode == RefreshIndicatorMode.error) {
       child = GestureDetector(
           onTap: () {
             // refreshNotification;
             info?.pullToRefreshNotificationState?.show();
           },
           child: Container(
             color: Colors.grey,
             alignment: Alignment.bottomCenter,
             height: offset,
             width: double.infinity,
             //padding: EdgeInsets.only(top: offset),
             child: Container(
               padding: EdgeInsets.only(left: 5.0),
               alignment: Alignment.center,
               child: Text(
                 mode?.toString() + "  click to retry" ?? "",
                 style: TextStyle(fontSize: 12.0, inherit: false),
               ),
             ),
           ));
     } else {
       child = Container(
         color: Colors.grey,
         alignment: Alignment.bottomCenter,
         height: offset,
         width: double.infinity,
         //padding: EdgeInsets.only(top: offset),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: <Widget>[
             refreshWiget,
             Container(
               padding: EdgeInsets.only(left: 5.0),
               alignment: Alignment.center,
               child: Text(
                 mode?.toString() ?? "",
                 style: TextStyle(fontSize: 12.0, inherit: false),
               ),
             )
           ],
         ),
       );
     }
 
     return SliverToBoxAdapter(
       child: child,
     );
   }
 
   bool success = false;
   Future<bool> onRefresh() {
     final Completer<bool> completer = new Completer<bool>();
     new Timer(const Duration(seconds: 2), () {
       completer.complete(success);
       success = true;
     });
     return completer.future.then((bool success) {
       if (success) {
         setState(() {
           listlength += 10;
         });
       }
       return success;
     });
   }
```

[see demo](https://github.com/fluttercandies/pull_to_refresh_notification/blob/master/example/lib/pages/pull_to_refresh_header.dart)

# Sample 3 image
build zoom image to pull to refresh with using PullToRefreshContainer.

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/pull_to_refresh/image.gif)
```dart
 Widget build(BuildContext context) {
     // TODO: implement build
     return PullToRefreshNotification(
       color: Colors.blue,
       pullBackOnRefresh: true,
       onRefresh: onRefresh,
       child: CustomScrollView(
         slivers: <Widget>[
           SliverAppBar(
             title: Text("PullToRefreshImage"),
           ),
           PullToRefreshContainer(buildPulltoRefreshImage),
           SliverList(
               delegate:
                   SliverChildBuilderDelegate((BuildContext context, int index) {
             return Container(
                 padding: EdgeInsets.only(bottom: 4.0),
                 child: Column(
                   children: <Widget>[
                     Text(
                       "List item : ${listlength - index}",
                       style: TextStyle(fontSize: 15.0, inherit: false),
                     ),
                     Divider(
                       color: Colors.grey,
                       height: 2.0,
                     )
                   ],
                 ));
           }, childCount: listlength)),
         ],
       ),
     );
   }
   
   Widget buildPulltoRefreshImage(PullToRefreshScrollNotificationInfo info) {
     var offset = info?.dragOffset ?? 0.0;
     Widget refreshWiget = Container();
     if (info?.refreshWiget != null) {
       refreshWiget = Material(
         type: MaterialType.circle,
         color: Theme.of(context).canvasColor,
         elevation: 2.0,
         child: Padding(
           padding: EdgeInsets.all(12),
           child: info.refreshWiget,
         ),
       );
     }
 
     return SliverToBoxAdapter(
       child: Stack(
         alignment: Alignment.center,
         children: <Widget>[
           Container(
               height: 200.0 + offset,
               width: double.infinity,
               child: Image.asset(
                 "assets/467141054.jpg",
                 //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
                 fit: BoxFit.cover,
               )),
           Center(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 refreshWiget,
                 Container(
                   padding: EdgeInsets.only(left: 5.0),
                   alignment: Alignment.center,
                   child: Text(
                     info?.mode?.toString() ?? "",
                     style: TextStyle(fontSize: 12.0, inherit: false),
                   ),
                 )
               ],
             ),
           )
         ],
       ),
     );
   }
```
[see demo](https://github.com/fluttercandies/pull_to_refresh_notification/blob/master/example/lib/pages/pull_to_refresh_image.dart)

# Sample 4 candies
build candies animation to pull to refresh with using PullToRefreshContainer.

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/pull_to_refresh/candies.gif)
```dart
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          PullToRefreshNotification(
            color: Colors.blue,
            onRefresh: onRefresh,
            maxDragOffset: maxDragOffset,
            armedDragUpCancel: false,
            key: key,
            child: CustomScrollView(
              ///in case list is not full screen and remove ios Bouncing
              physics: AlwaysScrollableClampingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  title: Text("PullToRefreshCandies"),
                ),
                PullToRefreshContainer((info) {
                  var offset = info?.dragOffset ?? 0.0;
                  Widget child = Container(
                    alignment: Alignment.center,
                    height: offset,
                    width: double.infinity,
                    child: RefreshLogo(
                      mode: info?.mode,
                      offset: offset,
                    ),
                  );

                  return SliverToBoxAdapter(
                    child: child,
                  );
                }),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.only(bottom: 4.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "List item : ${listlength - index}",
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Divider(
                            color: Colors.grey,
                            height: 2.0,
                          )
                        ],
                      ));
                }, childCount: listlength)),
              ],
            ),
          ),
          Positioned(
            right: 20.0,
            bottom: 20.0,
            child: FloatingActionButton(
              child: Icon(Icons.refresh),
              onPressed: () {
                key.currentState.show(notificationDragOffset: maxDragOffset);
              },
            ),
          )
        ],
      ),
    );
  }
```

[see demo](https://github.com/fluttercandies/pull_to_refresh_notification/blob/master/example/lib/pages/pull_to_refresh_candies.dart)

# refresh with code

* define key
```dart
  final GlobalKey<PullToRefreshNotificationState> key =
      new GlobalKey<PullToRefreshNotificationState>();

        PullToRefreshNotification(
          key: key,    
```

* use key

if you define pull Container hegith with dragOffset, you need set notificationDragOffset when refresh.

```dart
  key.currentState.show(notificationDragOffset: maxDragOffset);
 ```
# ☕️Buy me a coffee

![img](http://zmtzawqlp.gitee.io/my_images/images/qrcode.png)

# pull_to_refresh_notification

[![pub package](https://img.shields.io/pub/v/pull_to_refresh_notification.svg)](https://pub.dartlang.org/packages/pull_to_refresh_notification) [![GitHub stars](https://img.shields.io/github/stars/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/stargazers) [![GitHub forks](https://img.shields.io/github/forks/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/network)  [![GitHub license](https://img.shields.io/github/license/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/blob/master/LICENSE)  [![GitHub issues](https://img.shields.io/github/issues/fluttercandies/pull_to_refresh_notification)](https://github.com/fluttercandies/pull_to_refresh_notification/issues) <a href="https://qm.qq.com/q/ZyJbSVjfSU"><img src="https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Ffluttercandies%2F.github%2Frefs%2Fheads%2Fmain%2Fdata.yml&query=%24.qq_group_number&style=for-the-badge&label=QQ%E7%BE%A4&logo=qq&color=1DACE8" /></a>

文档语言: [English](README.md) | [中文简体](README-ZH.md)

自定义下拉刷新动画.

[Web demo for PullToRefreshNotification](https://fluttercandies.github.io/pull_to_refresh_notification/)

[掘金](https://juejin.im/post/5bebcc44f265da61682aedb8)

- [pull_to_refresh_notification](#pull_to_refresh_notification)
- [RefreshIndicatorMode](#refreshindicatormode)
- [Sample 1 appbar](#sample-1-appbar)
- [Sample 2 header](#sample-2-header)
- [Sample 3 image](#sample-3-image)
- [Sample 4 candies](#sample-4-candies)
- [Sample 5 candies](#sample-5-candies)
- [refresh with code](#refresh-with-code)
- [☕️Buy me a coffee](#️buy-me-a-coffee)

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
创建一个Appbar的下拉刷新动画

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
        var action = Padding(
          child: info?.refreshWidget ?? Icon(Icons.more_horiz),
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

# Sample 2 header
创建下拉刷新头，你可以轻松处理状态

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

     var offset = info?.dragOffset ?? 0.0;
     var mode = info?.mode;
     Widget refreshWidget = Container();
     //it should more than 18, so that RefreshProgressIndicator can be shown fully
     if (info?.refreshWidget != null &&
         offset > 18.0 &&
         mode != RefreshIndicatorMode.error) {
       refreshWidget = info.refreshWidget;
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
             refreshWidget,
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
 
```

# Sample 3 image

创建一个图片缩放的下拉刷新动画

![](https://github.com/fluttercandies/Flutter_Candies/tree/master/gif/pull_to_refresh/image.gif)
```dart
 Widget build(BuildContext context) {
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
     Widget refreshWidget = Container();
     if (info?.refreshWidget != null) {
       refreshWidget = Material(
         type: MaterialType.circle,
         color: Theme.of(context).canvasColor,
         elevation: 2.0,
         child: Padding(
           padding: EdgeInsets.all(12),
           child: info.refreshWidget,
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
                 refreshWidget,
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

# Sample 4 candies

创建一个棒棒糖下拉刷新动画

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

# Sample 5 candies
在一个反转的列表里面怎么实现下拉刷新(比如聊天列表)

```dart
        PullToRefreshNotification(
          onRefresh: onRefresh,
          maxDragOffset: 48,
          armedDragUpCancel: false,
          reverse: true,
          child: Column(
            children: <Widget>[
              PullToRefreshContainer(
                  (PullToRefreshScrollNotificationInfo info) {
                final double offset = info?.dragOffset ?? 0.0;

                //load history data
                return Container(
                  height: offset,
                  child: const RefreshProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 2.0,
                  ),
                );
              }),
              Expanded(
                child: ExtendedListView.builder(
                  ///in case list is not full screen and remove ios Bouncing
                  physics: const AlwaysScrollableClampingScrollPhysics(),
                  reverse: true,
                  extendedListDelegate:
                      const ExtendedListDelegate(closeToTrailing: true),
                  itemBuilder: (BuildContext context, int index) {
                    List<Widget> children = <Widget>[
                      Text('$index. ${chats[index]}'),
                      Image.asset(
                        'assets/avatar.jpg',
                        width: 30,
                        height: 30,
                      ),
                    ];
                    if (index % 2 == 0) {
                      children = children.reversed.toList();
                    }
                    return Row(
                      mainAxisAlignment: index % 2 == 0
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: children,
                    );
                  },
                  itemCount: chats.length,
                ),
              )
            ],
          ),
        ),
```

# refresh with code

使用代码来执行刷新动画

* 定义key
``` dart
  final GlobalKey<PullToRefreshNotificationState> key =
      new GlobalKey<PullToRefreshNotificationState>();

        PullToRefreshNotification(
          key: key,    
```

* 使用

如果你的刷新头是根据DragOffset来设置高度，那么你用代码执行刷新的时候。你记得要设置notificationDragOffset

 ``` dart 
  key.currentState.show(notificationDragOffset: maxDragOffset);
 ```
# ☕️Buy me a coffee

![img](http://zmtzawqlp.gitee.io/my_images/images/qrcode.png)

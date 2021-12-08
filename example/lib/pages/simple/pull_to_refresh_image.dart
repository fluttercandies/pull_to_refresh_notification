import 'dart:async';

import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

@FFRoute(
  name: 'fluttercandies://PullToRefreshImage',
  routeName: 'PullToRefreshImage',
  description:
      'Show how to use pull to refresh notification to build a pull refresh image',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 1,
  },
)
class PullToRefreshImage extends StatefulWidget {
  @override
  _PullToRefreshImageState createState() => _PullToRefreshImageState();
}

class _PullToRefreshImageState extends State<PullToRefreshImage> {
  final GlobalKey<PullToRefreshNotificationState> key =
      GlobalKey<PullToRefreshNotificationState>();
  int listlength = 50;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          PullToRefreshNotification(
            color: Colors.blue,
            pullBackOnRefresh: true,
            maxDragOffset: 80,
            pullBackDuration: const Duration(seconds: 1),
            onRefresh: onRefresh,
            key: key,
            child: CustomScrollView(
              ///in case list is not full screen and remove ios Bouncing
              physics: const AlwaysScrollableClampingScrollPhysics(),
              slivers: <Widget>[
                PullToRefreshContainer(buildPulltoRefreshImage),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return Container(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'List item : ${listlength - index}',
                            style: const TextStyle(fontSize: 15.0),
                          ),
                          const Divider(
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
              child: const Icon(Icons.refresh),
              onPressed: () {
                key.currentState.show();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildPulltoRefreshImage(PullToRefreshScrollNotificationInfo info) {
    final double offset = info?.dragOffset ?? 0.0;
    Widget refreshWidget = Container();
    if (info?.refreshWidget != null) {
      refreshWidget = info.refreshWidget;
    }

    return SliverToBoxAdapter(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              height: 200.0 + offset,
              width: double.infinity,
              child: Image.asset(
                'assets/467141054.jpg',
                //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
                fit: BoxFit.cover,
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                refreshWidget,
                Container(
                  padding: const EdgeInsets.only(left: 5.0),
                  alignment: Alignment.center,
                  child: Text(
                    info?.mode?.toString() ?? '',
                    style: const TextStyle(fontSize: 12.0, inherit: false),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 2), () {
      setState(() {
        listlength += 10;
      });
      return true;
    });
  }
}

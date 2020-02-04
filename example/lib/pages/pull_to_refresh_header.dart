import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart'
    as demo;
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: "fluttercandies://PullToRefreshHeader",
    routeName: "PullToRefreshHeader",
    description:
        "Show how to use pull to refresh notification to build a pull refresh header,and hide it on refresh done")
class PullToRefreshHeader extends StatefulWidget {
  @override
  _PullToRefreshHeaderState createState() => _PullToRefreshHeaderState();
}

class _PullToRefreshHeaderState extends State<PullToRefreshHeader> {
  int listlength = 50;
  DateTime dateTimeNow = DateTime.now();
  final GlobalKey<PullToRefreshNotificationState> key =
      new GlobalKey<PullToRefreshNotificationState>();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Stack(
      children: <Widget>[
        PullToRefreshNotification(
          color: Colors.blue,
          onRefresh: onRefresh,
          maxDragOffset: demo.maxDragOffset,
          armedDragUpCancel: false,
          key: key,
          child: CustomScrollView(
            ///in case list is not full screen and remove ios Bouncing
            physics: AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                title: Text("PullToRefreshHeader"),
              ),
              PullToRefreshContainer(buildPulltoRefreshHeader),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return Container(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "List item : ${listlength - index}",
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
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
              key.currentState.show(notificationDragOffset: demo.maxDragOffset);
            },
          ),
        )
      ],
    ));
  }

  Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
    //print(info?.mode);
    //print(info?.dragOffset);
//    print("------------");
    var offset = info?.dragOffset ?? 0.0;
    var mode = info?.mode;
    Widget child;
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
                "error, click to retry",
                style: TextStyle(fontSize: 12.0, inherit: false),
              ),
            ),
          ));
    } else {
      child = demo.PullToRefreshHeader(info, dateTimeNow);
    }

    return SliverToBoxAdapter(
      child: child,
    );
  }

  bool success = true;
  Future<bool> onRefresh() {
    return Future.delayed(Duration(seconds: 2), () {
      setState(() {
        dateTimeNow = DateTime.now();
        listlength += 10;
      });
      success = !success;
      return success;
    });
  }
}

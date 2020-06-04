import 'dart:async';

import 'package:example/pages/push_to_refresh_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: 'fluttercandies://PullToRefreshHeader',
    routeName: 'PullToRefreshHeader',
    description:
        'Show how to use pull to refresh notification to build a pull refresh header,and hide it on refresh done')
class PullToRefreshHeader extends StatefulWidget {
  @override
  _PullToRefreshHeaderState createState() => _PullToRefreshHeaderState();
}

class _PullToRefreshHeaderState extends State<PullToRefreshHeader> {
  int listlength = 50;
  DateTime dateTimeNow = DateTime.now();
  final GlobalKey<PullToRefreshNotificationState> key =
      GlobalKey<PullToRefreshNotificationState>();

  @override
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
            physics: const AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              const SliverAppBar(
                pinned: true,
                title: Text('PullToRefreshHeader'),
              ),
              PullToRefreshContainer(buildPulltoRefreshHeader),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                return Container(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'List item : ${listlength - index}',
                          style: const TextStyle(
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
              key.currentState.show(notificationDragOffset: maxDragOffset);
            },
          ),
        )
      ],
    ));
  }

  Widget buildPulltoRefreshHeader(PullToRefreshScrollNotificationInfo info) {
    //print(info?.mode);
    //print(info?.dragOffset);
//    print('------------');
    final double offset = info?.dragOffset ?? 0.0;
    final RefreshIndicatorMode mode = info?.mode;

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
              padding: const EdgeInsets.only(left: 5.0),
              alignment: Alignment.center,
              child: const Text(
                'error, click to retry',
                style: TextStyle(fontSize: 12.0, inherit: false),
              ),
            ),
          ));
    } else {
      child = PullToRefreshHeaderWidget(info, dateTimeNow);
//      child = Container(
//        color: Colors.grey,
//        alignment: Alignment.bottomCenter,
//        height: offset,
//        width: double.infinity,
//        //padding: EdgeInsets.only(top: offset),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            refreshWiget,
//            Container(
//              padding: EdgeInsets.only(left: 5.0),
//              alignment: Alignment.center,
//              child: Text(
//                mode?.toString() ?? '',
//                style: TextStyle(fontSize: 12.0, inherit: false),
//              ),
//            )
//          ],
//        ),
//      );
    }

    return SliverToBoxAdapter(
      child: child,
    );
  }

  bool success = false;
  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 2), () {
      if (success == false) {
        success = true;
        return false;
      }
      if (success) {
        setState(() {
          dateTimeNow = DateTime.now();
          listlength += 10;
        });
      }

      return success;
    });
  }
}

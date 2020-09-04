import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
  name: 'fluttercandies://PullToRefreshAppbar',
  routeName: 'PullToRefreshAppbar',
  description:
      'Show how to use pull to refresh notification to build a pull refresh appbar',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 0,
  },
)
class PullToRefreshAppbar extends StatefulWidget {
  @override
  _PullToRefreshAppbarState createState() => _PullToRefreshAppbarState();
}

class _PullToRefreshAppbarState extends State<PullToRefreshAppbar> {
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
          onRefresh: onRefresh,
          key: key,
          child: CustomScrollView(
            ///in case list is not full screen and remove ios Bouncing
            physics: const AlwaysScrollableClampingScrollPhysics(),
            slivers: <Widget>[
              PullToRefreshContainer(buildPulltoRefreshAppbar),
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
    ));
  }

  Widget buildPulltoRefreshAppbar(PullToRefreshScrollNotificationInfo info) {
    final double offset = info?.dragOffset ?? 0.0;

    return SliverAppBar(
        pinned: true,
        title: const Text('PullToRefreshAppbar'),
        centerTitle: true,
        expandedHeight: 200.0 + offset,
        actions: <Widget>[
          UnconstrainedBox(
            child: info?.refreshWiget ?? const Icon(Icons.more_horiz),
          )
        ],
        flexibleSpace: FlexibleSpaceBar(
            //centerTitle: true,
            title: Text(
              info?.mode?.toString() ?? '',
              style: const TextStyle(fontSize: 10.0),
            ),
            collapseMode: CollapseMode.pin,
            background: Image.asset(
              'assets/467141054.jpg',
              //fit: offset > 0.0 ? BoxFit.cover : BoxFit.fill,
              fit: BoxFit.cover,
            )));
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

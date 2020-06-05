import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_candies_demo_library/flutter_candies_demo_library.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(
    name: 'fluttercandies://PullToRefreshCandies',
    routeName: 'PullToRefreshCandies',
    description:
        'Show how to use pull to refresh notification to build a pull candies animation')
class PullToRefreshCandies extends StatefulWidget {
  @override
  _PullToRefreshCandiesState createState() => _PullToRefreshCandiesState();
}

class _PullToRefreshCandiesState extends State<PullToRefreshCandies> {
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
            onRefresh: onRefresh,
            maxDragOffset: maxDragOffset,
            armedDragUpCancel: false,
            key: key,
            child: CustomScrollView(
              ///in case list is not full screen and remove ios Bouncing
              physics: const AlwaysScrollableClampingScrollPhysics(),
              slivers: <Widget>[
                const SliverAppBar(
                  title: Text('PullToRefreshCandies'),
                ),
                PullToRefreshContainer(
                    (PullToRefreshScrollNotificationInfo info) {
                  final double offset = info?.dragOffset ?? 0.0;
                  final Widget child = Container(
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
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'List item : ${listlength - index}',
                            style: const TextStyle(fontSize: 15.0),
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

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 2), () {
      setState(() {
        listlength += 10;
      });
      return true;
    });
  }
}

class RefreshLogo extends StatefulWidget {
  const RefreshLogo({
    Key key,
    @required this.mode,
    @required this.offset,
  }) : super(key: key);
  final double offset;
  final RefreshIndicatorMode mode;

  @override
  _RefreshLogoState createState() => _RefreshLogoState();
}

class _RefreshLogoState extends State<RefreshLogo>
    with TickerProviderStateMixin {
  AnimationController rotateController;
  CurvedAnimation rotateCurveAnimation;
  Animation<double> rotateAnimation;
  double angle = 0.0;

  bool animating = false;

  @override
  void initState() {
    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    rotateCurveAnimation = CurvedAnimation(
      parent: rotateController,
      curve: Curves.ease,
    );
    rotateAnimation =
        Tween<double>(begin: 0.0, end: 2.0).animate(rotateCurveAnimation);
    super.initState();
  }

  void startAnimate() {
    animating = true;
    rotateController.repeat();
  }

  void stopAnimate() {
    animating = false;
    rotateController
      ..stop()
      ..reset();
  }

  Widget get logo => Image.asset(
        'assets/lollipop-without-stick.png',
        height: math.min(widget.offset, 50),
      );

  @override
  Widget build(BuildContext context) {
    if (widget.mode == null) {
      return Container();
    }
    if (!animating && widget.mode == RefreshIndicatorMode.refresh) {
      startAnimate();
    } else if (widget.offset < 10.0 &&
        animating &&
        widget.mode != RefreshIndicatorMode.refresh) {
      stopAnimate();
    }
    return Container(
      width: math.min(widget.offset, 50),
      height: math.min(widget.offset, 50),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey,
          ),
        ],
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Image.asset(
              'assets/lollipop.png',
            ),
          ),
          if (animating)
            RotationTransition(
              turns: rotateAnimation,
              child: logo,
            )
          else
            logo,
        ],
      ),
    );
  }
}

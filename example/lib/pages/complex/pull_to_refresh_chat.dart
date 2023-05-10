import 'package:english_words/english_words.dart';
import 'package:extended_list/extended_list.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';

@FFRoute(
  name: 'fluttercandies://PullToRefreshChat',
  routeName: 'PullToRefreshChat',
  description:
      'Show how to use pull to refresh notification for reverse list like chat list.',
  exts: <String, dynamic>{
    'group': 'Complex',
    'order': 2,
  },
)
class PullToRefreshChat extends StatefulWidget {
  @override
  _PullToRefreshChatState createState() => _PullToRefreshChatState();
}

class _PullToRefreshChatState extends State<PullToRefreshChat> {
  List<String> chats = <String>[];
  @override
  void initState() {
    chats.addAll(generateWordPairs().take(18).map((WordPair e) => e.asString));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PullToRefreshNotification(
          onRefresh: onRefresh,
          maxDragOffset: 48,
          armedDragUpCancel: false,
          reverse: true,
          child: Column(
            children: <Widget>[
              PullToRefreshContainer(
                  (PullToRefreshScrollNotificationInfo? info) {
                final double offset = info?.dragOffset ?? 0.0;

                //loading history data
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
        Positioned(
          right: 20.0,
          bottom: 20.0,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                // insert new data
                chats.insert(0, generateWordPairs().take(1).first.asString);
              });
            },
          ),
        ),
      ],
    );
  }

  Future<bool> onRefresh() {
    return Future<bool>.delayed(const Duration(seconds: 2), () {
      setState(() {
        chats.addAll(
            generateWordPairs().take(5).map((WordPair e) => e.asString));
      });
      return true;
    });
  }
}

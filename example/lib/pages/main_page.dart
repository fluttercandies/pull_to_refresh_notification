import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';
import 'package:oktoast/oktoast.dart';

import '../example_route.dart';
import '../example_routes.dart' as example_routes;
@FFRoute(
  name: 'fluttercandies://mainpage',
  routeName: 'MainPage',
)
class MainPage extends StatelessWidget {
MainPage() {
    final List<String> routeNames = <String>[];
    routeNames.addAll(example_routes.routeNames);
    routeNames.remove('fluttercandies://mainpage');
    routes.addAll(routeNames
        .map<RouteResult>((String name) => getRouteResult(name: name)));
  }
  final List<RouteResult> routes = <RouteResult>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('pull to refresh'),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext c, int index) {
          final RouteResult page = routes[index];
          return Container(
              margin: const EdgeInsets.all(20.0),
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      (index + 1).toString() + '.' + page.routeName,
                      //style: TextStyle(inherit: false),
                    ),
                    Text(
                      page.description,
                      style: TextStyle(color: Colors.grey),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, routes[index].name);
                },
              ));
        },
        itemCount: routes.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///clear memory
          clearMemoryImageCache();

          ///clear local cahced
          clearDiskCachedImages().then((bool done) {
            showToast(done ? 'clear succeed' : 'clear failed',
                position: const ToastPosition(align: Alignment.center));
          });
        },
        child: const Text(
          'clear cache',
          textAlign: TextAlign.center,
          style: TextStyle(
            inherit: false,
          ),
        ),
      ),
    );
  }
}

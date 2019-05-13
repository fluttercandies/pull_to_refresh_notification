## [0.2.5]

* fix issue that AlwaysScrollableClampingScrollPhysics is not working in new flutter version 

## [0.2.4]

* add notificationDragOffset parameter for show method in PullToRefreshNotificationState
  it's used to change offset when call refresh by coding
* show how to call refresh by coding

## [0.2.3]

* add AlwaysScrollableClampingScrollPhysics in case list is not full screen and remove ios Bouncing.

## [0.2.0]

* add armedDragUpCancel property.
  //Dragged far enough that an up event will run the onRefresh callback.
  //when use drag up,whether should cancel refresh
  final bool armedDragUpCancel;

## [0.1.5]

* Format code.

## [0.1.4]

* Remove dead code.

## [0.1.3]

* Fix issue in case negative value of _dragOffset

## [0.1.2]

* Fix issue in case notification.depth != 0

## [0.1.1]

* Fix threshold to refresh not right when set maxDragOffset

## [0.1.0]

* Upgrade Some Commments.

## [0.0.1]

* Initial Open Source release.
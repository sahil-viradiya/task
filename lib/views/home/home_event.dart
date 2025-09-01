abstract class HomeEvent {
  const HomeEvent();
}

class ToggleAlerts extends HomeEvent {
  final bool isEnabled;
  const ToggleAlerts({required this.isEnabled});

}

class ChangeTab extends HomeEvent {
  final int tabIndex;
  const ChangeTab({required this.tabIndex});
}

class ChangeBottomNav extends HomeEvent {
  final int navIndex;
  const ChangeBottomNav({required this.navIndex});

}

class SearchBookings extends HomeEvent {
  final String query;
  const SearchBookings({required this.query});
}

class FlowItemClosed extends HomeEvent {
  final int index;

  const FlowItemClosed({required this.index});
}

class RefreshData extends HomeEvent {}
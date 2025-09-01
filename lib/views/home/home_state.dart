
import 'home_model.dart';

abstract class HomeState{
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<FlowData> flowDataList;
  final bool isAlertsEnabled;
  final int selectedTab;
  final int bottomNavIndex;
  final String searchQuery;
  final bool isRefreshing;

  const HomeLoaded({
    required this.flowDataList,
    this.isAlertsEnabled = true,
    this.selectedTab = 0,
    this.bottomNavIndex = 0,
    this.searchQuery = '',
    this.isRefreshing = false,
  });

  HomeLoaded copyWith({
    List<FlowData>? flowDataList,
    bool? isAlertsEnabled,
    int? selectedTab,
    int? bottomNavIndex,
    String? searchQuery,
    bool? isRefreshing,

  }) {
    return HomeLoaded(
      flowDataList: flowDataList ?? this.flowDataList,
      isAlertsEnabled: isAlertsEnabled ?? this.isAlertsEnabled,
      selectedTab: selectedTab ?? this.selectedTab,
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});

}

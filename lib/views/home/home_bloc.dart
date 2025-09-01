import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../const/const_text.dart';
import 'home_event.dart';
import 'home_model.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  // Initialize with HomeLoaded state directly using _initialFlowData
  HomeBloc() : super(_createInitialState()) {
    on<ToggleAlerts>(_onToggleAlerts);
    on<ChangeTab>(_onChangeTab);
    on<ChangeBottomNav>(_onChangeBottomNav);
    on<SearchBookings>(_onSearchBookings);
    on<RefreshData>(_onRefreshData);
    on<FlowItemClosed>(_onFlowItemClosed);
  }
  static final List<FlowData> _initialFlowData = [
    FlowData(
      title: ConstText.personalInfo,
      flowLabel: [
        ConstText.clickProfile,
        ConstText.personalInfo,
        ConstText.setProfilePic,
        ConstText.submit,
      ],
    ),
    FlowData(
      title: ConstText.addVehicle,
      flowLabel: [
        ConstText.clickProfile,
        ConstText.manageVehicle,
        ConstText.addButton,
        ConstText.addDetails,
        ConstText.submit,
      ],
    ),
    FlowData(
      title: ConstText.addDriver,
      flowLabel: [
        ConstText.clickProfile,
        ConstText.manageDriver,
        ConstText.addButton,
        ConstText.addDetails,
        ConstText.submit,
      ],
    ),
  ];
  // Static method to create initial state with _initialFlowData
  static HomeLoaded _createInitialState() {
    return HomeLoaded(
      flowDataList: _initialFlowData,
      // Add other default properties
      isAlertsEnabled: false,
      selectedTab: 0,
      bottomNavIndex: 0,
      searchQuery: '',
    );
  }

  void _onToggleAlerts(ToggleAlerts event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(isAlertsEnabled: event.isEnabled));
    }
  }

  void _onChangeTab(ChangeTab event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(selectedTab: event.tabIndex));
    }
  }

  void _onChangeBottomNav(ChangeBottomNav event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(bottomNavIndex: event.navIndex));
    }
  }

  void _onSearchBookings(SearchBookings event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      emit((state as HomeLoaded).copyWith(searchQuery: event.query));
    }
  }

  Future<void> _onRefreshData(RefreshData event, Emitter<HomeState> emit) async {
    //emit(HomeLoading());
    try {
      // Your existing refresh logic here
      // Reset flow data on refresh
      emit(HomeLoaded(
        flowDataList: List.from(_initialFlowData),
        // Add your other properties here
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onFlowItemClosed(FlowItemClosed event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedList = List<FlowData>.from(currentState.flowDataList);
      if (event.index >= 0 && event.index < updatedList.length) {
        updatedList.removeAt(event.index);
      }
      emit(currentState.copyWith(flowDataList: updatedList));
    }
  }
}

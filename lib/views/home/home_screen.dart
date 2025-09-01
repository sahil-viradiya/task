import 'package:bottom_navbar_with_indicator/bottom_navbar_with_indicator.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../const/const_app_fonts.dart';
import '../../const/const_app_images.dart';
import '../../const/const_color.dart';
import '../../const/const_text.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import 'widgets/component.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Widget builder(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: const HomePage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${ConstText.error} ${state.message}',
                    style: AppFonts.ralewayStyle(
                      size: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(ConstText.retry,
                      style: AppFonts.ralewayStyle(
                        size: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (state is HomeLoaded) {
          return _HomePageContent(state: state);
        }
        return const Scaffold(body: SizedBox());
      },
    );
  }
}

class _HomePageContent extends StatefulWidget {
  final HomeLoaded state;

  const _HomePageContent({required this.state});

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController = TextEditingController();

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        context.read<HomeBloc>().add(ChangeTab(tabIndex: _tabController.index));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLogo(),
            _buildAlertsToggle(),
            _buildHelpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      AppImages.splash,
      width: 120,
      height: 40,
      fit: BoxFit.fill,
      errorBuilder: (context, exception, stackTrace) => const SizedBox(),
    );
  }

  Widget _buildAlertsToggle() {
    return AppBarContainer(
      title: ConstText.alerts,
      child: Transform.scale(
        scale: 0.8,
        child: Switch(
          value: widget.state.isAlertsEnabled,
          activeTrackColor: AppColors.primaryColor,
          activeColor: AppColors.white,
          inactiveThumbColor: AppColors.hintTextColor,
          inactiveTrackColor: AppColors.white,
          onChanged: (value) {
            context.read<HomeBloc>().add(ToggleAlerts(isEnabled: value));
          },
        ),
      ),
    );
  }

  Widget _buildHelpButton() {
    return AppBarContainer(
      title: ConstText.help,
      child: const Icon(Icons.support_agent, color: Colors.redAccent),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildTabBar(),
          const SizedBox(height: 10),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.all(8),
        indicatorColor: AppColors.primaryColor,
        dividerColor: Colors.transparent,
        unselectedLabelColor: AppColors.black,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColors.primaryColor,
        ),
        unselectedLabelStyle: AppFonts.ralewayStyle(
          fontWeight: FontWeight.w500,
          color: AppColors.black,
        ),
        labelStyle: AppFonts.ralewayStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.white,
        ),
        indicatorPadding: EdgeInsets.zero,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 0,
        tabs: const [
          Tab(text: ConstText.bookings),
          Tab(text: ConstText.freeVehicles),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        BookingsTab(
          searchController: _searchController,
          onRefresh: () => {},//context.read<HomeBloc>().add(RefreshData()),
          onSearch: (query) => context.read<HomeBloc>().add(SearchBookings(query: query)),
          flowDataList: widget.state.flowDataList,
          onFlowItemClose: (index) => context.read<HomeBloc>().add(FlowItemClosed(index: index)),
        ),
        FreeVehiclesTab(
          onBookVehicle: () {
            context.read<HomeBloc>().add(const ChangeBottomNav(navIndex: 0));
            context.read<HomeBloc>().add(const ChangeTab(tabIndex: 0));
            _tabController.animateTo(0);
            _searchController.clear();
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // Bottom Navigation Bar
            CustomLineIndicatorBottomNavbar(
              currentIndex: widget.state.bottomNavIndex,
              indicatorType: IndicatorType.top,
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primaryColor,
              lineIndicatorWidth: 3,
              selectedFontSize: 10,
              selectedIconSize: 24,
              unSelectedColor: AppColors.hintTextColor,
              unselectedFontSize: 10,
              unselectedIconSize: 24,
              splashColor: AppColors.white,
              enableLineIndicator: true,
              customBottomBarItems: [
                CustomBottomBarItems(
                  isAssetsImage: false,
                  icon: Icons.home_outlined,
                  label: ConstText.market,
                ),
                CustomBottomBarItems(
                  isAssetsImage: false,
                  icon: Icons.calendar_today_outlined,
                  label: ConstText.myBookings,
                ),
                CustomBottomBarItems(
                  isAssetsImage: false,
                  icon: Icons.add_circle_outline, // Empty space for center button
                  label: '',
                ),
                CustomBottomBarItems(
                  isAssetsImage: false,
                  icon: Icons.chat_bubble_outline,
                  label: ConstText.chat,
                ),
                CustomBottomBarItems(
                  isAssetsImage: false,
                  icon: Icons.person_outline,
                  label: ConstText.profile,
                ),
              ],
              onTap: (index) {
                if (index != 2) {
                  // Skip center button tap
                  context.read<HomeBloc>().add(ChangeBottomNav(navIndex: index));
                }
              },
            ),
            // Center Floating Action Button
            Positioned(
              top: 0,
              bottom: 0,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.addBtnColor, // Dark blue-gray color
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () {
                      // Handle center button tap
                    },
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

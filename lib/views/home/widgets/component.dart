import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../const/const_app_fonts.dart';
import '../../../const/const_color.dart';
import '../../../const/const_text.dart';
import '../home_model.dart';
import 'add_driver_flow.dart';

class AppBarContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const AppBarContainer({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppFonts.ralewayStyle(
                fontWeight: FontWeight.bold,
                size: 14,
                color: AppColors.black,
              ),
            ),
            const SizedBox(width: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class BookingsTab extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onRefresh;
  final ValueChanged<String> onSearch;
  final List<FlowData> flowDataList;
  final ValueChanged<int> onFlowItemClose;

  const BookingsTab({
    super.key,
    required this.searchController,
    required this.onRefresh,
    required this.onSearch,
    required this.flowDataList,
    required this.onFlowItemClose,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.black,
      backgroundColor: AppColors.white,
      strokeWidth: 3,
      onRefresh: () async {
        onRefresh();
        await Future.delayed(const Duration(seconds: 2));
      },
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
        children: [
          _buildSearchSection(),
          const SizedBox(height: 10),
          _buildServicesSection(),
          const SizedBox(height: 10),
          _buildInstructionsSection(),
          if (flowDataList.isNotEmpty) ...[
            const SizedBox(height: 10),
            _buildFlowSections(),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(child: _buildSearchField()),
        const SizedBox(width: 10),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      cursorColor: AppColors.black,
      style: AppFonts.ralewayStyle(
        size: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
      ),
      onChanged: onSearch,
      decoration: InputDecoration(
        hintText: ConstText.searchBookingHint,
        hintStyle: const TextStyle(fontSize: 12),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.search, color: AppColors.black),
        ),
        prefixIconConstraints: const BoxConstraints.tightFor(width: 30, height: 40),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(8),
      ),
    );
  }

  Widget _buildFilterButton() {
    return InkWell(
      onTap: () {
        // Handle filter tap
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.tune, color: Colors.redAccent, size: 25),
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          ServiceCard(
            icon: Icons.directions_car,
            iconColor: Colors.orange,
            backgroundColor: Colors.orange,
            title: ConstText.carLoan,
          ),
          ServiceCard(
            icon: Icons.security,
            iconColor: Colors.orange,
            backgroundColor: Colors.orange,
            title: ConstText.carInsurance,
          ),
          ServiceCard(
            icon: Icons.play_circle_filled,
            iconColor: Colors.orange,
            backgroundColor: Colors.orange,
            title: ConstText.tutorialVideos,
          ),
          ServiceCard(
            icon: Icons.rule,
            iconColor: Colors.orange,
            backgroundColor: Colors.orange,
            title: ConstText.rulesAndRegulations,
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        ConstText.infoNote,
        textAlign: TextAlign.justify,
        style: AppFonts.ralewayStyle(
          size: 15,
          color: Colors.black87,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildFlowSections() {
    if (flowDataList.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: flowDataList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final flow = flowDataList[index];
        return AddVehicleFlow(
          title: flow.title,
          flowLabel: flow.flowLabel,
          onClose: () {onFlowItemClose(index);},
        );
      },
    );
  }

}

class FreeVehiclesTab extends StatelessWidget {
  final VoidCallback onBookVehicle;

  const FreeVehiclesTab({super.key, required this.onBookVehicle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          ConstText.noVehicleAvailable,
          textAlign: TextAlign.center,
          style: AppFonts.ralewayStyle(
            size: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 10),
        AppButton(
          elevation: 0,
          color: AppColors.primaryColor,
          shapeBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          text: ConstText.bookVehicle,
          textColor: AppColors.white,
          textStyle: AppFonts.ralewayStyle(
            size: 16,
            fontWeight: FontWeight.w600,
          ),
          onTap: onBookVehicle,
        ),
      ],
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String title;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Handle tap action here
        },
        child: Container(
          height: 70,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          padding: EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColors.bgColor,
              borderRadius: BorderRadius.circular(8)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: iconColor,
              ),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryTextColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
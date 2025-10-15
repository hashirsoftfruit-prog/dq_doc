import 'package:dqueuedoc/controller/managers/state_manager.dart';
import 'package:dqueuedoc/model/helper/service_locator.dart';
import 'package:dqueuedoc/view/theme/constants.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNav extends StatelessWidget {
  final int btNavIndex;
  final double maxWidth;
  final double h10p;

  const CustomBottomNav({
    super.key,
    required this.btNavIndex,
    required this.maxWidth,
    required this.h10p,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: h10p * 1.2,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            index: 0,
            currentIndex: btNavIndex,
            icon: "assets/images/btnav_profile.svg",
            title: "Profile",
          ),
          _buildNavItem(
            index: 1,
            currentIndex: btNavIndex,
            icon: "assets/images/btnav_bookings.svg",
            title: "Consultations",
          ),
          _buildHomeButton(btNavIndex),
          _buildNavItem(
            index: 3,
            currentIndex: btNavIndex,
            icon: "assets/images/btnav_analytics.svg",
            title: "Analytics",
          ),
          _buildNavItem(
            index: 4,
            currentIndex: btNavIndex,
            icon: "assets/images/btnav_forum.svg",
            title: "Forum",
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required String icon,
    required String title,
  }) {
    final bool isActive = index == currentIndex;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => getIt<StateManager>().changeHomeIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          // color: isActive
          //     ? Colours.primaryblue.withValues(alpha: 0.08)
          //     : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: AnimatedScale(
          scale: isActive ? 1 : 0.9,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutBack,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                width: 26,
                height: isActive ? 26 : 24,
                colorFilter: ColorFilter.mode(
                  isActive ? Colours.primaryblue : const Color(0xff5B5B5B),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: t400_10.copyWith(
                  fontSize: isActive ? 14 : 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive
                      ? Colours.primaryblue
                      : const Color(0xff5B5B5B),
                ),
                child: Text(title),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton(int currentIndex) {
    bool isActive = currentIndex == 2;

    return InkWell(
      onTap: () => getIt<StateManager>().changeHomeIndex(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        // curve: Curves.easeOutBack,
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          // Always use circle (no switching between circle/rectangle)
          shape: BoxShape.circle,
          color: isActive ? Colours.primaryblue : Colors.white,
          border: Border.all(
            color: isActive ? Colours.primaryblue : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive
                  ? Colours.primaryblue.withValues(alpha: 0.4)
                  : Colors.transparent,
              blurRadius: isActive ? 12 : 0.0,
              spreadRadius: isActive ? 2 : 0.0,
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            "assets/images/btnav_home.svg",
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              isActive ? Colors.white : Colours.primaryblue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

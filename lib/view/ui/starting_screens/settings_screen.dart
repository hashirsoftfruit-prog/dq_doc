import 'package:dqueuedoc/controller/managers/auth_manager.dart';
import 'package:dqueuedoc/view/theme/constants.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final data = Provider.of<AuthManager>(context).docDetailsModel;

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;

        double h1p = maxHeight * 0.01;

        return Consumer<AuthManager>(
          builder: (context, manager, _) {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: kToolbarHeight,
                    collapsedHeight: kToolbarHeight,
                    pinned: true,
                    flexibleSpace: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: h1p * 0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12.0,
                                        ),
                                        child: SvgPicture.asset(
                                          "assets/images/back-arrow.svg",

                                          // color: Colors.white,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Row(
                                      children: [
                                        Text("Settings", style: t500_20),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),

                                  // verticalSpace(16),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      // shrinkWrap: true,
                      children: [
                        ListTile(
                          title: Text(
                            "Sound Notificaiton",
                            style: t400_18.copyWith(color: Colors.black),
                          ),
                          trailing: Switch(
                            onChanged: (val) {
                              manager.setSoundNotificationEnabled(val);
                            },
                            value:
                                manager.docDetailsModel!.isSoundEnabled ??
                                false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

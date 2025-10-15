import 'package:dqueuedoc/controller/managers/settlements_manager.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../controller/managers/state_manager.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/widgets.dart';

class SettlementHistory extends StatefulWidget {
  const SettlementHistory({super.key});

  @override
  State<SettlementHistory> createState() => _SettlementHistoryState();
}

class _SettlementHistoryState extends State<SettlementHistory> {
  // AvailableDocsModel docsData;
  int index = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<SettlementsManager>().getSettlemntHistory(index: index);
    });
    _controller.addListener(_scrollListener);
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      index++;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getIt<SettlementsManager>().getSettlemntHistory(index: index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tableTitleTxt(String title) {
      return Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colours.primaryblue.withOpacity(0.2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.textStyle15b,
            ),
          ),
        ),
      );
    }

    Widget tableSubtitleTxt(String title) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyles.textStyle15c,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        // List<String> tabHeads = ["Previous","Follow Ups"];

        return Consumer<SettlementsManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              // appBar: getIt<SmallWidgets>().appBarWidget(
              //   title: 'Settlements',
              //   height: h10p,
              //   width: w10p,
              //   fn: () {
              //     Navigator.pop(context);
              //   },
              // ),
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
                        padding: EdgeInsets.symmetric(horizontal: w1p * 0),
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
                                        Text("Settlements", style: t500_20),
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
                    child: pad(
                      horizontal: w1p * 5,
                      child: RefreshIndicator(
                        onRefresh: () async {
                          await getIt<SettlementsManager>().getSettlemntHistory(
                            index: index,
                          );
                        },
                        child:
                            mgr.settlements == null || mgr.settlements!.isEmpty
                            ? SizedBox(
                                width: double.infinity,
                                height:
                                    constraints.maxHeight *
                                    0.7, // give it some height to center
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        size: 96,
                                        color: clr5D5AAB,
                                      ),
                                      verticalSpace(10),
                                      Text(
                                        'No settlements found',
                                        style: t500_16.copyWith(
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView(
                                controller: _controller,
                                children: [
                                  verticalSpace(h1p * 2),
                                  mgr.settlements != null &&
                                          mgr.settlements!.isNotEmpty
                                      ? Row(
                                          children: [
                                            tableTitleTxt("Interval"),
                                            tableTitleTxt("Amount"),
                                            tableTitleTxt("Withdraw"),
                                          ],
                                        )
                                      : const SizedBox(),
                                  mgr.settlementLoader == true &&
                                          mgr.settlements!.isEmpty
                                      ? const Entry(
                                          yOffset: -100,
                                          // scale: 20,
                                          delay: Duration(milliseconds: 0),
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease,
                                          child: Padding(
                                            padding: EdgeInsets.all(28.0),
                                            child: AppLoader(),
                                          ),
                                        )
                                      : mgr.settlements != null &&
                                            mgr.settlements!.isNotEmpty
                                      ? Entry(
                                          xOffset: -1000,
                                          // scale: 20,
                                          delay: const Duration(
                                            milliseconds: 0,
                                          ),
                                          duration: const Duration(
                                            milliseconds: 700,
                                          ),
                                          curve: Curves.ease,
                                          child: Entry(
                                            opacity: .5,
                                            // angle: 3.1415,
                                            delay: const Duration(
                                              milliseconds: 0,
                                            ),
                                            duration: const Duration(
                                              milliseconds: 1500,
                                            ),
                                            curve: Curves.decelerate,
                                            child: Column(
                                              children: mgr.settlements!.map((
                                                item,
                                              ) {
                                                var index = mgr.settlements!
                                                    .indexOf(item);

                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    bottom: h1p * 1,
                                                  ),
                                                  child: InkWell(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    onTap: () async {
                                                      // if(coupon.applicable==true){
                                                      //   // await applyCoupnFn(coupon.couponCode??"");
                                                      //
                                                      // }else{
                                                      //
                                                      //   showTopSnackBar(
                                                      //       Overlay.of(context),
                                                      //       CustomSnackBar.error(backgroundColor:Colours.toastRed,
                                                      //         message:
                                                      //         "This coupon is not applicable",
                                                      //       ));
                                                      // }
                                                    },
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            tableSubtitleTxt(
                                                              '${getIt<StateManager>().getFormattedDate2(item.startDate!)}-${getIt<StateManager>().getFormattedDate2(item.endDate!)}',
                                                            ),
                                                            tableSubtitleTxt(
                                                              item.totalAmountPaid ??
                                                                  "0",
                                                            ),
                                                            tableSubtitleTxt(
                                                              getIt<
                                                                    StateManager
                                                                  >()
                                                                  .getFormattedDate2(
                                                                    item.settledDate!,
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
                                                        mgr.settlementLoader ==
                                                                    true &&
                                                                mgr
                                                                    .settlements!
                                                                    .isNotEmpty &&
                                                                index ==
                                                                    mgr.settlements!.length -
                                                                        1
                                                            ? const CircularProgressIndicator()
                                                            : const SizedBox(),
                                                      ],
                                                      // UpcomeAppointmentBox(h1p: h1p,w1p: w1p,date: e.date!=null?getIt<StateManager>().getFormattedDate(e.date!):""
                                                      //     ?? "",name:e.doctorFirstName ,type: e.speciality,
                                                      //     sheduledTime:"4.00 PM To 6.00 PM"
                                                      // ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                      ),
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

import 'package:dqueuedoc/model/core/revenue_screen_model.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:dqueuedoc/view/theme/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

import '../../../controller/managers/settlements_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/analytics_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';

class RevenueScreen extends StatelessWidget {
  final RevenueModel revenueData;
  const RevenueScreen(this.revenueData, {super.key});

  @override
  Widget build(BuildContext context) {
    // final DateRangePickerController _controller = DateRangePickerController();
    var noteC = TextEditingController();
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        getBtn({required String title}) {
          return Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w1p * 2,
                    vertical: h1p * 2,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colours.primaryblue,
                    ),
                    child: pad(
                      vertical: 8,
                      child: Text(
                        textAlign: TextAlign.center,
                        title,
                        style: TextStyles.prescript3,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        // getRow({required String title, required String val}){
        //   return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Text(title,style: TextStyles.analyticsTxt,),
        //       Text('$val Patients',style: TextStyles.analyticsTxt,),
        //     ],
        //   );
        // }

        subtitle(String title) {
          return Padding(
            padding: EdgeInsets.only(bottom: h1p * 1.5, top: h1p * 2),
            child: Text(title, style: TextStyles.analyticsTxt2),
          );
        }

        return ProgressHUD(
          indicatorColor: Colours.primaryblue,
          backgroundColor: Colours.primaryblue.withOpacity(0.1),
          padding: const EdgeInsets.all(24),
          child: Builder(
            builder: (context) {
              final progress = ProgressHUD.of(context);
              return Scaffold(
                backgroundColor: Colors.white,

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
                                          Text("Revenue", style: t500_20),
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            subtitle("Weekly Report"),
                            TableWidget(
                              revenueData.patientDetails?.dailyPatientCount ??
                                  [],
                            ),
                            verticalSpace(h1p * 0),
                            subtitle("Remarks"),
                            MyTextFormField2(
                              type: "char",
                              onsubmit: (val) {},
                              cntrolr: noteC,
                              minLine: 2,
                              maxLine: 2,
                              hnt: "Note",
                              isNumber: false,
                            ),
                            verticalSpace(h1p * 2),
                            BillBox(
                              w1p: w1p,
                              h1p: h1p,
                              serviceFee: '0',
                              subTotal:
                                  revenueData
                                      .patientDetails
                                      ?.totalWeeklyRevenue ??
                                  "0",
                              totalAmt:
                                  revenueData
                                      .patientDetails
                                      ?.totalWeeklyRevenue ??
                                  "0",
                            ),
                            verticalSpace(h1p * 2),
                            InkWell(
                              onTap: () async {
                                progress!.show();
                                var result = await getIt<SettlementsManager>()
                                    .requestWithdrawal(
                                      startDate: getIt<StateManager>()
                                          .stringToDateTime(
                                            revenueData.startDate!,
                                          ),
                                      endDate: getIt<StateManager>()
                                          .stringToDateTime(
                                            revenueData.endDate!,
                                          ),
                                      note: noteC.text,
                                      revenue:
                                          revenueData
                                              .patientDetails
                                              ?.totalWeeklyRevenue ??
                                          "0",
                                    );
                                if (result.status == true) {
                                  // Fluttertoast.showToast(msg: result.message??"");
                                  Navigator.pop(context, result.message);
                                  // Navigator.push(context, MaterialPageRoute(builder: (_)=>RevenueScreen(result)));
                                } else {
                                  Fluttertoast.showToast(
                                    msg: result.message ?? "",
                                  );
                                }

                                progress.dismiss();
                              },
                              child: getBtn(title: "Request Payment"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class TableWidget extends StatelessWidget {
  final List<DailyPatientCount>? dailyPatientCount;
  const TableWidget(this.dailyPatientCount, {super.key});
  @override
  Widget build(BuildContext context) {
    Text tableTitleTxt(String title) {
      return Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.textStyle15,
      );
    }

    Text tableSubTitleTxt(String title) {
      return Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.textStyle16,
      );
    }

    return Table(
      border: TableBorder.all(color: Colors.transparent),
      columnWidths: const <int, TableColumnWidth>{
        0: FlexColumnWidth(),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        // Header row
        TableRow(
          decoration: BoxDecoration(
            color: Colours.primaryblue.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          children: <Widget>[
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: tableTitleTxt('Date'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: tableTitleTxt('Consults'),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: tableTitleTxt('Revenue'),
              ),
            ),
          ],
        ),
        // Data rows
        for (int i = 0; i < dailyPatientCount!.length; i++)
          TableRow(
            decoration: BoxDecoration(
              color: i % 2 != 0
                  ? Colours.btnHash.withOpacity(0.3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            children: <Widget>[
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: tableSubTitleTxt(
                    '${getIt<StateManager>().getMonthDayFromString(dailyPatientCount?[i].date ?? "")}',
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: tableSubTitleTxt(
                    '${dailyPatientCount?[i].dailyBookingsCount ?? ""}',
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: tableSubTitleTxt(
                    '${dailyPatientCount?[i].dailyRevenue ?? ""}',
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

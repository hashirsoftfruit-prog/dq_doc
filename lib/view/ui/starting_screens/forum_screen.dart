import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:entry/entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/managers/home_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../model/core/fou_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/widgets.dart';
import 'forum_details_screen.dart';
import 'forum_search_screen.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  // int forumId;
  // ForumScreen(this.forumId);
  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  // AvailableDocsModel docsData;
  int index = 1;

  //
  // @override
  // void initState() {

  //
  // }
  @override
  void initState() {
    getIt<HomeManager>().getForumList(isRefresh: true);
    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      index++;
      getIt<HomeManager>().getForumList();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  var responseConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        // double h10p = maxHeight * 0.1;
        // double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,

              // appBar: getIt<SmallWidgets>().appBarWidget(
              //     hideBackBtn: true,
              //     title: "Forum",
              //     height: h10p * 0.9,
              //     width: w10p,
              //     fn: () {
              //       Navigator.pop(context);
              //     },
              //     child: InkWell(
              //         onTap: () {
              //           Navigator.push(context,
              //               MaterialPageRoute(builder: (_) => ForumSearchScreen()));
              //         },
              //         child: Padding(
              //           padding: EdgeInsets.symmetric(horizontal: w1p * 4),
              //           child: const Icon(
              //             Icons.search,
              //             key: ValueKey<int>(2),
              //             color: Colors.white,
              //           ),
              //         ))),
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
                        padding: EdgeInsets.only(left: w1p * 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(), const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Forum", style: t500_20),
                                  InkWell(
                                    onTap: () {
                                      log("clicked");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const ForumSearchScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: w1p * 0,
                                      ),
                                      child: const Icon(
                                        Icons.search,
                                        key: ValueKey<int>(2),
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),

                            // verticalSpace(16),
                          ],
                        ),
                      ),
                    ),
                  ),
                  mgr.forumLoader == true
                      ? SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(child: LogoLoader()),
                        )
                      : SliverToBoxAdapter(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              getIt<HomeManager>().getForumList(
                                isRefresh: true,
                              );
                            },
                            child: Column(
                              // shrinkWrap: true,
                              // controller: _controller,
                              children: [
                                verticalSpace(h1p),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w1p * 5,
                                    vertical: h1p * 2,
                                  ),
                                  child: Text(
                                    "Answer the patients questions to show your expertise.",
                                    style: TextStyles.forumtxt1,
                                  ),
                                ),
                                Entry(
                                  xOffset: -1000,
                                  // scale: 20,
                                  delay: const Duration(milliseconds: 0),
                                  duration: const Duration(milliseconds: 700),
                                  curve: Curves.ease,
                                  child: Entry(
                                    opacity: .5,
                                    // angle: 3.1415,
                                    delay: const Duration(milliseconds: 0),
                                    duration: const Duration(
                                      milliseconds: 1500,
                                    ),
                                    curve: Curves.decelerate,
                                    child:
                                        mgr.forumListModel?.publicForums !=
                                                null &&
                                            mgr
                                                .forumListModel!
                                                .publicForums!
                                                .isNotEmpty
                                        ? Column(
                                            children: mgr
                                                .forumListModel!
                                                .publicForums!
                                                .map(
                                                  (e) => GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) =>
                                                              ForumDetailsScreen(
                                                                forumId: e.id!,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: ForumWidget(
                                                      h1p: h1p,
                                                      w1p: w1p,
                                                      pf: e,
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(28.0),
                                            child: Center(
                                              child: Text(
                                                "Forums not available",
                                                style: TextStyles.textStyle2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                              ],
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

class ForumWidget extends StatelessWidget {
  final double w1p;
  final double h1p;
  final PublicForums pf;
  const ForumWidget({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.pf,
  });

  @override
  Widget build(BuildContext context) {
    String name = pf.fullName ?? "";
    // String age = pf.age ?? "";
    String image = pf.userImage ?? "";
    String place = pf.city ?? "";
    String date = getIt<StateManager>().dateTimeToLabels(
      DateTime.parse(pf.forumCreatedDate!),
    );
    String title = pf.title ?? "";
    String subtitle = pf.description ?? "";
    String responseCount = pf.responsesCount != null
        ? pf.responsesCount.toString()
        : "0";

    return Container(
      margin: EdgeInsets.only(bottom: h1p * 2, right: w1p * 5, left: w1p * 5),
      decoration: BoxDecoration(
        boxShadow: [
          boxShadow8,
          // boxShadow8b,
        ],
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffFBFBFB),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 45,
                    width: 45,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // fit: widget.fit,
                      imageUrl: '${StringConstants.baseUrl}$image',
                      placeholder: (context, url) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/forum-person-placeholder.png",
                      ),
                    ),
                  ),
                ),

                horizontalSpace(8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyles.forumtxt2),
                    Row(
                      children: [
                        Text(date, style: TextStyles.forumtxt3),
                        Text(", ", style: TextStyles.forumtxt3),
                        Text(place, style: TextStyles.forumtxt3),
                      ],
                    ),

                    // Text("$age, $place",style: TextStyles.textStyle78,),
                  ],
                ),
                // Spacer(),
                // Text(date,style: TextStyles.forumtxt3,)
              ],
            ),
          ),
          // verticalSpace(4),
          SizedBox(
            height: 90,

            // height: TextStyles.forumtxt5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.forumtxt5,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpace(4),
                  Text(
                    subtitle,
                    style: TextStyles.forumtxt4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ForumDetailsScreen(forumId: pf.id!, isCommentOn: true),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: pf.isAlreadyResponded == false
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff727272),
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          // fit: widget.fit,
                                          imageUrl:
                                              '${StringConstants.baseUrl}${getIt<SharedPreferences>().getString(StringConstants.proImage)}',
                                          placeholder: (context, url) =>
                                              const SizedBox(),
                                          errorWidget: (context, url, error) =>
                                              const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  horizontalSpace(8),
                                  Expanded(
                                    child: SizedBox(
                                      // height:50,
                                      // width:w1p*70,
                                      child: Text(
                                        "Add your comment",
                                        style: TextStyles.forumtxt7,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : pad(
                            horizontal: 8,
                            child: SizedBox(
                              child: Text(
                                "You have already responded",
                                style: TextStyles.textStyle10b2,
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/images/icon-comment-square.svg",
                        ),
                        horizontalSpace(4),
                        Text(responseCount, style: TextStyles.forumtxt6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:entry/entry.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/managers/home_manager.dart';
import '../../../model/core/fou_list_model.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/widgets.dart';
import 'forum_details_screen.dart';
import 'forum_screen.dart';

class ForumSearchScreen extends StatefulWidget {
  const ForumSearchScreen({super.key});

  //if veterinary forum type =1 otherwise type = 2

  @override
  State<ForumSearchScreen> createState() => _ForumSearchScreenState();
}

class _ForumSearchScreenState extends State<ForumSearchScreen> {
  // AvailableDocsModel docsData;
  int index = 1;

  //
  // @override
  // void initState() {

  //
  // }
  @override
  void initState() {
    _controller.addListener(_scrollListener);
    super.initState();
  }

  final ScrollController _controller = ScrollController();

  void _scrollListener() async {
    if (_controller.position.pixels == _controller.position.maxScrollExtent) {
      // print(1111111111);
      // index++;
      onSearchChanged(searchCntrlr.text);
    }
  }

  @override
  void dispose() {
    getIt<HomeManager>().disposeForumSearch();
    _controller.dispose();
    super.dispose();
  }

  var searchCntrlr = TextEditingController();

  Timer? _debounce;

  void onSearchChanged(String query, {bool? isRefresh}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // Make the API call here
      getIt<HomeManager>().searchForum(keyword: query, isRefresh: isRefresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double h10p = maxHeight * 0.1;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            List<PublicForums>? forumLists =
                mgr.publicForumSearchResultsModel?.publicForums;

            return Scaffold(
              // extendBody: true,
              backgroundColor: Colors.white,
              appBar: getIt<SmallWidgets>().appBarWidget(
                title: 'Search',
                height: h10p,
                width: w10p,
                fn: () {
                  Navigator.pop(context);
                },
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    // getIt<HomeManager>().setEnableSearchVariable(!mgr.isSearchEnabled);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w1p * 4),
                    child: const Icon(
                      Icons.close,
                      key: ValueKey<int>(2),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              body: RefreshIndicator(
                onRefresh: () async {},
                child: ListView(
                  controller: _controller,
                  children: [
                    // mgr.isSearchEnabled?
                    Entry(
                      yOffset: -80,
                      // scale: 20,
                      delay: const Duration(milliseconds: 0),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      child: Container(
                        width: maxWidth,
                        color: Colours.primaryblue,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: w1p * 5,
                            left: w1p * 5,
                            bottom: h1p,
                          ),
                          child: TextFormField(
                            controller: searchCntrlr,
                            autofocus: true,
                            style: TextStyles.textStyle12c,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                CupertinoIcons.search,
                                color: Colors.white70,
                              ),
                              contentPadding: const EdgeInsets.only(left: 10),
                              border: outLineBorder,
                              enabledBorder: outLineBorder,
                              focusedBorder: outLineBorder,
                            ),
                            onChanged: (val) {
                              if (val.length > 2) {
                                onSearchChanged(val, isRefresh: true);
                              }
                            },
                          ),
                        ),
                      ),
                    ),

                    // :SizedBox(),
                    verticalSpace(h1p),

                    // Padding(
                    //   padding:  EdgeInsets.symmetric(horizontal: w1p*5,vertical:h1p*2 ),
                    //   child: Text("Answer the patients questions to show your expertise.",style: TextStyles.medicalRecTxt1,),
                    // ),
                    mgr.forumSearchLoader == true
                        ? Entry(
                            yOffset: -100,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: LogoLoader(),
                            ),
                          )
                        : Entry(
                            xOffset: -1000,
                            // scale: 20,
                            delay: const Duration(milliseconds: 0),
                            duration: const Duration(milliseconds: 700),
                            curve: Curves.ease,
                            child: Entry(
                              opacity: .5,
                              // angle: 3.1415,
                              delay: const Duration(milliseconds: 0),
                              duration: const Duration(milliseconds: 1500),
                              curve: Curves.decelerate,
                              child: forumLists != null && forumLists.isNotEmpty
                                  ? Column(
                                      children: [
                                        ...forumLists.map((e) {
                                          var i = forumLists.indexOf(e);

                                          return Column(
                                            children: [
                                              InkWell(
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
                                              i == forumLists.length - 1 &&
                                                      mgr
                                                              .publicForumSearchResultsModel!
                                                              .next !=
                                                          null
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                            8.0,
                                                          ),
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 5,
                                                              color: Colours
                                                                  .primaryblue
                                                                  .withOpacity(
                                                                    0.8,
                                                                  ),
                                                            ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                            ],
                                          );
                                        }).toList(),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 50.0,
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: w10p * 3,
                                              child: Image.asset(
                                                "assets/images/forum-search.png",
                                                color: Colours.lightBlu,
                                              ),
                                            ),
                                            Text(
                                              searchCntrlr.text.isEmpty
                                                  ? "The forums you search will appear here."
                                                  : "Sorry, we couldn't find any results",
                                              style: TextStyles.textStyle23d2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dqueuedoc/model/core/fou_details_model.dart';
import 'package:dqueuedoc/view/theme/text_styles.dart';
import 'package:entry/entry.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../controller/managers/home_manager.dart';
import '../../../controller/managers/state_manager.dart';
import '../../../images_open_widget.dart';
import '../../../model/helper/service_locator.dart';
import '../../theme/constants.dart';
import '../../theme/widgets.dart';

class ForumDetailsScreen extends StatefulWidget {
  final int forumId;
  final bool? isCommentOn;
  const ForumDetailsScreen({
    super.key,
    required this.forumId,
    this.isCommentOn,
  });
  @override
  State<ForumDetailsScreen> createState() => _ForumDetailsScreenState();
}

class _ForumDetailsScreenState extends State<ForumDetailsScreen> {
  // AvailableDocsModel

  @override
  void dispose() {
    getIt<HomeManager>().forumDetailsScreenDispose();
    super.dispose();
  }

  @override
  void initState() {
    getIt<HomeManager>().getForumDetails(widget.forumId);
    super.initState();
  }

  // final ScrollController _controller = ScrollController();
  //
  // void _scrollListener()async {
  //   if (_controller.position.pixels == _controller.position.maxScrollExtent) {
  //     index++;
  //     getIt<HomeManager>().getConsultaions(index:index );
  //   }
  // }

  var responseConroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxHeight = constraints.maxHeight;
        double maxWidth = constraints.maxWidth;
        double h1p = maxHeight * 0.01;
        double w10p = maxWidth * 0.1;
        double w1p = maxWidth * 0.01;

        Widget imageContainer({String? url, List<String>? urls, int? indx}) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w1p * 2,
              vertical: w1p * 2,
            ),
            child: InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => GalleryImagest(
                //           titleGallery: "Gallery",
                //           galleryItems: urls!.map((e) => GalleryItemModel(id: e.toString(), imageUrl: e.toString())).toList(),
                //           backgroundDecoration: const BoxDecoration(
                //             color: Colors.black,
                //           ),
                //           initialIndex: indx??0,
                //           scrollDirection: Axis.horizontal,
                //           iconBack: const Icon(
                //             Icons.arrow_back,
                //             color: Colors.white,
                //           ),
                //           fit: BoxFit.contain,
                //           loop: false,
                //           activeCarouselList: true,
                //         )));

                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  showDragHandle: true,
                  barrierColor: Colors.white,
                  useSafeArea: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  // showDragHandle: true,
                  context: context,
                  builder: (context) =>
                      // PhotoViewContainer(w1p: w1p,h1p: h1p,url: url!)
                      GalleryImageViewWrapper(
                        paginationFn: () {
                          // print("jfdfahdjsfhsadjfasf");
                          // getIt<CordManager>().incrementPageIndex();
                          // getIt<CordManager>().getGalleryImages();
                        },
                        titleGallery: 'Gallery',
                        galleryItems: urls!.map((e) {
                          var indxx = urls.indexOf(e);

                          return GalleryItemModel(
                            id: getIt<StateManager>().generateRandomString(),
                            index: indxx,
                            imageUrl: e,
                          );
                        }).toList(),
                        backgroundColor: Colors.white,
                        initialIndex: indx,
                        loadingWidget: null,
                        errorWidget: null,
                        maxScale: 10,
                        minScale: 0.5,
                        reverse: false,
                        showListInGalley: false,
                        showAppBar: false,
                        closeWhenSwipeUp: false,
                        closeWhenSwipeDown: true,
                        radius: 0,
                        imageList: urls,
                      ),
                );
              },
              child: SizedBox(
                width: w10p * 2,
                height: w10p * 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: url ?? "",
                    placeholder: (context, url) => const SizedBox(),
                    errorWidget: (context, url, error) => const SizedBox(),
                  ),
                  //
                  // FadeInImage.assetNetwork(
                  // fit: BoxFit.fill,
                  //   placeholder: 'assets/images/imgPH.png',
                  //   image:url??"",
                  //   imageErrorBuilder: (context, url, error) => Image.asset('assets/images/imgPH.png',fit: BoxFit.fitHeight
                  //     ,),)
                ),
              ),
            ),
          );
        }

        return Consumer<HomeManager>(
          builder: (context, mgr, child) {
            return GestureDetector(
              onTap: () {
                // Unfocus when tapping outside the TextField
                FocusScope.of(context).unfocus();
              },
              child: Scaffold(
                // extendBody: true,
                backgroundColor: Colors.white,
                // appBar:AppBar(title:Text("Forum",style: TextStyles.consult3,), backgroundColor:Colours.primaryblue,),
                // appBar: getIt<SmallWidgets>().appBarWidget(
                //     title: "Forum",
                //     height: h10p * 0.9,
                //     width: w10p,
                //     fn: () {
                //       Navigator.pop(context);
                //     }),
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
                                          Text("Forum", style: t500_20),
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
                    mgr.forumLoader == true && mgr.forumDetailsModel == null
                        ? SliverFillRemaining(
                            hasScrollBody: false,
                            child: Center(child: LogoLoader()),
                          )
                        : SliverToBoxAdapter(
                            child: Column(
                              // shrinkWrap: true,
                              // controller: _controller,
                              children: [
                                mgr.forumDetailsModel?.forumDetails != null
                                    ? Builder(
                                        builder: (context) {
                                          ForumDetails f = mgr
                                              .forumDetailsModel!
                                              .forumDetails!;
                                          String name = f.fullName ?? '';
                                          String age = f.age ?? '';
                                          String place = f.city ?? '';
                                          String date = getIt<StateManager>()
                                              .getFormattedDate(
                                                f.forumCreatedDate!,
                                              );
                                          String title = f.title ?? "";
                                          String image = f.userImage ?? "";
                                          String subtitle = f.description ?? "";
                                          List<String> images = f.files!
                                              .map((e) => e.file)
                                              .where((file) => file != null)
                                              .cast<String>()
                                              .toList();
                                          if (kDebugMode) {
                                            print(images);
                                          }

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: w1p * 5,
                                                ),
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    boxShadow9,
                                                    boxShadow9b,
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: const Color(
                                                    0xffFBFBFB,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 8.0,
                                                              vertical: 18,
                                                            ),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    100,
                                                                  ),
                                                              child: SizedBox(
                                                                height: 50,
                                                                width: 50,
                                                                child: CachedNetworkImage(
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  // fit: widget.fit,
                                                                  imageUrl:
                                                                      '${StringConstants.baseUrl}$image',
                                                                  placeholder:
                                                                      (
                                                                        context,
                                                                        url,
                                                                      ) => Image.asset(
                                                                        "assets/images/forum-person-placeholder.png",
                                                                      ),
                                                                  errorWidget:
                                                                      (
                                                                        context,
                                                                        url,
                                                                        error,
                                                                      ) => Image.asset(
                                                                        "assets/images/forum-person-placeholder.png",
                                                                      ),
                                                                ),
                                                              ),
                                                            ),
                                                            horizontalSpace(8),
                                                            Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  name,
                                                                  style: TextStyles
                                                                      .forumtxt2,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      age,
                                                                      style: TextStyles
                                                                          .forumtxt4,
                                                                    ),
                                                                    Text(
                                                                      ", ",
                                                                      style: TextStyles
                                                                          .forumtxt4,
                                                                    ),
                                                                    Text(
                                                                      place,
                                                                      style: TextStyles
                                                                          .forumtxt4,
                                                                    ),
                                                                  ],
                                                                ),

                                                                // Text("$age, $place",style: TextStyles.textStyle78,),
                                                              ],
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              date,
                                                              style: TextStyles
                                                                  .forumtxt4,
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      // verticalSpace(4),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 18.0,
                                                              vertical: 8,
                                                            ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              title,
                                                              style: TextStyles
                                                                  .forumtxt8,
                                                            ),
                                                            verticalSpace(8),
                                                            Text(
                                                              subtitle,
                                                              style: TextStyles
                                                                  .forumtxt9,
                                                            ),
                                                            verticalSpace(8),
                                                            f.files != null
                                                                ? Wrap(
                                                                    children: images.map((
                                                                      img,
                                                                    ) {
                                                                      var i = images
                                                                          .indexOf(
                                                                            img,
                                                                          );

                                                                      // imageContainer(StringContants.imageBaseUrl+f.imgName!)).toList()
                                                                      return imageContainer(
                                                                        url:
                                                                            "${StringConstants.baseUrl}$img",
                                                                        indx: i,
                                                                        urls: images
                                                                            .map(
                                                                              (
                                                                                e,
                                                                              ) => '${StringConstants.baseUrl}$e',
                                                                            )
                                                                            .toList(),
                                                                      );
                                                                    }).toList(),
                                                                  )
                                                                : const SizedBox(),
                                                            verticalSpace(8),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              verticalSpace(8),
                                              mgr
                                                          .forumDetailsModel
                                                          ?.forumDetails
                                                          ?.isAlreadyResponded ==
                                                      false
                                                  ? Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                            horizontal: w1p * 5,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: const Color(
                                                            0xff727272,
                                                          ),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              100,
                                                            ),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 4,
                                                            ),
                                                        child: Row(
                                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Align(
                                                              alignment: Alignment
                                                                  .bottomRight,
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      100,
                                                                    ),
                                                                child: SizedBox(
                                                                  height: 40,
                                                                  width: 40,
                                                                  child: CachedNetworkImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    // fit: widget.fit,
                                                                    imageUrl:
                                                                        '${StringConstants.baseUrl}${getIt<SharedPreferences>().getString(StringConstants.proImage)}',
                                                                    placeholder:
                                                                        (
                                                                          context,
                                                                          url,
                                                                        ) => Image.asset(
                                                                          "assets/images/forum-person-placeholder.png",
                                                                        ),
                                                                    errorWidget:
                                                                        (
                                                                          context,
                                                                          url,
                                                                          error,
                                                                        ) => Image.asset(
                                                                          "assets/images/forum-person-placeholder.png",
                                                                        ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            horizontalSpace(8),
                                                            Expanded(
                                                              child: SizedBox(
                                                                // height:50,
                                                                // width:w1p*70,
                                                                child: TextField(
                                                                  autofocus:
                                                                      widget
                                                                          .isCommentOn ==
                                                                      true,
                                                                  controller:
                                                                      responseConroller,
                                                                  decoration: InputDecoration(
                                                                    hintText:
                                                                        'Add a comment',
                                                                    hintStyle:
                                                                        TextStyles
                                                                            .forumtxt2,
                                                                    border: InputBorder
                                                                        .none, // No border
                                                                    enabledBorder:
                                                                        InputBorder
                                                                            .none, // No border when enabled
                                                                    focusedBorder:
                                                                        InputBorder
                                                                            .none, // No border when focused
                                                                  ),
                                                                  minLines: 1,
                                                                  maxLines: 3,
                                                                ),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap: () async {
                                                                FocusScope.of(
                                                                  context,
                                                                ).unfocus();

                                                                if (responseConroller
                                                                    .text
                                                                    .isNotEmpty) {
                                                                  var res = await getIt<HomeManager>().submitForumResponse(
                                                                    forumId: widget
                                                                        .forumId,
                                                                    responseText:
                                                                        responseConroller
                                                                            .text,
                                                                    imgs: [],
                                                                  );
                                                                  if (res.status ==
                                                                      true) {
                                                                    responseConroller
                                                                            .text =
                                                                        '';

                                                                    getIt<
                                                                          HomeManager
                                                                        >()
                                                                        .updateForumRespondedInList(
                                                                          widget
                                                                              .forumId,
                                                                        );
                                                                    getIt<
                                                                          HomeManager
                                                                        >()
                                                                        .getForumDetails(
                                                                          widget
                                                                              .forumId,
                                                                        );

                                                                    showTopSnackBar(
                                                                      Overlay.of(
                                                                        context,
                                                                      ),
                                                                      CustomSnackBar.success(
                                                                        backgroundColor:
                                                                            Colours.toastBlue,
                                                                        maxLines:
                                                                            2,
                                                                        message:
                                                                            res.message ??
                                                                            "",
                                                                      ),
                                                                    );
                                                                  } else {
                                                                    responseConroller
                                                                            .text =
                                                                        '';

                                                                    showTopSnackBar(
                                                                      Overlay.of(
                                                                        context,
                                                                      ),
                                                                      CustomSnackBar.error(
                                                                        backgroundColor:
                                                                            Colours.toastRed,
                                                                        maxLines:
                                                                            2,
                                                                        message:
                                                                            res.message ??
                                                                            "",
                                                                      ),
                                                                    );
                                                                  }
                                                                } else {
                                                                  showTopSnackBar(
                                                                    Overlay.of(
                                                                      context,
                                                                    ),
                                                                    const CustomSnackBar.error(
                                                                      backgroundColor:
                                                                          Colours
                                                                              .toastRed,
                                                                      maxLines:
                                                                          2,
                                                                      message:
                                                                          "Oops! It looks like you forgot to type your reply.",
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          w1p *
                                                                          2,
                                                                    ),
                                                                child: SvgPicture.asset(
                                                                  "assets/images/icon-send.svg",
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : const SizedBox(),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: w1p * 5,
                                                  vertical: 18,
                                                ),
                                                child: Text(
                                                  "Answers",
                                                  style: TextStyles.forumtxt9,
                                                ),
                                              ),
                                              Entry(
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
                                                  child:
                                                      mgr
                                                                  .forumDetailsModel!
                                                                  .forumDetails!
                                                                  .response !=
                                                              null &&
                                                          mgr
                                                              .forumDetailsModel!
                                                              .forumDetails!
                                                              .response!
                                                              .isNotEmpty
                                                      ? Column(
                                                          children: mgr
                                                              .forumDetailsModel!
                                                              .forumDetails!
                                                              .response!
                                                              .map(
                                                                (
                                                                  e,
                                                                ) => ForumResponse(
                                                                  forumId: widget
                                                                      .forumId,
                                                                  h1p: h1p,
                                                                  w1p: w1p,
                                                                  pf: e,
                                                                ),
                                                              )
                                                              .toList(),
                                                        )
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets.all(
                                                                28.0,
                                                              ),
                                                          child: Center(
                                                            child: Text(
                                                              "No Answers",
                                                              style: TextStyles
                                                                  .forumtxt6,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : const SizedBox(),
                              ],
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

class ForumResponse extends StatelessWidget {
  final double w1p;
  final double h1p;
  final ForumResponseModel pf;
  final int forumId;
  const ForumResponse({
    super.key,
    required this.h1p,
    required this.w1p,
    required this.pf,
    required this.forumId,
  });

  @override
  Widget build(BuildContext context) {
    bool loader = Provider.of<HomeManager>(context).forumLoader;

    Widget flagWidget({required bool helpful}) {
      return InkWell(
        onTap: () async {
          // var res = await getIt<HomeManager>().forumResponseReactionSave(forumRespId:pf.id!,reaction:helpful? 1:2 );

          var res = await getIt<HomeManager>().forumResponseReactionSave(
            forumRespId: pf.id!,
            reaction: helpful ? 1 : 2,
          );

          if (res.status == true) {
            getIt<HomeManager>().getForumDetails(forumId);

            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.success(
                backgroundColor: Colours.toastBlue,
                maxLines: 2,
                message: res.message ?? "",
              ),
            );
          } else {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(
                backgroundColor: Colours.toastRed,
                maxLines: 2,
                message: res.message ?? "",
              ),
            );
          }
          //NOT COMPLETED
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(helpful ? "Yes" : "No", style: TextStyles.textStyle85),
        ),
      );
    }

    String name = pf.appUserName ?? pf.doctorName ?? '';
    // String age = 'pf.';
    // String place = 'pf.';
    String date = getIt<StateManager>().getFormattedDate(
      pf.responseCreatedDate!,
    );
    String subtitle = pf.response ?? "";
    String image = pf.doctorImage ?? pf.appUserImage ?? "";

    return Container(
      margin: EdgeInsets.symmetric(horizontal: w1p * 5, vertical: w1p * 2),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [boxShadow8, boxShadow8b],
        borderRadius: BorderRadius.circular(8),
        // border: Border(
        //   bottom: BorderSide(
        //     color: Color(0xff868686), // Border color
        //     width: 0.5, // Border width
        //   ),
        // ),
        // color:
        // Color(0xffFBFBFB)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: SizedBox(
                    height: 40,
                    width: 40,
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
                    Text(name, style: TextStyles.forumtxt9),
                    Text(date, style: TextStyles.forumtxt6b),

                    // Text("$age, $place",style: TextStyles.textStyle78,),
                  ],
                ),
                // Spacer(),
                // Text(date,style: TextStyles.textStyle78b,)
              ],
            ),
          ),
          // verticalSpace(4),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 18,
              ),
              child: Text(
                subtitle,
                style: t400_16.copyWith(color: Colors.black),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (pf.isSelfResponse != true)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: pf.isSelfResponse == true
                  ? const SizedBox()
                  : pf.isLiked == 0
                  ? Row(
                      children: [
                        Text(
                          "Was this answer helpful?",
                          style: TextStyles.textStyle84b,
                        ),
                        loader
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  "Updating...",
                                  style: TextStyles.textStyle85,
                                ),
                              )
                            : Row(
                                children: [
                                  flagWidget(helpful: true),
                                  flagWidget(helpful: false),
                                ],
                              ),
                      ],
                    )
                  : pf.isLiked == 1
                  ? Text(
                      "You marked this response as helpful",
                      style: TextStyles.textStyle84b,
                    )
                  : pf.isLiked == 2
                  ? Text(
                      "You marked this response as not helpful",
                      style: TextStyles.textStyle84b,
                    )
                  : const SizedBox(),
            ),
          // pf.isAlreadyFlagged ==false?Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: Row(children: [
          //     Text("Was this answer helpful?",style: TextStyles.textStyle84b,),
          //
          //     flagWidget(helpful: true,
          //     ),
          //     flagWidget(helpful: false),
          //
          //   ],),
          // ):SizedBox()
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: Row(children: [
          //     Text("Was this answer helpful?",style: TextStyles.forumtxt6,),
          //
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text("Yes",style: TextStyles.forumtxt6,),
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Text("No",style: TextStyles.forumtxt6,),
          //     )
          //
          //   ],),
          // )
        ],
      ),
    );
  }
}

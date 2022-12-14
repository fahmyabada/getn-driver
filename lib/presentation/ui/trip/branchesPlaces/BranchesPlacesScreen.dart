import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/branchesPlaces/branches_places_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/infoPlace/InfoPlaceScreen.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BranchesPlacesScreen extends StatefulWidget {
  const BranchesPlacesScreen({
    Key? key,
    this.placeId,
  }) : super(key: key);
  final String? placeId;

  @override
  State<BranchesPlacesScreen> createState() => _BranchesPlacesScreenState();
}

class _BranchesPlacesScreenState extends State<BranchesPlacesScreen> {
  // double _userRating = 3.0;

  @override
  void initState() {
    super.initState();
    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BranchesPlacesCubit()..getBranches(1, widget.placeId!),
      child: BlocConsumer<BranchesPlacesCubit, BranchesPlacesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Directionality(
            textDirection: LanguageCubit.get(context).isEn
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  LanguageCubit.get(context)
                      .getTexts('ChooseBranch')
                      .toString(),
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                centerTitle: true,
                elevation: 1.0,
              ),
              body: state is GetBranchesInitial
                  ? loading()
                  : ScrollEdgeListener(
                      edge: ScrollEdge.end,
                      // edgeOffset: 400,
                      // continuous: false,
                      // debounce: const Duration(milliseconds: 500),
                      // dispatch: true,
                      listener: () {
                        print("BranchesPlacesScreen*********** ");
                        BranchesPlacesCubit.get(context).loadingBranches =
                            false;

                        BranchesPlacesCubit.get(context).getBranches(
                            BranchesPlacesCubit.get(context).indexBranches,
                            widget.placeId!);
                      },
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount:
                            BranchesPlacesCubit.get(context).branches.length,
                        itemBuilder: (context, i) {
                          final data =
                              BranchesPlacesCubit.get(context).branches[i];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 15.r, vertical: 10.r),
                            elevation: 1.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    children: [
                                      ClipOval(
                                        clipBehavior: Clip.antiAlias,
                                        child: ImageTools.image(
                                            fit: BoxFit.fill,
                                            url: data.image!.src,
                                            height: 70.w,
                                            width: 70.w),
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.r),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      LanguageCubit.get(context)
                                                              .isEn
                                                          ? data.title!.en!
                                                          : data.title!.ar!,
                                                      style: TextStyle(
                                                          fontSize: 17.sp,
                                                          color: black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                LanguageCubit.get(context).isEn
                                                    ? '${data.country!.title!.en!}, ${data.city!.title!.en!}, ${data.area!.title!.en!}, ${data.address!.en!}'
                                                    : '${data.country!.title!.ar!}, ${data.city!.title!.ar!}, ${data.area!.title!.ar!}, ${data.address!.ar!}',

                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: grey2),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              /* RatingBar.builder(
                                                minRating: _userRating,
                                                itemBuilder: (context, index) =>
                                                    const Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 17.w,
                                                updateOnDrag: true,
                                                onRatingUpdate: (rating) {
                                                  setState(() {
                                                    _userRating = rating;
                                                  });
                                                },
                                                unratedColor:
                                                    Colors.amber.withAlpha(50),
                                                direction: Axis.horizontal,
                                              ),*/
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: defaultButton2(
                                            press: () async {
                                              CurrentLocation location =
                                                  await navigateToWithRefreshPagePrevious(
                                                      context,
                                                      InfoPlaceScreen(
                                                        id: data.id,
                                                        type: "Branch",
                                                      )) as CurrentLocation;
                                              print(
                                                  "BranchesPlacesScreen************ ${location.toString()}");
                                              setState(() {
                                                if (location.description !=
                                                    null) {
                                                  Navigator.of(context)
                                                      .pop(location);
                                                }
                                              });
                                            },
                                            text: LanguageCubit.get(context)
                                                .getTexts('Info')
                                                .toString(),
                                            fontSize: 20,
                                            paddingVertical: 3,
                                            backColor: accentColor,
                                            textColor: white),
                                      ),
                                      SizedBox(width: 20.w,),
                                      Expanded(
                                        child: defaultButton2(
                                            press: () {
                                              // print("placeId********* ${widget.placeId}");
                                              // print("branchId********* ${data.id}");
                                              // print("address********* ${data.address!.en!}");
                                              // print("placeLatitude********* ${data.placeLatitude!}");
                                              // print("placeLongitude********* ${data.placeLongitude!.toString()}");

                                              Navigator.of(context).pop(
                                                  CurrentLocation(
                                                      placeId: widget.placeId,
                                                      branchId: data.id,
                                                      description:
                                                          LanguageCubit.get(
                                                                      context)
                                                                  .isEn
                                                              ? data.address!.en!
                                                              : data.address!.ar!,
                                                      latitude:
                                                          data.placeLatitude!,
                                                      longitude:
                                                          data.placeLongitude!,
                                                      firstTime: true));
                                            },
                                            text: LanguageCubit.get(context)
                                                .getTexts('Select')
                                                .toString(),
                                            fontSize: 20,
                                            paddingVertical: 3,
                                            backColor: blueColor,
                                            textColor: white),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

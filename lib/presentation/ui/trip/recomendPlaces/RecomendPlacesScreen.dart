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
import 'package:getn_driver/presentation/ui/trip/branchesPlaces/BranchesPlacesScreen.dart';
import 'package:getn_driver/presentation/ui/trip/infoBranch/InfoBranchScreen.dart';
import 'package:getn_driver/presentation/ui/trip/infoPlace/InfoPlaceScreen.dart';
import 'package:getn_driver/presentation/ui/trip/recomendPlaces/recomend_places_cubit.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecomendPlacesScreen extends StatefulWidget {
  const RecomendPlacesScreen({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<RecomendPlacesScreen> createState() => _RecomendPlacesScreenState();
}

class _RecomendPlacesScreenState extends State<RecomendPlacesScreen> {
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
      create: (context) => RecomendPlacesCubit()..getPlaces(1, widget.id),
      child: BlocConsumer<RecomendPlacesCubit, RecomendPlacesState>(
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
                      .getTexts('ChoosePlace')
                      .toString(),
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                centerTitle: true,
                elevation: 1.0,
              ),
              body: state is GetPlacesInitial
                  ? loading()
                  : RecomendPlacesCubit.get(context).places.isNotEmpty
                      ? ScrollEdgeListener(
                          edge: ScrollEdge.end,
                          // edgeOffset: 400,
                          // continuous: false,
                          // debounce: const Duration(milliseconds: 500),
                          // dispatch: true,
                          listener: () {
                            print("RecomendPlacesScreen*********** ");
                            RecomendPlacesCubit.get(context).loadingPlaces =
                                false;

                            RecomendPlacesCubit.get(context).getPlaces(
                                RecomendPlacesCubit.get(context).indexPlaces,
                                widget.id);
                          },
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount:
                                RecomendPlacesCubit.get(context).places.length,
                            itemBuilder: (context, i) {
                              final data =
                                  RecomendPlacesCubit.get(context).places[i];
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
                                                url: data.logo != null
                                                    ? data.logo!.src
                                                    : null,
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
                                                          LanguageCubit.get(
                                                                      context)
                                                                  .isEn
                                                              ? data.title!.en!
                                                              : data.title!.ar!,
                                                          style: TextStyle(
                                                              fontSize: 17.sp,
                                                              color: black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  Text(
                                                    LanguageCubit.get(context)
                                                            .isEn
                                                        ? '${data.country!.title!.en!}, ${data.city!.title!.en!}, ${data.area!.title!.en!}, ${data.address!.en!}'
                                                        : '${data.country!.title!.ar!}, ${data.city!.title!.ar!}, ${data.area!.title!.ar!}, ${data.address!.ar!}',
                                                    style: TextStyle(
                                                        fontSize: 15.sp,
                                                        color: grey2),
                                                  ),
                                                  SizedBox(
                                                    height: 5.h,
                                                  ),
                                                  /*RatingBar.builder(
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
                                                  if (data.branchesCount! >=
                                                      1) {
                                                    CurrentLocation location =
                                                        await navigateToWithRefreshPagePrevious(
                                                                context,
                                                                InfoBranchScreen(
                                                                    id: data
                                                                        .id))
                                                            as CurrentLocation;
                                                    setState(() {
                                                      if (location
                                                              .description !=
                                                          null) {
                                                        Navigator.of(context)
                                                            .pop(location);
                                                      }
                                                    });
                                                  } else {
                                                    CurrentLocation location =
                                                        await navigateToWithRefreshPagePrevious(
                                                                context,
                                                                InfoPlaceScreen(
                                                                  id: data.id,
                                                                  type: "Place",
                                                                ))
                                                            as CurrentLocation;
                                                    setState(() {
                                                      if (location
                                                              .description !=
                                                          null) {
                                                        Navigator.of(context)
                                                            .pop(location);
                                                      }
                                                    });
                                                  }
                                                },
                                                text: LanguageCubit.get(context)
                                                    .getTexts('Info')
                                                    .toString(),
                                                fontSize: 20,
                                                paddingVertical: 3,
                                                backColor: accentColor,
                                                textColor: white),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          data.branchesCount! >= 1
                                              ? Expanded(
                                                  child: defaultButton2(
                                                      press: () async {
                                                        CurrentLocation
                                                            location =
                                                            await navigateToWithRefreshPagePrevious(
                                                                    context,
                                                                    BranchesPlacesScreen(
                                                                        placeId:
                                                                            data.id!))
                                                                as CurrentLocation;
                                                        print(
                                                            "RecomendPlacesScreen********* ${location.toString()}");

                                                        Navigator.of(context)
                                                            .pop(location);
                                                      },
                                                      text: LanguageCubit.get(
                                                              context)
                                                          .getTexts('Branches')
                                                          .toString(),
                                                      paddingVertical: 3,
                                                      backColor: blueColor,
                                                      textColor: white),
                                                )
                                              : Expanded(
                                                  child: defaultButton2(
                                                      press: () {
                                                        Navigator.of(context).pop(CurrentLocation(
                                                            placeId: data.id,
                                                            description:
                                                                LanguageCubit.get(
                                                                            context)
                                                                        .isEn
                                                                    ? data
                                                                        .title!
                                                                        .en!
                                                                    : data
                                                                        .title!
                                                                        .ar!,
                                                            latitude: data
                                                                .placeLatitude!,
                                                            longitude: data
                                                                .placeLongitude!,
                                                            firstTime: true));
                                                      },
                                                      text: LanguageCubit.get(
                                                              context)
                                                          .getTexts('Select')
                                                          .toString(),
                                                      fontSize: 20,
                                                      backColor: blueColor,
                                                      paddingVertical: 3,
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
                        )
                      : errorMessage(
                          message: LanguageCubit.get(context)
                              .getTexts('NotFoundPlace')
                              .toString(),
                          press: () {
                            RecomendPlacesCubit.get(context)
                                .getPlaces(1, widget.id);
                          },
                          context: context),
            ),
          );
        },
      ),
    );
  }
}

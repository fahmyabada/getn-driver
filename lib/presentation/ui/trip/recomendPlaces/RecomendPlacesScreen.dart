import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/trip/branchesPlaces/BranchesPlacesScreen.dart';
import 'package:getn_driver/presentation/ui/trip/infoBranch/InfoBranchScreen.dart';
import 'package:getn_driver/presentation/ui/trip/infoPlace/InfoPlaceScreen.dart';
import 'package:getn_driver/presentation/ui/trip/recomendPlaces/recomend_places_cubit.dart';

class RecomendPlacesScreen extends StatefulWidget {
  const RecomendPlacesScreen({Key? key}) : super(key: key);

  @override
  State<RecomendPlacesScreen> createState() => _RecomendPlacesScreenState();
}

class _RecomendPlacesScreenState extends State<RecomendPlacesScreen> {
  double _userRating = 3.0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecomendPlacesCubit()..getPlaces(1),
      child: BlocConsumer<RecomendPlacesCubit, RecomendPlacesState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'choose your destination',
                style: TextStyle(color: primaryColor, fontSize: 20.sp),
              ),
              centerTitle: true,
              elevation: 1.0,
            ),
            body: state is GetPlacesInitial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: black,
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController
                      ..addListener(() async {
                        if (_scrollController.position.extentAfter == 0) {
                          if (RecomendPlacesCubit.get(context).loadingPlaces) {
                            print("RecomendPlacesScreen*********** ");
                            RecomendPlacesCubit.get(context).loadingPlaces =
                                false;

                            RecomendPlacesCubit.get(context).getPlaces(
                                RecomendPlacesCubit.get(context).indexPlaces);
                          }
                        }
                      }),
                    scrollDirection: Axis.vertical,
                    itemCount: RecomendPlacesCubit.get(context).places.length,
                    itemBuilder: (context, i) {
                      final data = RecomendPlacesCubit.get(context).places[i];
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
                                        url: data.logo!.src,
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
                                                  data.title!.en!,
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
                                            data.address!.en!,
                                            style: TextStyle(
                                                fontSize: 15.sp, color: grey2),
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
                                  defaultButton2(
                                      press: () async {
                                        if (data.branchesCount! >= 1) {
                                          CurrentLocation location =
                                              await navigateToWithRefreshPagePrevious(
                                                      context,
                                                      InfoBranchScreen(
                                                          id: data.id))
                                                  as CurrentLocation;
                                          setState(() {
                                            if (location.description != null) {
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
                                                  )) as CurrentLocation;
                                          setState(() {
                                            if (location.description != null) {
                                              Navigator.of(context)
                                                  .pop(location);
                                            }
                                          });
                                        }
                                      },
                                      text: 'Info',
                                      backColor: accentColor,
                                      textColor: white),
                                  data.branchesCount! >= 1
                                      ? defaultButton2(
                                          press: () async {
                                            CurrentLocation location =
                                                await navigateToWithRefreshPagePrevious(
                                                        context,
                                                        BranchesPlacesScreen(
                                                            placeId: data.id!))
                                                    as CurrentLocation;
                                            print(
                                                "RecomendPlacesScreen********* ${location.toString()}");

                                            Navigator.of(context).pop(location);
                                          },
                                          text: 'Branches',
                                          backColor: blueColor,
                                          textColor: white)
                                      : defaultButton2(
                                          press: () {
                                            Navigator.of(context).pop(
                                                CurrentLocation(
                                                    placeId: data.id,
                                                    description:
                                                        data.title!.en!,
                                                    latitude: double.parse(
                                                        data.placeLatitude!),
                                                    longitude: double.parse(
                                                        data.placeLongitude!),
                                                    firstTime: true));
                                          },
                                          text: 'Select',
                                          backColor: blueColor,
                                          textColor: white),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

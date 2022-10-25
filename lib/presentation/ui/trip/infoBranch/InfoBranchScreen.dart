import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/trip/infoBranch/info_branch_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/infoPlace/InfoPlaceScreen.dart';

class InfoBranchScreen extends StatefulWidget {
  const InfoBranchScreen({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<InfoBranchScreen> createState() => _InfoBranchScreenState();
}

class _InfoBranchScreenState extends State<InfoBranchScreen> {
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
      create: (context) => InfoBranchCubit()
        ..getBranches(1, widget.id!)
        ..getInfoPlace(widget.id!),
      child: BlocConsumer<InfoBranchCubit, InfoBranchState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Branch Details',
                style: TextStyle(color: primaryColor, fontSize: 20.sp),
              ),
              centerTitle: true,
              elevation: 1.0,
            ),
            body: state is GetInfoPlaceInitial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: black,
                    ),
                  )
                : SingleChildScrollView(
              controller: _scrollController
                ..addListener(() async {
                  if (_scrollController
                      .position.extentAfter ==
                      0) {
                    if (InfoBranchCubit.get(context)
                        .loadingBranches) {
                      print(
                          "BranchesPlacesScreen*********** ");
                      InfoBranchCubit.get(context)
                          .loadingBranches = false;

                      InfoBranchCubit.get(context)
                          .getBranches(
                          InfoBranchCubit.get(context)
                              .indexBranches,
                          widget.id!);
                    }
                  }
                }),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 18.r, vertical: 20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                    url: InfoBranchCubit.get(context)
                                        .info
                                        ?.logo!
                                        .src,
                                    height: 80.w,
                                    width: 80.w),
                              ),
                              Expanded(
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 20.r),
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
                                              InfoBranchCubit.get(context)
                                                  .info!
                                                  .title!
                                                  .en!,
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(
                                        InfoBranchCubit.get(context)
                                            .info!
                                            .address!
                                            .en!,
                                        style: TextStyle(
                                            fontSize: 18.sp, color: grey2),
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
                            height: 25.h,
                          ),
                          Text(
                            'About Place',
                            style: TextStyle(
                                fontSize: 20.sp,
                                color: black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'About PlacePlacePlacePlacePlacePlacePlacePlacePlace',
                            style: TextStyle(fontSize: 18.sp, color: grey2),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          state is GetBranchesInitial
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: black,
                                  ),
                                )
                              : ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: InfoBranchCubit.get(context)
                                      .branches
                                      .length,
                                  itemBuilder: (context, i) {
                                    final data = InfoBranchCubit.get(context)
                                        .branches[i];
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
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.r),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                data.address!
                                                                    .en!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17.sp,
                                                                    color:
                                                                        black,
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
                                                          '${data.area}, ${data.city}, ${data.country}',
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              color: grey2),
                                                        ),
                                                        SizedBox(
                                                          height: 5.h,
                                                        ),
                                                        /*RatingBar.builder(
                                                          minRating:
                                                              _userRating,
                                                          itemBuilder: (context,
                                                                  index) =>
                                                              const Icon(
                                                            Icons.star,
                                                            color: Colors.amber,
                                                          ),
                                                          itemCount: 5,
                                                          itemSize: 17.w,
                                                          updateOnDrag: true,
                                                          onRatingUpdate:
                                                              (rating) {
                                                            setState(() {
                                                              _userRating =
                                                                  rating;
                                                            });
                                                          },
                                                          unratedColor: Colors
                                                              .amber
                                                              .withAlpha(50),
                                                          direction:
                                                              Axis.horizontal,
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
                                                      CurrentLocation location =
                                                          await navigateToWithRefreshPagePrevious(
                                                                  context,
                                                                  InfoPlaceScreen(
                                                                    id: data.id,
                                                                    type:
                                                                        "Branch",
                                                                  ))
                                                              as CurrentLocation;
                                                      print(
                                                          "BranchesPlacesScreen************ ${location.toString()}");
                                                      setState(() {
                                                        if (location
                                                                .description !=
                                                            null) {
                                                          Navigator.of(context)
                                                              .pop(location);
                                                        }
                                                      });
                                                    },
                                                    text: 'Info',
                                                    backColor: accentColor,
                                                    textColor: white),
                                                defaultButton2(
                                                    press: () {
                                                      // print("placeId********* ${widget.placeId}");
                                                      // print("branchId********* ${data.id}");
                                                      // print("address********* ${data.address!.en!}");
                                                      // print("placeLatitude********* ${data.placeLatitude!}");
                                                      // print("placeLongitude********* ${data.placeLongitude!.toString()}");

                                                      Navigator.of(context).pop(
                                                          CurrentLocation(
                                                              placeId:
                                                                  widget.id,
                                                              branchId: data.id,
                                                              description: data
                                                                  .address!.en!,
                                                              latitude: double
                                                                  .parse(data
                                                                      .placeLatitude!),
                                                              longitude: double
                                                                  .parse(data
                                                                      .placeLongitude!),
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
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

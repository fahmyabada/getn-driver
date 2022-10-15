import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/trip/recomendPlaces/recomend_places_cubit.dart';

class RecomendPlacesScreen extends StatefulWidget {
  const RecomendPlacesScreen({Key? key}) : super(key: key);

  @override
  State<RecomendPlacesScreen> createState() => _RecomendPlacesScreenState();
}

class _RecomendPlacesScreenState extends State<RecomendPlacesScreen> {
  double _userRating = 3.0;

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
                                          RatingBar.builder(
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
                                          ),
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
                                      press: () {},
                                      text: 'Info',
                                      backColor: accentColor,
                                      textColor: white),
                                  defaultButton2(
                                      press: () {
                                        Navigator.of(context).pop(
                                            CurrentLocation(
                                                description: data.title!.en!,
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

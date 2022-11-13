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
import 'package:getn_driver/presentation/ui/trip/infoPlace/info_place_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoPlaceScreen extends StatefulWidget {
  const InfoPlaceScreen({Key? key, this.id, this.type}) : super(key: key);

  final String? id;
  final String? type;

  @override
  State<InfoPlaceScreen> createState() => _InfoPlaceScreenState();
}

class _InfoPlaceScreenState extends State<InfoPlaceScreen> {
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
          InfoPlaceCubit()..getInfoPlace(widget.id!, widget.type!),
      child: BlocConsumer<InfoPlaceCubit, InfoPlaceState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        //010243443909
        builder: (context, state) {
          return Directionality(
            textDirection: LanguageCubit.get(context).isEn
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  '${widget.type!} ${LanguageCubit.get(context)
                      .getTexts('Details')
                      .toString()}',
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                centerTitle: true,
                elevation: 1.0,
              ),
              body: state is GetInfoInitial
                  ? loading()
                  : SingleChildScrollView(
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
                                      url: widget.type! == "Branch"
                                          ? InfoPlaceCubit.get(context)
                                              .info
                                              ?.image!
                                              .src
                                          : InfoPlaceCubit.get(context)
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
                                                widget.type! == "Branch"
                                                    ? LanguageCubit.get(context)
                                                            .isEn
                                                        ? InfoPlaceCubit.get(
                                                                context)
                                                            .info!
                                                            .address!
                                                            .en!
                                                        : InfoPlaceCubit.get(
                                                                context)
                                                            .info!
                                                            .address!
                                                            .ar!
                                                    : LanguageCubit.get(context)
                                                            .isEn
                                                        ? InfoPlaceCubit.get(
                                                                context)
                                                            .info!
                                                            .title!
                                                            .en!
                                                        : InfoPlaceCubit.get(
                                                                context)
                                                            .info!
                                                            .title!
                                                            .ar!,
                                                style: TextStyle(
                                                    fontSize: 20.sp,
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
                                          widget.type! == "Branch"
                                              ? '${InfoPlaceCubit.get(context).info!.area}, ${InfoPlaceCubit.get(context).info!.city}, ${InfoPlaceCubit.get(context).info!.country}'
                                              : LanguageCubit.get(context).isEn
                                                  ? InfoPlaceCubit.get(context)
                                                      .info!
                                                      .address!
                                                      .en!
                                                  : InfoPlaceCubit.get(context)
                                                      .info!
                                                      .address!
                                                      .ar!,
                                          style: TextStyle(
                                              fontSize: 18.sp, color: grey2),
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
                              height: 25.h,
                            ),
                            Text(
                              LanguageCubit.get(context)
                                  .getTexts('AboutPlace')
                                  .toString(),
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
                            defaultButton3(
                                press: () {
                                  widget.type! == "Branch"
                                      ? Navigator.of(context).pop(CurrentLocation(
                                          placeId: InfoPlaceCubit.get(context)
                                              .info!
                                              .place!,
                                          branchId: InfoPlaceCubit.get(context)
                                              .info!
                                              .id,
                                          description:
                                              LanguageCubit.get(context).isEn
                                                  ? InfoPlaceCubit.get(context)
                                                      .info!
                                                      .address!
                                                      .en!
                                                  : InfoPlaceCubit.get(context)
                                                      .info!
                                                      .address!
                                                      .ar!,
                                          latitude: double.parse(
                                              InfoPlaceCubit.get(context)
                                                  .info!
                                                  .placeLatitude!),
                                          longitude: double.parse(
                                              InfoPlaceCubit.get(context)
                                                  .info!
                                                  .placeLongitude!),
                                          firstTime: true))
                                      : Navigator.of(context)
                                          .pop(CurrentLocation(placeId: InfoPlaceCubit.get(context).info!.id!, description: LanguageCubit.get(context).isEn ? InfoPlaceCubit.get(context).info!.title!.en! : InfoPlaceCubit.get(context).info!.title!.ar!, latitude: double.parse(InfoPlaceCubit.get(context).info!.placeLatitude!), longitude: double.parse(InfoPlaceCubit.get(context).info!.placeLongitude!), firstTime: true));
                                },
                                text: "${LanguageCubit.get(context)
                                    .getTexts('selectThis')
                                    .toString()} ${widget.type!}",
                                backColor: accentColor,
                                textColor: white)
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

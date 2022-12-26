import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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
    print('type********** ${widget.type}');
    print('id********** ${widget.id}');
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
                  LanguageCubit.get(context).isEn
                      ? '${widget.type == 'Branch' ? LanguageCubit.get(context).getTexts('Branch').toString() : LanguageCubit.get(context).getTexts('Place').toString()} ${LanguageCubit.get(context).getTexts('Details').toString()}'
                      : '${LanguageCubit.get(context).getTexts('Details').toString()} ${widget.type == 'Branch' ? LanguageCubit.get(context).getTexts('Branch').toString() : LanguageCubit.get(context).getTexts('Place').toString()} ',
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
                                                      .info!
                                                      .image !=
                                                  null
                                              ? InfoPlaceCubit.get(context)
                                                  .info!
                                                  .image!
                                                  .src
                                              : null
                                          : InfoPlaceCubit.get(context)
                                                      .info!
                                                      .logo !=
                                                  null
                                              ? InfoPlaceCubit.get(context)
                                                  .info!
                                                  .logo!
                                                  .src
                                              : null,
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
                                                LanguageCubit.get(context).isEn
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
                                          LanguageCubit.get(context).isEn
                                              ? '${InfoPlaceCubit.get(context).info!.country!.title!.en!}, ${InfoPlaceCubit.get(context).info!.city!.title!.en!}, ${InfoPlaceCubit.get(context).info!.area!.title!.en!}, ${InfoPlaceCubit.get(context).info!.address!.en!}'
                                              : '${InfoPlaceCubit.get(context).info!.country!.title!.ar!}, ${InfoPlaceCubit.get(context).info!.city!.title!.ar!}, ${InfoPlaceCubit.get(context).info!.area!.title!.ar!}, ${InfoPlaceCubit.get(context).info!.address!.ar!}',
                                          style: TextStyle(
                                              fontSize: 18.sp, color: grey2),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
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
                            InfoPlaceCubit.get(context).info!.desc!.en != null
                                ? Html(
                                    data: LanguageCubit.get(context).isEn
                                        ? InfoPlaceCubit.get(context)
                                            .info!
                                            .desc!
                                            .en!
                                        : InfoPlaceCubit.get(context)
                                            .info!
                                            .desc!
                                            .ar!,
                                  )
                                : Text(
                                    LanguageCubit.get(context)
                                        .getTexts('PlaceDescription')
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 18.sp, color: grey2),
                                  ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Text(
                              LanguageCubit.get(context)
                                  .getTexts('Gallery')
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  color: black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            InfoPlaceCubit.get(context)
                                    .info!
                                    .gallery!
                                    .isNotEmpty
                                ? GridView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: InfoPlaceCubit.get(context)
                                        .info!
                                        .gallery!
                                        .length,
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 150.sp,
                                            crossAxisSpacing: 20.w,
                                            mainAxisSpacing: 20.h),
                                    itemBuilder: (context, i) {
                                      return Container(
                                        height: 200.h,
                                        width: 250.w,
                                        decoration: BoxDecoration(
                                          color: white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(25.r),
                                          border:
                                              Border.all(color: Colors.black),
                                        ),
                                        child: SizedBox(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(25.r),
                                            child: ImageTools.image(
                                              url: InfoPlaceCubit.get(context)
                                                  .info!
                                                  .gallery![i]
                                                  .src,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Text(
                                    widget.type == "Branch"
                                        ? LanguageCubit.get(context)
                                            .getTexts('NotHaveGalleryBranch')
                                            .toString()
                                        : LanguageCubit.get(context)
                                            .getTexts('NotHaveGalleryPlace')
                                            .toString(),
                                    style: TextStyle(
                                        fontSize: 18.sp, color: grey2),
                                  ),
                            SizedBox(
                              height: 25.h,
                            ),
                          ],
                        ),
                      ),
                    ),
              bottomNavigationBar: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.r, vertical: 10.r),
                child: defaultButton3(
                    press: () {
                      widget.type! == "Branch"
                          ? Navigator.of(context).pop(CurrentLocation(
                              placeId: InfoPlaceCubit.get(context).info!.place!,
                              branchId: InfoPlaceCubit.get(context).info!.id,
                              description: LanguageCubit.get(context).isEn
                                  ? InfoPlaceCubit.get(context)
                                      .info!
                                      .address!
                                      .en!
                                  : InfoPlaceCubit.get(context)
                                      .info!
                                      .address!
                                      .ar!,
                              latitude: InfoPlaceCubit.get(context)
                                  .info!
                                  .placeLatitude!,
                              longitude: InfoPlaceCubit.get(context)
                                  .info!
                                  .placeLongitude!,
                              firstTime: true))
                          : Navigator.of(context).pop(CurrentLocation(
                              placeId: InfoPlaceCubit.get(context).info!.id!,
                              description: LanguageCubit.get(context).isEn
                                  ? InfoPlaceCubit.get(context).info!.title!.en!
                                  : InfoPlaceCubit.get(context)
                                      .info!
                                      .title!
                                      .ar!,
                              latitude: InfoPlaceCubit.get(context)
                                  .info!
                                  .placeLatitude!,
                              longitude: InfoPlaceCubit.get(context)
                                  .info!
                                  .placeLongitude!,
                              firstTime: true));
                    },
                    text:
                        "${LanguageCubit.get(context).getTexts('select').toString()} ${widget.type == 'Branch' ? LanguageCubit.get(context).getTexts('Branch').toString() : LanguageCubit.get(context).getTexts('Place').toString()}",
                    backColor: accentColor,
                    textColor: white),
              ),
            ),
          );
        },
      ),
    );
  }
}

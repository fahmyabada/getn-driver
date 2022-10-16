import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/trip/infoPlace/info_place_cubit.dart';

class InfoBranchScreen extends StatefulWidget {
  const InfoBranchScreen({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<InfoBranchScreen> createState() => _InfoBranchScreenState();
}

class _InfoBranchScreenState extends State<InfoBranchScreen> {
  double _userRating = 3.0;

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
          return Scaffold(
            appBar: AppBar(
              title: Text(
                '${widget.type!} Details',
                style: TextStyle(color: primaryColor, fontSize: 20.sp),
              ),
              centerTitle: true,
              elevation: 1.0,
            ),
            body: state is GetInfoInitial
                ? const Center(
                    child: CircularProgressIndicator(
                      color: black,
                    ),
                  )
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
                                                  ? InfoPlaceCubit.get(context)
                                                      .info!
                                                      .address!
                                                      .en!
                                                  : InfoPlaceCubit.get(context)
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
                                        widget.type! == "Branch"
                                            ? '${InfoPlaceCubit.get(context).info!.area}, ${InfoPlaceCubit.get(context).info!.city}, ${InfoPlaceCubit.get(context).info!.country}'
                                            : InfoPlaceCubit.get(context)
                                                .info!
                                                .address!
                                                .en!,
                                        style: TextStyle(
                                            fontSize: 18.sp, color: grey2),
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
                                        description: InfoPlaceCubit.get(context)
                                            .info!
                                            .address!
                                            .en!,
                                        latitude: double.parse(
                                            InfoPlaceCubit.get(context)
                                                .info!
                                                .placeLatitude!),
                                        longitude: double.parse(
                                            InfoPlaceCubit.get(context)
                                                .info!
                                                .placeLongitude!),
                                        firstTime: true))
                                    : Navigator.of(context).pop(CurrentLocation(
                                        placeId:
                                            InfoPlaceCubit.get(context).info!.id!,
                                        description: InfoPlaceCubit.get(context).info!.title!.en!,
                                        latitude: double.parse(InfoPlaceCubit.get(context).info!.placeLatitude!),
                                        longitude: double.parse(InfoPlaceCubit.get(context).info!.placeLongitude!),
                                        firstTime: true));
                              },
                              text: "select this ${widget.type!}",
                              backColor: accentColor,
                              textColor: white)
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

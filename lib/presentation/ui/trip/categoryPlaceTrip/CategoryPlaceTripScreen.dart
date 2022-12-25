import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:getn_driver/data/model/CurrentLocation.dart';
import 'package:getn_driver/data/model/categoryPlaceTripModel/Data.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/categoryPlaceTrip/category_place_trip_screen_cubit.dart';
import 'package:getn_driver/presentation/ui/trip/recomendPlaces/RecomendPlacesScreen.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';

class CategoryPlaceTripScreen extends StatefulWidget {
  const CategoryPlaceTripScreen({Key? key}) : super(key: key);

  @override
  State<CategoryPlaceTripScreen> createState() =>
      _CategoryPlaceTripScreenState();
}

class _CategoryPlaceTripScreenState extends State<CategoryPlaceTripScreen> {
  bool loadingMoreUpCategory = false;

  void _loadMoreUpCategory() {
    CategoryPlaceTripScreenCubit.get(context).getCategoryPlace(
        CategoryPlaceTripScreenCubit.get(context).indexCategoryPlace);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryPlaceTripScreenCubit()..getCategoryPlace(1),
      child: BlocConsumer<CategoryPlaceTripScreenCubit,
          CategoryPlaceTripScreenState>(
        listener: (context, state) {
          if (state is CategoryPlaceTripSuccessState) {
            setState(() {
              loadingMoreUpCategory = false;
            });
          } else if (state is CategoryPlaceTripErrorState) {
            setState(() {
              loadingMoreUpCategory = false;
            });
          }
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
                      .getTexts('selectCategory')
                      .toString(),
                  style: TextStyle(color: primaryColor, fontSize: 20.sp),
                ),
                centerTitle: true,
                elevation: 1.0,
              ),
              body: ScrollEdgeListener(
                edge: ScrollEdge.end,
                // edgeOffset: 400,
                // continuous: false,
                // debounce: const Duration(milliseconds: 500),
                // dispatch: true,
                listener: () {
                  setState(() {
                    loadingMoreUpCategory = true;
                  });
                  _loadMoreUpCategory();
                },
                child: CategoryPlaceTripScreenCubit.get(context)
                        .loadingCategoryPlace
                    ? Center(child: loading())
                    : state is CategoryPlaceTripSuccessState
                        ? CategoryPlaceTripScreenCubit.get(context)
                                .categoryPlace
                                .isEmpty
                            ? errorMessage(
                                message: LanguageCubit.get(context)
                                    .getTexts('NotFoundData')
                                    .toString(),
                                press: () {
                                  CategoryPlaceTripScreenCubit.get(context)
                                      .getCategoryPlace(1);
                                },
                                context: context)
                            : SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(height: 10.h,),
                                  Padding(
                                    padding:  EdgeInsets.symmetric(horizontal:  10.r ),
                                    child: AlignedGridView.count(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20.w,
                                      mainAxisSpacing: 20.w,
                                        physics: const NeverScrollableScrollPhysics(), 
                                        itemCount: CategoryPlaceTripScreenCubit.get(
                                                context)
                                            .categoryPlace
                                            .length,
                                        shrinkWrap: true,

                                        itemBuilder: (context, i) {
                                          Data data =
                                              CategoryPlaceTripScreenCubit.get(
                                                      context)
                                                  .categoryPlace[i];
                                          return InkWell(
                                            child: Container(
                                              padding:  EdgeInsets.symmetric(horizontal:  10.r ,vertical: 10.r),

                                              decoration: BoxDecoration(
                                                color: white,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(25.r),
                                                border:
                                                    Border.all(color: grey2),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    color: Colors.red,
                                                    height: 1.sw / 3.5,
                                                    width: 1.sw / 3.5,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(25.r),
                                                      child: ImageTools.image(
                                                        url: data.icon != null
                                                            ? data.icon!.src!
                                                            : null,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 25.h,
                                                  ),
                                                  Text('dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd',
                                                    // LanguageCubit.get(context).isEn
                                                    //     ? data.title!.en!
                                                    //     : data.title!.ar!,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: black,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              CurrentLocation location =
                                                  await navigateToWithRefreshPagePrevious(
                                                      context,
                                                      RecomendPlacesScreen(
                                                        id: data.id!,
                                                      )) as CurrentLocation;
                                              setState(() {
                                                if (location.description != null) {
                                                  Navigator.of(context)
                                                      .pop(location);
                                                }
                                              });
                                            },
                                          );
                                        },
                                      ),
                                  ),
                                ],
                              ),
                            )
                        : state is CategoryPlaceTripErrorState
                            ? errorMessage(
                                message: state.message,
                                press: () {
                                  CategoryPlaceTripScreenCubit.get(context)
                                      .getCategoryPlace(1);
                                },
                                context: context)
                            : Container(),
              ),
            ),
          );
        },
      ),
    );
  }
}

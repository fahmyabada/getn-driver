import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/image_tools.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/packages/packages_screen_cubit.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({Key? key, required this.carCategory}) : super(key: key);
  final String carCategory;

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  bool loadingPackages = false;

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
    return BlocConsumer<PackagesScreenCubit, PackagesScreenState>(
      listener: (context, state) {
        if (state is PackagesSuccessState) {
          setState(() {
            loadingPackages = false;
          });
        } else if (state is PackagesErrorState) {
          setState(() {
            loadingPackages = false;
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
                LanguageCubit.get(context).getTexts('Notifications').toString(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              centerTitle: true,
            ),
            body: ScrollEdgeListener(
              edge: ScrollEdge.end,
              // edgeOffset: 400,
              // continuous: false,
              // debounce: const Duration(milliseconds: 500),
              // dispatch: true,
              listener: () {
                setState(() {
                  print("_controllerNotification*********** ");
                  loadingPackages = true;
                });
                PackagesScreenCubit.get(context).getNotification(
                    PackagesScreenCubit.get(context).indexPackages,
                    widget.carCategory);
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.r, horizontal: 15.r),
                  child: state is PackagesLoading
                      ? loading()
                      : state is PackagesSuccessState
                          ? PackagesScreenCubit.get(context).packages.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: PackagesScreenCubit.get(context)
                                      .packages
                                      .length,
                                  itemBuilder: (context, index) {
                                    var package =
                                        PackagesScreenCubit.get(context)
                                            .packages[index];
                                    return InkWell(
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.r),
                                        padding: EdgeInsets.all(10.r),
                                        decoration: BoxDecoration(
                                          color: white,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(25.r),
                                          border: Border.all(color: grey2),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 1.sw / 3.5,
                                              width: 1.sw / 3.5,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(25.r),
                                                child: ImageTools.image(
                                                  url: package.icon != null
                                                      ? package.icon!.src!
                                                      : null,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15.h,
                                            ),
                                            Text(
                                              LanguageCubit.get(context).isEn
                                                  ? package.title!.en!
                                                  : package.title!.ar!,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: black,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {},
                                    );
                                  },
                                )
                              : errorMessage2(
                                  message: LanguageCubit.get(context)
                                      .getTexts('NotFoundData')
                                      .toString(),
                                  press: () {
                                    PackagesScreenCubit.get(context)
                                        .getNotification(1, widget.carCategory);
                                  },
                                  context: context)
                          : state is PackagesErrorState
                              ? errorMessage2(
                                  message: state.message,
                                  press: () {
                                    PackagesScreenCubit.get(context)
                                        .getNotification(1, widget.carCategory);
                                  },
                                  context: context)
                              : Container(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

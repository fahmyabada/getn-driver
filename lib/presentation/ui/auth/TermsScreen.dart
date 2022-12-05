import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/policies/policies_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
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
      create: (context) => PoliciesCubit()..getPolicies(widget.title),
      child: BlocConsumer<PoliciesCubit, PoliciesState>(
        listener: (context, state) {
          if (state is PoliciesLoading) {}
        },
        builder: (context, state) {
          return Directionality(
            textDirection: LanguageCubit.get(context).isEn
                ? ui.TextDirection.ltr
                : ui.TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                centerTitle: true,
              ),
              body: state is PoliciesLoading
                  ? loading()
                  : state is PoliciesErrorState
                      ? errorMessage2(
                          message: state.message,
                          press: () {
                            PoliciesCubit.get(context)
                                .getPolicies(widget.title);
                          },
                          context: context)
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Html(
                                data: LanguageCubit.get(context).isEn
                                    ? PoliciesCubit.get(context).content!.en!
                                    : PoliciesCubit.get(context).content!.ar!,
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 20.h, bottom: 20.h),
                                padding: EdgeInsets.all(15.r),
                                child: defaultButton3(
                                    press: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    text: LanguageCubit.get(context)
                                        .getTexts('Accept')
                                        .toString(),
                                    backColor: accentColor,
                                    textColor: white),
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

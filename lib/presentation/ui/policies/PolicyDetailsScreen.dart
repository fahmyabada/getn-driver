import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/ui/policies/policies_cubit.dart';

class PolicyDetailsScreen extends StatelessWidget {
  const PolicyDetailsScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PoliciesCubit()..getPolicies(title),
      child: BlocConsumer<PoliciesCubit, PoliciesState>(
        listener: (context, state) {
          if (state is PoliciesLoading) {}
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
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
              message: 'Something went wrong, please try again',
              press: () {
                PoliciesCubit.get(context).getPolicies(title);
              })
                    : SingleChildScrollView(
                      child: Html(
                          data: PoliciesCubit.get(context).content,
                        ),
                    ),
          );
        },
      ),
    );
  }
}

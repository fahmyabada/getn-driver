import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
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
                ? const Center(
                    child: CircularProgressIndicator(
                    color: black,
                  ))
                : state is PoliciesErrorState
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                'Something went wrong, please try again'),
                            TextButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                              ),
                              onPressed: () {
                                PoliciesCubit.get(context).getPolicies(title);
                              },
                              child: const Text('Retry'),
                            )
                          ],
                        ),
                      )
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

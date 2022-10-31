import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';

class RequestTransactionScreen extends StatefulWidget {
  const RequestTransactionScreen({Key? key}) : super(key: key);

  @override
  State<RequestTransactionScreen> createState() => _RequestTransactionScreenState();
}

class _RequestTransactionScreenState extends State<RequestTransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Request Transaction',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}

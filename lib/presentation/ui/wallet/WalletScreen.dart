import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late ScrollController _controllerWallet;

  @override
  void initState() {
    super.initState();
    _controllerWallet = ScrollController();
    WalletCubit.get(context).getWallet(1);
  }

  @override
  void dispose() {
    super.dispose();
    _controllerWallet.removeListener(_loadMoreWallet);
  }

  Row buildBalanceRow({required String title, required String balance}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 23.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Text(
            balance,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _loadMoreWallet() {
    WalletCubit.get(context).loadingWallet = false;


    WalletCubit.get(context).getWallet(WalletCubit.get(context).indexWallet);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'My Wallet',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              controller: _controllerWallet
                ..addListener(() async {
                  if (_controllerWallet.position.extentAfter == 0) {
                    if (WalletCubit.get(context).loadingWallet) {
                      print("_controllerWallet*********** ");
                      _loadMoreWallet();
                    }
                  }
                }),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 10.r,
                  horizontal: 16.r,
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.wallet,
                              color: primaryColor,
                              size: 80.sp,
                            ),
                            Text(
                              'Balance',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 26.sp,
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            SizedBox(
                              width: 280.w,
                              child: buildBalanceRow(
                                title: 'Wallet',
                                balance: WalletCubit.get(context)
                                        .walletValue
                                        .isNotEmpty
                                    ? WalletCubit.get(context).walletValue
                                    : "0.0",
                              ),
                            ),
                            Divider(
                              endIndent: 1.sw / 8,
                              indent: 1.sw / 8,
                            ),
                            SizedBox(
                              width: 280.w,
                              child: buildBalanceRow(
                                title: 'Hold',
                                balance:
                                    WalletCubit.get(context).walletHold.isNotEmpty
                                        ? WalletCubit.get(context).walletHold
                                        : "0.0",
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.r),
                              child: SizedBox(
                                  width: 1.sw,
                                  child: SizedBox(
                                    height: 50.h,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
                                        ),
                                        backgroundColor: primaryColor,
                                      ),
                                      onPressed: () {
                                        // Get.toNamed(Routes.ADD_NEW_CARD);
                                      },
                                      child: Text(
                                        'Charge Balance',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.sp),
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                     SizedBox(
                      height: 8.h,
                    ),
                    const Divider(),
                     ListTile(
                      title: Text(
                        'Last Transactions',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    WalletCubit.get(context).wallet.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: WalletCubit.get(context).wallet.length,
                            itemBuilder: (context, index) {
                              var item = WalletCubit.get(context).wallet[index];
                              return ListTile(
                                title: Text(
                                  item.id!,
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.sp,
                                  ),
                                ),
                                subtitle: Text(item.comment ?? ''),
                                trailing: Text(
                                  item.amount!.toStringAsFixed(2),
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(0),
                              );
                            })
                        : Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            const Center(
                                child: CircularProgressIndicator(
                                  color: black,
                                ),
                              ),
                          ],
                        ),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}

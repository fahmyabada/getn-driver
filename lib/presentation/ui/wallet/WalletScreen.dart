import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getn_driver/data/utils/colors.dart';
import 'package:getn_driver/data/utils/widgets.dart';
import 'package:getn_driver/presentation/di/injection_container.dart';
import 'package:getn_driver/presentation/ui/language/language_cubit.dart';
import 'package:getn_driver/presentation/ui/wallet/RequestTransactionScreen.dart';
import 'package:getn_driver/presentation/ui/wallet/wallet_cubit.dart';
import 'package:scroll_edge_listener/scroll_edge_listener.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool loadingMoreWallet = false;
  bool loadingMoreRequests = false;
  int _currentIndex = 0;
  String typeScreen = "wallet";

  @override
  void initState() {
    super.initState();
    WalletCubit.get(context).getWallet(1);
    if (getIt<SharedPreferences>().getBool("isEn") != null) {
      LanguageCubit.get(context).isEn =
          getIt<SharedPreferences>().getBool("isEn")!;
    }
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
    WalletCubit.get(context).getWallet(WalletCubit.get(context).indexWallet);
  }

  void _loadMoreRequests() {
    WalletCubit.get(context)
        .getRequests(WalletCubit.get(context).indexRequests);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalletCubit, WalletState>(
      listener: (context, state) {
        if (state is WalletSuccessState) {
          setState(() {
            loadingMoreWallet = false;
          });
        } else if (state is WalletErrorState) {
          setState(() {
            loadingMoreWallet = false;
          });
        } else if (state is RequestsSuccessState) {
          setState(() {
            loadingMoreRequests = false;
          });
        } else if (state is RequestsErrorState) {
          setState(() {
            loadingMoreRequests = false;
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
                LanguageCubit.get(context).getTexts('MyWallet').toString(),
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
                if (typeScreen == "wallet") {
                  setState(() {
                    print("_controllerWallet*********** ");
                    loadingMoreWallet = true;
                  });
                  _loadMoreWallet();
                } else if (typeScreen == "requests") {
                  print("_controllerRequests*********** $loadingMoreRequests");
                  setState(() {
                    loadingMoreRequests = true;
                  });
                  _loadMoreRequests();
                }
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.r,
                    horizontal: 15.r,
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
                                LanguageCubit.get(context)
                                    .getTexts('Balance')
                                    .toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26.sp,
                                ),
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              WalletCubit.get(context).loadingWallet
                                  ? loading()
                                  : WalletCubit.get(context).wallet.isNotEmpty
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            SizedBox(
                                              width: 280.w,
                                              child: buildBalanceRow(
                                                title:
                                                    LanguageCubit.get(context)
                                                        .getTexts('Wallet')
                                                        .toString(),
                                                balance: WalletCubit.get(
                                                            context)
                                                        .walletValue
                                                        .isNotEmpty
                                                    ? WalletCubit.get(context)
                                                        .walletValue
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
                                                title:
                                                    LanguageCubit.get(context)
                                                        .getTexts('Hold')
                                                        .toString(),
                                                balance: WalletCubit.get(
                                                            context)
                                                        .walletHold
                                                        .isNotEmpty
                                                    ? WalletCubit.get(context)
                                                        .walletHold
                                                    : "0.0",
                                              ),
                                            ),
                                          ],
                                        )
                                      : errorMessage2(
                                          message: WalletCubit.get(context)
                                                  .walletFailure ??
                                              LanguageCubit.get(context)
                                                  .getTexts('NotFoundData')
                                                  .toString(),
                                          press: () {
                                            WalletCubit.get(context)
                                                .indexWallet = 1;
                                            WalletCubit.get(context)
                                                .getWallet(1);
                                          }),
                              SizedBox(
                                height: 16.h,
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.r),
                                child: defaultButton3(
                                  backColor: primaryColor,
                                  textColor: white,
                                  press: () async {
                                    await navigateToWithRefreshPagePrevious(
                                            context,
                                            const RequestTransactionScreen())
                                        .then((value) {
                                      setState(() {
                                        loadingMoreWallet = false;
                                        loadingMoreRequests = false;
                                        _currentIndex = 0;
                                        typeScreen = "wallet";
                                        WalletCubit.get(context).getWallet(1);
                                      });
                                    });
                                  },
                                  text: LanguageCubit.get(context)
                                      .getTexts('RequestTransaction')
                                      .toString(),
                                ),
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
                          LanguageCubit.get(context)
                              .getTexts('LastTransactions')
                              .toString(),
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.sp,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      _currentIndex == 0
                          ? state is WalletLoading
                              ? loading()
                              : state is WalletSuccessState
                                  ? WalletCubit.get(context).wallet.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: WalletCubit.get(context)
                                              .wallet
                                              .length,
                                          itemBuilder: (context, index) {
                                            var item = WalletCubit.get(context)
                                                .wallet[index];
                                            return Column(
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    item.type!,
                                                    style: TextStyle(
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22.sp,
                                                    ),
                                                  ),
                                                  subtitle:
                                                      Text(item.comment ?? ''),
                                                  trailing: Column(
                                                    children: [
                                                      Text(
                                                        item.status!,
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20.sp,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5.h,),
                                                      Text(
                                                        item.amount!
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 20.sp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.all(0),
                                                ),
                                                index ==
                                                            WalletCubit.get(
                                                                        context)
                                                                    .wallet
                                                                    .length -
                                                                1 &&
                                                        loadingMoreWallet
                                                    ? Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                          loading(),
                                                          SizedBox(
                                                            height: 10.h,
                                                          ),
                                                        ],
                                                      )
                                                    : Container(),
                                              ],
                                            );
                                          })
                                      : errorMessage2(
                                          message: LanguageCubit.get(context)
                                              .getTexts('NotFoundData')
                                              .toString(),
                                          press: () {
                                            WalletCubit.get(context)
                                                .getWallet(1);
                                          })
                                  : state is WalletErrorState
                                      ? errorMessage2(
                                          message: state.message,
                                          press: () {
                                            WalletCubit.get(context)
                                                .getWallet(1);
                                          })
                                      : Container()
                          : _currentIndex == 1
                              ? state is RequestsLoading
                                  ? loading()
                                  : state is RequestsSuccessState
                                      ? WalletCubit.get(context)
                                              .requests
                                              .isNotEmpty
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.vertical,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  WalletCubit.get(context)
                                                      .requests
                                                      .length,
                                              itemBuilder: (context, index) {
                                                var item =
                                                    WalletCubit.get(context)
                                                        .requests[index];
                                                return Column(
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        item.status!,
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 22.sp,
                                                        ),
                                                      ),
                                                      subtitle:
                                                          Text(item.id ?? ''),
                                                      trailing: Text(
                                                        item.amount!
                                                            .toStringAsFixed(2),
                                                        style: TextStyle(
                                                          color: primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20.sp,
                                                        ),
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              0),
                                                    ),
                                                    index ==
                                                                WalletCubit.get(
                                                                            context)
                                                                        .requests
                                                                        .length -
                                                                    1 &&
                                                            loadingMoreRequests
                                                        ? Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                              loading(),
                                                              SizedBox(
                                                                height: 10.h,
                                                              ),
                                                            ],
                                                          )
                                                        : Container(),
                                                  ],
                                                );
                                              })
                                          : errorMessage2(
                                              message:
                                                  LanguageCubit.get(context)
                                                      .getTexts('NotFoundData')
                                                      .toString(),
                                              press: () {
                                                WalletCubit.get(context)
                                                    .getRequests(1);
                                              })
                                      : state is WalletErrorState
                                          ? errorMessage2(
                                              message: state.message,
                                              press: () {
                                                WalletCubit.get(context)
                                                    .getRequests(1);
                                              })
                                          : Container()
                              : Container(),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  if (index == 0) {
                    WalletCubit.get(context).indexWallet = 1;
                    WalletCubit.get(context).getWallet(1);
                    typeScreen = "wallet";
                  } else {
                    WalletCubit.get(context).indexRequests = 1;
                    WalletCubit.get(context).getRequests(1);
                    typeScreen = "requests";
                  }
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: primaryColor,
              selectedItemColor: accentColor,
              unselectedItemColor: grey,
              items: [
                BottomNavigationBarItem(
                    icon: const Icon(Icons.upcoming),
                    label: LanguageCubit.get(context)
                        .getTexts('Wallet')
                        .toString()),
                BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: LanguageCubit.get(context)
                        .getTexts('Requests')
                        .toString()),
              ],
            ),
          ),
        );
      },
    );
  }
}

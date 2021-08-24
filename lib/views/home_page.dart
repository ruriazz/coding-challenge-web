import 'package:arcainternational/constant/app_colors.dart';
import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/payment_model.dart';
import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:arcainternational/widget/app_button.dart';
import 'package:arcainternational/widget/main_layout.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  bool onLoad = true;
  List<Payment> paymentList = <Payment>[];
  bool isAdmin = false;

  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bool isAuth = await Application.userService.isAuth();
      if(!isAuth) {
        Application.router.navigateTo(context, '/auth', clearStack: true);
        return;
      }

      _initialPage();
    });
  }

  void _initialPage() async {
    isAdmin = await Application.userService.isAdmin();
    paymentList = await Application.paymentService.getAllPayment();
    print(paymentList.length);

    super.setState(() {
      paymentList = paymentList;
      onLoad = false;
    });
  }

  Widget build(BuildContext context) {
    return MainView(
      context: context,
      body: Center(
        child: onLoad ? SizedBox(
            width: 65,
            height: 65,
            child: CircularProgressIndicator(strokeWidth: 2)
          ) : MainLayout(
            context: context,
            body: Column(
              children: [
                Container(
                  child: Text(
                    "Riwayat Pembayaran",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  width: 500,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: _ItemPaymentList(),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  List<Widget> _ItemPaymentList() {
    return <Widget>[
      for(Payment payment in paymentList)
        InkWell(
          onTap: () => Application.router.navigateTo(context, '/detail-pay/${payment.id}'),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${payment.id}",
                          style: TextStyle(
                            color: AppColors.fontColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "${DateFormat('dd-MM-yyyy HH:mm').format(DateTime.fromMillisecondsSinceEpoch(payment.timeStored! * 1000))}",
                          style: TextStyle(
                            color: Color.fromRGBO(123, 130, 140, 1),
                            fontSize: 11
                          ),
                        ),
                        Text(
                          "${payment.submiter!.name!.capitalize()} | ${payment.submiter!.email}",
                          style: TextStyle(
                            color: Color.fromRGBO(123, 130, 140, 1),
                            fontSize: 11
                          ),
                        ),
                        Divider()
                      ],
                    ),
                  )
                ),
                isAdmin ? SizedBox(
                  child: IconButton(
                    color: Colors.red,
                    icon: Icon(Icons.delete_forever),
                    onPressed: () async {
                      bool delete = await showDialog(
                        context: context, 
                        builder: (_) => AlertDialog(
                          content: Text("Hapus data pembayaran ${payment.id!}?"),
                          actions: [
                            AppButton(
                              label: "Batal",
                              backgroundColor: Color.fromRGBO(125, 125, 125, 1),
                              onPressed: () => Navigator.of(context).pop(false)
                            ),
                            AppButton(
                              label: "Hapus",
                              backgroundColor: Colors.red,
                              onPressed: () => Navigator.of(context).pop(true)
                            )
                          ],
                        )
                      );

                      if(!delete)
                        return;

                      super.setState(() {
                        onLoad = true;
                      });

                      bool removed = await Application.paymentService.deletePayment(id: payment.id!);
                      if(removed)
                        Application.router.navigateTo(context, '/', replace: true);

                      super.setState(() {
                        onLoad = false;
                      });
                    },
                  ),
                ) : Container()
              ],
            ),
          ),
        )
    ];
  }
}
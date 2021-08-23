import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/payment_model.dart';
import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:arcainternational/widget/app_button.dart';
import 'package:arcainternational/widget/main_layout.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DetailPaymentPage extends StatefulWidget {
  String id;

  DetailPaymentPage({required this.id});

  _DetailPaymentPageState createState() {
    return new _DetailPaymentPageState();
  }
}

class _DetailPaymentPageState extends State<DetailPaymentPage> {
  bool onLoad = true;
  Payment? dataPayment;

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
    dataPayment = await Application.paymentService.getPayment(id: widget.id);
    if(dataPayment == null)
      Application.router.navigateTo(context, '/', replace: true);

    super.setState(() {
      dataPayment = dataPayment;
      onLoad = false;
    });

    print("data: ${dataPayment.toString()}");
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
            body: _MainPage(),
          )
      ),
    );
  }

  Widget _MainPage() {
    String fixedString = dataPayment!.totalPayment!.toString();
    String x = NumberFormat.simpleCurrency(locale: 'id').format(double.parse(fixedString));
    x = x.replaceAll('Rp', '');

    return Center(
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 85,
                    child: Text("ID"),
                  ),
                  Container(
                    child: Text(": ${dataPayment!.id}"),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 85,
                    child: Text("Tanggal"),
                  ),
                  Container(
                    child: Text(": ${dataPayment!.timeStored}"),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 85,
                    child: Text("Jam"),
                  ),
                  Container(
                    child: Text(": ${dataPayment!.timeStored}"),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 85,
                    child: Text("Petugas"),
                  ),
                  Container(
                    child: Text(": ${dataPayment!.submiter!.name!.capitalize()} | ${dataPayment!.submiter!.email}"),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 2.5),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 85,
                    child: Text("Dana"),
                  ),
                  Container(
                    child: Text(": Rp. $x"),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: AppButton(
                label: "Edit",
                onPressed: (){},
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Card(
                child: SizedBox(
                  height: 500,
                  width: 500,
                  child: ListView.separated(
                    itemCount: dataPayment!.member!.length,
                    itemBuilder: (context, index) {
                      String fixedString = ((dataPayment!.member![index].value! / 100) * dataPayment!.totalPayment!).toString();
                      String x = NumberFormat.simpleCurrency(locale: 'id').format(double.parse(fixedString));
                      x = x.replaceAll('Rp', '');
                    
                      return StatefulBuilder(
                        builder: (context, _setState) {
                          return ListTile(
                            title: Text(
                              dataPayment!.member![index].user!.name!,
                              style: TextStyle(
                                fontSize: 14
                              ),
                            ),
                            subtitle: Text(
                              dataPayment!.member![index].user!.email!
                            ),
                            trailing: Container(
                              // padding: EdgeInsets.only(top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text("${dataPayment!.member![index].value!}%"),
                                  Text("Rp. $x")
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(); 
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
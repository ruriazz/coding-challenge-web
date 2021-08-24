import 'dart:convert';

import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/member_model.dart';
import 'package:arcainternational/datamodels/payment_model.dart';
import 'package:arcainternational/helpers/input_formatter/rupiah_formatter.dart';
import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:arcainternational/widget/app_button.dart';
import 'package:arcainternational/widget/app_text_filed.dart';
import 'package:arcainternational/widget/main_layout.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool onDelete = false;
  bool editing = false;
  bool isAdmin = false;
  Payment? dataPayment;
  List<String> memberValue = <String>[];

  TextEditingController tcEditPay = new TextEditingController();
  FocusNode fnEditPay = new FocusNode();

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
    dataPayment = await Application.paymentService.getPayment(id: widget.id);
    if(dataPayment == null)
      Application.router.navigateTo(context, '/', replace: true);

    if(dataPayment == null)
      Application.router.navigateTo(context, '/', replace: true);

    String x = NumberFormat.simpleCurrency(locale: 'id').format(dataPayment!.totalPayment);
    x = x.replaceAll('Rp', '');
    x = x.replaceAll(',00', '');

    for(Member member in dataPayment!.member!) {
      String fixedString = ((member.value! / 100) * dataPayment!.totalPayment!).toString();
      String x = NumberFormat.simpleCurrency(locale: 'id').format(double.parse(fixedString));
      x = x.replaceAll('Rp', '');

      memberValue.add(x);
    }

    super.setState(() {
      dataPayment = dataPayment;
      tcEditPay.text = x;
      onLoad = false;
    });

    print("data: ${dataPayment.toString()}");
  }

  Widget build(BuildContext context) {
    return MainView(
      context: context,
      body: Center(
        child: onLoad || dataPayment == null ? SizedBox(
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
                    child: Text(": ${DateFormat('dd-MM-yyyy').format(DateTime.fromMillisecondsSinceEpoch(dataPayment!.timeStored! * 1000))}"),
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
                    child: Text(": ${DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(dataPayment!.timeStored! * 1000))}"),
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
                    child: !editing ? Row(
                      children: [
                        Text(": Rp. $x"),
                        isAdmin ? AppButton(
                          margin: EdgeInsets.only(left: 10),
                          onPressed: (){
                            super.setState(() {
                              editing = true;
                            });
                          },
                          label: "ubah",
                        ) : Container()
                      ],
                    ) : isAdmin ? Row(
                      children: [
                        AppTextField(
                          label: "Pembayaran",
                          width: 150,
                          prefixText: "Rp. ",
                          controller: tcEditPay, 
                          focusNode: fnEditPay,
                          onChanged: __changeMemberValue,
                          inputFormatter: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            RupiahInputFormatter()
                          ],
                        ),
                        AppButton(
                          backgroundColor: Colors.green,
                          margin: EdgeInsets.only(left: 10),
                          onPressed: __saveUpdate,
                          label: "Simpan",
                        ),
                        AppButton(
                          backgroundColor: Color.fromRGBO(125, 125, 125, 1),
                          margin: EdgeInsets.only(left: 10),
                          onPressed: (){
                            __changeMemberValue(dataPayment!.totalPayment.toString());
                            super.setState(() {
                              editing = false;
                            });
                          },
                          label: "Batal",
                        ),
                      ],
                    ) : Container(),
                  )
                ],
              ),
            ),
            isAdmin ? Container(
              width: 500,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  onDelete ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22.5),
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(strokeWidth: 2,)
                    ),
                  ) : AppButton(
                    margin: EdgeInsets.all(2.5),
                    backgroundColor: Colors.red,
                    label: "Hapus",
                    onPressed: __deletePayment,
                  )
                ],
              ),
            ) : Container(),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: Card(
                child: SizedBox(
                  height: 500,
                  width: 500,
                  child: ListView.separated(
                    itemCount: dataPayment!.member!.length,
                    itemBuilder: (context, index) {
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
                                  Text("Rp. ${memberValue[index]}")
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

  void __deletePayment() async {
    bool next = await showDialog(
      barrierDismissible: true,
      context: context, 
      builder: (_) => AlertDialog(
        content: Text("Hapus data?"),
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

    if(!next)
      return;

    setState(() {
      onDelete = true;
    });
    bool deleted = await Application.paymentService.deletePayment(id: dataPayment!.id!);
    if(deleted)
      Application.router.navigateTo(context, '/');

    setState(() {
      onDelete = false;
    });
  }

  void __changeMemberValue(String value) async {
    value = value.replaceAll('.', '');
    double doubleVal = double.parse(value);

    for(Member member in dataPayment!.member!) {
      int idx = dataPayment!.member!.indexOf(member);

      double val = member.value! / 100;
      String fixVal = (val * doubleVal).toStringAsFixed(2);
      String x = NumberFormat.simpleCurrency(locale: 'id').format(double.parse(fixVal));
      x = x.replaceAll('Rp', '');
      x = x.replaceAll(',00', '');
      print(fixVal);
      memberValue[idx] = x;
    }

    super.setState(() {
      memberValue = memberValue;
    });

    print(doubleVal);
  }

  void __saveUpdate() async {
    bool next = await showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        content: Text("Simpan data?"),
        actions: [
          AppButton(
            backgroundColor: Color.fromRGBO(125, 125, 125, 1),
            label: "Batal",
            onPressed: () => Navigator.of(context).pop(false)
          ),
          AppButton(
            backgroundColor: Colors.green,
            label: "Simpan",
            onPressed: () => Navigator.of(context).pop(true)
          )
        ],
      )
    );

    if(!next)
      return;


    try {
      fnEditPay.unfocus();
    } catch (e) {}
    
    super.setState(() {
      onLoad = true;
    });

    String editedValue = tcEditPay.text;
    editedValue = editedValue.replaceAll('.', '');
    double doubleVal = double.parse(editedValue);

    dataPayment!.totalPayment = doubleVal;

    bool updated = await Application.paymentService.updatePayment(newData: dataPayment!);
    if(updated)
      Application.router.navigateTo(context, '/detail-pay/${dataPayment!.id}', replace: true);

    super.setState(() {
      onLoad = false;
    });
  }
}
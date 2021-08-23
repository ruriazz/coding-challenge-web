import 'dart:convert';

import 'package:arcainternational/constant/application.dart';
import 'package:arcainternational/datamodels/member_model.dart';
import 'package:arcainternational/datamodels/payment_model.dart';
import 'package:arcainternational/datamodels/user_model.dart';
import 'package:arcainternational/helpers/input_formatter/percent_formatter.dart';
import 'package:arcainternational/helpers/input_formatter/rupiah_formatter.dart';
import 'package:arcainternational/helpers/validator_helper.dart';
import 'package:arcainternational/widget/app_button.dart';
import 'package:arcainternational/widget/app_modal.dart';
import 'package:arcainternational/widget/app_text_filed.dart';
import 'package:arcainternational/widget/checkbox_list_tile.dart';
import 'package:arcainternational/widget/main_layout.dart';
import 'package:arcainternational/widget/main_view.dart';
import 'package:arcainternational/widget/pay_list_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentPage extends StatefulWidget {
  _PaymentPageState createState() {
    return new _PaymentPageState();
  }
}

class _PaymentPageState extends State<PaymentPage> {
  bool onLoad = true;
  List<User> employeeList = <User>[];
  List<User> selectedEmployee = <User>[];
  List<bool> checked = <bool>[];
  List<Widget> dynamicAppTextField = <Widget>[];
  List<Widget> widgetListValue = <Widget>[];
  List<TextEditingController> dynamicTC = <TextEditingController>[];
  List<FocusNode> dynamicFN = <FocusNode>[];
  List<bool> dynamicErrTF = <bool>[];
  double percentTotal = 100.00;
  List<User> newEmployeeList = <User>[];

  TextEditingController tctotalPay = new TextEditingController();
  FocusNode fnTotalPay = new FocusNode();
  bool errTotalPay = false;
  bool submitUser = false;
  bool onSubmit = false;

  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      bool isAuth = await Application.userService.isAdmin();
      if(!isAuth) {
        Application.router.navigateTo(context, '/', clearStack: true);
        return;
      }

      _initialPage();
    });
  }

  void _initialPage() async {
    employeeList = await Application.userService.getEmployee();
    checked.clear();
    employeeList.forEach((e) {
      checked.add(false);
    });

    super.setState(() {
      employeeList = employeeList;
      checked = checked;
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
                AppTextField(
                  controller: tctotalPay, 
                  focusNode: fnTotalPay,
                  label: "Pembayaran",
                  prefixText: "Rp. ",
                  isError: errTotalPay,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => __onPercentChange(value, null),
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    RupiahInputFormatter()
                  ],
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  width: 265,
                  alignment: Alignment.centerLeft,
                  child: Text("Sisa pembagian: ${percentTotal.toStringAsFixed(2)}%"),
                ),
                Container(
                  child: Column(
                    children: dynamicAppTextField,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: submitUser ? SizedBox(
                    child: CircularProgressIndicator(strokeWidth: 2,),
                  ) : AppButton(
                    width: 85,
                    label: "+ Penerima",
                    onPressed: __selectEmployee
                  ),
                ),
                dynamicAppTextField.length > 0 ? Container(
                  margin: EdgeInsets.only(bottom: 15),
                  width: 265,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Penerima Bonus"
                  ),
                ) : Container(),
                Container(
                  width: 265,
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: widgetListValue,
                  ),
                ),
                widgetListValue.length > 0 ? onSubmit ? SizedBox(
                  child: CircularProgressIndicator(strokeWidth: 2,)
                ) : AppButton(
                  margin: EdgeInsets.only(top: 15),
                  label: "Simpan Data",
                  width: 85,
                  onPressed: __submitData
                ) : Container()
              ],
            ),
          )
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _UserSelect() {
    print("panjangList: ${employeeList.length}");
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: employeeList.length,
                  itemBuilder: (context, index) {
                    return CheckBoxListTile(
                      title: employeeList[index].name!,
                      subtitle: employeeList[index].email,
                      isSelected: checked[index],
                      onAction: (bool? value) {
                        final int idx = selectedEmployee.indexOf(employeeList[index]);

                        if(value == true) {
                          selectedEmployee.add(employeeList[index]);

                          Widget itemValue = new PayListValue(name: employeeList[index].name!, percent: 0) ;
                          TextEditingController x = new TextEditingController();
                          FocusNode y = new FocusNode();
                          Widget z = new AppTextField(
                            margin: EdgeInsets.symmetric(vertical: 2.5),
                            label: employeeList[index].name!.capitalize(),
                            controller: x,
                            focusNode: y,
                            suffixText: "%",
                            inputFormatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                              PercentInputFormatter(),
                            ],
                            onChanged: (value) => __onPercentChange(value, x),
                          );

                          widgetListValue.add(itemValue);
                          dynamicAppTextField.add(z);
                          dynamicFN.add(y);
                          dynamicTC.add(x);

                        } else {
                          String ctrText = dynamicTC[idx].text;
                          if(ctrText.isNotEmpty) {                        
                            ctrText = ctrText.replaceAll(',', '.');
                            double val = double.parse(ctrText);
                            percentTotal = percentTotal + val;
                          }

                          selectedEmployee.remove(employeeList[index]);
                          dynamicAppTextField.removeAt(idx);
                          dynamicFN.removeAt(idx);
                          dynamicTC.removeAt(idx);
                          widgetListValue.removeAt(idx);
                        }

                        super.setState(() {
                          percentTotal = percentTotal;
                          widgetListValue = widgetListValue;
                          selectedEmployee = selectedEmployee;
                          checked[index] = value!;
                          dynamicAppTextField = dynamicAppTextField;
                          dynamicFN = dynamicFN;
                          dynamicTC = dynamicTC;
                        });

                      },
                    );
                  },
                ),
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        label: "+Buruh",
                        onPressed: () => Navigator.of(context).pop('new_user'),
                      ),
                    ),
                    Expanded(
                      child: AppButton(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        label: "Simpan",
                        onPressed: () => Navigator.of(context).pop(null),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }

  Widget _CreateUser(StateSetter _setState) {
    TextEditingController tcEmail = new TextEditingController();
    TextEditingController tcName = new TextEditingController();
    FocusNode fnEmail = new FocusNode();
    FocusNode fnName = new FocusNode();
    bool err = false;


    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Text("Data Buruh"),
                  ),
                  AppTextField(
                    margin: EdgeInsets.all(5),
                    label: "Nama",
                    keyboardType: TextInputType.text,
                    controller: tcName, 
                    focusNode: fnName
                  ),
                  AppTextField(
                    margin: EdgeInsets.all(5),
                    label: "Email",
                    keyboardType: TextInputType.emailAddress,
                    controller: tcEmail,
                    isError: err,
                    focusNode: fnEmail
                  ),
                  AppButton(
                    margin: EdgeInsets.all(10),
                    width: 95,
                    label: "Tambahkan",
                    onPressed: () async {
                      if(tcEmail.text.isEmpty || tcName.text.isEmpty)
                        return;

                      String email = tcEmail.text.trim();
                      String name = tcName.text.trim();

                      if(!Valid.email(email))
                        return;

                      bool same = false;
                      for(User user in newEmployeeList) {
                        if(user.email == email) {
                          same = true;
                          break;
                        }
                      }
                      if(same)
                        return;

                      bool unique = await Application.userService.isUniqueEmail(email);
                      if(!unique)
                        return;

                      try {
                        fnName.unfocus();
                        fnEmail.unfocus();
                      } catch (e) {}

                      newEmployeeList.add(new User(email: email, name: name));
                      print("length: ${newEmployeeList.length}");

                      _setState(() {
                        newEmployeeList = newEmployeeList;
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: newEmployeeList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      newEmployeeList[index].name!,
                      style: TextStyle(fontSize: 12),
                    ),
                    subtitle: Text(
                      newEmployeeList[index].email!,
                      style: TextStyle(fontSize: 11),
                    ),
                    trailing: SizedBox(
                      child: IconButton(
                        color: Colors.red,
                        icon: Icon(Icons.remove),
                        onPressed: (){
                          newEmployeeList.removeAt(index);
                          
                          _setState(() {
                            newEmployeeList = newEmployeeList;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                Expanded(
                  child: AppButton(
                    backgroundColor: Colors.green,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    label: "Simpan",
                    onPressed: () => Navigator.of(context).pop('new_user'),
                  ),
                ),
                Expanded(
                  child: AppButton(
                    backgroundColor: Colors.red,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    label: "Batal",
                    onPressed: () => Navigator.of(context).pop('reopen'),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  void __onPercentChange(String value, TextEditingController? controller) {
    double x = 100;
    double total = 0;
    for(TextEditingController ctr in dynamicTC) {
      int idx = dynamicTC.indexOf(ctr);

      if(ctr.text.isNotEmpty) {
        String ctrText = ctr.text;
        ctrText = ctrText.replaceAll(',', '.');
        double val = double.parse(ctrText);
        total += val;

        if(tctotalPay.text.isNotEmpty) {
          if(total <= 100) {
            String totalPay = tctotalPay.text.replaceAll('.', '');
            double totalPayInt = double.parse(totalPay);
            val = val / 100;
            widgetListValue[idx] = PayListValue(name: selectedEmployee[idx].name!, percent: (totalPayInt * val));
          } else {
            widgetListValue[idx] = PayListValue(name: selectedEmployee[idx].name!, percent: 0);
          }
        }
      }
    }



    percentTotal = x - total;
    Application.percentTotal = percentTotal;
    super.setState(() {
      percentTotal = percentTotal;
      widgetListValue = widgetListValue;
    });

    if(percentTotal < 0) {
      showDialog(
        context: context, 
        builder: (_) => AlertDialog(content: Text("Melebihi jumlah yang disediakan. Kamu membagikan lebih dari 100%"),)
      );
    }
  }

  void __selectEmployee() async {
    String? action = await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, _setState) {
          _setState(() {
            employeeList = employeeList;
          });

          return new AppModal(
            context: context,
            width: 120,
            body: _UserSelect(),
          );
        }
      )
    );

    if(action != null && action == 'new_user')
      __createEmployee();
  }

  void __createEmployee() async {
    setState(() {
      newEmployeeList = <User>[];
    });

    dynamic action = await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, StateSetter setState) {
          return new AppModal(
            context: context,
            width: 350,
            body: _CreateUser(setState),
          );
        }
      )
    );

    if(action.toString() == 'reopen')
      return __selectEmployee();

    if(action.toString() == 'new_user' && newEmployeeList.length > 0) {
      super.setState(() {
        submitUser = true;
      });

      final List<User> newUsers = await Application.userService.submitNewUser(users: newEmployeeList);

      super.setState(() {
        submitUser = false;
      });

      if(newUsers.length > 0)
        Application.router.navigateTo(context, '/pay', replace: true);
    }
  }

  void __submitData() async {
    if(tctotalPay.text.isEmpty || tctotalPay.text == '0')
      return;

    if(selectedEmployee.length == 0)
      return;

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

    super.setState(() {
      onSubmit = true;
    });

    String totalPayment = tctotalPay.text;
    totalPayment = totalPayment.replaceAll('.', '');
    totalPayment = totalPayment.replaceAll(',', '.');

    String sessionString = await Application.session.getSession(key: User.sessionKey);
    User user = User.fromJson(json.decode(sessionString));
    user.authToken = null;

    List<Member> listMember = <Member>[];

    for(User selected in selectedEmployee) {
      int idx = selectedEmployee.indexOf(selected);

      String stringValue = dynamicTC[idx].text;
      stringValue = stringValue.replaceAll(',', '.');

      final Member member = new Member(
        user: selected,
        value: double.parse(stringValue)
      );

      listMember.add(member);
    }

    Payment? newPayment = await Application.paymentService.submitData(data: new Payment(
      totalPayment: double.parse(totalPayment),
      submiter: user,
      member: listMember
    ));

    super.setState(() {
      onSubmit = false;
    });

    if(newPayment != null) {
      Application.router.navigateTo(context, '/detail-pay/${newPayment.id}', replace: true);
    }
  }
}
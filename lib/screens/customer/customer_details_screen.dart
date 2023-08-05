import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lively_studio/app_color.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/model/model_customer_data.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:lively_studio/style.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../model/model_customer.dart';
import '../../provider/customer_chat_provider.dart';
import 'customer_update_diaog.dart';

class CustomerDetailsScreen extends StatefulWidget {
  final CustomerData customerData;

  const CustomerDetailsScreen({super.key, required this.customerData});

  @override
  CustomerDetailsScreenState createState() => CustomerDetailsScreenState();
}

class CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<CustomerChatProvider>(builder: (context, customerProvider, child) {
              return Container(
                color: primaryBackGround,
                child: Column(
                  children: [
                    SizedBox(
                      height: 6.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: primary,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_rounded),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              customerProvider.customer.customerName,
                              style: heading18,
                            ),
                            Text(
                              customerProvider.customer.customerMobileNo,
                              style: generalText,
                            ),
                          ],
                        ),
                        Container()
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Ink(
                          decoration: const ShapeDecoration(
                            color: primary,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.call),
                            color: primary,
                            onPressed: () {
                              GeneralUtils.makePhoneCall(customerProvider.customer.customerMobileNo);
                            },
                          ),
                        ),
                        Ink(
                          decoration: const ShapeDecoration(
                            color: primary,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                            ),
                            color: primary,
                            onPressed: () {
                              GeneralUtils.openWhatsApp(customerProvider.customer.customerMobileNo,
                                  "Hello ${customerProvider.customer.customerName}\n I am from ${ConfigGetter.USERDETAILS}");
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10, bottom: 10),
              child: Text(
                "Customer Info",
                style: heading14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 10, bottom: 10, right: 22),
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: secondaryBackground,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [BoxShadow(color: Color(0x1e000000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0)],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Number of Calls Made : ${widget.customerData.totalCalls}",
                    style: heading14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 10, bottom: 10, right: 18),
              child: Text(
                "Product enquired",
                style: heading14,
              ),
            ),
            SizedBox(
              height: 40.h,
              child: ListView.builder(
                  itemCount: widget.customerData.productUrls.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          width: 60.w, // Set your desired width
                          height: 400,
                          decoration: BoxDecoration(
                            color: secondaryBackground,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [BoxShadow(color: Color(0x1e000000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0)],
                          ),
                          child: Stack(
                            children: [
                              WebView(
                                backgroundColor: Colors.white,
                                javascriptMode: JavascriptMode.disabled,
                                initialUrl: widget.customerData.productUrls[index],
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetailsWebView(
                                                productUrl: widget.customerData.productUrls[index],
                                              )),
                                    );
                                  },
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  ),
                                  child: const Text('View'),
                                ),
                              )
                            ],
                          )),
                    );
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return EditCustomer(
                  customer: Provider.of<CustomerChatProvider>(context, listen: false).customer,
                  onUpdate: () => {Provider.of<CustomerChatProvider>(context, listen: false).getAllCustomer()},
                );
              });
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}

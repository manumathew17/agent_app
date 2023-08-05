import 'dart:convert';

import 'package:currency_symbols/currency_symbols.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lively_studio/model/model_customer.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/provider/customer_chat_provider.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:lively_studio/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../config/getter.dart';
import '../../model/model_customer_data.dart';
import '../../provider/catalog_provider.dart';
import '../../utils/general.dart';
import 'customer_details_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerChatProvider>(context, listen: false).getAllCustomer();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  _getUserDetails(Customer customer) {
    Loader.show(context);
    RequestRouter requestRouter = RequestRouter();
    final queryParams = {"customer_uuid": customer.customerUuid};
    requestRouter.getCustomerDetails(
        queryParams,
        RequestCallbacks(
            onSuccess: (response) {
              Map<String, dynamic> jsonDataMap = jsonDecode(response);
              final customerDetail = CustomerData.fromJson(jsonDataMap['data']);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerDetailsScreen(
                          customerData: customerDetail,
                        )),
              );
            },
            onError: (_) {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackGround,
          title: const Text(
            "Chats",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Consumer<CustomerChatProvider>(builder: (context, customerData, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: textWhiteGrey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 3),
                          child: Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              Provider.of<CatalogProvider>(context, listen: false).search(value);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search ',
                              hintStyle: TextStyle(fontSize: 13, color: Colors.black, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: customerData.customerList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 20),
                            child: InkWell(
                              onTap: () => {
                                customerData.setSelectedCustomer(customerData.customerList[index]),
                                _getUserDetails(customerData.customerList[index])},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: greyGeneral,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              customerData.customerList[index].customerName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 14),
                                            ),
                                            Text(
                                              customerData.customerList[index].customerMobileNo,
                                              style: const TextStyle(fontWeight: FontWeight.w100, color: Colors.black, fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),

                                      SizedBox(
                                        width: 1.w,
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Ink(
                                            decoration: const ShapeDecoration(
                                              shape: CircleBorder(),
                                            ),
                                            child: IconButton(
                                              icon: const FaIcon(
                                                FontAwesomeIcons.whatsapp,
                                                color: Colors.green,
                                              ),
                                              color: primary,
                                              onPressed: () {
                                                GeneralUtils.openWhatsApp(customerData.customerList[index].customerMobileNo, "");
                                              },
                                            ),
                                          ),

                                          IconButton(
                                            icon: const Icon(Icons.phone),
                                            color: Colors.black,
                                            onPressed: () {
                                              GeneralUtils.makePhoneCall(customerData.customerList[index].customerMobileNo);
                                            },
                                          ),
                                        ],
                                      )
                                      //    Text("10:12 PM", style: TextStyle(fontWeight: FontWeight.w200, color: Colors.grey, fontSize: 10))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }))
              ],
            ),
          );
        }));
  }
}

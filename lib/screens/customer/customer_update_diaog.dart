import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_color.dart';
import '../../model/model_customer.dart';
import '../../model/model_customer_data.dart';
import '../../provider/customer_chat_provider.dart';
import '../../style.dart';

class EditCustomer extends StatefulWidget {
  final Customer customer;
  final VoidCallback onUpdate;

  const EditCustomer({super.key,  required this.onUpdate, required this.customer,});

  @override
  EditCustomerState createState() => EditCustomerState();
}

class EditCustomerState extends State<EditCustomer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final RequestRouter requestRouter = RequestRouter();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.customer.customerName;
    mobileController.text = widget.customer.customerMobileNo;
  }




  _updateCustomerDetails(String name, String number) {
    Loader.show(context);
    final postBody = {"customer_uuid": widget.customer.customerUuid, "mobile_no": number, "name": name};
    requestRouter.updateCustomerDetails(postBody, RequestCallbacks(onSuccess: (response)  {
      Map<String, dynamic> jsonDataMap = jsonDecode(response);


      Provider.of<CustomerChatProvider>(context, listen: false).customer.customerName=jsonDataMap['data']['name'];
      Provider.of<CustomerChatProvider>(context, listen: false).customer.customerMobileNo=jsonDataMap['data']['mobile_no'];
      Provider.of<CustomerChatProvider>(context, listen: false).customer.customerUuid=jsonDataMap['data']['uuid'];

      widget.onUpdate(); Navigator.pop(context);}, onError: (error) {}));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Edit Information', style: heading6),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: textWhiteGrey,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        label: const Text('Enter name'),
                        hintText: 'Enter name',
                        hintStyle: heading6.copyWith(color: textGrey),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: textWhiteGrey,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        label: const Text('Enter phone number'),
                        hintText: 'Enter phone number',
                        hintStyle: heading6.copyWith(color: textGrey),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // To close the dialog
                  },
                  child: Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _updateCustomerDetails(nameController.text, mobileController.text);
                    }
                  },
                  child: Text('Update'),
                ),
              ],
            ),
            SizedBox(height: 3.w),
          ],
        ),
      ),
    );
  }
}

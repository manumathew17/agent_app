import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../app_color.dart';

class ProductDetailsWebView extends StatelessWidget {
  final String productUrl;

  const ProductDetailsWebView({super.key, required this.productUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackGround,
          leading: BackButton(
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Product details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: WebView(
          backgroundColor: Colors.white,
          initialUrl: productUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ));
  }
}

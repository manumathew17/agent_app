import 'package:currency_symbols/currency_symbols.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lively_studio/app_color.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/screens/product/product_detail_screen.dart';
import 'package:lively_studio/utils/Logger.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../provider/catalog_provider.dart';
import '../../utils/shared_preference.dart';
import '../../widgets/snackbar.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({super.key});

  @override
  ProductCatalogState createState() => ProductCatalogState();
}

class ProductCatalogState extends State<ProductCatalog> {
  final TextEditingController _searchController = TextEditingController();
  late GeneralSnackBar _generalSnackBar;

  @override
  initState() {
    super.initState();
    _generalSnackBar = GeneralSnackBar(context);
    Provider.of<CatalogProvider>(context, listen: false).getProductsList();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBackGround,
          title: const Text(
            "Products",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: Consumer<CatalogProvider>(
            builder: (context, catalogProvider, child) {
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                              Provider.of<CatalogProvider>(context,
                                      listen: false)
                                  .search(value);
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search ',
                              hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: catalogProvider.filteredProductList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x1e000000),
                                      offset: Offset(0, 2),
                                      blurRadius: 8,
                                      spreadRadius: 0)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                      height: 10.w,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.w / 2),
                                        child: Image.network(
                                          catalogProvider
                                              .filteredProductList[index]
                                              .thumbnail,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 1,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            catalogProvider
                                                .filteredProductList[index]
                                                .product,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            "${cSymbol(ConfigGetter.COMPANY_DETAILS.currency.currencyCode)} ${GeneralUtils.getPrice(catalogProvider.filteredProductList[index].price)}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: darkGreen,
                                                fontSize: 12),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProductDetailsWebView(
                                                              productUrl:
                                                                  catalogProvider
                                                                      .filteredProductList[
                                                                          index]
                                                                      .product_url,
                                                            )),
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(primary),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          lightPrimary_2),
                                                ),
                                                child: const Text('View'),
                                              ),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              TextButton.icon(
                                                onPressed: () {
                                                  GeneralUtils.copyToClipboard(
                                                      catalogProvider
                                                          .filteredProductList[
                                                              index]
                                                          .product_url);
                                                  _generalSnackBar
                                                      .showSuccessSnackBar(
                                                          "Copied to clipboard");
                                                },
                                                icon: const Icon(
                                                    Icons.copy_rounded),
                                                label: const Text('Copy url'),
                                                style: ButtonStyle(
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(primary),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          lightPrimary_1),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }))
              ],
            ),
          );
        })

        // Center(
        //   child: Text("Catalog"),
        // ),
        );
  }
}

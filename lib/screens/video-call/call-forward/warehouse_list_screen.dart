import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/provider/websocket_provider.dart';
import 'package:lively_studio/utils/notification/notification_controller.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:lively_studio/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../app_color.dart';
import '../../../network/callback.dart';
import '../../../provider/catalog_provider.dart';
import '../../../widgets/snackbar.dart';

class WareHouseList extends StatefulWidget {
  const WareHouseList({super.key, required this.onCallForwarded});

  final VoidCallback onCallForwarded;

  @override
  WareHouseListState createState() => WareHouseListState();
}

class WareHouseListState extends State<WareHouseList> {
  final TextEditingController _searchController = TextEditingController();
  late GeneralSnackBar _generalSnackBar;
  RequestRouter _requestRouter = RequestRouter();

  @override
  initState() {
    super.initState();
    _generalSnackBar = GeneralSnackBar(context);
    Provider.of<CatalogProvider>(context, listen: false).getCompanyLocation();
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
          "Forward call",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Consumer<CatalogProvider>(builder: (context, catalogProvider, child) {
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
                            Provider.of<CatalogProvider>(context, listen: false).filterLocations(value);
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
                      itemCount: catalogProvider.filteredLocation.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: greyGeneral,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    catalogProvider.filteredLocation[index].name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black, fontSize: 14),
                                  ),
                                  Text(
                                    catalogProvider.filteredLocation[index].address,
                                    style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FilledButton(
                                        onPressed: () async {
                                          Loader.show(context);
                                          Provider.of<WebSocketProvider>(context, listen: false)
                                              .sendMessageForCallForwarding(catalogProvider.filteredLocation[index].warehouseUuid);

                                          final postBody = {
                                            'token': Provider.of<WebSocketProvider>(context, listen: false).call_token,
                                            "call_status": 4,
                                            "source": "cms",
                                            "warehouse_uuid": catalogProvider.filteredLocation[index].warehouseUuid
                                          };
                                          _requestRouter.updateCallStatus(
                                              postBody,
                                              RequestCallbacks(onSuccess: (response) {
                                                Loader.hide();
                                                _generalSnackBar
                                                    .showWarningSnackBar("Call forwarded to ${catalogProvider.filteredLocation[index].name}");
                                                Navigator.pop(context);
                                                widget.onCallForwarded();
                                              }, onError: (error) {
                                                Loader.hide();
                                                _generalSnackBar.showErrorSnackBar("Failed to forward the call");
                                              }));

                                          NotificationController.cancelAllNotification();
                                          await SharedPreferenceUtility.setCallAttended(true);
                                        },
                                        child: const Text('Forward to here'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }))
            ],
          ),
        );
      }),
    );
  }
}

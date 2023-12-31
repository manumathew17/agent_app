import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/network/callback.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/provider/home-provider.dart';
import 'package:lively_studio/screens/call_list_screen.dart';
import 'package:lively_studio/screens/customer/chat_screen.dart';
import 'package:lively_studio/screens/home/home_screen.dart';
import 'package:lively_studio/screens/profile/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../app_color.dart';
import '../../provider/websocket_provider.dart';
import '../../style.dart';
import '../../utils/notification/notification_controller.dart';
import '../../widgets/progress_bar.dart';
import '../calls/calls_screen.dart';
import '../product/catalog_screen.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

class DashBoardScreenState extends State<DashBoardScreen> {
  bool isOfflineConfirmShown = false;
  String tokenId = "Token";

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  RequestRouter requestRouter = RequestRouter();

  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  int _selectedIndex = 0;

  bool isPlaying = false;

  static const List<Widget> _homeScreensWidgets = [HomeScreen(), CallScreen(), ChatScreen(), ProductCatalog(), ProfileScreen()];

  @override
  void initState() {

    _onlineStatus();
    Provider.of<HomeProvider>(context, listen: false).getUserOnlineStatus(() {_showOfflineConfirmation(); });
    NotificationController.initializeLocalNotifications();
    super.initState();
  }

  _onlineStatus() {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);




    homeProvider.addListener(() {
      bool isOnline = homeProvider.isOnline;
      if (!isOnline && !isOfflineConfirmShown) {
        isOfflineConfirmShown = true;
        _showOfflineConfirmation();
      }
    });
  }

  Future<void> _showOfflineConfirmation() {
    isOfflineConfirmShown = true;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Offline'),
          content: const Text('You are offline please make it online'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text(
                'Online',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                _updateOnlineStatus();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _updateOnlineStatus() {
    Provider.of<HomeProvider>(context, listen: false).updateOnlineStatus(value: true);
  }


  // _joinCall() {
  //   if (ZegoUIKitPrebuiltCallMiniOverlayMachine().isMinimizing) {
  //     return;
  //   }
  //   GoRouter.of(context).push("/video-call");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homeScreensWidgets.elementAt(_selectedIndex),
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.bounceIn,
        selectedIndex: _selectedIndex,
        iconSize: 30,
        showElevation: false,
        // use this to remove appBar's elevation

        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home_filled),
            title: const Text(
              'Home',
              style: TextStyle(color: primaryDark),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.call_rounded),
            title: const Text(
              'Call',
              style: TextStyle(color: primaryDark),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.chat_rounded),
            title: const Text(
              'Chat',
              style: TextStyle(color: primaryDark),
            ),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.dashboard_rounded),
            title: const Text(
              'Catalog',
              style: TextStyle(color: primaryDark),
            ),
          ),
          // FlashyTabBarItem(
          //   icon: Icon(Icons.chat_rounded),
          //   title: Text('Chat'),
          // ),
          FlashyTabBarItem(
            icon: const Icon(
              Icons.account_circle_rounded,
            ),
            title: const Text(
              'Profile',
              style: TextStyle(color: primaryDark),
            ),
          ),
        ],
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
        }),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: Center(
//       child: PopupMenuButton<SampleItem>(
//         enableFeedback: true,
//         tooltip: 'Options',
//         surfaceTintColor: Colors.white,
//         elevation: 20,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10.0),
//         ),
//         // Callback that sets the selected popup menu item.
//         onSelected: (SampleItem item) {},
//         itemBuilder: (BuildContext context) =>
//         <PopupMenuEntry<SampleItem>>[
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.itemOne,
//             child: Text('Item 1'),
//           ),
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.itemTwo,
//             child: Text('Item 2'),
//           ),
//           const PopupMenuItem<SampleItem>(
//             value: SampleItem.itemThree,
//             child: Text('Item 3'),
//           ),
//         ],
//         child: IntrinsicWidth(
//           child: Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.0),
//               border: Border.all(
//                 color: lightPrimary_2, // Replace with your primary color
//                 width: 1,
//               ),
//             ),
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'Weekly',
//                     style: generalText,
//                   ),
//                 ),
//                 Icon(Icons.arrow_drop_down_rounded),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed:_joinCall,
//       tooltip: 'Join call',
//       child: const Icon(Icons.add),
//     ),
//   );
// }
}

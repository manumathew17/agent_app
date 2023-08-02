import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:lively_studio/widgets/snackbar.dart';
import 'package:sizer/sizer.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../app_color.dart';
import '../../network/callback.dart';
import '../../style.dart';
import '../../widgets/loader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late GeneralSnackBar _generalSnackBar;
  bool light1 = true;
  final values = List.filled(7, true);

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  initState() {
    super.initState();
    _generalSnackBar = GeneralSnackBar(context);
  }

  Future<void> _selectTime(bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = selectedTime;
          _startTimeController.text = _startTime!.format(context);
          _endTime = null;
          _endTimeController.text = '';
        } else {
          _endTime = selectedTime;
          _endTimeController.text = _endTime!.format(context);
        }
      });
    }
  }

  _logOut() async {
    Loader.show(context);
    RequestRouter requestRouter = RequestRouter();
    final requestBody = {
      'fcm_token': " ",
    };

    requestRouter.updateFcmToken(
        requestBody,
        RequestCallbacks(
            onSuccess: (response) async => {await SharedPreferenceUtility.clearAllStorage(), Loader.hide(), context.go('/login')},
            onError: (error) => {Loader.hide(), _generalSnackBar.showErrorSnackBar(error)}));
  }

  Future<void> _logoutConfirm(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure to log out ?'),
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
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _logOut();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 10.w,
                    height: 10.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.w / 2),
                      child: Image.network(
                        ConfigGetter.COMPANY_DETAILS.brandLogo,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ConfigGetter.COMPANY_DETAILS.companyName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          ConfigGetter.USERDETAILS.userId,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: darkGreen, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Table(
                children: [
                  TableRow(children: [
                    Text('Name', style: heading6),
                    Text('agent name', style: heading6),
                  ]),
                  TableRow(children: [
                    Text('Email', style: heading6),
                    Text('test@gmial.com', style: heading6),
                  ]),
                  TableRow(children: [
                    Text('Phone number', style: heading6),
                    Text('+974585632654', style: heading6),
                  ]),
                  TableRow(children: [
                    Text('Timings', style: heading6),
                    Text('9 am to 6 pm', style: heading6),
                  ]),
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              Text('Availability', style: heading6),
              SizedBox(
                height: 1.h,
              ),
              WeekdaySelector(
                onChanged: (int day) {
                  print(day);
                  setState(() {
                    final index = day % 7;
                    values[index] = !values[index];
                  });
                },
                values: values,
              ),
              SizedBox(
                height: 5.h,
              ),
              TextFormField(
                controller: _startTimeController,
                readOnly: true,
                onTap: () => _selectTime(true),
                decoration: InputDecoration(
                  labelText: 'Start Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _endTimeController,
                readOnly: true,
                onTap: () => _selectTime(false),
                decoration: InputDecoration(
                  labelText: 'End Time',
                  suffixIcon: Icon(Icons.access_time),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available?', style: heading6),
                  Switch(
                    value: light1,
                    onChanged: (bool value) {
                      setState(() {
                        light1 = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                  width: 100.w,
                  child: FilledButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(errorPrimary),
                    ),
                    onPressed: () {
                      _logoutConfirm(context);
                    },
                    child: const Text('Logout'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

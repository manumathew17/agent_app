import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lively_studio/config/getter.dart';
import 'package:lively_studio/network/request_route.dart';
import 'package:lively_studio/utils/general.dart';
import 'package:lively_studio/utils/shared_preference.dart';
import 'package:lively_studio/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../app_color.dart';
import '../../model/model_agent_availability.dart';
import '../../network/callback.dart';
import '../../provider/home-provider.dart';
import '../../style.dart';
import '../../widgets/loader.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late GeneralSnackBar _generalSnackBar;
  TimeOfDay? _fromTime;
  TimeOfDay? _toTime;
  final _formKey = GlobalKey<FormState>();
  bool light1 = true;

  List<bool> workingDays = List.filled(7, false);
  RequestRouter requestRouter = RequestRouter();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  @override
  initState() {
    super.initState();
    _generalSnackBar = GeneralSnackBar(context);
    _getAgentTiming();
  }

  _getAgentTiming() {
    requestRouter.getAgentTiming(RequestCallbacks(
        onSuccess: (response) {
          Map<String, dynamic> jsonDatMap = jsonDecode(response);
          Map<String, dynamic> data = jsonDatMap['data']["availability"];

          AvailabilityAvailability agentAvailability = AvailabilityAvailability.fromJson(data);
          setState(() {
            for (int i = 0; i < agentAvailability.days.length; i++) {
              workingDays[agentAvailability.days[i]] = true;
            }
            _fromTime = GeneralUtils.intToTimeOfDay(agentAvailability.time.min);
            _toTime = GeneralUtils.intToTimeOfDay(agentAvailability.time.max);

            _startTimeController.text = _formatTime(_fromTime!);
            _endTimeController.text = _formatTime(_toTime!);
          });
        },
        onError: (error) {}));
  }

  Future<void> _selectFromTime(BuildContext context) async {
    _endTimeController.text = "";
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _fromTime = selectedTime;
        _startTimeController.text = _formatTime(_fromTime!);
        _toTime = null; // Reset the "to" time when selecting "from" time
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    if (_fromTime == null) {
      // Don't proceed if "from" time is not selected yet
      return;
    }

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _fromTime!,
    );

    if (selectedTime != null) {
      setState(() {
        _toTime = selectedTime;
        _endTimeController.text = _formatTime(_toTime!);
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    String period = time.hour >= 12 ? 'PM' : 'AM';
    int hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  _updateWorkingDays() {
    if (_formKey.currentState?.validate() ?? false) {
      List<int> selectedWorking = [];
      for (int i = 0; i < workingDays.length; i++) {
        if (workingDays[i] == true) {
          selectedWorking.add(i);
        }
      }

      final postBody = {
        "user_id": ConfigGetter.USERDETAILS.userId,
        "availability": {
          "days": selectedWorking,
          "time": {"min": _fromTime!.hour, "max": _toTime!.hour}
        }
      };

      Loader.show(context);

      requestRouter.updateUser(
          postBody,
          RequestCallbacks(onSuccess: (_) {
            _generalSnackBar.showSuccessSnackBar("Updated successfully");
          }, onError: (_) {
            _generalSnackBar.showErrorSnackBar("Failed to update");
          }));
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
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
    final requestBody = {
      'fcm_token': " ",
    };

    requestRouter.updateFcmToken(
        requestBody,
        RequestCallbacks(
            onSuccess: (response) async => {await SharedPreferenceUtility.clearAllStorage(), Loader.hide(), context.go('/login')},
            onError: (error) => {
              SharedPreferenceUtility.clearAllStorage(),
              Loader.hide(), _generalSnackBar.showErrorSnackBar(error)}));
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
                          ConfigGetter.USERDETAILS.user_name,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: darkGreen, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer<HomeProvider>(builder: (context, onlineStatus, child) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(
                                onlineStatus.isOnline ? 'Online' : 'Offline',
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Switch(
                              value: onlineStatus.isOnline,
                              onChanged: (bool value) {
                                Provider.of<HomeProvider>(context, listen: false).updateOnlineStatus();
                              },
                            ),
                          ],
                        );
                      }),
                    ],
                  ))
                ],
              ),
              SizedBox(
                height: 5.h,
              ),
              // Table(
              //   children: [
              //
              //     TableRow(children: [
              //       Text('Email', style: heading6),
              //       Text('test@gmial.com', style: heading6),
              //     ]),
              //     TableRow(children: [
              //       Text('Phone number', style: heading6),
              //       Text('+974585632654', style: heading6),
              //     ]),
              //     TableRow(children: [
              //       Text('Timings', style: heading6),
              //       Text('9 am to 6 pm', style: heading6),
              //     ]),
              //   ],
              // ),
              SizedBox(
                height: 3.h,
              ),
              Text('Availability', style: heading6),
              SizedBox(
                height: 1.h,
              ),
              WeekdaySelector(
                onChanged: (int day) {
                  setState(() {
                    final index = day % 7;
                    workingDays[index] = !workingDays[index];
                  });
                },
                values: workingDays,
              ),
              SizedBox(
                height: 5.h,
              ),

              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: TextFormField(
                          controller: _startTimeController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          onTap: () => _selectFromTime(context),
                          decoration: InputDecoration(
                            label: const Text('From'),
                            hintText: 'From',
                            hintStyle: heading6.copyWith(color: textGrey),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter from time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: textWhiteGrey,
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: TextFormField(
                          controller: _endTimeController,
                          keyboardType: TextInputType.number,
                          readOnly: true,
                          onTap: () => _selectToTime(context),
                          decoration: InputDecoration(
                            label: const Text('To'),
                            hintText: 'To',
                            hintStyle: heading6.copyWith(color: textGrey),
                            border: const OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value?.isEmpty ?? true) {
                              return 'Please enter to time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(onPressed: () => {_updateWorkingDays()}, child: const Text("Update"))
                ],
              ),

              SizedBox(
                height: 5.h,
              ),

              //
              //
              //
              //
              //
              // TextFormField(
              //   controller: _startTimeController,
              //   readOnly: true,
              //   onTap: () => _selectTime(true),
              //   decoration: InputDecoration(
              //     labelText: 'Start Time',
              //     suffixIcon: Icon(Icons.access_time),
              //   ),
              // ),
              // SizedBox(height: 16),
              // TextFormField(
              //   controller: _endTimeController,
              //   readOnly: true,
              //   onTap: () => _selectTime(false),
              //   decoration: InputDecoration(
              //     labelText: 'End Time',
              //     suffixIcon: Icon(Icons.access_time),
              //   ),
              // ),

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

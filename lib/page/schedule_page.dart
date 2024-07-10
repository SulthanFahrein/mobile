import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/config/app_route.dart';
import 'package:test_ta_1/config/constants.dart';
import 'package:test_ta_1/controller/c_property.dart';
import 'package:test_ta_1/controller/c_schedule.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/model/property.dart' as PropertyModel;
import 'package:test_ta_1/model/user.dart';
import 'package:test_ta_1/model/schedule.dart' as ScheduleModel;
import 'package:test_ta_1/widget/button_custom.dart';
import 'package:intl/intl.dart';
import 'package:test_ta_1/widget/short_address.dart';
import 'package:test_ta_1/widget/alertdialog.dart'; // Import alertdialog.dart

class Schedule extends StatefulWidget {
  final PropertyModel.Datum property;

  const Schedule({
    Key? key,
    required this.property,
  }) : super(key: key);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  late Future<List<PropertyModel.Datum>> _propertiesFuture;
  late Future<List<ScheduleModel.Jadwal>> _schedulesFuture;
  TimeOfDay _timeOfDay = const TimeOfDay(hour: 0, minute: 00);
  late DateTime today;
  late DateTime selectedDay;
  ScheduleModel.Jadwal? currentSchedule; 
  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    selectedDay = today;
    _propertiesFuture = fetchProperties();
    _schedulesFuture = fetchSchedules();
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _timeOfDay = value;
        });
      }
    });
  }

  Future<List<ScheduleModel.Jadwal>> fetchSchedules() async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;

    if (user == null) {
      print('User is not logged in');
      return [];
    }

    final controller = ScheduleController();
    final schedules = await controller.getSchedule(user.idUser ?? 0);
    return schedules.map((e) => ScheduleModel.Jadwal.fromJson(e)).toList();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
  }

  void _submitSchedule(BuildContext context) async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;

    if (user == null) {
      print('User is not logged in');
      return;
    }

    // Show confirmation dialog before submitting
    showAlertDialog(
      context: context,
      onConfirm: () async {
        final controller = ScheduleController();
        try {
          final formattedTime =
              '${_timeOfDay.hour.toString().padLeft(2, '0')}:${_timeOfDay.minute.toString().padLeft(2, '0')}';

          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);

          await controller.postSchedule(
            idPengguna: user.idUser ?? 0,
            idProperti: widget.property.id,
            tanggal: formattedDate,
            pukul: formattedTime,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Schedule posted successfully')),
          );
          Navigator.pushReplacementNamed(context, AppRoute.schedulesuccess);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to post schedule: $e')),
          );
        }
      },
      imageAsset: AppAsset.alert,
      message: 'Do you want to submit this schedule?',
    );
  }

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final user = sessionProvider.user;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Schedule",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<PropertyModel.Datum>>(
        future: _propertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final properties = snapshot.data ?? [];
            if (properties.isEmpty) {
              // Handle case when no properties are available
              return Center(child: Text('No properties available'));
            }
            final propertyId = widget.property.id; // Assuming widget.property has the property ID

            return FutureBuilder<List<ScheduleModel.Jadwal>>(
              future: _schedulesFuture,
              builder: (context, scheduleSnapshot) {
                if (scheduleSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (scheduleSnapshot.hasError) {
                  return Center(child: Text('Error: ${scheduleSnapshot.error}'));
                } else {
                  final schedules = scheduleSnapshot.data ?? [];
                  final filteredSchedules = schedules.where((schedule) => schedule.idProperti == propertyId).toList();

                  if (filteredSchedules.isEmpty) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        header(context, widget.property),
                        const SizedBox(height: 16),
                        fieldSchedule(user),
                        const SizedBox(height: 16),
                        calendar(),
                        const SizedBox(height: 25),
                        buildBottomNavigationBar(context),
                      ],
                    );
                  }

                  final currentSchedule = filteredSchedules.reduce((curr, next) =>
                      curr.idJadwal > next.idJadwal ? curr : next);

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      header(context, widget.property),
                      const SizedBox(height: 16),
                      fieldSchedule(user),
                      const SizedBox(height: 16),
                      calendar(),
                      const SizedBox(height: 25),
                      if (currentSchedule.jadwalDiterima == 'pending')
                        Center(
                          child: Text(
                            'Jadwal Telah disimpan, mohon tunggu respon dari Admin',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (currentSchedule.jadwalDiterima == 'accept')
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'Jadwal Telah di Accept Admin, silahkan selesaikan kunjungan anda',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                      if (currentSchedule.jadwalDiterima == 'done' ||
                          currentSchedule.jadwalDiterima == 'reject')
                        buildBottomNavigationBar(context),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Container calendar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 43,
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        focusedDay: today,
        firstDay: DateTime.utc(2012, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        onDaySelected: _onDaySelected,
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return ButtonCustom(
      label: 'Submit',
      isExpand: true,
      onTap: () => _submitSchedule(context),
    );
  }

  Widget fieldSchedule(User? user) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set Schedule',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Time',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _timeOfDay.format(context).toString(),
                    style: const TextStyle(fontSize: 30),
                  ),
                  MaterialButton(
                    onPressed: _showTimePicker,
                    color: AppColor.primary,
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'PICK TIME',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Calendar',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Container header(BuildContext context, PropertyModel.Datum property) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              '$baseUrll/storage/images_property/${property.images[0].image}',
              fit: BoxFit.cover,
              height: 70,
              width: 90,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  shortenAddress(property.address),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

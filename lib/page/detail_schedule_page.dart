import 'package:flutter/material.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/constants.dart';

import 'package:test_ta_1/controller/c_schedule.dart';
import 'package:test_ta_1/widget/alertdialog.dart';
import 'package:test_ta_1/widget/button_custom.dart';
import 'package:intl/intl.dart';

class DetailSchedule extends StatelessWidget {
  final dynamic schedule;

  const DetailSchedule({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(
            const Duration(seconds: 1)); // Placeholder for refresh logic
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          title: const Text(
            "Detail Booking",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            header(context), // Custom function returning a widget for header
            const SizedBox(height: 16),
            scheduleDetail(
                context), // Custom function returning a widget for schedule details
            const SizedBox(height: 20),
            buttonEditDelete(
                context), // Custom function returning a widget for edit/delete buttons
          ],
        ),
      ),
    );
  }

  Center buttonEditDelete(BuildContext context) {
    String status = schedule['jadwal_diterima'];
    String message;
    Color messageColor;

    switch (status) {
      case 'accept':
        message = 'Schedule ini sudah di Accept, ';
        messageColor = Colors.green;
        break;
      case 'done':
        message = 'Schedule ini sudah di Done';
        messageColor = Theme.of(context).primaryColor;
        break;
      case 'reject':
        message =
            'Schedule ini sudah di Reject, di mohon untuk melakukan set schedule ulang';
        messageColor = Colors.red;
        break;
      default:
        message = '';
        messageColor = Colors.grey;
    }

    return Center(
      child: message.isNotEmpty
          ? Center(
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: messageColor,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonCustom(
                  label: 'Edit Schedule',
                  hasShadow: false,
                  onTap: () {
                    _showEditDialog(context);
                  },
                ),
                const SizedBox(width: 8),
                ButtonCustom(
                label: 'Delete',
                hasShadow: false,
                onTap: () async {
                  // Show confirmation dialog before deleting
                  showAlertDialog(
                    context: context,
                    onConfirm: () async {
                      try {
                        await ScheduleController()
                            .deleteSchedule(schedule['id_jadwal']);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Schedule deleted successfully')),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Failed to delete schedule')),
                        );
                      }
                    },
                    imageAsset: AppAsset.alert,
                    message: 'Are you sure you want to delete this schedule?',
                   // Optional: Change color of the dialog
                  );
                },
                color: Colors.red,
                boxShadowColor: Colors.red,
              ),
              ],
            ),
    );
  }

  Container scheduleDetail(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detail',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          itemscheduleDetail(
            context,
            'Name',
            schedule['pengguna']['name_user'] ?? 'N/A',
          ),
          const SizedBox(height: 16),
          itemscheduleDetail(
            context,
            'Phone',
            schedule['pengguna']['phone_user'] ?? 'N/A',
          ),
          const SizedBox(height: 16),
          itemscheduleDetail(
            context,
            'Date',
            schedule['tanggal'] ?? 'N/A',
          ),
          const SizedBox(height: 16),
          itemscheduleDetail(
            context,
            'Time',
            schedule['pukul'] ?? 'N/A',
          ),
          const SizedBox(height: 16),
          itemscheduleDetail(
            context,
            'PIC',
            schedule['pic'] ?? '-',
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: schedule['jadwal_diterima'] == "accept"
                      ? Colors.green
                      : schedule['jadwal_diterima'] == "reject"
                          ? Colors.red
                          : schedule['jadwal_diterima'] == "pending"
                              ? Colors.grey
                              : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  schedule['jadwal_diterima'] == "accept"
                      ? 'Accept'
                      : schedule['jadwal_diterima'] == "reject"
                          ? 'Reject'
                          : schedule['jadwal_diterima'] == "pending"
                              ? 'Pending'
                              : 'Done',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          Text(
            'Note :',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            schedule['catatan'] ?? '-',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Row itemscheduleDetail(BuildContext context, String title, String data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          data,
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Container header(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  '$baseUrll/storage/images_property/${schedule['properti']['images'][0]['image']}',
                  fit: BoxFit.cover,
                  height: 70,
                  width: 90,
                  errorBuilder: (context, error, stackTrace) {
                    print(error);
                    return const Center(child: Text('Image not available '));
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['properti']['name'] ?? 'N/A',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10,),
          Text(
                  schedule['properti']['address'] ?? 'N/A',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
                ),
        ],
      ),
    );
    
  }

  void _showEditDialog(BuildContext context) {
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();

    dateController.text = schedule['tanggal'];
    timeController.text = formatTime(schedule['pukul']);

    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Schedule'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              controller: dateController,
              decoration: InputDecoration(
                labelText: 'Date',
                hintText: 'YYYY-MM-DD',
              ),
            ),
            TextFormField(
              controller: timeController,
              decoration: InputDecoration(
                labelText: 'Time',
                hintText: 'HH:MM',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () async {
              // Show confirmation dialog before saving
              showAlertDialog(
                context: context,
                onConfirm: () async {
                  try {
                    await ScheduleController().updateSchedule(
                      id_jadwal: schedule['id_jadwal'],
                      tanggal: dateController.text,
                      pukul: timeController.text,
                    );
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Schedule updated successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update schedule : $e')),
                    );
                  }
                },
                imageAsset: AppAsset.alert,
                message: 'Are you sure you want to update this schedule?',
              );
            },
          ),
        ],
      );
    },
  );
  }

  String formatTime(String time) {
    DateTime parsedTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('HH:mm').format(parsedTime);
  }
}

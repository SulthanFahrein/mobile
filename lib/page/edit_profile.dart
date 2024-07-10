import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/model/user.dart';
import 'package:test_ta_1/widget/alertdialog.dart';
import 'package:test_ta_1/widget/button_custom.dart';
import 'package:test_ta_1/widget/custom_text_form_field.dart';


class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    User? user = sessionProvider.user;

    // Create controllers for the form fields
    TextEditingController nameController =
        TextEditingController(text: user?.nameUser);
    TextEditingController phoneController =
        TextEditingController(text: user?.phoneUser);

    void _saveProfile() async {
      // Validate form fields before saving
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all required fields')),
        );
        return; // Stop execution if fields are not filled
      }

      // Validate phone length
      if (phoneController.text.length > 15 || phoneController.text.length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone number must be between 10 and 15 characters'),
          ),
        );
        return; 
      }

      // Confirm before saving
      showAlertDialog(
        context: context,
        imageAsset: AppAsset.alert, 
        message: 'Are you sure you want to save changes?',
        onConfirm: () async {
          // Update user object with new values
          if (user != null) {
            user.nameUser = nameController.text;
            user.phoneUser = phoneController.text;

            try {
              await sessionProvider.updateProfile(user);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile updated successfully')),
              );
              Navigator.pop(context); // Go back to previous screen
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to update profile: $e')),
              );
            }
          }
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          CustomTextFormField(
            controller: nameController,
            hintText: 'Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Name is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: phoneController,
            hintText: 'Phone',
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Phone is required';
              }
              if (value.length > 15) {
                return 'Phone must be at most 15 characters long';
              }
              if (value.length < 10) {
                return 'Phone must be at least 10 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ButtonCustom(
            label: 'Save',
            isExpand: true,
            onTap: _saveProfile,
          ),
        ],
      ),
    );
  }
}

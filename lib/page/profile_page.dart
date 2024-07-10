import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:test_ta_1/config/app_asset.dart';
import 'package:test_ta_1/config/app_color.dart';
import 'package:test_ta_1/config/app_route.dart';
import 'package:test_ta_1/controller/sessionProvider.dart';
import 'package:test_ta_1/widget/alertdialog.dart';
import 'package:test_ta_1/widget/button_custom.dart';
import 'package:http/http.dart' as http;
import 'package:test_ta_1/config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadProfileImage(); // Load profile image when the page initializes
  }

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Save the selected image for the current user
      saveProfileImage(_image);
      // Call uploadProfileImage immediately after selecting an image
      await uploadProfileImage(context);
    } else {
      print('No image selected.');
    }
  }

  Future<void> uploadProfileImage(BuildContext context) async {
    if (_image == null) return;

    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrll/api/data_user/upload-profile-image'),
      );
      request.fields['user_id'] = user?.idUser.toString() ?? '';
      request.files.add(await http.MultipartFile.fromPath('profile_image', _image!.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Handle successful upload
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image uploaded successfully')),
        );
        // Update the locally stored profile image path for the current user
        saveProfileImage(_image);
      } else {
        // Handle other status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload profile image: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile image: $e')),
      );
      print(e);
    }
  }

  Future<void> loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;
    String? imagePath = prefs.getString('profile_image_path_${user?.idUser}');
    if (imagePath != null && imagePath.isNotEmpty) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> saveProfileImage(File? image) async {
    if (image == null) return;
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final user = sessionProvider.user;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path_${user?.idUser}', image.path);
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
          "Profile",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              photoname(context, user),
              button(context),
              listviewtrinity(context, sessionProvider),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                width: double.infinity,
                height: 200,
              ),
            ],
          )
        ],
      ),
    );
  }

  Container listviewtrinity(BuildContext context, SessionProvider sessionProvider) {
    return Container(
      color: AppColor.netrall,
      padding: const EdgeInsets.all(15),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          ListTile(
            leading: Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(45),
              child: InkWell(
                borderRadius: BorderRadius.circular(45),
                child: const SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('Setting'),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Material(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(45),
              child: InkWell(
                borderRadius: BorderRadius.circular(45),
                child: const SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: Icon(
                      Icons.book,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('Information'),
            onTap: () {
              Navigator.pushNamed(context, AppRoute.information);
            },
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: Material(
              color: AppColor.alert,
              borderRadius: BorderRadius.circular(45),
              child: InkWell(
                borderRadius: BorderRadius.circular(45),
                child: const SizedBox(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text('Logout'),
            onTap: () {
              showAlertDialog(
                context: context,
                onConfirm: () async {
                  await sessionProvider.logout();
                  Navigator.pushNamedAndRemoveUntil(context, AppRoute.signin, (route) => false);
                },
                imageAsset: AppAsset.alert,
                message: 'Do you want to\nlog out',
              );
            },
          ),
        ],
      ),
    );
  }

  Container button(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ButtonCustom(
        label: 'Edit Profile',
        hasShadow: false,
        onTap: () {
          Navigator.pushNamed(context, AppRoute.editprofile);
        },
      ),
    );
  }


Container photoname(BuildContext context, dynamic user) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.white),
    ),
    width: 1000, // Sesuaikan lebar kontainer sesuai kebutuhan
    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            // Menampilkan dialog dengan gambar zoom-in
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); 
                          },
                          child: Hero(
                            tag: 'profile_image_hero', 
                            child: _image == null
                              ? Image.asset(
                                  AppAsset.profile,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  _image!,
                                  fit: BoxFit.contain,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Stack(
            children: [
              SizedBox(
                width: 130, 
                height: 130, 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: _image == null
                    ? Image.asset(
                        AppAsset.profile,
                        fit: BoxFit.fitWidth,
                      )
                    : Image.file(
                        _image!,
                        fit: BoxFit.fitWidth,
                      ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    // Menampilkan pilihan kamera atau galeri
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: const Icon(Icons.camera),
                                title: const Text('Camera'),
                                onTap: () {
                                  getImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: const Text('Gallery'),
                                onTap: () {
                                  getImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColor.primary,
                    child: Icon(
                      Icons.camera_alt,
                      color: AppColor.secondary
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          user?.nameUser ?? '',
          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          user?.emailUser ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          user?.phoneUser ?? '',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    ),
  );
}





}

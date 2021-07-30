import 'dart:io';

import 'package:acc/models/authentication/verify_phone_signin.dart';
import 'package:acc/models/profile/profile_image.dart';
import 'package:acc/services/ProfileService.dart';
import 'package:acc/utilites/text_style.dart';
import 'package:acc/utilites/ui_widgets.dart';
import 'package:acc/utils/code_utils.dart';
import 'package:acc/widgets/circular_container.dart';
import 'package:acc/widgets/image_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ProfilePicScreen extends StatefulWidget {
  final String imageUrl;

  ProfilePicScreen(this.imageUrl);

  @override
  createState() => _ProfilePicScreenState();
}

class _ProfilePicScreenState extends State<ProfilePicScreen> {
  File profilePhoto;
  final double circleRadius = 100;
  final double borderRadius = 80;
  final double innerContHeight = 190;
  final double imageHeight = 100;
  var progress;
  var _imageUrl;

  @override
  void initState() {
    _imageUrl = widget.imageUrl;
    print('ImageURL: $_imageUrl');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white));

    Future<void> _uploadFile(
        BuildContext context, File file, String fileName) async {
      progress = ProgressHUD.of(context);
      progress?.showWithText('Uploading File...');
      try {
        if (file != null) {
          UploadProfileImage imgResponse =
              await ProfileService.uploadProfileImage(file, fileName);
          if (imgResponse.type == 'success') {
            final userData = await CodeUtils.getUserInfo();
            if (userData != null) {
              userData.profileImage = imgResponse.data.userProfileImagePath;
              final isSynced =
                  await CodeUtils.syncUserPreferencesWithData(userData);
              if (isSynced) {
                UserData.instance.userInfo = await CodeUtils.getUserInfo();
              }
            }
          }
        } else {
          showSnackBar(context, 'Something went wrong.');
        }
        progress.dismiss();
        setState(() {});
      } catch (e) {
        showSnackBar(context, 'Something went wrong.');
        if (progress != null) {
          progress.dismiss();
        }
        setState(() {});
      }
    }

    void _openDialogToUploadFile(
        BuildContext context, File file, String fileName) {
      // set up the buttons
      Widget positiveButton = TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _uploadFile(context, file, fileName);
          },
          child: Text(
            "Ok",
            style: textNormal16(Color(0xff00A699)),
          ));

      Widget cancelButton = TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            profilePhoto = null;
            setState(() {});
          },
          child: Text(
            "Cancel",
            style: textNormal16(Color(0xff00A699)),
          ));

      AlertDialog alert = AlertDialog(
        content: Text('Do you want to upload the chosen image?'),
        actions: [
          positiveButton,
          cancelButton,
        ],
      );

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    void _imgFromSource(BuildContext context, ImageSource source) async {
      final ImagePicker _picker = ImagePicker();
      final pickedFile = await _picker.getImage(
          source: source, preferredCameraDevice: CameraDevice.rear);

      setState(() {
        profilePhoto = File(pickedFile.path);
        String fileName = p.basename(profilePhoto.path);
        _openDialogToUploadFile(context, profilePhoto, fileName);
      });
    }

    void _showPicker(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return SafeArea(
              child: Container(
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        leading: new Icon(Icons.photo_library),
                        title: new Text('Photo Library'),
                        onTap: () {
                          _imgFromSource(context, ImageSource.gallery);
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _imgFromSource(context, ImageSource.camera);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            );
          });
    }

    Widget _setProfilePic() {
      return ProgressHUD(
        child: Builder(
          builder: (context) => Center(
            child: GestureDetector(
              onTap: () {
                _showPicker(context);
              },
              child: Container(
                height: 200,
                width: 200,
                child: CircleAvatar(
                  radius: circleRadius,
                  backgroundColor: Colors.orange,
                  child: profilePhoto == null
                      ? (_imageUrl != null && _imageUrl != '')
                          ? ImageCircle(
                              borderRadius: circleRadius,
                              image: Image.network(
                                _imageUrl,
                                width: innerContHeight,
                                height: innerContHeight,
                                fit: BoxFit.fill,
                              ),
                            )
                          : CircularContainer(
                              circleRadius: circleRadius,
                              innerContHeight: innerContHeight)
                      : ImageCircle(
                          borderRadius: circleRadius,
                          image: Image.file(
                            profilePhoto,
                            width: innerContHeight,
                            height: innerContHeight,
                            fit: BoxFit.fill,
                          )),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.0,
      ),
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 10, left: 10),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Image.asset("assets/images/icon_close.png"),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              _setProfilePic(),
            ],
          ),
        ),
      ),
    );
  }
}

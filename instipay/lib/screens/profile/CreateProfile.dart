import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  // late PickedFile _imageFile;
  PickedFile? pickedImage;
  io.File? _imageFile;
  bool _load = false;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: <Widget>[
            imageProfile(),
            SizedBox(
              height: 20,
            ),
            nameTextField(),
            SizedBox(
              height: 20,
            ),
            dobField(),
            SizedBox(
              height: 20,
            ),
            branchTextField(),
            SizedBox(
              height: 20,
            ),
            yearField(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? AssetImage("assets/images/logo.png")
                : FileImage(io.File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
              bottom: 20.0,
              right: 20.0,
              child: TextButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: ((builder) => bottomSheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.teal,
                  size: 28.0,
                ),
              ))
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text(
          "Choose Profile Photo",
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () {
                takePhoto(ImageSource.camera);
              },
            ),
            Text("Camera"),
            IconButton(
              icon: const Icon(Icons.image),
              onPressed: () {
                takePhoto(ImageSource.gallery);
              },
            ),
            Text("Gallery"),
          ],
        )
      ]),
    );
  }

  // void takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(
  //     source: source,
  //   );
  //   setState(() {
  //     _imageFile = pickedFile as PickedFile;
  //   });
  // }

  Future takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = io.File(pickedFile!.path);
      _load = false;
    });
  }

  Widget nameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.green,
          ),
          labelText: "Name",
          helperText: "Name can't be empty",
          hintText: "Navya Agarwal"),
    );
  }

  Widget dobField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.green,
          ),
          labelText: "Date of Birth",
          helperText: "Provide DOB as DD/MM/YY",
          hintText: "01/01/2004"),
    );
  }

  Widget branchTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.green,
          ),
          labelText: "Branch",
          helperText: "Branch can't be empty",
          hintText: "Mechanical Engineering"),
    );
  }

  Widget yearField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          )),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.green,
          ),
          labelText: "Year",
          helperText: "Year can't be empty",
          hintText: "2"),
    );
  }
}

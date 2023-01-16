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
  final dropdownItems = ['Student', 'Faculty', 'Vendor'];
  var _value = "-1";
  DateTime date = DateTime(2022, 12, 24);

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
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(
              height: 7,
            ),
            ElevatedButton(
              child: Text('Select Date of Birth'),
              style: ElevatedButton.styleFrom(primary: Color(0xff300757)),
              onPressed: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                );

                if (newDate == null) return;

                setState(() => date = newDate);
              },
            ),
            SizedBox(
              height: 20,
            ),
            idTextField(),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6))),
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text("-Select Role-"),
                      value: "-1",
                    ),
                    DropdownMenuItem(
                      child: Text("Student"),
                      value: "1",
                    ),
                    DropdownMenuItem(
                      child: Text("Faculty"),
                      value: "2",
                    ),
                    DropdownMenuItem(
                      child: Text("Vendor"),
                      value: "3",
                    ),
                  ],
                  onChanged: (v) {}),
            ),
            // yearField(),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: (() {}),
              child: Text("Submit"),
              style: ElevatedButton.styleFrom(primary: Color(0xff300757)),
            )
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
                  color: Color(0xff300757),
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
            color: Color(0xff300757),
          ),
          labelText: "Name",
          helperText: "Name can't be empty",
          hintText: "Navya Agarwal"),
    );
  }

  Widget idTextField() {
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
            color: Color(0xff300757),
          ),
          labelText: "College Id",
          helperText: "Id can't be empty",
          hintText: "1180372019"),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import 'package:flutter/services.dart' show rootBundle;

import 'model/model.dart';

void main() {
  runApp(MyApp());
}

List<Item> parseItems(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Item>((json) => Item.fromJson(json)).toList();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Master',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File _image;
  final picker = ImagePicker();

  List<Item> recipeList;

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/recipe.json').then((value) {
      recipeList = parseItems(value);
      print(recipeList);
    });

    loadModel().then((value) => print('model loaded'));
  }

  @override
  Future<void> dispose() async {
    await Tflite.close();
    super.dispose();
  }

  Future<String> loadModel() async {
    return Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
      useGpuDelegate: true,
    );
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? Text('No image selected.')
                : Image.file(
                    _image,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.camera),
              child: Text('select image from camera'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => getImage(ImageSource.gallery),
              child: Text('select image from gallery'),
            )
          ],
        ),
      ),
      floatingActionButton: _getFab(),
    );
  }

  _getFab() {
    if (_image != null) {
      return FloatingActionButton.extended(
        onPressed: () async {
          Tflite.runModelOnImage(path: _image.path, asynch: true)
              .then((value) async {
            print(value);

            if (value.length > 0) {
              final Map itemName = value.first;

              final item = recipeList
                  .where((element) => element.name == itemName['label']);



              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => Result(item: item.first)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('No item found'),
              ));
            }
          });
        },
        label: Text('get recipe'),
      );
    }
  }
}

class Result extends StatelessWidget {
  Result({Key key, @required this.item}) : super(key: key);

  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Item name : ${item.name}',
                  style: TextStyle(fontSize: 24),
                ),
              ),
              ExpansionTile(
                title: Text('ingredients'),
                children: [Text(item.ingredients1)],
              ),
              ExpansionTile(
                title: Text('Recipe'),
                children: [Text(item.recipe1)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

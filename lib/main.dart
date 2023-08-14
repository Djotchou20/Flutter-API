import 'dart:convert';
// import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import './dashboard.dart';
import './base_stations.dart';
// import 'camera.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'display.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'myform.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SiteSurvey',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => LoginPage(),
          '/dashboard.dart': (context) => const Dashboard(),
          '/details': (context) => Details(
                item: {},
              ),
          '/base_stations.dart': (context) => BaseStation(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const String apiKey = 'gw8c4kos0wgsgogw408o88wwwwk4cs80s80g480g';
    const String apiUrl =
        'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/sitesurveyreq/getpendingsitesurveysbyuser?username=admin'; // Replace with your API URL

    final headers = {
      'x-api-key': apiKey,
    };

    try {
      final http.Response response =
          await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> fetchData = responseData['data'];
        setState(() {
          data = fetchData;
        });
        print(data);
      } else {
        throw Exception(
            'Failed to fetch data from API. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SITE SURVEY'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MyForm(data: const {},)),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Client ID: ${item['id'] ?? ''}'),
                    Text('Clientname: ${item['clientname'] ?? ''}'),
                    Text('Email: ${item['email'] ?? ''}'),
                    Text('Phone Number: ${item['phone'] ?? ''}'),
                    Text('Site Address: ${item['siteaddress'] ?? ''}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}






class Details extends StatefulWidget {
  final Map<String, dynamic> item;

  Details({required this.item});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> formData = {};
  String coordinate = '';
  String latitide = '';
  String longitude = '';
  XFile? selectedImage;
  String selectedValue = '';
  List<String> fetchedData = [];
  bool showFields = false;

  String selectedValue1 = 'Yes';
  List<String> dropdownItems = ['Yes', 'No'];

  @override
  void initState() {
    super.initState();
    formData = Map.from(widget.item);
    _getLocation();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {}
  }

  Future<void> openCamera() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (image != null) {
      setState(() {
        formData['image1'] = image.path;
      });
    }
  }

  Future<void> _getLocation() async {
    final PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        coordinate = position.toString();
        latitide = position.latitude.toString();
        longitude = position.longitude.toString();
      });
    } else if (locationStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Location permission is required for effective performance.'),
      ));
    }
  }

  Future<String> getApiKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_key') ?? '';
  }

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse(
          'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/sitesurveyreq/getbasestations'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          fetchedData = data.map((item) => item.toString()).toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showFields = !showFields;
                  });
                },
                // child: DropdownButton<String>(
                //   value: selectedValue1,
                //   onChanged: (newValue) {
                //     setState(() {
                //       selectedValue1 = newValue!;
                //     });
                //   },
                //   items: dropdownItems.map((String value) {
                //     return DropdownMenuItem<String>(
                //       value: value,
                //       child: Text(value),
                //     );
                //   }).toList(),
                // ),
                child: Text(showFields ? 'YES' : 'NO'),
              ),
              Visibility(
                visible: showFields,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Visible Field'),
                  ),
                ),
              ),
              
              
              // SizedBox(height: 20),
              // Text('Selected Value: $selectedValue'),
              const SizedBox(height: 60),
              selectedImage != null
                  ? Image.file(
                      File(selectedImage!.path),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(),
              SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                initialValue: formData['image1'] ?? '',
                decoration: InputDecoration(
                  labelText: 'Image',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: openCamera,
                  ),
                ),
                onChanged: (value) {
                  formData['image1'] = value;
                },
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: selectedValue,
                items: fetchedData.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
              ),
              TextFormField(),
              ElevatedButton(
                  onPressed: () {
                    Display();
                  },
                  child: Icon(Icons.camera_alt)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _getLocation,
                      child: CircleAvatar(
                        child: Icon(Icons.my_location),
                      ),
                    ),
                    // const SizedBox(height: 30),
                    Text(
                      coordinate,
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    // const SizedBox(height: 15),
                    Text(
                      'Latitude: $latitide',
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                    // const SizedBox(height: 15),
                    Text(
                      'Longitude: $longitude',
                      style: TextStyle(fontSize: 18, color: Colors.orange),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                readOnly: true,
                initialValue: formData['id'] ?? '',
                decoration: InputDecoration(labelText: 'Client ID'),
                onChanged: (value) {
                  formData['id'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['clientname'] ?? '',
                decoration: InputDecoration(labelText: 'Client Name'),
                onChanged: (value) {
                  formData['clientname'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['email'] ?? '',
                decoration: InputDecoration(labelText: 'Client Email'),
                onChanged: (value) {
                  formData['email'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['phone'] ?? '',
                decoration: InputDecoration(labelText: 'Client Phone'),
                onChanged: (value) {
                  formData['phone'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['siteaddress'] ?? '',
                decoration: InputDecoration(labelText: 'Client Site Address'),
                onChanged: (value) {
                  formData['siteaddress'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['clientcoordinate'] ?? '',
                decoration: InputDecoration(labelText: 'Client Coordinate'),
                onChanged: (value) {
                  formData['clientcoordinate'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['distance'] ?? '',
                decoration: InputDecoration(labelText: 'Client Distance'),
                onChanged: (value) {
                  formData['distance'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['sitesurveynumber'] ?? '',
                decoration:
                    InputDecoration(labelText: 'Client SiteSurvey Number'),
                onChanged: (value) {
                  formData['sitesurveynumber'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['site_survey_type'] ?? '',
                decoration:
                    InputDecoration(labelText: 'Client SiteSurvey Type'),
                onChanged: (value) {
                  formData['site_survey_type'] = value;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: formData['is_fibre'] ?? '',
                decoration: InputDecoration(labelText: 'Client is_Fibre'),
                onChanged: (value) {
                  formData['is_fibre'] = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

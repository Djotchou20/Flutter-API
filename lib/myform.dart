import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
// import 'package:quickalert/models/quickalert_type.dart';
// import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

class MyForm extends StatefulWidget {
  Map<String, dynamic> data;
  MyForm({required this.data});
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  bool isVisible = true;
  bool iVisible = true;
  bool uVisible = false;

  String _apiKey = '';
  List<String> _baseStationNames = [];
  List<String> _recommendedradio = [];
  List<String> _baseStationCordinates = [];
  // List<String> _radiotype = [];
  String? _selectedBaseStation;
  String? _selectedrecommendedradio;
  File? image;
  File? image2;

  final String apiEndpoint =
      'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/sitesurveyreq/getbasestations';

  final String apiUrl =
      'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/sitesurveyreq/executesitesurvey';

  final String apiRecommendedRadio =
      'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/sitesurveyreq/recommendedradio';

  final String apiRouterType =
      'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/Sitesurveyreq/routertype';

  @override
  void initState() {
    super.initState();
    _fetchRecommendedRadio();
    _fetchBaseStationData();
  }

  Future<void> _fetchRecommendedRadio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('apiKey') ?? '';

    final http.Response response = await http
        .get(Uri.parse(apiRecommendedRadio), headers: {'x-api-key': _apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      setState(() {
        _recommendedradio = List<String>.from(
            data['installation_radios'].map((radio) => radio['radio']));
        // List<String>.from(data['data'].map((station) => station['name']));
      });
      print(_recommendedradio);
    } else {}
  }

  Future<void> _fetchBaseStationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('apiKey') ?? '';

    final http.Response response =
        await http.get(Uri.parse(apiEndpoint), headers: {'x-api-key': _apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      Map<String, String> baseStationsData = {};
      for (var station in data['data']) {
        String name = station['name'];
        String coordinates = station['coordinates'];
        baseStationsData[name] = coordinates;
      }
      setState(() {
        _baseStationNames = baseStationsData.keys.toList();
        _baseStationCordinates = baseStationsData.values.toList();
      });
    } else {
      print('An error occured at line 97');

      print(
          'Failed to fetch base station data. Status code: ${response.statusCode}');
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String? _selectedOption1;
  // String? _selectedOption2;
  DateTime? _selectedDate;
  String? _fiber;
  String? _phone;
  String? _remail;
  String? _id;
  FileImage? _image;
  String coordinate = '';
  String latitude = '';
  String longitude = '';

  // FileImage? image2;

  TextEditingController _name = TextEditingController();
  TextEditingController _achievableController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mastController = TextEditingController();

  // List<String> _options = ['YES', 'NO'];

  // Future<void> _submitForm() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();

  //     // Convert the selected base station to its corresponding coordinate
  //     String? selectedCoordinate;
  //     int index = _baseStationNames.indexOf(_selectedBaseStation!);
  //     if (index != -1) {
  //       selectedCoordinate = _baseStationCordinates[index];
  //     }

  //     final Map<String, dynamic> formData = {
  //       'btscoordinate': selectedCoordinate,
  //     };
  //     try {
  //       final http.Response response = await http.post(
  //         Uri.parse(apiUrl),
  //         body: formData,
  //         headers: {'x-api-key': _apiKey},
  //       );
  //       if (response.statusCode == 200) {
  //         // Success, do something
  //       } else {
  //         // Handle error
  //         // ...
  //       }
  //     } catch (error) {
  //       // Handle error
  //       // ...
  //     }
  //   }
  // }
  Future<void> _getLocation() async {
    final PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude.toStringAsFixed(6);
        longitude = position.longitude.toStringAsFixed(6);

        coordinate = '$latitude $longitude';
        iVisible = false;
        uVisible = true;
      });

      // return position;
    }
    if (locationStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Location is recommended fro effective performance'),
      ));
    }
    print(coordinate);
  }

  XFile? _pickedFile1;
  String? base64String1;

  Future<void> _pickImage() async {
    final PermissionStatus CameraStatus = await Permission.camera.request();

    if (CameraStatus.isGranted) {
      try {
        final image = await ImagePicker().pickImage(source: ImageSource.camera);
        if (image != null) {
          setState(() {
            _pickedFile1 = image;
          });
          Uint8List imageBytes1 = File(image.path).readAsBytesSync();
          setState(() {
            base64String1 =
                base64Encode(imageBytes1); //This is a Base 64 image for api
          });
        }
      } on PlatformException catch (e) {
        print('Failed to print Images: $e');
      }
    } else {
      return;
    }
  }

  XFile? _pickedFile;
  String? base64String;

  Future<void> _pickImage2() async {
    final PermissionStatus CameraStatus = await Permission.camera.request();

    if (CameraStatus.isGranted) {
      try {
        final image2 =
            await ImagePicker().pickImage(source: ImageSource.gallery);

        if (image2 != null) {
          setState(() {
            _pickedFile = image2;
          });
          List<int> imageBytes = File(image2.path).readAsBytesSync();
          setState(() {
            base64String = base64Encode(imageBytes); //
          });
          //  This is the IMAGE FILE IN BASE 64. Pass it to the API
        }

        setState(() {});
      } on PlatformException catch (e) {
        print('Failed to print Images: $e');
      }
    } else {
      return;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? rowData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    _name.text = widget.data['clientname'].toString();
    _achievableController.text = widget.data['achievable'].toString();
    _achievableController.text = 'NO';
    _email.text = widget.data['email'].toString();
    _phoneController.text = widget.data['phone'].toString();

    // _selectedOption1 = rowData?['email'] ?? '';
    _fiber = 'YES';
    _phone = widget.data['phone'].toString();
    _id = rowData?['id'] ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('Execute Site Survey'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          // initialvalue: 'YES',
                          value: _achievableController.text,
                          onChanged: (String? newValue) {
                            setState(() {
                              _achievableController.text = newValue!;
                            });
                            if (_achievableController.text == 'NO') {
                              setState(() {
                                isVisible = false;
                              });
                            } else if (_achievableController.text == 'YES') {
                              setState(() {
                                isVisible = true;
                              });
                            }
                          },
                          items: <String>['YES', 'NO'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            labelText: 'Achievable',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Visibility(
                      visible: isVisible,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: DropdownButtonFormField<String>(
                              value: _selectedBaseStation,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedBaseStation = newValue;
                                });
                              },
                              items: _baseStationNames
                                  .map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Base Station',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a base station';
                                }
                                return null;
                              },
                            ),
                          ),
                          // ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _name.text,
                            decoration: const InputDecoration(
                              labelText: 'Client Name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the client name';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _name.text = value!;
                            },
                          ),
                          const SizedBox(height: 10.0),
                          TextFormField(
                            initialValue: _email.text,
                            decoration: const InputDecoration(
                              labelText: 'Client Email',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Client Email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _remail = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          Visibility(
                            visible: uVisible,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                              ),
                              child: Text(
                                coordinate,
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          Visibility(
                            visible: iVisible,
                            child: GestureDetector(
                              onTap: _getLocation,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue[500],
                                ),
                                child: Center(
                                  child: Text('Get Coordinates',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _addressController.text,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Client Address';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _addressController.text = value!;
                            },
                          ),
                          // AnimatedButton(
                          //   pressEvent: _submitForm()
                          // ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _phoneController.text,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the Phone number';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _phoneController.text = value!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            initialValue: _email.text,
                            decoration: const InputDecoration(
                              labelText: 'Engineer assigned',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Specify the engineer';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email.text = value!;
                            },
                          ),

                          const SizedBox(height: 16.0),
                          Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  // Update the _description variable with the entered text
                                  // setState(() {
                                  //   _description = value;
                                  // });
                                },
                                maxLines: 4,
                                decoration: InputDecoration(
                                  labelText: 'Enter description',
                                  hintText: 'Describe something...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    // Text(
                                    //   'Achievable',
                                    //   style: TextStyle(fontSize: 16),
                                    // ),
                                    SizedBox(height: 10),
                                    DropdownButtonFormField<String>(
                                      // value: _achievableController.text,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _mastController.text = newValue!;
                                          setState(() {
                                            // isVisible = !isVisible;
                                          });
                                        });
                                      },
                                      items: <String>['YES', 'NO']
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      decoration: const InputDecoration(
                                        labelText: 'Mast Installed',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedrecommendedradio,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedrecommendedradio = newValue;
                                    });
                                  },
                                  items: _recommendedradio
                                      .map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  decoration: const InputDecoration(
                                    labelText: 'Recommended Radio',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Recommended radio';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              TextField(
                                onChanged: (value) {},
                                maxLines: 2,
                                decoration: InputDecoration(
                                  labelText: 'Recommended Cable Lenth',
                                  hintText: 'Describe something...',
                                  // border: OutlineInputBorder(),
                                ),
                              ), // ),
                            ],
                          ),

                          GestureDetector(
                            onTap: () {
                              _selectDate(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    _selectedDate == null
                                        ? 'Select a Date'
                                        : 'Selected Date: ${_selectedDate.toString().split(' ')[0]}',
                                  ),
                                  const Icon(Icons.calendar_today),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                          ),
                          child: Center(
                            child: Text('Camera',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _pickImage2,
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue[400],
                          ),
                          child: Center(
                            child: Text('Gallery',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                    ),
                    onPressed: () async {
                      String? selectedCoordinate;
                      int index =
                          _baseStationNames.indexOf(_selectedBaseStation!);
                      if (index != -1) {
                        selectedCoordinate = _baseStationCordinates[index];
                      }

                      final Map<String, dynamic> formData = {
                        'id': 34,
                        'btscoordinate': selectedCoordinate,
                        'achievable': _achievableController.text,
                        'username': 'admin',
                        'is_fibre': 'YES',
                        'clientcoordinate': selectedCoordinate,
                        'recommended_router': _selectedrecommendedradio,
                        'isamastinstalled': _mastController.text,
                      };

                      try {
                        final http.Response response = await http.post(
                          Uri.parse(apiUrl),
                          body: formData,
                          headers: {'x-api-key': _apiKey},
                        );
                        if (response.statusCode == 200) {
                          print('Hello world');
                        } else {
                          print('Error Occured');
                          // ...
                        }
                      } catch (error) {
                        // Handle error
                        // ...
                      }
                    },
                    // color: Colors.white,
                    child: const Text('Submit'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

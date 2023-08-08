import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import './dashboard.dart';
import './base_stations.dart';

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
                    builder: (context) => Details(item: data[index])),
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
  late Map<String, dynamic> formData;

  @override
  void initState() {
    super.initState();
    formData = Map.from(widget.item);
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {}
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Submit'),
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

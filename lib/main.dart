import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'LoginPage.dart';
import './dashboard.dart';

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
          '/details': (context) => Details(item: []),
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

class Details extends StatelessWidget {
  final dynamic item;

  Details({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: [
          SizedBox(height: 10),
          Text('Client ID: ${item['id'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Name: ${item['clientname'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Email: ${item['email'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Phone: ${item['phone'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Site Address: ${item['siteaddress'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Coordinate: ${item['clientcoordinate'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Distance: ${item['distance'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client SiteSurvey Number: ${item['sitesurveynumber'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client SiteSurvey Type: ${item['site_survey_type'] ?? ''}'),
          SizedBox(height: 10),
          Text('Client Is_Fibre: ${item['is_fibre'] ?? ''}'),
        ],
      ),
    );
  }
}

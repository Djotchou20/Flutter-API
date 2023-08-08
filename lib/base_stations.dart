import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BaseStation extends StatefulWidget {
  const BaseStation({Key? key}) : super(key: key);

  @override
  _BaseStationState createState() => _BaseStationState();
}

class _BaseStationState extends State<BaseStation> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<String> getApiKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('api_key') ?? '';
  }

  Future<void> fetchData() async {
    final String apiKey = await getApiKey();

    const String apiUrl =
        'https://testenv.ciphernet.net/ngcomintranetv2/api/v1/sitesurveyreq/getbasestations';

    final headers = {
      'x-api-key': apiKey,
    };

    try {
      final http.Response response =
          await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> fetchBaseStation = responseData['data'];
        setState(() {
          data = fetchBaseStation;
        });
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
        title: const Text('Base Stations'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          final item = data[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID: ${item['id'] ?? ''}'),
                  Text('Name: ${item['name'] ?? ''}'),
                  Text('Coordinates: ${item['coordinates'] ?? ''}'),
                  Text('Remarks: ${item['remarks'] ?? ''}'),
                  Text('Status: ${item['status'] ?? ''}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

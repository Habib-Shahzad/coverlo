import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JsonList extends StatefulWidget {

  const JsonList( {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _JsonListState createState() => _JsonListState();
}

class _JsonListState extends State<JsonList> {
  late Future<Map<String, dynamic>> jsonDataFuture;

  @override
  void initState() {
    super.initState();
    jsonDataFuture = _loadInfo();
  }

  Future<Map<String, dynamic>> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final info = prefs.getString('insuranceInfo');
    if (info != null) {
      return jsonDecode(info);
    }
    return jsonDecode('{}');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: jsonDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          Map<String, dynamic> jsonData = snapshot.data!;
          return ListView.builder(
            itemCount: jsonData.keys.length,
            itemBuilder: (BuildContext context, int index) {
              String key = jsonData.keys.elementAt(index);
              return ListTile(
                title: Text('$key: ${jsonData[key]}'),
              );
            },
          );
        }
      },
    );
  }
}

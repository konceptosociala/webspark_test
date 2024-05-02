import 'dart:convert';

import 'package:anyhow/base.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webspark_test/model/index.dart';
import 'package:webspark_test/screens/index.dart';
import 'package:webspark_test/utils/index.dart';

class ProcessScreen extends Screen {
  final Uri uri;

  const ProcessScreen({
    super.key, 
    required this.uri,
    required super.nextScreen,
  });

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();

  @override
  String title() => "Process screen";

  @override
  Screen? previous() => HomeScreen(nextScreen: nextScreen);
}

class _ProcessScreenState extends State<ProcessScreen> with TickerProviderStateMixin {
  late final Uri uri;
  late Future<Result<List<Data>, String>>? futureData;
  
  @override
  void initState() {
    uri = widget.uri;

    futureData = fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<Data>, String>>(
      future: futureData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data! case Ok(:final ok)) {
            return PathFinderWidget(data: ok);
          } else if(snapshot.data! case Err(:final err)) {
            return Text(err);
          }
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Downloading data..."),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            )
          ],
        );
      },
    );
  }
 
  Future<Result<List<Data>, String>> fetchData() async {
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Ok(List<Data>.from(jsonData['data'].map((x) => Data.fromJson(x))));
      } else {
        return Err('Wrong GET request "${uri.toString()}"');
      }
    } catch (e) {
      return Err(e.toString());
    }
  }
  
}
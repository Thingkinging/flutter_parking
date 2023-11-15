import 'dart:convert';

import 'package:flutter_parking/models/park.dart';
import 'package:http/http.dart' as http;

import '../key/key.dart';

Future<List<Park>> fetchPark() async {
  List<Park> parkingList;
  String url =
      "http://openapi.seoul.go.kr:8088/$apiKey/json/GetParkInfo/1/5/";
      // "http://data.seoul.go.kr/dataList/OA-21709/S/1/datasetView.do";
      // "http://data.seoul.go.kr/dataList/OA-13122/S/1/datasetView.do";
  final response = await http.get(Uri.parse(url));
  final responseBody = response.body;

  final jsonMap = json.decode(responseBody);

  parkingList = jsonMap.containsKey("GetParkInfo")
      ? (jsonMap['GetParkInfo']['row'] as List)
          .map((e) => Park.fromJson(e))
          .toList()
      : List.empty();

  if (response.statusCode == 200) {
    return parkingList;
  } else {
    throw Exception('Failed to load park info');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_parking/services/fetchpark.dart';

import 'models/park.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<Park>> parks;

  @override
  void initState() {
    super.initState();
    parks = fetchPark();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '오픈API 활용하기',
      home: Scaffold(
        appBar: AppBar(
          title: Text('공영 주차장 조회'),
        ),
        body: Center(
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text('주차장명'),
          //     Text('주차코드'),
          //     Text('위도위치'),
          //     Text('경도위치'),
          //   ],
          // ),
          child: FutureBuilder<List<Park>>(
            future: parks,
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(snapshot.data?.length != 0 ? snapshot.data![0].parking_name : "없음"),
                    Text(snapshot.data?.length != 0 ? snapshot.data![0].parking_code : "없음"),
                    Text(snapshot.data?.length != 0 ? snapshot.data![0].lat.toString() : "없음"),
                    Text(snapshot.data?.length != 0 ? snapshot.data![0].lng.toString() : "없음"),
                  ],
                );
              } else if(snapshot.hasError){
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

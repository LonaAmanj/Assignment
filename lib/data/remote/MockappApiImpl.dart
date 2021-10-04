import 'dart:convert';
import 'package:flutter_application/data/model/Mokapp.dart';
import 'package:flutter_application/data/remote/MockappApi.dart';
import 'package:http/http.dart' as http;

class MockappApiImpl implements MockappApi {
  @override
  Future<List<Mockapp>> getMockappList() async {
    try {
      final response = await http.get(
          Uri.parse('https://61504abaa706cd00179b73ef.mockapi.io/api/v1/home'));
      if (response.statusCode == 200) {
        List<dynamic> arrJson = json.decode(response.body) as List;
        Map<String, dynamic> mapResponse = arrJson[0];

        var list = mapResponse['sections'] as List;
        List<Mockapp> listMockapp = [];
        for (var idx = 0; idx < list.length; idx++) {
          Mockapp mockapp = Mockapp();
          mockapp.sectionType = list.asMap()[idx]['sectionType'];
          mockapp.items = list.asMap()[idx]['items'];
          listMockapp.add(mockapp);
        }
        return listMockapp;
      } else {
        throw Exception("Error Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("There was a problem with the connection");
    }
  }
}

import 'package:flutter_application/data/model/Mokapp.dart';

abstract class MockappApi {
  Future<List<Mockapp>> getMockappList();
}

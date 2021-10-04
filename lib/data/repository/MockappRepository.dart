import 'package:flutter_application/data/model/Mokapp.dart';

abstract class MockappRepository {
  Future<List<Mockapp>> getMockappList();
}

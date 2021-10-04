import 'package:flutter_application/data/model/Mokapp.dart';
import 'package:flutter_application/data/remote/MockappApi.dart';
import 'package:flutter_application/data/repository/MockappRepository.dart';

class MockappRepositoryImpl implements MockappRepository {
  MockappApi? mockappApi;
  MockappRepositoryImpl(MockappApi mockappApi) {
    this.mockappApi = mockappApi;
  }

  @override
  Future<List<Mockapp>> getMockappList() {
    return mockappApi!.getMockappList();
  }
}

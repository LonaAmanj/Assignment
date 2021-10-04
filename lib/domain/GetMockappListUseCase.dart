import 'package:flutter_application/data/model/Mokapp.dart';
import 'package:flutter_application/data/repository/MockappRepository.dart';
import 'package:flutter_application/domain/BaseUseCase.dart';

class GetMockappListUseCase extends BaseUseCase<List<Mockapp>> {
  MockappRepository? mockappRepository;

  GetMockappListUseCase(MockappRepository mockappRepository) {
    this.mockappRepository = mockappRepository;
  }

  @override
  Future<List<Mockapp>> perform() {
    return mockappRepository!.getMockappList();
  }
}

import 'package:flutter_application/data/model/Mokapp.dart';
import 'package:flutter_application/data/remote/MockappApiImpl.dart';
import 'package:flutter_application/data/repository/MockappRepositoryImpl.dart';
import 'package:flutter_application/domain/GetMockappListUseCase.dart';
import 'package:rxdart/rxdart.dart';

class ViewModelMockappList {
  var mockappListSubject = PublishSubject<List<Mockapp>>();

  Stream<List<Mockapp>> get mockappList => mockappListSubject.stream;

  GetMockappListUseCase getMockappListUseCase =
      GetMockappListUseCase(MockappRepositoryImpl(MockappApiImpl()));

  void getMockappList() async {
    try {
      mockappListSubject = PublishSubject<List<Mockapp>>();
      mockappListSubject.sink.add(await getMockappListUseCase.perform());
    } catch (e) {
      await Future.delayed(Duration(milliseconds: 500));
      mockappListSubject.sink.addError(e);
    }
  }

  void closeObservable() {
    mockappListSubject.close();
  }
}

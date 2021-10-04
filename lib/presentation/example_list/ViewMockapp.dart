import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/data/model/Mokapp.dart';
import 'package:flutter_application/presentation/example_list/ViewModelMockappList.dart';
import 'package:flutter_application/presentation/example_list/ViewProducts.dart';

class ViewMockappList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildMockappContent());
  }

  Widget buildMockappContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MockappListView(),
        ],
      ),
    );
  }
}

class MockappListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MockappListViewState();
  }
}

class MockappListViewState extends State<MockappListView>
    with WidgetsBindingObserver {
  final ViewModelMockappList viewModelMockappList = ViewModelMockappList();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refresh();
    }
  }

  @override
  void initState() {
    super.initState();
    refresh();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        refresh();
      }
    });
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    viewModelMockappList.closeObservable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Mockapp>>(
      stream: viewModelMockappList.mockappList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildCircularProgressIndicatorWidget();
        }
        if (snapshot.hasError) {
          showSnackBar(context, snapshot.error.toString());
          return buildListViewNoDataWidget();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          var mockappList = snapshot.data;
          if (null != mockappList)
            return builGridViewWidget(mockappList);
          else
            return buildListViewNoDataWidget();
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget builGridViewWidget(List<Mockapp> mockappList) {
    return Expanded(
        child: Column(
      children: [
        Expanded(
          child: GridView.builder(
              itemCount: mockappList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 5),
              itemBuilder: (_, int index) {
                var item = mockappList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ViewProductList(
                                  data: item.items!,
                                )));
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(3, 2),
                          blurRadius: 3,
                          color: Colors.grey.withOpacity(.6),
                        )
                      ],
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.center,
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.withOpacity(.2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(500.0),
                                child: Image.network(
                                  'http://placeimg.com/640/480',
                                  width: 130,
                                  height: 130,
                                  fit: BoxFit.fill,
                                ),
                              )),
                          Text(
                            item.sectionType.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ]),
                  ),
                );
              }),
        )
      ],
    ));
  }

  Widget buildListViewNoDataWidget() {
    return Expanded(
      child: Center(
        child: Text("No Data Available"),
      ),
    );
  }

  Widget buildCircularProgressIndicatorWidget() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showSnackBar(BuildContext context, String errorMessage) async {
    await Future.delayed(Duration.zero);
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  void refresh() {
    viewModelMockappList.getMockappList();
    setState(() {});
  }
}

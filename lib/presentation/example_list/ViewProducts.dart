import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/data/model/Mokapp.dart';
import 'package:flutter_application/presentation/example_list/ViewModelMockappList.dart';

// ignore: must_be_immutable
class ViewProductList extends StatelessWidget {
  List? data;
  ViewProductList({this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: buildMockappContent(),
      appBar: AppBar(
        title: Text('Products'),
      ),
    ));
  }

  Widget buildMockappContent() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MockappListView(
            data: data ?? [],
          ),
        ],
      ),
    );
  }
}

class MockappListView extends StatefulWidget {
  List? data;

  MockappListView({this.data});

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
            return buildListViewWidget();
          else
            return buildListViewNoDataWidget();
        }
        return CircularProgressIndicator();
      },
    );
  }

  Widget buildListViewWidget() {
    return Flexible(
        child: new ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: widget.data!.length,
      itemBuilder: (BuildContext context, int index) {
        var item = widget.data![index];

        return Card(
            child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(500),
            child: item['image'] == null
                ? FlutterLogo()
                : Image.network(
                    item['image'],
                    width: 60,
                    height: 60,
                    fit: BoxFit.fill,
                  ),
          ),
          title: Text(
            item['title'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            item['subtitle'].toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
          trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              color: Colors.red.withOpacity(.3),
              child: Text(item['price'].toString())),
          onTap: () {},
        ));
      },
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

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:untitled4/Response.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Category> categorydata = [];
  List<SubCategories> subcategorydata = [];
  List<Product> productsList = [];
  //List<CategoryData> categorydatalist = [];
  int initPosition = 0;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) async {
          await getDio();
        // await Provider.of<SavedJobsProvider>(context, listen: false)
        //     .makeMarkersNew(context);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey,actions: [

      ],
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        // backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomTabView(
              initPosition: initPosition,
              itemCount: categorydata.length,
              tabBuilder: (context, index) => Tab(text: categorydata[index].name),
              pageBuilder: (context, index) => categorydata[initPosition].subCategories!=null && categorydata[initPosition].subCategories!.length!=0 ?
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categorydata[initPosition].subCategories!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return categorydata[initPosition].subCategories![index].product!=null && categorydata[initPosition].subCategories![index].product!.length!=0 ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(categorydata[initPosition].subCategories![index].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: categorydata[initPosition].subCategories![index].product!.length,
                          itemBuilder: (BuildContext context, int index1) {
                            return
                              Expanded(
                              child: Container(
                                height: 150,
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(categorydata[initPosition].subCategories![index].product![index1].imageName.toString()),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(categorydata[initPosition].subCategories![index].product![index1].name.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black38)),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ):Container();
                  },
                ),
              ):Container(),
              onPositionChange: (index) async {
                print('current position: $index');
                initPosition = index;
                await getSubCategory(categorydata[index].id.toString());
              },
              onScroll: (position) => print('$position'),
            ),
          ),

        ],
      ),
    );

  }

  Future<void> getDio() async {
    try {

      var data = {
        "CategoryId":0,
        "PageIndex":1
      };

      var response = await Dio(BaseOptions(headers: {"Content-Type":
      "application/json"}))
          .post('http://esptiles.imperoserver.in/api/API/Product/DashBoard',data: data);

      log(response.toString());
      ResponseData res =
      ResponseData.fromJson(response.data);
      print(res.result!.category!.length.toString());
      categorydata = res.result!.category!;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSubCategory(String categoryID) async {
    try {

      var data = {
        "CategoryId":categoryID,
        "PageIndex":1
      };

      var response = await Dio(BaseOptions(headers: {"Content-Type":
      "application/json"}))
          .post('http://esptiles.imperoserver.in/api/API/Product/DashBoard',data: data);

      log(response.toString());
      ResponseData res =
      ResponseData.fromJson(response.data);
      //print(res.result!.category!.length.toString());
      //categorydata = res.result!.category!;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getProducts(String subcategoryId) async {
    try {

      var data = {
        "SubCategoryId":subcategoryId,
        "PageIndex":1
      };

      var response = await Dio(BaseOptions(headers: {"Content-Type":
      "application/json"}))
          .post('http://esptiles.imperoserver.in/api/API/Product/ProductList',data: data);

      log(response.toString());
      ResponseData res =
      ResponseData.fromJson(response.data);
      //print(res.result!.category!.length.toString());
      //categorydata = res.result!.category!;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

}

class CustomTabView extends StatefulWidget {
  final int? itemCount;
  final IndexedWidgetBuilder? tabBuilder;
  final IndexedWidgetBuilder? pageBuilder;
  final Widget? stub;
  final ValueChanged<int>? onPositionChange;
  final ValueChanged<double>? onScroll;
  final int? initPosition;

  CustomTabView({
    @required this.itemCount,
    @required this.tabBuilder,
    @required this.pageBuilder,
    this.stub,
    this.onPositionChange,
    this.onScroll,
    this.initPosition,
  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  TabController? controller;
  int? _currentCount;
  int? _currentPosition;

  @override
  void initState() {
    _currentPosition = widget.initPosition ?? 0;
    controller = TabController(
      length: widget.itemCount!,
      vsync: this,
      initialIndex: _currentPosition!,
    );
    controller!.addListener(onPositionChange);
    controller!.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;
    super.initState();
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller!.animation!.removeListener(onScroll);
      controller!.removeListener(onPositionChange);
      controller!.dispose();

      if (widget.initPosition != null) {
        _currentPosition = widget.initPosition;
      }

      if (_currentPosition! > widget.itemCount! - 1) {
        _currentPosition = widget.itemCount! - 1;
        _currentPosition = _currentPosition! < 0 ? 0 :
        _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            if(mounted) {
              widget.onPositionChange!(_currentPosition!);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount!,
          vsync: this,
          initialIndex: _currentPosition!,
        );
        controller!.addListener(onPositionChange);
        controller!.animation!.addListener(onScroll);
      });
    } else if (widget.initPosition != null) {
      controller!.animateTo(widget.initPosition!);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller!.animation!.removeListener(onScroll);
    controller!.removeListener(onPositionChange);
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.itemCount! < 1) return widget.stub ?? Container();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: TabBar(
            isScrollable: true,
            controller: controller,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Theme.of(context).hintColor,
            indicator: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
            ),
            tabs: List.generate(
              widget.itemCount!,
                  (index) => widget.tabBuilder!(context, index),
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: List.generate(
              widget.itemCount!,
                  (index) => widget.pageBuilder!(context, index),
            ),
          ),
        ),
      ],
    );
  }

  onPositionChange() {
    if (!controller!.indexIsChanging) {
      _currentPosition = controller!.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange!(_currentPosition!);
      }
    }
  }

  onScroll() {
    if (widget.onScroll is ValueChanged<double>) {
      widget.onScroll!(controller!.animation!.value);
    }
  }
}





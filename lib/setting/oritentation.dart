import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_reservation/provide_model/scan_speed_provide_model.dart';
import 'package:provider/provider.dart';

main() => runApp(MultiProvider(child: MyApp(), providers: [
  ChangeNotifierProvider(create: (ctx) => TestProviderModel())
]));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Consumer<TestProviderModel>(builder: (ctx, vm, child) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                double width = MediaQuery.of(context).size.width;
                double height = MediaQuery.of(context).size.height;
                print('dssssssssssssssssssss========$width');
                int count = orientation == Orientation.portrait ? 3 : 5;
                return buildGridView(count);
              },
            );
          }),
        ),
      ),
    );
  }

  GridView buildGridView(int count) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: count, crossAxisSpacing: 2, mainAxisSpacing: 4),
      itemBuilder: (context, index) {
        return Container(
          color: Colors.primaries[index % Colors.primaries.length],
        );
      },
      itemCount: 30,
    );
  }
}

import 'package:custom_render_object/custom_single_child_render_object.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TestPage(),
      // home: CustomLeafRenderObjectWidget(),
      // home: Center(
      //   child: CustomMultiChildRenderObjectWidget(
      //     children: [
      //       CustomExpand(
      //         child: Container(
      //           color: Colors.yellow,
      //           width: 50,
      //           height: 50,
      //         ),
      //       ),
      //       CustomExpand(
      //         child: Container(
      //           color: Colors.greenAccent,
      //           width: 50,
      //           height: 50,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final controller = ScrollController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: CustomSingleChildRenderObjectWidget(
          controller: controller,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.separated(
              controller: controller,
              itemCount: 50,
              itemBuilder: (ctx, index) {
                return Container(
                  width: 150,
                  height: 50,
                  color: index % 2 == 0 ? Colors.deepPurple : Colors.deepPurple,
                );
              },
              separatorBuilder: (ctx, index) {
                return const SizedBox(height: 4);
              },
            ),
          ),
        ),
      );
}

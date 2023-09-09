import 'package:flutter/material.dart';
import 'package:flutter_sort_visualizer/sort.dart';
import 'package:flutter_sort_visualizer/visualizer_painter.dart';

const Size size = Size(400, 400);

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key});

  final List<int> baseData = List<int>.generate(1500, (int index) => index)
    ..shuffle();

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Sort Visualizer',
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: <Widget>[
                for (SortType type in SortType.values)
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: StreamBuilder<List<int>>(
                      stream:
                          (Sort()..sort(List<int>.from(baseData), type)).stream,
                      initialData: baseData,
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<List<int>> snapshot,
                      ) =>
                          Stack(
                        children: <Widget>[
                          CustomPaint(
                            size: size,
                            painter: VisualizerPainter(snapshot.data!),
                          ),
                          Text(
                            '${type.name} sort ${type == SortType.bubble ? '(speedup)' : ''}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

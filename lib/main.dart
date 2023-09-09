import 'package:flutter/material.dart';
import 'package:flutter_sort_visualizer/sort.dart';
import 'package:flutter_sort_visualizer/visualizer_painter.dart';

const Size size = Size(200, 200);

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<int> baseData = List.generate(300, (index) => index)..shuffle();

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              for (SortType type in SortType.values)
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: StreamBuilder<List<int>>(
                    stream: (Sort()..sort(List.from(baseData), type)).stream,
                    initialData: baseData,
                    builder: (context, snapshot) => Stack(
                      children: [
                        Text(
                          '${type.name} sort',
                          style: const TextStyle(color: Colors.white),
                        ),
                        CustomPaint(
                          size: size,
                          painter: VisualizerPainter(snapshot.data!),
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
}

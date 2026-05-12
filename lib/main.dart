import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

void main() {
  runApp(const PetDetectorApp());
}

class PetDetectorApp extends StatelessWidget {
  const PetDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Detector YOLO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const PetDetectorPage(),
    );
  }
}

class PetDetectorPage extends StatefulWidget {
  const PetDetectorPage({super.key});

  @override
  State<PetDetectorPage> createState() => _PetDetectorPageState();
}

class _PetDetectorPageState extends State<PetDetectorPage> {
  String detectedPet = 'No pet detected';

  final List<String> petLabels = [
    'cat',
    'dog',
    'bird',
  ];

  void handleDetection(List<dynamic> results) {
    String newText = 'No pet detected';

    for (final result in results) {
      final label = result.label?.toString().toLowerCase() ?? '';

      if (petLabels.contains(label)) {
        newText = 'Pet detected: $label';
        break;
      }
    }

    if (newText != detectedPet) {
      setState(() {
        detectedPet = newText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool foundPet = detectedPet != 'No pet detected';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Detector YOLO'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          YOLOView(
            modelPath: 'assets/models/yolov8n.tflite',
            task: YOLOTask.detect,
            onResult: handleDetection,
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 32,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: foundPet
                    ? Colors.green.withOpacity(0.85)
                    : Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                detectedPet,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
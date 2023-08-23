// ignore_for_file: camel_case_types, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// ignore: camel_case_types
class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  State<loadingScreen> createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  @override
  Widget build(BuildContext context) {
    const spinkit = SpinKitWanderingCubes(
      color: Colors.blue,
      size: 50.0,
    );

    if (!mounted) {
      super.dispose();
    }
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: spinkit),
    );
  }
}

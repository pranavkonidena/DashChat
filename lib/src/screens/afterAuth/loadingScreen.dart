import 'package:dash_chat/src/screens/afterAuth/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class loadingScreen extends StatefulWidget {
  const loadingScreen({super.key});

  @override
  State<loadingScreen> createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
   
  @override
  void initState() {
    // TODO: implement initState
    
    super.initState();
  }
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
      body: Center(
        child: spinkit
      ),
    );
    Future.delayed(Duration(seconds: 5), () {
      Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()),
                    );
    });
  }
}
import 'package:flutter/material.dart';

class BlancScreen extends StatelessWidget {
  const BlancScreen({super.key, required this.body});
  final Widget body;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: body,
    );
  }
}

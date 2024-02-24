import 'package:flutter/material.dart';

class InjectionContainer extends StatefulWidget {
  final Widget child;

  const InjectionContainer({super.key, required this.child});

  @override
  State<InjectionContainer> createState() => _InjectionContainerState();
}

class _InjectionContainerState extends State<InjectionContainer> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

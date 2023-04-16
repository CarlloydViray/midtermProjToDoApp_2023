import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class finished extends StatefulWidget {
  const finished({super.key});

  @override
  State<finished> createState() => _finishedState();
}

class _finishedState extends State<finished> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('FINISHED'),
      Text('FINISHED'),
      Text('FINISHED'),
      Text('FINISHED'),
      Text('FINISHED'),
      Text('FINISHED'),
      Text('FINISHED'),
    ],);
  }
}
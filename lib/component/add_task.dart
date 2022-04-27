import 'package:flutter/material.dart';
import 'package:gw/globals.dart' as globals;

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    print(globals.statusKey);
    return Container();
  }
}
// class AddTask extends StatefulWidget {
//   const AddTask({Key? key}) : super(key: key);

//   @override
//   State<AddTask> createState() => _AddTaskState();
// }

// class _AddTaskState extends State<AddTask> {
//   @override
//   Widget build(BuildContext context) {
//     print(widget.taskName);
//     return Container(
//       child: Text(widget.taskName),
//     );
//   }
// }

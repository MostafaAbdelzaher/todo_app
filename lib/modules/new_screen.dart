import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shard/components.dart';

class NewTasksScreen extends StatelessWidget {
  NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          List<Map> tasks = AppCubit.get(context).newTasks;
          return tasksBuilder(tasks: tasks);
        });
  }
}

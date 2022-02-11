import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget defaultTextField({
  bool isPassword = false,
  required TextInputType? type,
  required TextEditingController? control,
  required String label,
  IconData? prefix,
  Function? suffixButtonPressed,
  IconData? suffix,
  onSubmitted,
  onTap,
  bool isClickable = true,
  Function? validator,
}) =>
    TextFormField(
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
      obscureText: isPassword,
      keyboardType: type,
      controller: control,
      onFieldSubmitted: onSubmitted,
      onTap: onTap,
      validator: (value) {
        return validator!(value);
      },
      enabled: isClickable,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(
          prefix,
          size: 20,
        ),
      ),
    );

Widget itemTasks(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5, top: 5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          height: 75,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${model["title"]}",
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF838284),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          "${model['date']}",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${model['time']}",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                IconButton(
                    padding: EdgeInsetsDirectional.zero,
                    onPressed: () {
                      AppCubit.get(context)
                          .updateData(status: "done", id: model["id"]);
                    },
                    icon: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.black45,
                      size: 20,
                    )),
                IconButton(
                    padding: EdgeInsetsDirectional.zero,
                    onPressed: () {
                      AppCubit.get(context)
                          .updateData(status: "archive", id: model["id"]);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: 20,
                    )),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).tasksDelete(id: model['id']);
      },
    );
Widget tasksBuilder({
  required List<Map> tasks,
}) =>
    ConditionalBuilder(
        condition: tasks.isNotEmpty,
        builder: (context) => ListView.separated(
            itemBuilder: (context, index) => itemTasks(tasks[index], context),
            separatorBuilder: (context, index) => Container(
                  color: Colors.grey[300],
                  width: double.infinity,
                  height: 1.0,
                ),
            itemCount: tasks.length),
        fallback: (context) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.menu_outlined,
                    color: Colors.white,
                    size: 100,
                  ),
                  Text(
                    "No tasks yet, please add some tasks",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ));

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../shard/components.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabase) {
            Navigator.pop(context);
            titleController.text = "";
            timeController.text = "";
            dateController.text = "";
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.grey,
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.deepOrange,
              title: Text(
                cubit.title[cubit.currentIndex],
              ),
            ),
            body: ConditionalBuilder(
              builder: (context) => cubit.screen[cubit.currentIndex],
              condition: true,
              fallback: (context) => const CircularProgressIndicator(),
            ),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: () {
                  if (cubit.isBottomSheetShown) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertTowDataBase(
                          title: titleController.text,
                          time: timeController.text,
                          date: dateController.text);
                      cubit.changBottomSheetSates(
                          isShow: false, icon: Icons.edit);
                    }
                  } else {
                    scaffoldKey.currentState!
                        .showBottomSheet(
                          (context) => Container(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 60,
                                      child: defaultTextField(
                                        onSubmitted: (value) {},
                                        type: TextInputType.text,
                                        control: titleController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter some title';
                                          }
                                          return null;
                                        },
                                        onTap: () {},
                                        label: "title",
                                        prefix: Icons.title,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height: 60,
                                      child: defaultTextField(
                                        onSubmitted: (value) {},
                                        type: TextInputType.datetime,
                                        control: timeController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter time';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            timeController.text = value!
                                                .format(context)
                                                .toString();
                                          });
                                        },
                                        label: "time",
                                        prefix: Icons.watch_later,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height: 60,
                                      child: defaultTextField(
                                        onSubmitted: (value) {},
                                        type: TextInputType.datetime,
                                        control: dateController,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter date';
                                          }
                                          return null;
                                        },
                                        onTap: () {
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2050-01-01'),
                                          ).then((value) {
                                            dateController.text =
                                                DateFormat.yMMMd()
                                                    .format(value!);
                                          });
                                        },
                                        label: "date",
                                        prefix: Icons.calendar_today,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          elevation: 20.0,
                        )
                        .closed
                        .then((value) {
                      cubit.changBottomSheetSates(
                          isShow: false, icon: Icons.edit);
                    });
                    cubit.changBottomSheetSates(isShow: true, icon: Icons.add);
                  }
                },
                child: Icon(cubit.fabIcon)),
            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.deepOrange,
                type: BottomNavigationBarType.fixed,
                currentIndex: AppCubit.get(context).currentIndex,
                onTap: (index) {
                  AppCubit.get(context).changeIndex(index);
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu_outlined), label: "Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.check_circle_outline,
                      ),
                      label: "Done"),
                  BottomNavigationBarItem(
                      icon: Icon(
                        Icons.archive_outlined,
                      ),
                      label: "Archive"),
                ]),
          );
        },
      ),
    );
  }
}

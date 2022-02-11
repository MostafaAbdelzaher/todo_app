import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/cubit/states.dart';
import '../../modules/archive.dart';
import '../../modules/done_screen.dart';
import '../../modules/new_screen.dart';

class AppCubit extends Cubit<AppStates> {
  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  AppCubit() : super(Initial());

  static AppCubit get(context) => BlocProvider.of(context);
  IconData fabIcon = Icons.edit;
  bool isBottomSheetShown = false;

  int currentIndex = 0;
  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> title = [
    'New tasks',
    'Done tasks',
    'Archived task',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    emit(ChangNavigatorBar());
  }

  void createDatabase() {
    openDatabase('todo.db', version: 1, onCreate: (database, version) {
      print(" database created");
      database
          .execute(
              'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
          .then((value) {
        print("table created");
      }).catchError((error) {
        print(" error When Creating table ${error.toString()}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);
      {
        emit(AppGetDatabase());
      }
      print("database opened");
    }).then((value) {
      database = value;
      emit(AppCreateDatabase());
    });
  }

  Future insertTowDataBase({
    required String title,
    required String time,
    required String date,
  }) async {
    return await database!.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO tasks(title,date,time,status) VALUES ("$title","$date","$time","new")',
      )
          .then((value) {
        print("$value insert successfully");
        emit(AppInsertDatabase());
        getDataFromDatabase(database);
      }).catchError((onError) {
        print("error when inserting values${onError.toString()}");
      });
      return null;
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    database!.rawQuery('SELECT * From tasks').then((value) {
      value.forEach((element) {
        if (element["status"] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archivedTasks.add(element);
        }
      });
      emit(AppGetDatabase());
    });
  }

  void updateData({
    required String status,
    required int id,
  }) {
    database!.rawUpdate(
      'UPDATE tasks SET  status = ? WHERE Id = ?',
      [status, '$id'],
    ).then((value) {
      emit(AppUpdateStatus());
      getDataFromDatabase(database);
    });
  }

  void changBottomSheetSates({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(ChangBottomSheetSatesIcon());
  }

  void tasksDelete({
    required int id,
  }) {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteStatus());
      getDataFromDatabase(database);
    });
  }
}

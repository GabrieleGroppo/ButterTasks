import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:butter_task/features/task/presentation/providers/task_provider.dart';
import 'package:butter_task/features/task/presentation/pages/inbox_page.dart';
import 'package:butter_task/features/task/domain/repositories/task_repository.dart';
import 'package:butter_task/features/task/data/repositories/task_repository_impl.dart';
import 'package:butter_task/features/task/data/datasources/task_local_data_source.dart';
import 'package:butter_task/features/task/data/datasources/task_remote_data_source.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'features/task/data/datasources/notification_data_source_impl.dart';
import 'features/task/data/repositories/notification_repository_impl.dart';
import 'features/task/domain/repositories/notification_repository.dart';
import 'features/task/domain/usecases/create_task_use_case.dart';
import 'features/task/domain/usecases/schedule_task_due_date_notification_use_case.dart';

void main() {
  // Initialize SQLite for desktop/non-mobile platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // Initialize FFI
    sqfliteFfiInit();
    // Set the database factory to the FFI implementation
    databaseFactory = databaseFactoryFfi;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initSettings =
    InitializationSettings(android: androidInitSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  // Create the dependencies
  final TaskLocalDataSource localDataSource = TaskLocalDataSource();
  final TaskRemoteDataSource remoteDataSource = TaskRemoteDataSourceImpl();

  final TaskRepository taskRepository = TaskRepositoryImpl(
    localDataSource: localDataSource,
    //remoteDataSource: remoteDataSource,
  );

  final NotificationRepository notificationRepository = NotificationRepositoryImpl(
    dataSource: NotificationDataSourceImpl(flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin),
  );

  final CreateTaskUseCase createTaskUseCase = CreateTaskUseCase(
    taskRepository: taskRepository,
    scheduleNotification: ScheduleTaskDueDateNotificationUseCase(repository: notificationRepository),
  );




  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider(taskRepository, createTaskUseCase),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Butter Task',
      theme: ThemeData(
        //sepia color scheme 704214
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromRGBO(112, 66, 20, 1.0),
        ),
        useMaterial3: true,
      ),
      home: const InboxPage(),
    );
  }
}
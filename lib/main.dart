import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:butter_task/features/task/presentation/providers/task_provider.dart';
import 'package:butter_task/features/task/presentation/pages/inbox_page.dart';
import 'package:butter_task/features/task/domain/repositories/task_repository.dart';
import 'package:butter_task/features/task/data/repositories/task_repository_impl.dart';
import 'package:butter_task/features/task/data/datasources/task_local_data_source.dart';
import 'package:butter_task/features/task/data/datasources/task_remote_data_source.dart';

void main() {
  // Create the dependencies
  final TaskLocalDataSource localDataSource = TaskLocalDataSource();
  final TaskRemoteDataSource remoteDataSource = TaskRemoteDataSourceImpl();

  final TaskRepository taskRepository = TaskRepositoryImpl(
    localDataSource: localDataSource,
    //remoteDataSource: remoteDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskProvider(taskRepository),
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

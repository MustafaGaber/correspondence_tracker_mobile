import 'package:correspondence_tracker/classifications/cubit/classifications_cubit.dart';
import 'package:correspondence_tracker/classifications/models/classification.dart';
import 'package:correspondence_tracker/classifications/service/classifications_service.dart';
import 'package:correspondence_tracker/correspondences/cubit/correspondences_cubit.dart';
import 'package:correspondence_tracker/correspondences/screens/correspondences_page.dart';
import 'package:correspondence_tracker/correspondences/service/correspondence_service.dart';
import 'package:correspondence_tracker/correspondents/cubit/correspondents_cubit.dart';
import 'package:correspondence_tracker/correspondents/service/correspondents_service.dart';
import 'package:correspondence_tracker/departments/cubit/departments_cubit.dart';
import 'package:correspondence_tracker/departments/service/departments_service.dart';
import 'package:correspondence_tracker/subjects/cubit/subjects_cubit.dart';
import 'package:correspondence_tracker/subjects/service/subjects_service.dart';
import 'package:correspondence_tracker/users/cubit/users_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'users/service/users_service.dart';

void main() {
  startApp();
}

Future<void> startApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final appDocDir = await getApplicationDocumentsDirectory();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  final apiUrl = "http://localhost/api/CorrespondenceApi";
  final mobileApiUrl =
      "https://desktop-ijs5l3q.tail1c0027.ts.net/api/CorrespondenceApi";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CorrespondencesCubit(
            CorrespondenceService(kIsWeb ? apiUrl : mobileApiUrl),
          ),
        ),
        BlocProvider(
          create: (context) => DepartmentsCubit(
            DepartmentsService(kIsWeb ? apiUrl : mobileApiUrl),
          ),
        ),
        BlocProvider(
          create: (context) => CorrespondentsCubit(
            CorrespondentsService(kIsWeb ? apiUrl : mobileApiUrl),
          ),
        ),
        BlocProvider(
          create: (context) =>
              UsersCubit(UsersService(kIsWeb ? apiUrl : mobileApiUrl)),
        ),
        BlocProvider(
          create: (context) => ClassificationsCubit(
            ClassificationsService(kIsWeb ? apiUrl : mobileApiUrl),
          ),
        ),
        BlocProvider(
          create: (context) =>
              SubjectsCubit(SubjectsService(kIsWeb ? apiUrl : mobileApiUrl)),
        ),
      ],
      child: MaterialApp(
        title: 'متابعة الخطابات',
        theme: ThemeData(
          useMaterial3: true,
          cardTheme: CardThemeData(color: ColorScheme.light().surface),
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const CorrespondencesPage(),
      ),
    );
  }
}

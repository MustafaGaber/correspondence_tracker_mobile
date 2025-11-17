import 'package:correspondence_tracker/correspondences/cubit/correspondences_cubit.dart';
import 'package:correspondence_tracker/correspondences/screens/correspondences_page.dart';
import 'package:correspondence_tracker/correspondences/service/correspondence_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

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
  final mobileApiUrl = "https://desktop-ijs5l3q.tail1c0027.ts.net/api/CorrespondenceApi";
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CorrespondencesCubit(CorrespondenceService(kIsWeb ? apiUrl : mobileApiUrl)),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          cardTheme: CardThemeData(
            color:ColorScheme.light().surface,
          ),
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const CorrespondencePage(),
      ),
    );
  }
}

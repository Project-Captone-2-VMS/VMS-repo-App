import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vms_app/features/location/data/repositories/location_repository_impl.dart';
import 'package:vms_app/features/location/ui/cubit/location_cubit.dart';
import 'package:vms_app/firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocationCubit(LocationRepositoryImpl()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

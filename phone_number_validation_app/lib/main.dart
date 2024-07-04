import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/country_bloc.dart';
import 'repositories/country_repository.dart';
import 'screens/home_screen.dart';

void main() {
  final countryRepository = CountryRepository();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<CountryBloc>(
          create: (BuildContext context) => CountryBloc(countryRepository),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
    MaterialApp(
      title: 'Valiadate Phone Number',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

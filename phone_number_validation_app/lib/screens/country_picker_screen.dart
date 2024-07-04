import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_bloc.dart';
import '../blocs/country_event.dart';
import '../blocs/country_state.dart';
import '../models/country.dart';

class CountryPickerScreen extends StatefulWidget {
  @override
  _CountryPickerScreenState createState() => _CountryPickerScreenState();
}

class _CountryPickerScreenState extends State<CountryPickerScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CountryBloc>(context).add(LoadCountries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Country'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                BlocProvider.of<CountryBloc>(context).add(SearchCountry(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<CountryBloc, CountryState>(
              builder: (context, state) {
                if (state is CountryLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CountryLoaded) {
                  return ListView.builder(
                    itemCount: state.countries.length,
                    itemBuilder: (context, index) {
                      final country = state.countries[index];
                      return ListTile(
                        title: Text('${country.phoneCode} ${country.name}'),
                        onTap: () {
                          Navigator.pop(context, country);
                        },
                      );
                    },
                  );
                } else if (state is CountryError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

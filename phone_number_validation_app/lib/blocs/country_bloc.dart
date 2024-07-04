import 'package:flutter_bloc/flutter_bloc.dart';
import 'country_event.dart';
import 'country_state.dart';
import '../repositories/country_repository.dart';
import '../models/country.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryRepository countryRepository;
  List<Country> _allCountries = []; // Internal variable to store the original list

  CountryBloc(this.countryRepository) : super(CountryInitial());

  @override
  Stream<CountryState> mapEventToState(CountryEvent event) async* {
    if (event is LoadCountries) {
      yield CountryLoading();
      try {
        final countries = await countryRepository.fetchCountries();
        _allCountries = countries; // Storing the original list in this variable
        yield CountryLoaded(countries);
      } catch (e) {
        yield CountryError(e.toString());
      }
    } else if (event is SearchCountry) {
      if (state is CountryLoaded) {
        final filteredCountries = _allCountries
            .where((country) => country.name.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        yield CountryLoaded(filteredCountries);
      }
    }
  }
}

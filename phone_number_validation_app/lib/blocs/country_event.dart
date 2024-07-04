import 'package:equatable/equatable.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object> get props => [];
}

class LoadCountries extends CountryEvent {}

class SearchCountry extends CountryEvent {
  final String query;

  const SearchCountry(this.query);

  @override
  List<Object> get props => [query];
}

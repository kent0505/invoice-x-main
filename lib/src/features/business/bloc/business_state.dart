part of 'business_bloc.dart';

final class BusinessState {
  BusinessState({
    this.businesses = const[ ],
    this.defaultBusiness,
    this.loading = false,
  });

  final List<Business> businesses;
  final Business? defaultBusiness;
  final bool loading;

  BusinessState copyWith({
    List<Business>? businesses,
    Business? defaultBusiness,
    bool? loading,
  }) {
    return BusinessState(
      businesses: businesses ?? this.businesses,
      defaultBusiness: defaultBusiness ?? this.defaultBusiness,
      loading: loading ?? this.loading,
    );
  }
}

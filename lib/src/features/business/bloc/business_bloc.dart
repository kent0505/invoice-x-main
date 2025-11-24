import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/business_repository.dart';
import '../models/business.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessRepository _repository;

  BusinessBloc({required BusinessRepository repository})
      : _repository = repository,
        super(BusinessState()) {
    on<BusinessEvent>(
      (event, emit) => switch (event) {
        GetBusiness() => _getBusiness(event, emit),
        AddBusiness() => _addBusiness(event, emit),
        EditBusiness() => _editBusiness(event, emit),
        DeleteBusiness() => _deleteBusiness(event, emit),
      },
    );
  }

  void _getBusiness(
    GetBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    if (!state.loading) {
      emit(state.copyWith(loading: true));
    }

    final businesses = await _repository.getBusiness();

    emit(state.copyWith(
      businesses: businesses.reversed.toList(),
      loading: false,
    ));
  }

  void _addBusiness(
    AddBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    final business = event.business;

    await _repository.addBusiness(business);

    add(GetBusiness());
  }

  void _editBusiness(
    EditBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    await _repository.editBusiness(event.business);

    add(GetBusiness());
  }

  void _deleteBusiness(
    DeleteBusiness event,
    Emitter<BusinessState> emit,
  ) async {
    emit(state.copyWith(loading: true));

    await _repository.deleteBusiness(event.business);

    add(GetBusiness());
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/constants.dart';
import '../../../core/utils.dart';
import '../data/vip_repository.dart';

part 'vip_event.dart';
part 'vip_state.dart';

class VipBloc extends Bloc<VipEvent, VipState> {
  final VipRepository _repository;

  VipBloc({required VipRepository repository})
      : _repository = repository,
        super(VipState()) {
    on<VipEvent>(
      (event, emit) => switch (event) {
        CheckVip() => _checkVip(event, emit),
        CheckPurchased() => _checkPurchased(event, emit),
        UseFree() => _useFree(event, emit),
      },
    );
  }

  void _checkVip(
    CheckVip event,
    Emitter<VipState> emit,
  ) async {
    if (isIOS()) {
      emit(state.copyWith(
        loading: true,
        free: _repository.getFree(),
      ));

      try {
        final customerInfo = await Purchases.getCustomerInfo().timeout(
          const Duration(seconds: 10),
        );

        final offerings = await Purchases.getOfferings().timeout(
          const Duration(seconds: 10),
        );

        final offering = offerings.getOffering('paywall_1');

        emit(state.copyWith(
          loading: false,
          isVip: customerInfo.entitlements.active.isNotEmpty,
          offering: offering,
        ));
      } catch (e) {
        logger(e);
        emit(state.copyWith(loading: false));
      }
    } else {
      // android
      emit(state.copyWith(
        isVip: true,
        loading: false,
        offering: null,
      ));
    }
  }

  void _checkPurchased(
    CheckPurchased event,
    Emitter<VipState> emit,
  ) async {
    final isVip = event.customerInfo.entitlements.active.isNotEmpty;
    emit(state.copyWith(isVip: isVip));
  }

  void _useFree(
    UseFree event,
    Emitter<VipState> emit,
  ) async {
    int free = _repository.getFree();
    free = free - 1;
    logger('free = $free');
    await _repository.setFree(free);
    emit(state.copyWith(free: free));
  }
}

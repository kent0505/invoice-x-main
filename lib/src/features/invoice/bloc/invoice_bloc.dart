import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils.dart';
import '../data/invoice_repository.dart';
import '../data/photo_repository.dart';
import '../models/invoice.dart';
import '../models/photo.dart';

part 'invoice_event.dart';
part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRepository _invoiceRepository;
  final PhotoRepository _photoRepository;

  InvoiceBloc({
    required InvoiceRepository invoiceRepository,
    required PhotoRepository photoRepository,
  })  : _invoiceRepository = invoiceRepository,
        _photoRepository = photoRepository,
        super(InvoiceState()) {
    on<InvoiceEvent>(
      (event, emit) => switch (event) {
        GetInvoices() => _getInvoices(event, emit),
        AddInvoice() => _addInvoice(event, emit),
        EditInvoice() => _editInvoice(event, emit),
        DeleteInvoice() => _deleteInvoice(event, emit),
      },
    );
  }

  void _getInvoices(
    GetInvoices event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      final invoices = await _invoiceRepository.getInvoices();
      final photos = await _photoRepository.getPhotos();

      emit(state.copyWith(
        invoices: invoices,
        photos: photos,
      ));
    } catch (e) {
      logger(e);
    }
  }

  void _addInvoice(
    AddInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      final iid = await _invoiceRepository.addInvoice(event.invoice);

      emit(state.copyWith(iid: iid));

      for (final path in event.paths) {
        await _photoRepository.addPhoto(
          Photo(
            id: iid.toString(),
            path: path,
          ),
        );
      }

      add(GetInvoices());
    } catch (e) {
      logger(e);
    }
  }

  void _editInvoice(
    EditInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await _invoiceRepository.editInvoice(event.invoice);
      await _photoRepository.deletePhotos(event.invoice.id);

      for (final path in event.paths) {
        await _photoRepository.addPhoto(
          Photo(
            id: event.invoice.id,
            path: path,
          ),
        );
      }

      add(GetInvoices());
    } catch (e) {
      logger(e);
    }
  }

  void _deleteInvoice(
    DeleteInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    try {
      await _invoiceRepository.deleteInvoice(event.invoice);

      add(GetInvoices());
    } catch (e) {
      logger(e);
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        super(InvoiceInitial()) {
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
    final invoices = await _invoiceRepository.getInvoices();
    final photos = await _photoRepository.getPhotos();
    emit(InvoiceLoaded(
      invoices: invoices,
      photos: photos,
    ));
  }

  void _addInvoice(
    AddInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    await _invoiceRepository.addInvoice(event.invoice);
    await _photoRepository.addPhotos(event.photos);
    add(GetInvoices());
  }

  void _editInvoice(
    EditInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    await _invoiceRepository.editInvoice(event.invoice);
    await _photoRepository.deletePhotos(event.invoice);
    await _photoRepository.addPhotos(event.invoice.photos);
    add(GetInvoices());
  }

  void _deleteInvoice(
    DeleteInvoice event,
    Emitter<InvoiceState> emit,
  ) async {
    await _invoiceRepository.deleteInvoice(event.invoice);
    await _photoRepository.deletePhotos(event.invoice);
    add(GetInvoices());
  }
}

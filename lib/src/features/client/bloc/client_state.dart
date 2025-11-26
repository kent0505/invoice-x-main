part of 'client_bloc.dart';

final class ClientState {
  ClientState({
    this.clients = const[ ],
  });

  final List<Client> clients;

  ClientState copyWith({
    List<Client>? clients,
  }) {
    return ClientState(
      clients: clients ?? this.clients,
    );
  }
}

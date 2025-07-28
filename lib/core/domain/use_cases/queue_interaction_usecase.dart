import 'package:injectable/injectable.dart';
import '../entities/interaction_entity.dart';
import '../repositories/cryptos_repository.dart';

@injectable
class QueueInteractionIterator {
  final CryptosRepository _repository;

  QueueInteractionIterator(this._repository);

  Future<void> enqueue(Interaction interaction) =>
      _repository.enqueueInteraction(interaction);

  Future<void> flushQueue() => _repository.flushInteractions();

  Future<void> send(Interaction interaction) =>
      _repository.sendInteraction(interaction);
}

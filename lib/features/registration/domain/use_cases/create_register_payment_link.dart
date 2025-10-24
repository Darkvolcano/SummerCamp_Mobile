import 'package:summercamp/features/registration/domain/entities/optional_choice.dart';
import 'package:summercamp/features/registration/domain/repositories/registration_repository.dart';

class CreateRegisterPaymentLink {
  final RegistrationRepository repository;
  CreateRegisterPaymentLink(this.repository);

  Future<String> call({
    required int registrationId,
    List<OptionalChoice>? optionalChoices,
  }) async {
    return await repository.registerPaymentLink(
      registrationId: registrationId,
      optionalChoices: optionalChoices,
    );
  }
}

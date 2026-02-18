import 'package:freezed_annotation/freezed_annotation.dart';

part 'registration.freezed.dart';
part 'registration.g.dart';

/// Request payload for collar registration
@freezed
class RegistrationRequest with _$RegistrationRequest {
  const factory RegistrationRequest({
    /// 15-digit IMEI from the collar
    required String imei,

    /// Current user's ID
    required String userId,

    /// Current user's authentication token
    required String userToken,
  }) = _RegistrationRequest;

  factory RegistrationRequest.fromJson(Map<String, dynamic> json) =>
      _$RegistrationRequestFromJson(json);
}

/// Response from collar registration endpoint
@freezed
class RegistrationResponse with _$RegistrationResponse {
  const factory RegistrationResponse({
    /// Registration status (A, B, or C from SRS)
    required RegistrationStatus status,

    /// Backend-generated collar token (for Cases A & C)
    String? collarToken,

    /// Human-readable message
    String? message,
  }) = _RegistrationResponse;

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) =>
      _$RegistrationResponseFromJson(json);
}

/// Registration status enum matching SRS requirements
enum RegistrationStatus {
  /// Case A: Collar already registered to current user
  @JsonValue('alreadyRegisteredCurrentUser')
  alreadyRegisteredCurrentUser,

  /// Case B: Collar already registered to another user (ERROR)
  @JsonValue('alreadyRegisteredOtherUser')
  alreadyRegisteredOtherUser,

  /// Case C: Collar newly registered to current user
  @JsonValue('newlyRegistered')
  newlyRegistered,
}

/// Extension methods for RegistrationStatus
extension RegistrationStatusExtension on RegistrationStatus {
  /// Whether registration was successful (Cases A or C)
  bool get isSuccess {
    return this == RegistrationStatus.alreadyRegisteredCurrentUser ||
        this == RegistrationStatus.newlyRegistered;
  }

  /// Whether registration failed (Case B)
  bool get isFailure {
    return this == RegistrationStatus.alreadyRegisteredOtherUser;
  }

  /// Whether a collar token should be available
  bool get hasCollarToken {
    return isSuccess;
  }
}

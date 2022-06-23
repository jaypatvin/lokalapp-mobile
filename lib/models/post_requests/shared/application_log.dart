import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:recase/recase.dart';

part 'application_log.g.dart';

enum ActionTypes {
  userLogin,
  userLogout,
  // userLoginFB,
  // userLoginGoogle,
  userLoginFailed,
  // userLoginForgotPassword,
  // userLoginChangePassword,
  // userUpdate,
  userInvite,
  productView,
  productLike,
  // productCreate,
  // productUpdate,
  // productDelete,
  shopView,
  // shopCreate,
  // shopUpdate,
  // shopDelete,
  // postView,
  // postLiked,
  // postMuted,
  // orderView,
  // cartAddProduct,
  // cartRemoveProduct,
  // cartClear,
  // notificationClicked,
  // notificationMuted,
}

extension ActionTypesToString on ActionTypes {
  String get value => toString().split('.').last;
}

@JsonSerializable()
class ApplicationLog {
  const ApplicationLog({
    required this.communityId,
    required this.actionType,
    required this.deviceId,
    this.associatedDocument,
    this.source = 'app',
    this.metadata,
  });

  @JsonKey(required: true)
  final String communityId;

  @JsonKey(
    required: true,
    toJson: _actionTypeToJson,
    fromJson: _actionTypeFromJson,
  )
  final ActionTypes actionType;

  @JsonKey(required: true)
  final String deviceId;

  final String? associatedDocument;
  final String? source;
  final Map<String, dynamic>? metadata;

  ApplicationLog copyWith({
    String? communityId,
    ActionTypes? actionType,
    String? deviceId,
    String? associatedDocument,
    String? source,
    Map<String, dynamic>? metadata,
  }) {
    return ApplicationLog(
      communityId: communityId ?? this.communityId,
      actionType: actionType ?? this.actionType,
      deviceId: deviceId ?? this.deviceId,
      associatedDocument: associatedDocument ?? this.associatedDocument,
      source: source ?? this.source,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => _$ApplicationLogToJson(this);

  factory ApplicationLog.fromJson(Map<String, dynamic> json) =>
      _$ApplicationLogFromJson(json);

  @override
  String toString() {
    return 'ApplicationLog(communityId: $communityId, actionType: $actionType, '
        'deviceId: $deviceId, associatedDocument: $associatedDocument, '
        'source: $source, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApplicationLog &&
        other.communityId == communityId &&
        other.actionType == actionType &&
        other.deviceId == deviceId &&
        other.associatedDocument == associatedDocument &&
        other.source == source &&
        mapEquals(other.metadata, metadata);
  }

  @override
  int get hashCode {
    return communityId.hashCode ^
        actionType.hashCode ^
        deviceId.hashCode ^
        associatedDocument.hashCode ^
        source.hashCode ^
        metadata.hashCode;
  }
}

String _actionTypeToJson(ActionTypes actionType) {
  return actionType.value.snakeCase;
}

ActionTypes _actionTypeFromJson(String actionType) =>
    ActionTypes.values.firstWhere((e) => e.value == actionType);

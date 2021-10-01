import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/product_subscription_plan.dart';
import '../services/lokal_api/subscription_service.dart';

class SubscriptionPlanBodySchedule {
  final List<DateTime> startDates;
  final int repeatUnit;
  final String repeatType;
  final DateTime lastDate;

  const SubscriptionPlanBodySchedule({
    @required this.startDates,
    @required this.repeatUnit,
    @required this.repeatType,
    this.lastDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'start_dates': startDates
          ?.map((date) => DateFormat("yyyy-MM-dd").format(date))
          ?.toList(),
      'repeat_unit': repeatUnit,
      'repeat_type': repeatType,
      'last_date':
          lastDate != null ? DateFormat("yyyy-MM-dd").format(lastDate) : "",
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SubscriptionPlanBodySchedule(startDates: $startDates, '
        'repeatUnit: $repeatUnit, repeatType: $repeatType, lastDate: $lastDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionPlanBodySchedule &&
        listEquals(other.startDates, startDates) &&
        other.repeatUnit == repeatUnit &&
        other.repeatType == repeatType &&
        other.lastDate == lastDate;
  }

  @override
  int get hashCode {
    return startDates.hashCode ^
        repeatUnit.hashCode ^
        repeatType.hashCode ^
        lastDate.hashCode;
  }
}

class SubscriptionPlanBody {
  String productId;
  String buyerId;
  String shopId;
  int quantity;
  String instruction;
  String paymentMethod;
  SubscriptionPlanBodySchedule plan;
  SubscriptionPlanBody({
    this.productId,
    this.buyerId,
    this.shopId,
    this.quantity,
    this.instruction,
    this.paymentMethod,
    this.plan,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'buyer_id': buyerId,
      'shop_id': shopId,
      'quantity': quantity,
      'payment_method': paymentMethod,
      'plan': plan.toMap(),
      'instruction': instruction,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'SubscriptionPlanBody(productId: $productId, buyerId: $buyerId, '
        'shopId: $shopId, quantity: $quantity, instruction: $instruction, '
        'paymentMethod: $paymentMethod, plan: $plan)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubscriptionPlanBody &&
        other.productId == productId &&
        other.buyerId == buyerId &&
        other.shopId == shopId &&
        other.quantity == quantity &&
        other.instruction == instruction &&
        other.paymentMethod == paymentMethod &&
        other.plan == plan;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        buyerId.hashCode ^
        shopId.hashCode ^
        quantity.hashCode ^
        instruction.hashCode ^
        paymentMethod.hashCode ^
        plan.hashCode;
  }
}

class SubscriptionProvider {
  final _service = SubscriptionService.instance;
  String _idToken;

  void setIdToken(String idToken) {
    _idToken = idToken;
  }

  Future<ProductSubscriptionPlan> createSubscriptionPlan(
    Map<String, dynamic> data,
  ) async {
    final response =
        await _service.createSubscriptionPlan(idToken: _idToken, data: data);

    if (response.statusCode != 200) {
      return null;
    }

    try {
      final Map<String, dynamic> body = json.decode(response.body);
      if (body['status'] != "ok") throw Exception(body['data']);

      final subscriptionPlan = ProductSubscriptionPlan.fromMap(body['data']);
      return subscriptionPlan;
    } catch (e) {
      return null;
    }
  }

  Future<bool> autoReschedulePlan(String planId) async {
    final response =
        await _service.autoReschedulePlan(idToken: _idToken, planId: planId);

    if (response.statusCode != 200) {
      return false;
    }

    try {
      final Map<String, dynamic> body = json.decode(response.body);
      return body["status"] == "ok";
    } catch (e) {
      return false;
    }
  }

  Future<bool> manualReschedulePlan(
    String planId,
    Map<String, dynamic> data,
  ) async {
    final response = await _service.manualReschedulePlan(
      idToken: _idToken,
      planId: planId,
      data: data,
    );

    if (response.statusCode != 200) {
      print(response.body);
      return false;
    }

    try {
      final Map<String, dynamic> body = json.decode(response.body);
      return body["status"] == "ok";
    } catch (e) {
      return false;
    }
  }
}

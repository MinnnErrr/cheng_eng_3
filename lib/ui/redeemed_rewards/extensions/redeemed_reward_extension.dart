import 'package:cheng_eng_3/domain/models/redeemed_reward_model.dart';
import 'package:flutter/material.dart';

extension RedeemedRewardStatusExtension on RedeemedReward{
  Color get statusColor {
    return isClaimed ? Colors.grey : Colors.green;
  }
} 
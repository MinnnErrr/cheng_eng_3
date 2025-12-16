import 'dart:io';

import 'package:cheng_eng_3/core/models/message_model.dart';
import 'package:cheng_eng_3/core/models/reward_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/core/services/reward_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'staff_rewards_notifier.g.dart';

@riverpod
class StaffRewardsNotifier extends _$StaffRewardsNotifier {
  RewardService get _rewardService => ref.read(rewardServiceProvider);
  ImageService get _imageService => ref.read(imageServiceProvider);

  @override
  FutureOr<List<Reward>> build() async {
    return await _rewardService.getAllRewards();
  }

  // void refresh() => ref.invalidateSelf();

  Future<Message> addReward({
    required String rewardCode,
    required String name,
    required String description,
    required int points,
    required int quantity,
    required bool status,
    required List<File> photos,
    required String? conditions,
    required DateTime? availableUntil,
    required int? validityWeeks
  }) async {
    final rewardId = Uuid().v4();
    List<String> photoPaths = [];

    if (photos.isNotEmpty) {
      String rewardId = Uuid().v4();

      for (File photo in photos) {
        try {
          final photoPath = await _imageService.uploadImage(
            photoFile: photo,
            tableName: 'rewards',
            id: '$rewardId/$rewardId',
          );
          photoPaths.add(photoPath);
        } catch (e) {
          return Message(isSuccess: false, message: 'Failed to upload photos');
        }
      }
    }

    final reward = Reward(
      id: rewardId,
      createdAt: DateTime.now(),
      code: rewardCode,
      name: name,
      description: description,
      points: points,
      quantity: quantity,
      photoPaths: photoPaths,
      status: status,
      conditions: conditions,
      availableUntil: availableUntil,
      validityWeeks: validityWeeks
    );

    try {
      await _rewardService.create(reward);
      return Message(isSuccess: true, message: 'Reward added');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to add reward');
    }
  }

  Future<Message> updateReward({
    required String id,
    required String rewardCode,
    required String name,
    required String description,
    required int points,
    required int quantity,
    required List<dynamic> photos,
    required String? conditions,
    required DateTime? availableUntil,
    required int? validityWeeks
  }) async {
    final previous = state.value ?? [];
    final currentReward = previous.firstWhere(
      (r) => r.id == id,
      orElse: () => throw Exception('Reward not found'),
    );

    String extractPathFromUrl(String url) {
      final uri = Uri.parse(url);
      final idx = uri.pathSegments.indexOf('images');
      if (idx == -1) return '';
      return uri.pathSegments.sublist(idx + 1).join('/');
    }

    //photo
    List<String> newPaths = [];

    for (final photo in photos) {
      late String path;
      if (photo is String) {
        path = extractPathFromUrl(photo);
      } else if (photo is File) {
        final rewardId = Uuid().v4();
        path = await _imageService.uploadImage(
          photoFile: photo,
          tableName: 'rewards',
          id: '$id/$rewardId',
        );
      } else {
        continue;
      }
      newPaths.add(path);
    }

    final reward = currentReward.copyWith(
      code: rewardCode,
      name: name,
      description: description,
      points: points,
      quantity: quantity,
      conditions: conditions,
      availableUntil: availableUntil,
      validityWeeks: validityWeeks,
      photoPaths: newPaths,
      updatedAt: DateTime.now(),
    );

    try {
      await _rewardService.update(reward);
      return Message(isSuccess: true, message: 'Reward updated');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to update reward');
    }
  }

  Future<Message> updateStatus({
    required String id,
    required bool isActive,
  }) async {
    try {
      await _rewardService.updateStatus(isActive, id);

      return Message(isSuccess: true, message: 'Reward status updated');
    } catch (e) {
      return Message(
        isSuccess: false,
        message: 'Failed to update reward status',
      );
    }
  }

  // Future<Message> descreaseQuantity({
  //   required String id,
  // }) async {
  //   try {
  //     final previous = state.value ?? [];
  //     final currentReward = previous.firstWhere(
  //       (r) => r.id == id,
  //       orElse: () => throw Exception('Reward not found'),
  //     );

  //     final newQty = currentReward.quantity - 1;

  //     await _rewardService.updateQuantity(newQty, id);

  //     return Message(isSuccess: true, message: 'Reward quantity updated');
  //   } catch (e) {
  //     return Message(
  //       isSuccess: false,
  //       message: 'Failed to update reward quantity',
  //     );
  //   }
  // }

  Future<Message> deleteReward(String id) async {
    try {
      await _rewardService.delete(id);

      return Message(isSuccess: true, message: 'Reward deleted');
    } catch (e) {
      return Message(isSuccess: false, message: 'Failed to delete reward');
    }
  }
}


import 'package:cheng_eng_3/core/models/profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileListitem extends ConsumerWidget {
  const ProfileListitem({super.key, required this.profile});

  final Profile? profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: profile == null
            ? Center(
                child: Text('No profile found'),
              )
            : Column(
                children: [
                  Text(
                    profile!.email,
                    softWrap: true,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profile!.name,
                    softWrap: true,
                  ),
                  Text(
                    profile!.phoneNum,
                  ),
                  Text(
                    profile!.gender,
                  ),
                ],
              ),
      ),
    );
  }
}

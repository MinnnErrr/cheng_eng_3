import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileListitem extends ConsumerWidget {
  const ProfileListitem({
    super.key,
    required this.email,
    required this.name,
    required this.dialCode,
    required this.phoneNum,
    required this.gender,
  });

  final String? email;
  final String? name;
  final String? dialCode;
  final String? phoneNum;
  final String? gender;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: email == null || name == null || phoneNum == null
              ? Center(
                  child: Text('No profile found'),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      email!,
                      softWrap: true,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      name!,
                      softWrap: true,
                    ),
                    Text(
                      '$dialCode$phoneNum',
                    ),
                    if (gender != null)
                      Text(
                        gender!,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}

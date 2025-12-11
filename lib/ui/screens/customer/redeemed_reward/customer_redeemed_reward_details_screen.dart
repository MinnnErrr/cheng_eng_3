import 'dart:convert';

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/redeem_reward/redeemed_reward_notifier.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CustomerRedeemedRewardDetailsScreen extends ConsumerStatefulWidget {
  const CustomerRedeemedRewardDetailsScreen({
    super.key,
    required this.redeemedId,
  });
  final String redeemedId;

  @override
  ConsumerState<CustomerRedeemedRewardDetailsScreen> createState() {
    return _CustomerRedeemedRewardDetailsScreenState();
  }
}

class _CustomerRedeemedRewardDetailsScreenState
    extends ConsumerState<CustomerRedeemedRewardDetailsScreen> {
  final PageController _pageController = PageController();
  final _dateFormatter = DateFormat('dd/MM/yyyy').add_jm();
  String? _redeemedId;
  String? _userId;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    if (user == null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => Main(),
        ),
        (route) => false,
      );
    }

    final redeemed = ref.watch(
      redeemedRewardByIdProvider((user!.id, widget.redeemedId)),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Details'),
        actions: [
          IconButton(
            onPressed: () => _showQrDialog(context),
            icon: Icon(Icons.qr_code),
          ),
        ],
      ),
      body: redeemed.when(
        data: (redeemed) {
          setState(() {
            _redeemedId = redeemed.id;
            _userId = user.id;
          });
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  //photo
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: redeemed.photoPaths.isEmpty
                        ? Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported),
                                Text('No image found'),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              //image
                              Expanded(
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: redeemed.photoPaths.length,
                                  itemBuilder: (context, index) {
                                    final imageService = ref.read(
                                      imageServiceProvider,
                                    );
                                    final imageUrl = imageService
                                        .retrieveImageUrl(
                                          redeemed.photoPaths[index],
                                        );

                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        12,
                                      ),
                                      child: Image.network(
                                        imageUrl,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, progress) {
                                          if (progress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  progress.expectedTotalBytes !=
                                                      null
                                                  ? progress.cumulativeBytesLoaded /
                                                        progress
                                                            .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 40,
                                                ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 10),

                              //dots
                              SmoothPageIndicator(
                                controller: _pageController,
                                count: redeemed.photoPaths.length,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor: Theme.of(
                                    context,
                                  ).colorScheme.primary,
                                  dotColor: Colors.grey.shade400,
                                  expansionFactor: 3,
                                ),
                              ),
                            ],
                          ),
                  ),

                  if (redeemed.expiryDate != null)
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.errorContainer,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Expiry Date: ${_dateFormatter.format(redeemed.expiryDate!)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),

                  //details
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainerLowest,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '#${redeemed.code}',
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),

                        Text(
                          redeemed.name,
                          softWrap: true,
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Row(
                          children: [
                            Text('Status'),
                            Spacer(),
                            Text(
                              redeemed.isClaimed ? 'Unclaimed' : 'Claimed',
                              style: TextStyle(
                                color: redeemed.isClaimed
                                    ? Theme.of(context).colorScheme.error
                                    : Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text('Redeemed at'),
                            Spacer(),
                            Text(_dateFormatter.format(redeemed.createdAt)),
                          ],
                        ),

                        Row(
                          children: [
                            Text('Updated at'),
                            Spacer(),
                            Text(
                              redeemed.updatedAt != null
                                  ? _dateFormatter.format(redeemed.updatedAt!)
                                  : '-',
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Text('Points used: '),
                        Text(
                          '${redeemed.points.toString()} pts',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),

                  //description
                  Container(
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          redeemed.description,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),

                  //remarks
                  if (redeemed.conditions != null)
                    Container(
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.errorContainer,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remarks',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            redeemed.conditions!,
                            softWrap: true,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void _showQrDialog(BuildContext context) {
    final qrData = jsonEncode({
      'userId': _userId,
      'redeemedRewardId': _redeemedId,
    });
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text('Show this QR to the staff for claiming the reward'),
              const SizedBox(
                height: 20,
              ),
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

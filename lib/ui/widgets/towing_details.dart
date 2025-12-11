
import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TowingDetailsScreen extends ConsumerWidget {
  const TowingDetailsScreen({super.key, required this.towing});

  final Towing towing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.sizeOf(context);

    final imageService = ref.read(imageServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 30,
      children: [
        //vehicle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              'Vehicle Details',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            _vehicle(context, towing, imageService, screenSize),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              'Towing Details',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            _towingDetails(context, towing),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(
              'Picture of Surrounding',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            _image(context, towing, imageService, screenSize),
          ],
        ),
      ],
    );
  }

  Widget _towingDetails(BuildContext context, Towing towing) {
    final dateFormatter = DateFormat('dd/MM/yyyy').add_jm();
    Widget towingDetailsItem({required String title, required String value}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        spacing: 10,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            softWrap: true,
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                spacing: 20,
                children: [
                  towingDetailsItem(
                    title: 'Address',
                    value: towing.address,
                  ),
                  towingDetailsItem(
                    title: 'Coordinates',
                    value: '${towing.longitude}, ${towing.latitude}',
                  ),
                  towingDetailsItem(
                    title: 'Created At',
                    value: dateFormatter.format(towing.createdAt),
                  ),
                  towingDetailsItem(
                    title: 'Updated At',
                    value: towing.updatedAt != null
                        ? dateFormatter.format(towing.updatedAt!)
                        : '-',
                  ),
                  towingDetailsItem(
                    title: 'Status',
                    value: towing.status,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Remarks',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          towing.remarks ?? '-',
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
          ),
        ],
      ),
    );
  }

  Widget _image(
    BuildContext context,
    Towing towing,
    ImageService imageService,
    Size screenSize,
  ) {
    return imageBuilder(
      url: towing.photoPath != null
          ? imageService.retrieveImageUrl(
              towing.photoPath!,
            )
          : null,
      containerWidth: double.infinity,
      containerHeight: screenSize.height * 0.3,
      noImageContent: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_not_supported),
            Text('No image found'),
          ],
        ),
      ),
      context: context,
    );
  }

  Widget _vehicle(
    BuildContext context,
    Towing towing,
    ImageService imageService,
    Size screenSize,
  ) {
    return InkWell(
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //picture
              imageBuilder(
                url: towing.photoPath != null
                    ? imageService.retrieveImageUrl(towing.photoPath!)
                    : null,
                containerWidth: screenSize.width * 0.15,
                containerHeight: screenSize.height * 0.1,
                noImageContent: Container(
                  color: Colors.white,
                  child: Icon(Icons.directions_car),
                ),
                context: context,
              ),

              const SizedBox(
                width: 20,
              ),

              //details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      towing.regNum,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      '${towing.make}, ${towing.model}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    Text(
                      towing.colour,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

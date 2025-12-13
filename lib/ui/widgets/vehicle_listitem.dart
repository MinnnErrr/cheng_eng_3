import 'package:cheng_eng_3/core/models/vehicle_model.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/ui/widgets/imagebuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VehicleListitem extends ConsumerWidget {
  const VehicleListitem({
    super.key,
    required this.vehicle,
    required this.descriptionRequired,
    required this.colourRequired,
    required this.yearRequired,
    this.icon,
  });

  final Vehicle vehicle;
  final bool descriptionRequired;
  final bool yearRequired;
  final bool colourRequired;
  final Widget? icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageService = ref.read(imageServiceProvider);
    final screenSize = MediaQuery.of(context).size;

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //picture
            imageBuilder(
              url: vehicle.photoPath != null
                  ? imageService.retrieveImageUrl(vehicle.photoPath!)
                  : null,
              containerWidth: screenSize.width * 0.2,
              containerHeight: screenSize.height * 0.12,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (descriptionRequired == true)
                        Text(
                          vehicle.description ?? '-',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),

                      Text(
                        vehicle.regNum,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle.make}, ${vehicle.model}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (yearRequired == true)
                        Text(
                          vehicle.year.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                      if (colourRequired == true)
                        Text(
                          vehicle.colour,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 20,
            ),

            //icon
            if (icon != null) icon!,
          ],
        ),
      ),
    );
  }
}

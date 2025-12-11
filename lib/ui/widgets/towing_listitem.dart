import 'package:cheng_eng_3/core/models/towing_model.dart';
import 'package:cheng_eng_3/utils/status_colour.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TowingListItem extends ConsumerWidget {
  const TowingListItem({
    super.key,
    required this.towing,
    this.tapAction,
  });

  final Towing towing;
  final GestureTapCallback? tapAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final timeFormatter = DateFormat('dd/MM/yyyy').add_jm();

    return InkWell(
      onTap: tapAction,
      child: Card(
        color: Theme.of(context).colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        towing.regNum,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Text(
                        '${towing.make}, ${towing.model} | ${towing.colour}',
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        children: [
                          Icon(size: 20, Icons.location_on),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            towing.address,
                            softWrap: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Chip(
                  side: BorderSide.none,
                  label: Text(
                    towing.status,
                    style: TextStyle(color: Colors.white),
                  ),
                  labelStyle: Theme.of(context).textTheme.labelSmall,
                  padding: EdgeInsets.all(0),
                  backgroundColor: getTowingStatusColor(
                    towing.status, context
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

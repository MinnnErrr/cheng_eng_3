import 'package:cheng_eng_3/core/models/maintenance_model.dart';
import 'package:cheng_eng_3/ui/screens/customer/maintenance/maintenance_details_screen.dart';
import 'package:cheng_eng_3/ui/widgets/maintenance_listitem.dart';
import 'package:flutter/material.dart';

class MaintenanceCarousel extends StatefulWidget {
  final List<Maintenance> maintenanceList;
  const MaintenanceCarousel({super.key, required this.maintenanceList});

  @override
  State<MaintenanceCarousel> createState() => _MaintenanceCarouselState();
}

class _MaintenanceCarouselState extends State<MaintenanceCarousel> {
  int _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.maintenanceList.isEmpty) {
      return Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text('No upcoming maintenance'),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 145,
          child: PageView.builder(
            itemCount: widget.maintenanceList.length,
            controller: PageController(
              viewportFraction: 1,
            ),
            onPageChanged: (index) {
              setState(() {
                _activeIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final m = widget.maintenanceList[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: MaintenanceListItem(
                  maintenance: m,
                  tapAction: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MaintenanceDetailsScreen(maintenance: m),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.maintenanceList.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _activeIndex == index ? 24 : 8, 
              decoration: BoxDecoration(
                color: _activeIndex == index
                    ? Theme.of(context)
                          .colorScheme
                          .primary 
                    : Colors.grey.withValues(alpha: 0.5), 
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// import 'package:cheng_eng_3/core/models/order_model.dart';
// import 'package:cheng_eng_3/ui/extensions/order_extension.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class OrderDelivery extends ConsumerWidget {
//   const OrderDelivery({
//     super.key,
//     required this.firstName,
//     required this.lastName,
//     required this.addressLine1,
//     required this.addressLine2,
//     required this.city,
//     required this.country,
//     required this.dialCode,
//     required this.phoneNum,
//     required this.postcode,
//     required this.state,
//   });

//   final String firstName;
//   final String lastName;
//   final String dialCode;
//   final String phoneNum;
//   final String addressLine1;
//   final String? addressLine2;
//   final String postcode;
//   final String city;
//   final MalaysiaState state;
//   final String country;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // FORMATTING: Clean address join logic
//     // Removes empty parts so you don't get ", , "
//     final fullAddress = [
//       addressLine1,
//       addressLine2,
//       '$postcode $city',
//       '${state.label}, $country',
//     ].where((s) => s != null && s.trim().isNotEmpty).join(', ');

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surfaceContainer,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
//       ),
//       child: Column(
//         children: [
//           _buildDetailRow(
//             context,
//             'Name',
//             '$firstName $lastName',
//           ),
//           _buildDetailRow(
//             context,
//             'Phone', // Removed Duplicate
//             '$dialCode $phoneNum',
//           ),
//           _buildDetailRow(
//             context,
//             'Address',
//             fullAddress,
//             isAddress: true, // Flag to handle alignment differently
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(
//     BuildContext context,
//     String label,
//     String value, {
//     Color? color,
//     bool isAddress = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         crossAxisAlignment:
//             CrossAxisAlignment.start, // Align to top for multi-line
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // Label (Fixed width or flexible)
//           Text(
//             label,
//             style: TextStyle(
//               color: Theme.of(context).colorScheme.onSurfaceVariant,
//             ),
//           ),

//           const SizedBox(width: 20),

//           // Value (Expanded prevents overflow)
//           Expanded(
//             child: Text(
//               value,
//               textAlign: TextAlign.right, // Aligns value to the right
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 // Use Theme color for Dark Mode support
//                 color: color ?? Theme.of(context).colorScheme.onSurface,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
// import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_by_id_provider.dart';
// import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_by_vehicle_provider.dart';
// import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_count_days_provider.dart';
// import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_nearest_date_provider.dart';
// import 'package:cheng_eng_3/core/controllers/product/product_by_id_provider.dart';
// import 'package:cheng_eng_3/core/controllers/towing/customer_towings_notifier.dart';
// import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
// import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
// import 'package:cheng_eng_3/core/controllers/towing/staff_towings_notifier.dart';
// import 'package:cheng_eng_3/core/controllers/towing/towing_by_id_provider.dart';
// import 'package:cheng_eng_3/core/controllers/vehicle/customer_vehicle_notifier.dart';
// import 'package:cheng_eng_3/core/services/auth_service.dart';
// import 'package:cheng_eng_3/core/services/image_service.dart';
// import 'package:cheng_eng_3/core/services/maintenance_service.dart';
// import 'package:cheng_eng_3/core/services/profile_service.dart';
// import 'package:cheng_eng_3/core/services/towing_service.dart';
// import 'package:cheng_eng_3/core/services/vehicle_service.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final appStateResetProvider = Provider((ref) {
//   void resetAll() {
//     ref.invalidate(authProvider);
//     ref.invalidate(profileProvider);
//     ref.invalidate(customerVehicleProvider);
//     ref.invalidate(productByIdProvider);
//     ref.invalidate(maintenanceProvider);
//     ref.invalidate(maintenanceByIdProvider);
//     ref.invalidate(maintenanceByVehicleProvider);
//     ref.invalidate(maintenanceByNearestDateProvider);
//     ref.invalidate(maintenanceCountDaysProvider);
//     ref.invalidate(staffTowingsProvider);
//     ref.invalidate(customerTowingsProvider);
//     ref.invalidate(towingByIdProvider);

//     ref.invalidate(authServiceProvider);
//     ref.invalidate(profileServiceProvider);
//     ref.invalidate(vehicleServiceProvider);
//     ref.invalidate(maintenanceServiceProvider);
//     ref.invalidate(imageServiceProvider);
//     ref.invalidate(towingServiceProvider);
//   }

//   return resetAll;
// });

import 'package:cheng_eng_3/core/controllers/auth/auth_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/customer_towing_notifier.dart';
import 'package:cheng_eng_3/core/controllers/maintenance/maintenance_notifier.dart';
import 'package:cheng_eng_3/core/controllers/profile/profile_notifier.dart';
import 'package:cheng_eng_3/core/controllers/towing/staff_towing_notifier.dart';
import 'package:cheng_eng_3/core/controllers/vehicle/vehicle_notifier.dart';
import 'package:cheng_eng_3/core/services/auth_service.dart';
import 'package:cheng_eng_3/core/services/image_service.dart';
import 'package:cheng_eng_3/core/services/maintenance_service.dart';
import 'package:cheng_eng_3/core/services/profile_service.dart';
import 'package:cheng_eng_3/core/services/towing_service.dart';
import 'package:cheng_eng_3/core/services/vehicle_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appStateResetProvider = Provider((ref) {
  void resetAll() {
    ref.invalidate(authProvider);
    ref.invalidate(profileProvider);
    ref.invalidate(vehicleProvider);
    ref.invalidate(vehicleByIdProvider);
    ref.invalidate(maintenanceProvider);
    ref.invalidate(maintenanceByIdProvider);
    ref.invalidate(maintenanceByVehicleProvider);
    ref.invalidate(maintenanceByNearestDateProvider);
    ref.invalidate(maintenanceCountDaysProvider);
    ref.invalidate(staffTowingProvider);
    ref.invalidate(staffTowingByIdProvider);
    ref.invalidate(customerTowingProvider);
    ref.invalidate(customerTowingByIdProvider);

    ref.invalidate(authServiceProvider);
    ref.invalidate(profileServiceProvider);
    ref.invalidate(vehicleServiceProvider);
    ref.invalidate(maintenanceServiceProvider);
    ref.invalidate(imageServiceProvider);
    ref.invalidate(towingServiceProvider);
  }

  return resetAll;
});

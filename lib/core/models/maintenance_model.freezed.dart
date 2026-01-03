// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'maintenance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MaintenanceList {

 List<Maintenance> get maintenances;
/// Create a copy of MaintenanceList
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceListCopyWith<MaintenanceList> get copyWith => _$MaintenanceListCopyWithImpl<MaintenanceList>(this as MaintenanceList, _$identity);

  /// Serializes this MaintenanceList to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceList&&const DeepCollectionEquality().equals(other.maintenances, maintenances));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(maintenances));

@override
String toString() {
  return 'MaintenanceList(maintenances: $maintenances)';
}


}

/// @nodoc
abstract mixin class $MaintenanceListCopyWith<$Res>  {
  factory $MaintenanceListCopyWith(MaintenanceList value, $Res Function(MaintenanceList) _then) = _$MaintenanceListCopyWithImpl;
@useResult
$Res call({
 List<Maintenance> maintenances
});




}
/// @nodoc
class _$MaintenanceListCopyWithImpl<$Res>
    implements $MaintenanceListCopyWith<$Res> {
  _$MaintenanceListCopyWithImpl(this._self, this._then);

  final MaintenanceList _self;
  final $Res Function(MaintenanceList) _then;

/// Create a copy of MaintenanceList
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maintenances = null,}) {
  return _then(_self.copyWith(
maintenances: null == maintenances ? _self.maintenances : maintenances // ignore: cast_nullable_to_non_nullable
as List<Maintenance>,
  ));
}

}


/// Adds pattern-matching-related methods to [MaintenanceList].
extension MaintenanceListPatterns on MaintenanceList {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MaintenanceList value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MaintenanceList() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MaintenanceList value)  $default,){
final _that = this;
switch (_that) {
case _MaintenanceList():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MaintenanceList value)?  $default,){
final _that = this;
switch (_that) {
case _MaintenanceList() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Maintenance> maintenances)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MaintenanceList() when $default != null:
return $default(_that.maintenances);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Maintenance> maintenances)  $default,) {final _that = this;
switch (_that) {
case _MaintenanceList():
return $default(_that.maintenances);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Maintenance> maintenances)?  $default,) {final _that = this;
switch (_that) {
case _MaintenanceList() when $default != null:
return $default(_that.maintenances);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MaintenanceList implements MaintenanceList {
  const _MaintenanceList({required final  List<Maintenance> maintenances}): _maintenances = maintenances;
  factory _MaintenanceList.fromJson(Map<String, dynamic> json) => _$MaintenanceListFromJson(json);

 final  List<Maintenance> _maintenances;
@override List<Maintenance> get maintenances {
  if (_maintenances is EqualUnmodifiableListView) return _maintenances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_maintenances);
}


/// Create a copy of MaintenanceList
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceListCopyWith<_MaintenanceList> get copyWith => __$MaintenanceListCopyWithImpl<_MaintenanceList>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceListToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MaintenanceList&&const DeepCollectionEquality().equals(other._maintenances, _maintenances));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_maintenances));

@override
String toString() {
  return 'MaintenanceList(maintenances: $maintenances)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceListCopyWith<$Res> implements $MaintenanceListCopyWith<$Res> {
  factory _$MaintenanceListCopyWith(_MaintenanceList value, $Res Function(_MaintenanceList) _then) = __$MaintenanceListCopyWithImpl;
@override @useResult
$Res call({
 List<Maintenance> maintenances
});




}
/// @nodoc
class __$MaintenanceListCopyWithImpl<$Res>
    implements _$MaintenanceListCopyWith<$Res> {
  __$MaintenanceListCopyWithImpl(this._self, this._then);

  final _MaintenanceList _self;
  final $Res Function(_MaintenanceList) _then;

/// Create a copy of MaintenanceList
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maintenances = null,}) {
  return _then(_MaintenanceList(
maintenances: null == maintenances ? _self._maintenances : maintenances // ignore: cast_nullable_to_non_nullable
as List<Maintenance>,
  ));
}


}


/// @nodoc
mixin _$Maintenance {

 String get id; String get title; String? get description; String? get remarks; DateTime get currentServDate; double? get currentServDistance; DateTime get nextServDate; double? get nextServDistance; bool get isComplete; DateTime? get deletedAt; String get vehicleId; DateTime? get updatedAt;
/// Create a copy of Maintenance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceCopyWith<Maintenance> get copyWith => _$MaintenanceCopyWithImpl<Maintenance>(this as Maintenance, _$identity);

  /// Serializes this Maintenance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Maintenance&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.currentServDate, currentServDate) || other.currentServDate == currentServDate)&&(identical(other.currentServDistance, currentServDistance) || other.currentServDistance == currentServDistance)&&(identical(other.nextServDate, nextServDate) || other.nextServDate == nextServDate)&&(identical(other.nextServDistance, nextServDistance) || other.nextServDistance == nextServDistance)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,remarks,currentServDate,currentServDistance,nextServDate,nextServDistance,isComplete,deletedAt,vehicleId,updatedAt);

@override
String toString() {
  return 'Maintenance(id: $id, title: $title, description: $description, remarks: $remarks, currentServDate: $currentServDate, currentServDistance: $currentServDistance, nextServDate: $nextServDate, nextServDistance: $nextServDistance, isComplete: $isComplete, deletedAt: $deletedAt, vehicleId: $vehicleId, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MaintenanceCopyWith<$Res>  {
  factory $MaintenanceCopyWith(Maintenance value, $Res Function(Maintenance) _then) = _$MaintenanceCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description, String? remarks, DateTime currentServDate, double? currentServDistance, DateTime nextServDate, double? nextServDistance, bool isComplete, DateTime? deletedAt, String vehicleId, DateTime? updatedAt
});




}
/// @nodoc
class _$MaintenanceCopyWithImpl<$Res>
    implements $MaintenanceCopyWith<$Res> {
  _$MaintenanceCopyWithImpl(this._self, this._then);

  final Maintenance _self;
  final $Res Function(Maintenance) _then;

/// Create a copy of Maintenance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? remarks = freezed,Object? currentServDate = null,Object? currentServDistance = freezed,Object? nextServDate = null,Object? nextServDistance = freezed,Object? isComplete = null,Object? deletedAt = freezed,Object? vehicleId = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,currentServDate: null == currentServDate ? _self.currentServDate : currentServDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentServDistance: freezed == currentServDistance ? _self.currentServDistance : currentServDistance // ignore: cast_nullable_to_non_nullable
as double?,nextServDate: null == nextServDate ? _self.nextServDate : nextServDate // ignore: cast_nullable_to_non_nullable
as DateTime,nextServDistance: freezed == nextServDistance ? _self.nextServDistance : nextServDistance // ignore: cast_nullable_to_non_nullable
as double?,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Maintenance].
extension MaintenancePatterns on Maintenance {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Maintenance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Maintenance() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Maintenance value)  $default,){
final _that = this;
switch (_that) {
case _Maintenance():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Maintenance value)?  $default,){
final _that = this;
switch (_that) {
case _Maintenance() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String? remarks,  DateTime currentServDate,  double? currentServDistance,  DateTime nextServDate,  double? nextServDistance,  bool isComplete,  DateTime? deletedAt,  String vehicleId,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Maintenance() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.remarks,_that.currentServDate,_that.currentServDistance,_that.nextServDate,_that.nextServDistance,_that.isComplete,_that.deletedAt,_that.vehicleId,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description,  String? remarks,  DateTime currentServDate,  double? currentServDistance,  DateTime nextServDate,  double? nextServDistance,  bool isComplete,  DateTime? deletedAt,  String vehicleId,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Maintenance():
return $default(_that.id,_that.title,_that.description,_that.remarks,_that.currentServDate,_that.currentServDistance,_that.nextServDate,_that.nextServDistance,_that.isComplete,_that.deletedAt,_that.vehicleId,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description,  String? remarks,  DateTime currentServDate,  double? currentServDistance,  DateTime nextServDate,  double? nextServDistance,  bool isComplete,  DateTime? deletedAt,  String vehicleId,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Maintenance() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.remarks,_that.currentServDate,_that.currentServDistance,_that.nextServDate,_that.nextServDistance,_that.isComplete,_that.deletedAt,_that.vehicleId,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Maintenance implements Maintenance {
  const _Maintenance({required this.id, required this.title, this.description, this.remarks, required this.currentServDate, required this.currentServDistance, required this.nextServDate, required this.nextServDistance, required this.isComplete, this.deletedAt, required this.vehicleId, this.updatedAt});
  factory _Maintenance.fromJson(Map<String, dynamic> json) => _$MaintenanceFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override final  String? remarks;
@override final  DateTime currentServDate;
@override final  double? currentServDistance;
@override final  DateTime nextServDate;
@override final  double? nextServDistance;
@override final  bool isComplete;
@override final  DateTime? deletedAt;
@override final  String vehicleId;
@override final  DateTime? updatedAt;

/// Create a copy of Maintenance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MaintenanceCopyWith<_Maintenance> get copyWith => __$MaintenanceCopyWithImpl<_Maintenance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MaintenanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Maintenance&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.remarks, remarks) || other.remarks == remarks)&&(identical(other.currentServDate, currentServDate) || other.currentServDate == currentServDate)&&(identical(other.currentServDistance, currentServDistance) || other.currentServDistance == currentServDistance)&&(identical(other.nextServDate, nextServDate) || other.nextServDate == nextServDate)&&(identical(other.nextServDistance, nextServDistance) || other.nextServDistance == nextServDistance)&&(identical(other.isComplete, isComplete) || other.isComplete == isComplete)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.vehicleId, vehicleId) || other.vehicleId == vehicleId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,remarks,currentServDate,currentServDistance,nextServDate,nextServDistance,isComplete,deletedAt,vehicleId,updatedAt);

@override
String toString() {
  return 'Maintenance(id: $id, title: $title, description: $description, remarks: $remarks, currentServDate: $currentServDate, currentServDistance: $currentServDistance, nextServDate: $nextServDate, nextServDistance: $nextServDistance, isComplete: $isComplete, deletedAt: $deletedAt, vehicleId: $vehicleId, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MaintenanceCopyWith<$Res> implements $MaintenanceCopyWith<$Res> {
  factory _$MaintenanceCopyWith(_Maintenance value, $Res Function(_Maintenance) _then) = __$MaintenanceCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description, String? remarks, DateTime currentServDate, double? currentServDistance, DateTime nextServDate, double? nextServDistance, bool isComplete, DateTime? deletedAt, String vehicleId, DateTime? updatedAt
});




}
/// @nodoc
class __$MaintenanceCopyWithImpl<$Res>
    implements _$MaintenanceCopyWith<$Res> {
  __$MaintenanceCopyWithImpl(this._self, this._then);

  final _Maintenance _self;
  final $Res Function(_Maintenance) _then;

/// Create a copy of Maintenance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? remarks = freezed,Object? currentServDate = null,Object? currentServDistance = freezed,Object? nextServDate = null,Object? nextServDistance = freezed,Object? isComplete = null,Object? deletedAt = freezed,Object? vehicleId = null,Object? updatedAt = freezed,}) {
  return _then(_Maintenance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,remarks: freezed == remarks ? _self.remarks : remarks // ignore: cast_nullable_to_non_nullable
as String?,currentServDate: null == currentServDate ? _self.currentServDate : currentServDate // ignore: cast_nullable_to_non_nullable
as DateTime,currentServDistance: freezed == currentServDistance ? _self.currentServDistance : currentServDistance // ignore: cast_nullable_to_non_nullable
as double?,nextServDate: null == nextServDate ? _self.nextServDate : nextServDate // ignore: cast_nullable_to_non_nullable
as DateTime,nextServDistance: freezed == nextServDistance ? _self.nextServDistance : nextServDistance // ignore: cast_nullable_to_non_nullable
as double?,isComplete: null == isComplete ? _self.isComplete : isComplete // ignore: cast_nullable_to_non_nullable
as bool,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,vehicleId: null == vehicleId ? _self.vehicleId : vehicleId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

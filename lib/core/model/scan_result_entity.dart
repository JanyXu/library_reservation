import 'package:library_reservation/generated/json/base/json_convert_content.dart';class ScanResultEntity with JsonConvert<ScanResultEntity> {	String? userName;	String? certNo;	String? certType;	String? phone;	int? healthStatus;	int? vaccinationStatus;	int? vaccinationPlusStatus;	int? travelStatus;	String? lastRNATime;	int? lastRNAResult;}
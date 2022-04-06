import 'package:library_reservation/core/model/scan_result_entity.dart';scanResultEntityFromJson(ScanResultEntity data, Map<String, dynamic> json) {	if (json['userName'] != null) {		data.userName = json['userName'].toString();	}	if (json['certNo'] != null) {		data.certNo = json['certNo'].toString();	}	if (json['certType'] != null) {		data.certType = json['certType'].toString();	}	if (json['phone'] != null) {		data.phone = json['phone'].toString();	}	if (json['healthStatus'] != null) {		data.healthStatus = json['healthStatus'] is String				? int.tryParse(json['healthStatus'])				: json['healthStatus'].toInt();	}	if (json['vaccinationStatus'] != null) {		data.vaccinationStatus = json['vaccinationStatus'] is String				? int.tryParse(json['vaccinationStatus'])				: json['vaccinationStatus'].toInt();	}	if (json['vaccinationPlusStatus'] != null) {		data.vaccinationPlusStatus = json['vaccinationPlusStatus'] is String				? int.tryParse(json['vaccinationPlusStatus'])				: json['vaccinationPlusStatus'].toInt();	}	if (json['travelStatus'] != null) {		data.travelStatus = json['travelStatus'] is String				? int.tryParse(json['travelStatus'])				: json['travelStatus'].toInt();	}	if (json['lastRNATime'] != null) {		data.lastRNATime = json['lastRNATime'].toString();	}	if (json['lastRNAResult'] != null) {		data.lastRNAResult = json['lastRNAResult'] is String				? int.tryParse(json['lastRNAResult'])				: json['lastRNAResult'].toInt();	}	return data;}Map<String, dynamic> scanResultEntityToJson(ScanResultEntity entity) {	final Map<String, dynamic> data = new Map<String, dynamic>();	data['userName'] = entity.userName;	data['certNo'] = entity.certNo;	data['certType'] = entity.certType;	data['phone'] = entity.phone;	data['healthStatus'] = entity.healthStatus;	data['vaccinationStatus'] = entity.vaccinationStatus;	data['vaccinationPlusStatus'] = entity.vaccinationPlusStatus;	data['travelStatus'] = entity.travelStatus;	data['lastRNATime'] = entity.lastRNATime;	data['lastRNAResult'] = entity.lastRNAResult;	return data;}
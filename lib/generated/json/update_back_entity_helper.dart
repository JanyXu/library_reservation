import 'package:library_reservation/core/model/update_back_entity.dart';updateBackEntityFromJson(UpdateBackEntity data, Map<String, dynamic> json) {	if (json['success'] != null) {		data.success = json['success'].toString();	}	if (json['token'] != null) {		data.token = json['token'].toString();	}	if (json['id'] != null) {		data.id = json['id'].toString();	}	return data;}Map<String, dynamic> updateBackEntityToJson(UpdateBackEntity entity) {	final Map<String, dynamic> data = new Map<String, dynamic>();	data['success'] = entity.success;	data['token'] = entity.token;	data['id'] = entity.id;	return data;}
import 'package:shared_preferences/shared_preferences.dart';import 'package:library_reservation/core/model/dic_data_value_entity.dart';import 'dart:convert' as convert;class ManagerUtils{  static ManagerUtils get instance => _getInstance();  static ManagerUtils? _managerUtils;  SharedPreferences? _prefs;  static ManagerUtils _getInstance() {    if (_managerUtils == null) {      _managerUtils = new ManagerUtils._init();    }    return _managerUtils!;  }  ManagerUtils._init(){    if(_prefs==null){      _initSharedPreferences();    }  }  init(){    _initSharedPreferences();  }  Future<void> _initSharedPreferences() async {    _prefs = await SharedPreferences.getInstance();  }  saveSeriesNumber(String? number){    if (number == null) return;    _prefs?.setString("series_number", number);  }  String? getSeriesNumber(){    return _prefs?.getString('series_number');  }  saveHttpToken(String? token){    if(token == null) return;    _prefs?.setString("http_token", token);  }  String? getHttpToken(){    return _prefs?.getString('http_token');  }  saveRate(int? rate){    if (rate == null) return;    _prefs?.setInt('rate', rate);  }  int? getRate(){    return _prefs?.getInt('rate');  }  saveDicVersion(String? version,String? dicCode){    if(version == null || dicCode == null) return;    _prefs?.setString(dicCode, version);  }  String? getDicVersion(String? dicCode){    if(dicCode == null) return '';    return _prefs?.getString(dicCode);  }  saveDicValue(String? key,String? value){    if(key == null || value == null) return;    _prefs?.setString(key, value);  }  String? getDicValue(String? key){    if(key == null) return '';    return _prefs?.getString(key);  }  DicDataValueEntity? getDicValueData(String? dicValue){    if (dicValue == null) return null;    Map<String, dynamic> user = convert.jsonDecode(dicValue);    DicDataValueEntity dataValueEntity = DicDataValueEntity().fromJson(user);    return dataValueEntity;  }  void clear(){    _prefs?.clear();  }  T? get<T> (String key) {    var result = _prefs?.get(key);    if (result != null) {      return result as T;    }    return null;  }}
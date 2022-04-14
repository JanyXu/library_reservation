import 'dart:ui';import 'package:library_reservation/core/model/dic_data_entity.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:shared_preferences/shared_preferences.dart';import 'package:library_reservation/core/model/dic_data_value_entity.dart';import 'dart:convert' as convert;import 'assets.dart';import 'common.dart';class ManagerUtils{  static ManagerUtils get instance => _getInstance();  static ManagerUtils? _managerUtils;  Map<String, dynamic>? deviceMap;  String? deviceId;  double latitude = 0.1;  double longitude = 0.1;  SharedPreferences? _prefs;  static ManagerUtils _getInstance() {    if (_managerUtils == null) {      _managerUtils = new ManagerUtils._init();    }    return _managerUtils!;  }  ManagerUtils._init(){    if(_prefs==null){      _initSharedPreferences();    }  }  init(){    _initSharedPreferences();  }  Future<void> _initSharedPreferences() async {    _prefs = await SharedPreferences.getInstance();  }  saveSeriesNumber(String? number){    if (number == null) return;    _prefs?.setString("series_number", number);  }  String? getSeriesNumber(){    String? seriesNumber = _prefs?.getString('series_number');    return seriesNumber == null ? '':seriesNumber;  }  saveSeriesNumberKey(String? number){    if (number == null) return;    _prefs?.setString("series_number_key", number);  }  String? getSeriesNumberKey(){    String? seriesNumber = _prefs?.getString('series_number_key');    return seriesNumber == null ? '':seriesNumber;  }  saveHttpToken(String? token){    if(token == null) return;    _prefs?.setString("http_token", token);  }  String? getHttpToken(){    return _prefs?.getString('http_token');  }  saveRate(int? rate){    if (rate == null) return;    _prefs?.setInt('rate', rate);  }  int getRate(){    int? rate = _prefs?.getInt('rate');    return rate == null ? 5:rate;  }  saveDicVersion(String? version,String? dicCode){    if(version == null || dicCode == null) return;    _prefs?.setString(dicCode, version);  }  String? getDicVersion(String? dicCode){    if(dicCode == null) return '';    return _prefs?.getString(dicCode) == null ? '':_prefs?.getString(dicCode);  }  saveDicValue(String? key,String? value){    if(key == null || value == null) return;    _prefs?.setString(key, value);  }  String? getDicValue(String? key){    if(key == null) return '';    return _prefs?.getString(key) == null ? '':_prefs?.getString(key);  }  DicDataValueEntity? getDicData(){    String version = ManagerUtils.instance.getDicVersion(Common.dic_code)!;    String dicValue = ManagerUtils.instance.getDicValue('${Common.dic_code}$version')!;    return ManagerUtils.instance.getDicValueData(dicValue);  }  DicDataValueEntity? getDicValueData(String? dicValue){    if (dicValue == null) return null;    Map<String, dynamic> user = convert.jsonDecode(dicValue);    DicDataValueEntity dataValueEntity = DicDataValueEntity().fromJson(user);    return dataValueEntity;  }  DicDataValueScanCodeResultCqqrcode? getResultCode(){    if (ManagerUtils.instance.getDicData() ==  null) return null;    return ManagerUtils.instance.getDicData()!.scanCodeResult!.cqqrcode;  }  void clear(){    _prefs?.clear();  }  T? get<T> (String key) {    var result = _prefs?.get(key);    if (result != null) {      return result as T;    }    return null;  }}class Utils{  //获取fill-in-key-text  static String? getSettingUrl(){    return ManagerUtils.instance.getDicData()!.settingUrl;  }  //获取fill-in-key-text  static String? getFillInKeyText(){    return ManagerUtils.instance.getDicData()!.fillInKeyText;  }  //获取notice-text  static String? getNoticeText(){    return ManagerUtils.instance.getDicData()!.noticeText;  }  //获取扫码声音  static String? getScanCodeSound(){    return ManagerUtils.instance.getDicData()!.scanCodeSound;  }  // 疫苗接种信息  static String? getVaccinationStatus(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    print('vaccinationStatusDic ==== ${ManagerUtils.instance.getResultCode()!}');    return ManagerUtils.instance.getResultCode()!.vaccinationStatus![key];  }  // 加强针接种信息  static String? getVaccinationPlusStatus(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    return ManagerUtils.instance.getResultCode()!.vaccinationPlusStatus![key];  }  // 核酸检测信息  static String? getLastRnaResult(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    if (key == '99') {      String lastRnaResult = ManagerUtils.instance.getResultCode()!.lastRnaResult![key]!;      return lastRnaResult.substring(0,5);    }    return ManagerUtils.instance.getResultCode()!.lastRnaResult![key];  }  // 最后检测时间  static String? getLastRnaResultTime(String? key,String? time){    if (key == null) return '';    if (key == '99'){      String lastRnaResult = ManagerUtils.instance.getResultCode()!.lastRnaResult![key]!;      return lastRnaResult.substring(5,lastRnaResult.length);    }    // if (time == null) return '';    // DateTime timeFormat = DateTime.fromMillisecondsSinceEpoch(int.parse((time==null)?'':time));    // int year = timeFormat.year;    // int month = timeFormat.month;    // int day = timeFormat.day;    // return '$year-$month-$day';    return "";  }  // 核酸检测信息-颜色  static Color getLastRnaResultColor(int? result){    if (result == null) return ColorConfig.colorFFFFFF;    if (result == 1) return ColorConfig.color0BFF00;    if (result == 2) return ColorConfig.colorFF2F24;    return ColorConfig.colorFFFFFF;  }  // 健康状态信息-图片  static String? getHealthStatusImage(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    return ManagerUtils.instance.getResultCode()!.healthStatus![key]['image'];  }  //  行程核验信息-文本  static String? getTravelStatusText(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    return ManagerUtils.instance.getResultCode()!.travelStatus![key]['text'];  }  //  行程核验信息-图片  static String? getTravelStatusImage(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    return ManagerUtils.instance.getResultCode()!.travelStatus![key]['image'];  }  //  汇总信息-文本  static String? getTotalResultText(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    return ManagerUtils.instance.getResultCode()!.totalResult![key]['text'];  }  //  汇总信息-语音  static String? getTotalResultVoice(String? key){    if (key == null) return '';    if (ManagerUtils.instance.getResultCode() == null) return '';    return ManagerUtils.instance.getResultCode()!.totalResult![key]['voice'];  }  //  汇总信息-图片-左  static String getTotalResultLeftImage(String key){    if (key == 'safe') return Assets.safe_left;    if (key == 'risky') return Assets.risky_left;    return Assets.other_left;  }  //  汇总信息-图片-右  static String getTotalResultRightImage(String key){    if (key == 'safe') return Assets.safe_right;    if (key == 'risky') return Assets.risky_right;    return Assets.other_right;  }  // 核酸检测信息-颜色  static Color getTotalResultColor(String key){    if (key == 'safe') return ColorConfig.color0BFF00;    if (key == 'risky') return ColorConfig.colorFF2F24;    return ColorConfig.colorFFFFFF;  }}
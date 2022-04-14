import 'dart:convert';import 'package:flutter/material.dart';import 'package:flutter/services.dart';import 'package:library_reservation/core/service/utils/assets.dart';import 'package:library_reservation/core/model/scan_result_entity.dart';import 'package:library_reservation/core/service/utils/common.dart';import 'package:library_reservation/core/service/utils/manager_utils.dart';import 'data_code.dart';import 'data_common.dart';class SCDialogsDataWidget extends StatelessWidget {  final bool isHorizontal;  final ScanResultEntity? scanResultEntity;  const SCDialogsDataWidget({    Key? key,    this.isHorizontal = false,    this.scanResultEntity}) : super(key: key);  static Future<ScanResultEntity> _getData() async {    final jsonStr = await rootBundle.loadString('assets/voice/Category.json');    final resData = jsonDecode(jsonStr);    final data = ScanResultEntity().fromJson(resData);    return data;  }  @override  Widget build(BuildContext context) {    print('device========${ManagerUtils.instance.deviceMap}');    return Center(        child: Stack(          children: [            _buildGroundWidget(isHorizontal),            isHorizontal ? _buildHorizontalWidget(scanResultEntity!):_buildVerticalWidget(scanResultEntity!)          ],        )    );    // return FutureBuilder<ScanResultEntity>(    //   future: _getData(),    //   builder: (ctx , snapshot){    //     if (!snapshot.hasData) return SizedBox(height: 0);    //     final resultEntity = snapshot.data!;    //     return Center(    //         child: Stack(    //           children: [    //             _buildGroundWidget(isHorizontal),    //             isHorizontal ? _buildHorizontalWidget(resultEntity):_buildVerticalWidget(resultEntity)    //           ],    //         )    //     );    //   },    // );  }  Widget _buildGroundWidget(bool isHorizontal){    return Image.asset(      isHorizontal ? Assets.bg_horizontal : Assets.bg_vertical,      width: isHorizontal ? 607 : 322,      height: isHorizontal ? 257 : 574,      fit: BoxFit.cover,    );  }  Widget _buildHorizontalWidget(ScanResultEntity? resultEntity){    if (ManagerUtils.instance.getDicVersion(Common.dic_code) == null){      return Container();    }    return Row(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [        SCDialogsDataCodeWidget(isHorizontal: true,resultEntity: resultEntity,),        Column(          children: _buildCommonWidget(resultEntity)        )      ],    );  }  Widget _buildVerticalWidget(ScanResultEntity? resultEntity){    return Column(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [        SCDialogsDataCodeWidget(resultEntity: resultEntity),        Row(          children: _buildCommonWidget(resultEntity)        )      ],    );  }  List<Widget> _buildCommonWidget(ScanResultEntity? resultEntity){    String? time = resultEntity?.lastRNATime!;    DateTime timeFormat = DateTime.fromMillisecondsSinceEpoch(int.parse((time==null)?'':time));    int year = timeFormat.year;    int month = timeFormat.month;    int day = timeFormat.day;    // int hour = timeFormat.hour;    // int minite = timeFormat.minute;    // int second = timeFormat.second;    return [      SCDialogsDataCommonWidget(        title: '新冠疫苗',        imageAsset: Assets.vaccine,        name:  Utils.getVaccinationStatus(resultEntity!.vaccinationStatus.toString()),        subName: Utils.getVaccinationPlusStatus(resultEntity.vaccinationPlusStatus.toString()),      ),      SCDialogsDataCommonWidget(        title: '核酸检测',        imageAsset: Assets.detection,        name: Utils.getLastRnaResult(resultEntity.lastRNAResult.toString()),        color: Utils.getLastRnaResultColor(resultEntity.lastRNAResult),        // subName: resultEntity.lastRNATime,        subName: Utils.getLastRnaResultTime(resultEntity.lastRNAResult.toString(),            "$year:$month:$day")        //  subName: "2022-04-11"      )    ];  }}
import 'package:flutter/material.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:library_reservation/core/service/utils/assets.dart';import 'package:library_reservation/core/model/scan_result_entity.dart';import 'package:library_reservation/core/service/utils/manager_utils.dart';import 'package:library_reservation/core/model/dic_data_value_entity.dart';import 'data_code.dart';import 'data_common.dart';class SCDialogsDataWidget extends StatelessWidget {  final bool isHorizontal;  final ScanResultEntity? resultEntity;  const SCDialogsDataWidget({    Key? key,    this.resultEntity,    this.isHorizontal = false}) : super(key: key);  @override  Widget build(BuildContext context) {    print('getDicVersion =============${ManagerUtils.instance.getDicVersion("ScanCodeAssistantExplain")}');    print('getDicValue===========${ManagerUtils.instance.getDicData()!.scanCodeResult!.cqqrcode!.lastRnaResult}');    return Center(      child: Stack(        children: [          _buildGroundWidget(isHorizontal),          isHorizontal ? _buildHorizontalWidget():_buildVerticalWidget()        ],      )    );  }  Widget _buildGroundWidget(bool isHorizontal){    return Image.asset(      isHorizontal ? Assets.bg_horizontal : Assets.bg_vertical,      width: isHorizontal ? 607 : 322,      height: isHorizontal ? 257 : 574,      fit: BoxFit.cover,    );  }  Widget _buildHorizontalWidget(){    if (ManagerUtils.instance.getDicVersion("ScanCodeAssistantExplain961266405003182080") == null){      return Container();    }    return Row(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [         SCDialogsDataCodeWidget(isHorizontal: true),        Column(          children: _buildCommonWidget()        )      ],    );  }  Widget _buildVerticalWidget(){    if (ManagerUtils.instance.getDicVersion("ScanCodeAssistantExplain961266405003182080") == null){      return Container();    }    return Column(      mainAxisAlignment: MainAxisAlignment.spaceBetween,      children: [        SCDialogsDataCodeWidget(),        Row(          children: _buildCommonWidget()        )      ],    );  }  List<Widget> _buildCommonWidget(){    return [      SCDialogsDataCommonWidget(        title: '新冠疫苗',        imageAsset: Assets.vaccine,        name:  ManagerUtils.instance.getVaccinationStatus('${resultEntity!.vaccinationStatus}'),        subName: ManagerUtils.instance.getVaccinationPlusStatus('${resultEntity!.vaccinationPlusStatus}'),      ),      SCDialogsDataCommonWidget(        title: '核酸检测',        imageAsset: Assets.detection,        name: ManagerUtils.instance.getLastRnaResult('${resultEntity!.lastRNAResult}'),        color: ManagerUtils.instance.getLastRnaResultColor(resultEntity!.lastRNAResult),        subName: resultEntity!.lastRNATime,      )    ];  }}
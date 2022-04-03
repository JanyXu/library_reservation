import 'package:flutter/material.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:library_reservation/core/service/utils/assets.dart';import 'package:library_reservation/core/service/utils/common_widget.dart';//二维码模块class SCDialogsDataCodeWidget extends StatelessWidget {  final bool isHorizontal;  const SCDialogsDataCodeWidget({Key? key,this.isHorizontal = false}) : super(key: key);  @override  Widget build(BuildContext context) {    return Container(      width: isHorizontal ? 446 : double.infinity,      height: isHorizontal ? double.infinity : 431,      padding: EdgeInsets.all(25),      child: isHorizontal ? _buildHorizontalWidget():_buildVerticalWidget()    );  }  Widget _buildHorizontalWidget(){    return Column(      children: [        SizedBox(height: 3),        _buildMarkWidget(),        SizedBox(height: 14),        Container(          height: 151,          width: double.infinity,          child:Row(            children: [              _buildQRCodeWidget(),              SizedBox(width: 21),              Container(                width: 188,                height: 151,                child: Column(                  children: [                    _buildInformationWidget(),                    SizedBox(height: 12,),                    Divider(                      height: 0.5,                      color: ColorConfig.colorFFFFFF,                    ),                    SizedBox(height: 12,),                    _buildTravelWidget()                  ],                )              )            ],          )        )      ],    );  }  Widget _buildVerticalWidget(){    return Column(      children: [        SizedBox(height: 10),        _buildMarkWidget(),        SizedBox(height: 20),        _buildQRCodeWidget(),        SizedBox(height: 15),        _buildInformationWidget(),        SizedBox(height: 15),        Divider(          height: 0.5,          color: ColorConfig.colorFFFFFF,        ),        SizedBox(height: 15),        _buildTravelWidget()      ],    );  }  //1.风险文案  Widget _buildMarkWidget(){    return Container(      alignment: Alignment.center,      height: 25,      child: Image.asset(        Assets.mark_yellow,      ),    );  }  //2.二维码  Widget _buildQRCodeWidget(){    return Container(      height: 151,      child: Row(        children: [          SizedBox(width: isHorizontal ? 3 : 30),          CommonWidget.buildCachedNetworkImage(            'https://cdn-oss.bigdatacq.com/10000003/959486248906854400.png',            width: 184,            height: 151,            errorImg: Assets.normal_code,            fit: BoxFit.cover,          ),        ],      ),    );  }  //3.基本信息  Widget _buildInformationWidget(){    return Container(      padding: EdgeInsets.only(left: 3),      width: double.infinity,      height: 72,      child: Column(        mainAxisAlignment: MainAxisAlignment.spaceBetween,        crossAxisAlignment: CrossAxisAlignment.start,        children: [          Text('人员姓名：**国',style: TextStyleConfig.textFFFFFF_12),          Text('证件号码：*************1234',style: TextStyleConfig.textFFFFFF_12),          Text('扫码时间：2021-03-28 19:28:56',style: TextStyleConfig.textFFFFFF_12)        ],      ),    );  }  //4.行程信息  Widget _buildTravelWidget(){    return Container(      padding: EdgeInsets.only(left: 2),      width: double.infinity,      height: 51,      child: Row(        crossAxisAlignment: CrossAxisAlignment.center,        children: [          Image.asset(            Assets.travel_green,          ),          SizedBox(width: 12,),          Container(            alignment: Alignment.centerLeft,            width: isHorizontal ? 120 : 192,            height: double.infinity,            child: Text(              '*14天内到达或途经过存在中风险或高风险地区的城市',              maxLines: 3,              style: TextStyleConfig.textFFFFFF_12.copyWith(height: 1.5),            ),          )        ],      ),    );  }}
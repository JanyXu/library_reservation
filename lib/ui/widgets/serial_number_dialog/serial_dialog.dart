import 'package:dio/dio.dart';import 'package:flutter/material.dart';import 'package:fluttertoast/fluttertoast.dart';import 'package:library_reservation/core/service/config/api_config.dart';import 'package:library_reservation/core/service/config/color_config.dart';import 'package:library_reservation/core/service/network/network.dart';import 'package:library_reservation/core/service/utils/assets.dart';import 'package:library_reservation/core/service/utils/manager_utils.dart';class SCSerialDialogWidget extends StatefulWidget {  const SCSerialDialogWidget({Key? key}) : super(key: key);  @override  State<SCSerialDialogWidget> createState() => _SCSerialDialogWidgetState();}class _SCSerialDialogWidgetState extends State<SCSerialDialogWidget> {  TextEditingController? _controller;  @override  void initState() {    // TODO: implement initState    super.initState();    _controller = TextEditingController();  }  @override  Widget build(BuildContext context) {    return Scaffold(        backgroundColor: ColorConfig.colorB3000000,        body: Center(          child: Container(            width: 321,            height: 250,            alignment: Alignment.center,            child: Stack(              children:[                Image.asset(                  Assets.serial_bg,                  fit: BoxFit.cover,                  width: 321,                  height: 250,                ),                _buildContent(),              ],          ),        ))    );  }  Widget _buildContent(){    return Container(      // color: Colors.red,      padding: EdgeInsets.all(23),      width: double.infinity,      child: Column(        children: [          SizedBox(height: 3,),          Container(              child: Text('填写序列号',style: TextStyleConfig.textFFFFFF_16,),            height: 20,          ),          SizedBox(height: 15,),          Image.asset(            Assets.serial_space,            fit: BoxFit.cover,            width: double.infinity,            height: 2,          ),          SizedBox(height: 16,),          Container(            width: double.infinity,            height: 17,            alignment: Alignment.centerLeft,            child:  Text(Utils.getFillInKeyText()!,style: TextStyleConfig.textFFFFFF_12,),          ),          SizedBox(height: 12,),          Container(            width: double.infinity,            height: 40,            padding: EdgeInsets.only(left: 10,right: 10),            decoration: BoxDecoration(              border: Border.all(color: Color(0xffA5A5E3)),              borderRadius: BorderRadius.circular(5),            ),            child: TextField(              controller: _controller,              textAlign: TextAlign.start,              style: TextStyleConfig.textFFFFFF_12,              decoration: InputDecoration(                labelText: _controller?.text.length == 0 ? '请填入序列':'',                labelStyle: TextStyleConfig.textFFFFFF_12.copyWith(color: ColorConfig.color7676AD),                border: InputBorder.none,              ),              onChanged: (value){                setState(() {                });              },            ),          ),          SizedBox(height: 24,),          Image.asset(            Assets.serial_space,            fit: BoxFit.cover,            width: double.infinity,            height: 2,          ),          SizedBox(height: 13,),          Container(            width: double.infinity,            height: 40,            child: Row(              mainAxisAlignment: MainAxisAlignment.spaceBetween,              children: [                GestureDetector(                  child: Container(                    height: double.infinity,                    width: 130,                    child: Stack(                      alignment: Alignment.center,                      children: [                        Image.asset(                          Assets.serial_cancel,                          fit: BoxFit.cover,                          width: double.infinity,                          height: double.infinity,                        ),                        Text('取消',style: TextStyleConfig.text6F6FA5_12,)                      ],                    ),                  ),                  onTap: (){                    Navigator.of(context).pop();                  },                ),                GestureDetector(                  child: Container(                    height: double.infinity,                    width: 130,                    child: Stack(                      alignment: Alignment.center,                      children: [                        Image.asset(                          Assets.serial_confirm,                          fit: BoxFit.cover,                          width: double.infinity,                          height: double.infinity,                        ),                        Text('确定',style: TextStyleConfig.textFFFFFF_12,)                      ],                    ),                  ),                  onTap: (){                    _confirmClick(context, _controller!.text);                  },                )              ],            ),          ),    ],      ),    );  }  void _confirmClick(BuildContext context,String value){    if (value.length == 0) {      Fluttertoast.showToast(msg: Utils.getFillInKeyText()!);      return;    }    _boundSerial(value).then((valueData){      print('value=======$value');      if (valueData['code'].toString() == '200'){        Fluttertoast.showToast(msg: '绑定成功');        Navigator.of(context).pop();        ManagerUtils.instance.saveSeriesNumber(valueData['data']['terminalId']);        ManagerUtils.instance.saveSeriesNumberKey(value);        return;      }      Fluttertoast.showToast(msg: valueData['msg']);    });  }  //1.1 数据获取-分类数据  Future<Map<String, dynamic>> _boundSerial(String value) async {    Map<String, dynamic> map = {      "deviceId":ManagerUtils.instance.deviceId,      // "deviceId":'12345',      "terminalKey":value    };    Response res = await HttpUtil.instance        .post(ApiConfig.activate, data: map);    return res.data;  }}
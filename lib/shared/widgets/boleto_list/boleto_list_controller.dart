import 'package:flutter/cupertino.dart';
import 'package:playflow/shared/models/boleto_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoletoListController {
  final boletosNotifier = ValueNotifier<List<BoletoModel>>(<BoletoModel>[]);
  final boletoNotifier = ValueNotifier<BoletoModel>(BoletoModel());

  List<BoletoModel> get boletos => boletosNotifier.value;
  BoletoModel get boleto => boletoNotifier.value;

  set boletos(List<BoletoModel> value) => boletosNotifier.value = value;
  set boleto(BoletoModel value) => boletoNotifier.value = value;

  BoletoListController() {
    getBoletos();
  }

  Future<void> getBoletos() async {
    try {
      final instance = await SharedPreferences.getInstance();
      final response = instance.getStringList("boletos") ?? <String>[];
      boletos = response.map((e) => BoletoModel.fromJson(e)).toList();
    } catch (e) {
      boletos = <BoletoModel>[];
    }
  }
}

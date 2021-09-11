import 'package:flutter/cupertino.dart';
import 'package:playflow/shared/models/boleto_model.dart';
import 'package:playflow/shared/widgets/boleto_list/boleto_list_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertBoletoController {
  final erroNotifier = ValueNotifier<bool>(false);
  bool get erro => erroNotifier.value;
  set erro(bool value) => erroNotifier.value = value;

  final formKey = GlobalKey<FormState>();

  final BoletoListController controller;

  late BoletoModel editModel;

  BoletoModel model;

  InsertBoletoController({required this.controller, required this.model});

  String? validateName(String? value) => value == null || value.isEmpty
      ? "O nome não pode ser vazio"
      : erro
          ? "Um boleto já existe com este nome"
          : null;
  String? validateVencimento(String? value) =>
      value?.isEmpty ?? true ? "A data de vencimento não pode ser vazio" : null;
  String? validateValor(double value) =>
      value == 0 ? "Insira um valor maior que R\$ 0,00" : null;
  String? validateCodigo(String? value) =>
      value?.isEmpty ?? true ? "O código do boleto não pode ser vazio" : null;

  void onChange({
    String? name,
    String? dueDate,
    double? value,
    String? barcode,
  }) {
    editModel = editModel.copyWith(
      name: name,
      dueDate: dueDate,
      value: value,
      barcode: barcode,
    );
  }

  Future<bool> cadastrarBoleto() async {
    final form = formKey.currentState;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final boletos = prefs.getStringList('boletos') ?? <String>[];
    if (boletos
        .where(
            (element) => BoletoModel.fromJson(element).name == editModel.name)
        .isNotEmpty) {
      erro = true;
    } else {
      erro = false;
    }
    if (form!.validate()) {
      await saveBoleto();
      return true;
    } else {
      return false;
    }
  }

  Future<void> saveBoleto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final boletos = prefs.getStringList('boletos') ?? <String>[];
    if (boletos
        .where(
            (element) => BoletoModel.fromJson(element).name == editModel.name)
        .isEmpty) {
      boletos.add(editModel.toJson());
      await prefs.setStringList('boletos', boletos);
      controller.getBoletos();
    } else {
      erro = true;
    }
    return;
  }
}

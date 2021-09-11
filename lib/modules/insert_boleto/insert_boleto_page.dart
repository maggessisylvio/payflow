import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:playflow/modules/insert_boleto/insert_boleto_controller.dart';
import 'package:playflow/shared/models/boleto_model.dart';
import 'package:playflow/shared/themes/app_colors.dart';
import 'package:playflow/shared/themes/app_text_styles.dart';
import 'package:playflow/shared/widgets/boleto_list/boleto_list_controller.dart';
import 'package:playflow/shared/widgets/input_text/input_text_widget.dart';
import 'package:playflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class InsertBoletoPage extends StatefulWidget {
  final BoletoListController boletoController;
  final BoletoModel model;

  const InsertBoletoPage({
    required this.boletoController,
    required this.model,
  });

  @override
  _InsertBoletoPageState createState() => _InsertBoletoPageState();
}

class _InsertBoletoPageState extends State<InsertBoletoPage> {
  late final InsertBoletoController? controller;

  final moneyController = MoneyMaskedTextController(
    decimalSeparator: ',',
    leftSymbol: 'R\$',
    thousandSeparator: '.',
  );

  final dateController = MaskedTextController(mask: "00/00/0000");
  final barcodeController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void initState() {
    controller = InsertBoletoController(
        controller: widget.boletoController, model: widget.model);
    controller!.editModel = widget.model;
    nameController.text = widget.model.name ?? '';
    dateController.text = widget.model.dueDate ?? '';
    moneyController.updateValue(widget.model.value ?? 0);
    barcodeController.text = widget.model.barcode ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 93),
                child: Text(
                  "Preencha os dados do boleto",
                  style: TextStyles.titleBoldHeading,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Form(
                key: controller!.formKey,
                child: Column(
                  children: [
                    InputTextWidget(
                      label: "Nome do Boleto",
                      controller: nameController,
                      icon: Icons.description_outlined,
                      validator: controller!.validateName,
                      onChanged: (value) {
                        controller!.onChange(name: value);
                      },
                    ),
                    InputTextWidget(
                      label: "Vencimento",
                      controller: dateController,
                      icon: FontAwesomeIcons.timesCircle,
                      validator: controller!.validateVencimento,
                      onChanged: (value) {
                        controller!.onChange(dueDate: value);
                      },
                    ),
                    InputTextWidget(
                      label: "Valor",
                      controller: moneyController,
                      icon: FontAwesomeIcons.wallet,
                      validator: (_) => controller!
                          .validateValor(moneyController.numberValue),
                      onChanged: (value) {
                        controller!
                            .onChange(value: moneyController.numberValue);
                      },
                    ),
                    InputTextWidget(
                      label: "Código",
                      controller: barcodeController,
                      icon: FontAwesomeIcons.barcode,
                      validator: controller!.validateCodigo,
                      onChanged: (value) {
                        controller!.onChange(barcode: value);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SetLabelButtons(
        enableSecondaryColor: true,
        primaryLabel: "Cancelar",
        primaryOnPressed: () {
          Navigator.pop(context);
        },
        secondaryLabel: "Cadastrar",
        secondaryOnPressed: () async {
          await controller!.cadastrarBoleto();
          Navigator.pop(context);
        },
      ),
    );
  }
}

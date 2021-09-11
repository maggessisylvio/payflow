import 'package:flutter/material.dart';
import 'package:playflow/modules/barcode_scanner/barcode_scanner_controller.dart';
import 'package:playflow/modules/barcode_scanner/barcode_scanner_status.dart';
import 'package:playflow/shared/models/boleto_model.dart';
import 'package:playflow/shared/themes/app_colors.dart';
import 'package:playflow/shared/themes/app_text_styles.dart';
import 'package:playflow/shared/widgets/boleto_list/boleto_list_controller.dart';
import 'package:playflow/shared/widgets/bottom_sheet/bottom_sheet_widget.dart';
import 'package:playflow/shared/widgets/set_label_buttons/set_label_buttons.dart';

class BarcodeScannerPage extends StatefulWidget {
  final BoletoListController controller;
  const BarcodeScannerPage({
    required this.controller,
  });

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  final controller = BarcodeScannerController();

  @override
  void initState() {
    controller.getAvailableCameras();
    controller.statusNotifier.addListener(() {
      if (controller.status.hasBarcode) {
        Navigator.pushReplacementNamed(
          context,
          "/insert_boleto",
          arguments: [
            BoletoModel(barcode: controller.status.barcode),
            widget.controller,
          ],
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      left: true,
      bottom: true,
      right: true,
      child: Stack(
        children: [
          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, status, __) {
              if (status.showCamera) {
                return Container(
                  child: controller.cameraController!.buildPreview(),
                );
              } else {
                return Container();
              }
            },
          ),
          RotatedBox(
            quarterTurns: 1,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  "Escaneie o código de barras do boleto",
                  style: TextStyles.buttonBackground,
                ),
                centerTitle: true,
                leading: BackButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.dispose();
                  },
                  color: AppColors.background,
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                      child: Container(
                    color: Colors.black.withOpacity(0.6),
                  )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.transparent,
                      )),
                  Expanded(
                      child: Container(
                    color: Colors.black.withOpacity(0.6),
                  )),
                ],
              ),
              bottomNavigationBar: SetLabelButtons(
                primaryLabel: "Inserir código do boleto",
                primaryOnPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    "/insert_boleto",
                    arguments: [
                      null,
                      widget.controller,
                    ],
                  );
                },
                secondaryLabel: "Adicionar da galeria",
                secondaryOnPressed: () {
                  controller.scanWithImagePicker();
                },
              ),
            ),
          ),
          ValueListenableBuilder<BarcodeScannerStatus>(
            valueListenable: controller.statusNotifier,
            builder: (_, status, __) {
              if (status.hasError) {
                return BottomSheetWidget(
                  title: "Não foi possível identificar um código de barras.",
                  subtitle:
                      "Tente escanear novamente ou digite o código do seu boleto.",
                  primaryLabel: "Escanear novamente",
                  primaryOnPressed: () {
                    controller.scanWithCamera();
                  },
                  secondaryLabel: "Digitar código",
                  secondaryOnPressed: () {
                    Navigator.pushReplacementNamed(context, '/insert_boleto',
                        arguments: [
                          null,
                          widget.controller,
                        ]);
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}

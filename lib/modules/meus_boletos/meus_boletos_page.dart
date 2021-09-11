import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';

import 'package:playflow/shared/models/boleto_model.dart';
import 'package:playflow/shared/themes/app_colors.dart';
import 'package:playflow/shared/themes/app_text_styles.dart';
import 'package:playflow/shared/widgets/boleto_info/boleto_info.dart';
import 'package:playflow/shared/widgets/boleto_list/boleto_list_controller.dart';
import 'package:playflow/shared/widgets/boleto_list/boleto_list_widget.dart';

class MeusBoletosPage extends StatefulWidget {
  final BoletoListController controller;

  const MeusBoletosPage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _MeusBoletosPageState createState() => _MeusBoletosPageState();
}

class _MeusBoletosPageState extends State<MeusBoletosPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                color: AppColors.primary,
                height: 40,
                width: double.maxFinite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ValueListenableBuilder<List<BoletoModel>>(
                  valueListenable: widget.controller.boletosNotifier,
                  builder: (_, boletos, __) => AnimatedCard(
                    direction: AnimatedCardDirection.top,
                    child: BoletoInfoWidget(size: boletos.length),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
            child: Row(
              children: [
                Text(
                  "Meus boletos",
                  style: TextStyles.titleBoldHeading,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: Divider(
              thickness: 1,
              height: 1,
              color: AppColors.stroke,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BoletoListWidget(
              controller: widget.controller,
            ),
          ),
        ],
      ),
    );
  }
}

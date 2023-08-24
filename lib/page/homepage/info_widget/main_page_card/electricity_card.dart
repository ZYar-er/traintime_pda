import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:watermeter/page/homepage/info_widget/main_page_card/main_page_card.dart';
import 'package:watermeter/repository/electricity_session.dart'
    as electricity_session;
import 'package:watermeter/repository/xidian_ids/payment_session.dart'
    as owe_session;

class ElectricityCard extends StatelessWidget {
  const ElectricityCard({super.key});

  @override
  Widget build(BuildContext context) {
    if (electricity_session.electricityInfo.value.isEmpty) {
      electricity_session.update();
    }
    if (owe_session.owe.value.isEmpty) {
      owe_session.update();
    }
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text("水电信息"),
            children: [
              SimpleDialogOption(
                child: Obx(
                  () => Text(
                    "电费帐号：${electricity_session.ElectricitySession.electricityAccount()}\n"
                    "电量信息：${electricity_session.electricityInfo.value} 度电\n"
                    "欠费信息：${owe_session.owe.value}\n"
                    "长按可以重新加载，有欠费一般代表水费",
                  ),
                ),
              ),
              SimpleDialogOption(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("确定"),
                ),
              ),
            ],
          ),
        );
      },
      onLongPress: () {
        electricity_session.update();
        owe_session.update();
      },
      child: MainPageCard(
        icon: Icons.electric_meter_rounded,
        text: "电量信息",
        children: [
          Obx(
            () => Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontSize: 20,
                    ),
                    children: !electricity_session.isNotice.value
                        ? [
                            TextSpan(
                              text: electricity_session.electricityInfo.value,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const TextSpan(text: " 度电"),
                          ]
                        : [
                            TextSpan(
                              text: electricity_session.electricityInfo.value,
                            ),
                          ],
                  ),
                ),
              ),
            ),
          ),
          Obx(() => Text(owe_session.owe.value)),
        ],
      ),
    );
  }
}

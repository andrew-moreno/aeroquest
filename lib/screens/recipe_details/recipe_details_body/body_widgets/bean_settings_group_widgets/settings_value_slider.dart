import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_weight_slider/vertical_weight_slider.dart';

import 'package:aeroquest/constraints.dart';
import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/providers/recipes_provider.dart';
import 'package:aeroquest/widgets/recipe_settings/widgets/settings_value.dart';

class SettingsValueSlider extends StatefulWidget {
  const SettingsValueSlider({
    Key? key,
    required this.maxWidth,
    this.coffeeSettingsData,
  }) : super(key: key);

  final double maxWidth;
  final CoffeeSettings? coffeeSettingsData;

  @override
  State<SettingsValueSlider> createState() => _SettingsValueSliderState();
}

class _SettingsValueSliderState extends State<SettingsValueSlider> {
  /// all the available setting types that can be edited for each recipe
  final List<SettingType> _settingTypeList = [
    SettingType.grindSetting,
    SettingType.coffeeAmount,
    SettingType.waterAmount,
    SettingType.waterTemp,
    SettingType.brewTime,
    SettingType.none,
  ];

  /// initializing setting values when modal sheet activated
  /// default values set when no values are passed (eg. adding new bean settings)
  @override
  void initState() {
    super.initState();
    Provider.of<RecipesProvider>(context, listen: false).tempGrindSetting =
        widget.coffeeSettingsData?.grindSetting ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).tempCoffeeAmount =
        widget.coffeeSettingsData?.coffeeAmount ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterAmount =
        widget.coffeeSettingsData?.waterAmount ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).tempWaterTemp =
        widget.coffeeSettingsData?.waterTemp ?? 100;
    Provider.of<RecipesProvider>(context, listen: false).tempBrewTime =
        widget.coffeeSettingsData?.brewTime ?? 0;
    Provider.of<RecipesProvider>(context, listen: false).activeSetting =
        SettingType.none;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipesProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => SettingsValueContainer(
                  settingType: _settingTypeList[index],
                  provider: provider,
                ),
              ),
            ),
            const Divider(height: 13, color: Color(0x00000000)),
            Stack(
              children: List.generate(
                6,
                (index) => VerticalWeightSliderBuilder(
                  maxWidth: widget.maxWidth,
                  provider: provider,
                  settingType: _settingTypeList[index],
                  disableScrolling: (index == 5) ? true : false,
                  opacity: (index == 5) ? 0.3 : 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class VerticalWeightSliderBuilder extends StatelessWidget {
  const VerticalWeightSliderBuilder({
    Key? key,
    this.opacity = 1,
    this.disableScrolling = false,
    required this.maxWidth,
    required this.provider,
    required this.settingType,
  }) : super(key: key);

  /// used to reduce opacity when slider is inactive
  final double opacity;

  /// if true, will set the sliders physics to NeverScrollableScrollPhysics
  final bool disableScrolling;

  /// max width of parent
  /// used to avoid clipping of the slider when modal is active
  final double maxWidth;

  /// provider passed down from parent
  final RecipesProvider provider;

  /// setting type to change for this slider
  final SettingType settingType;

  int _maxValue(SettingType settingType) {
    switch (settingType) {
      case SettingType.grindSetting:
        return 100;
      case SettingType.coffeeAmount:
        return 100;
      case SettingType.waterAmount:
        return 999;
      case SettingType.waterTemp:
        return 100;
      case SettingType.brewTime:
        return 180; // 30 minutes
      case SettingType.none:

        /// value doesnt matter but initial value of slider set to 50
        /// must be greater than 50 plus space on screen
        return 100;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// initializing controllers for weight slider
    WeightSliderController _grindSettingController = WeightSliderController(
      initialWeight: provider.tempGrindSetting!,
      interval: 0.25,
    );
    WeightSliderController _coffeeAmountController = WeightSliderController(
      initialWeight: provider.tempCoffeeAmount!.toDouble(),
      interval: 0.1,
    );
    WeightSliderController _waterAmountController = WeightSliderController(
      initialWeight: provider.tempWaterAmount!.toDouble(),
      interval: 1,
    );
    WeightSliderController _waterTempController = WeightSliderController(
      initialWeight: provider.tempWaterTemp!.toDouble(),
      interval: 1,
    );
    WeightSliderController _brewTimeController = WeightSliderController(
      initialWeight: provider.tempBrewTime!.toDouble(),
      interval: 1,
    );
    WeightSliderController _noSettingController =
        WeightSliderController(initialWeight: 50);

    WeightSliderController _controllerSelector(SettingType settingType) {
      switch (settingType) {
        case SettingType.grindSetting:
          return _grindSettingController;
        case SettingType.coffeeAmount:
          return _coffeeAmountController;
        case SettingType.waterAmount:
          return _waterAmountController;
        case SettingType.waterTemp:
          return _waterTempController;
        case SettingType.brewTime:
          return _brewTimeController;
        case SettingType.none:
          return _noSettingController;
      }
    }

    return Visibility(
      visible: provider.activeSetting == settingType ? true : false,
      child: Opacity(
        opacity: opacity,
        child: VerticalWeightSlider(
          disableScrolling: disableScrolling,
          maxWidth: maxWidth,
          maxWeight: _maxValue(settingType),
          height: 40,
          decoration: const PointerDecoration(
            width: 25.0,
            height: 3.0,
            largeColor: kLightSecondary,
            mediumColor: kLightSecondary,
            gap: 0,
          ),
          controller: _controllerSelector(settingType),
          onChanged: (double value) {
            provider.sliderOnChanged(value, settingType);
          },
        ),
      ),
    );
  }
}

class SettingsValueContainer extends StatelessWidget {
  const SettingsValueContainer({
    Key? key,
    required this.settingType,
    required this.provider,
  }) : super(key: key);

  /// defines the setting type of the settings value container
  /// (grind setting, coffee amount, etc.)
  final SettingType settingType;

  /// provider passed down from parent
  /// required for on tap activate/deactivate function to work
  final RecipesProvider provider;

  @override
  Widget build(BuildContext context) {
    dynamic _settingValue(SettingType settingType) {
      switch (settingType) {
        case SettingType.grindSetting:
          return Provider.of<RecipesProvider>(context).tempGrindSetting;
        case SettingType.coffeeAmount:
          return Provider.of<RecipesProvider>(context).tempCoffeeAmount;
        case SettingType.waterAmount:
          return Provider.of<RecipesProvider>(context).tempWaterAmount;
        case SettingType.waterTemp:
          return Provider.of<RecipesProvider>(context).tempWaterTemp;
        case SettingType.brewTime:
          return Provider.of<RecipesProvider>(context).tempBrewTime;
        case SettingType.none:
          throw Exception("SettingType.none passed incorrectly");
      }
    }

    return GestureDetector(
      onTap: () {
        provider.settingOnTap(settingType);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
        margin: provider.activeSetting != settingType
            ? const EdgeInsets.all(2)
            : null,
        decoration: BoxDecoration(
          color: kLightSecondary,
          borderRadius: BorderRadius.circular(kCornerRadius),
          boxShadow: [kBoxShadow],
          border: provider.activeSetting == settingType
              ? Border.all(color: kAccent, width: 2)
              : null,
        ),
        child: SettingsValue(
          settingValue: _settingValue(settingType),
          settingType: settingType,
        ),
      ),
    );
  }
}

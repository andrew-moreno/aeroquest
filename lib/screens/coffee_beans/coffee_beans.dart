import 'package:aeroquest/models/coffee_bean_entry.dart';
import 'package:aeroquest/widgets/card_header/card_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:aeroquest/widgets/appbar/appbar_text.dart';
import 'package:aeroquest/widgets/card_header/card_header_buttons.dart';
import 'package:aeroquest/widgets/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../models/beans_provider.dart';
import '../../constraints.dart';

class CoffeeBeans extends StatefulWidget {
  const CoffeeBeans({Key? key}) : super(key: key);

  static const routeName = "/manageBeans";

  @override
  State<CoffeeBeans> createState() => _CoffeeBeansState();
}

class _CoffeeBeansState extends State<CoffeeBeans> {
  final List<CoffeeBeanEntry> _data = BeansProvider().beans;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: const AppBarLeading(function: LeadingFunction.menu),
        title: const AppBarText(text: "BEANS"),
        actions: [
          AppBarAddButton(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(kCornerRadius)),
                ),
                isScrollControlled: false,
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildFormField("Name", true),
                          const Divider(height: 20, color: Color(0x00000000)),
                          _buildFormField("Description", false),
                          const Divider(height: 20, color: Color(0x00000000)),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          itemCount: _data.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildBeansContainer(
                _data[index].beanName, _data[index].description);
          },
          separatorBuilder: (context, index) {
            return const Divider(
              color: Color(0x00000000),
              height: 20,
            );
          },
        ),
      ),
    );
  }

  FormBuilderTextField _buildFormField(hint, autoFocus) {
    return FormBuilderTextField(
      cursorColor: kDarkNavy,
      name: "beanName",
      style: TextStyle(color: kTextColor),
      autofocus: autoFocus,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        hintText: hint,
        hintStyle: const TextStyle(
          color: kTextColor,
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: const BorderSide(color: kAccentOrange),
        ),
        filled: true,
        fillColor: kLightNavy,
      ),
    );
  }

  Container _buildBeansContainer(beanName, description) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 15,
      ),
      decoration: BoxDecoration(
        color: kLightNavy,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CardHeader(
        title: beanName,
        description: description,
        actions: [
          CardHeaderButton(
            icon: Icons.edit,
            onTap: () {
              print("Hello");
            },
          ),
          CardHeaderButton(
            icon: Icons.delete,
            onTap: () {
              print("Hello");
            },
          ),
        ],
      ),
    );
  }
}

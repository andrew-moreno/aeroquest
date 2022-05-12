import 'package:aeroquest/models/recipe_entry.dart';
import 'package:aeroquest/screens/recipe_details/widgets/recipe_details_body.dart';
import 'package:aeroquest/screens/recipe_details/widgets/recipe_details_header.dart';
import 'package:aeroquest/widgets/appbar/appbar_addButton.dart';
import 'package:aeroquest/widgets/appbar/appbar_leading.dart';
import 'package:flutter/material.dart';
import 'package:aeroquest/constraints.dart';

class RecipeDetails extends StatefulWidget {
  RecipeDetails({
    Key? key,
    required recipeData,
  })  : _recipeData = recipeData,
        super(key: key);

  final RecipeEntry _recipeData;
  final ScrollController _scrollController = ScrollController();

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final GlobalKey _stickyKey = GlobalKey();
  double _dynamicTotalHeight = 0;
  static const double _upperDividerHeight = 55;
  static const double _lowerDividerHeight = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(_getTotalHeight);
  }

  double _getWidgetHeight(GlobalKey key) {
    RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }

  _getTotalHeight(_) {
    _dynamicTotalHeight = _getWidgetHeight(_stickyKey) +
        _upperDividerHeight +
        _lowerDividerHeight;

    setState(() {});

    return _dynamicTotalHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: kDarkSecondary,
          child: CustomScrollView(
            controller: widget._scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: kPrimary,
                elevation: 100,
                leading: const AppBarLeading(function: LeadingFunction.back),
                actions: [AppBarAddButton(onTap: () {}, icon: Icons.edit)],
                expandedHeight: _dynamicTotalHeight,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      const Divider(
                        height: _upperDividerHeight,
                        color: Color(0x00000000),
                      ),
                      RecipeDetailsHeader(
                        key: _stickyKey,
                        title: widget._recipeData.title,
                        description: widget._recipeData.description,
                      ),
                      const Divider(
                        height: _lowerDividerHeight,
                        color: Color(0x00000000),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: RecipeDetailsBody(
                  recipeData: widget._recipeData,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

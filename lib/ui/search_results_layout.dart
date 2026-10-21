import 'package:flutter/material.dart';

/// Keeps search controls and results reachable on phones and with large text.
class SearchResultsLayout extends StatelessWidget {
  const SearchResultsLayout({
    super.key,
    required this.header,
    required this.itemCount,
    required this.itemBuilder,
    this.empty,
  });
  final Widget header;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final Widget? empty;

  @override
  Widget build(BuildContext context) => CustomScrollView(
    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    slivers: [
      SliverToBoxAdapter(child: header),
      if (itemCount == 0 && empty != null)
        SliverFillRemaining(hasScrollBody: false, child: empty!)
      else
        SliverList(
          delegate: SliverChildBuilderDelegate(
            itemBuilder,
            childCount: itemCount,
          ),
        ),
    ],
  );
}

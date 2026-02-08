import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DescriptionWithToggle extends ConsumerStatefulWidget {
  final String description;
  final int id;

  const DescriptionWithToggle({
    super.key,
    required this.description,
    required this.id,
  });

  @override
  ConsumerState<DescriptionWithToggle> createState() =>
      _DescriptionWithToggleState();
}

class _DescriptionWithToggleState extends ConsumerState<DescriptionWithToggle> {
  bool showSeeMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => checkTextLines());
  }

  void checkTextLines() {
    final textSpan = TextSpan(
      text: widget.description,
      style: const TextStyle(fontSize: 18),
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 40);
    if (textPainter.didExceedMaxLines) {
      ref.read(showSeeMoreProvider(widget.id).notifier).foo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer(
          builder:
              (context, expRef, child) => Text(
                widget.description,
                maxLines: expRef.watch(expandedProvider(widget.id)) ? null : 3,
                overflow:
                    expRef.watch(expandedProvider(widget.id))
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
        ),
        const SizedBox(height: 8),

        Consumer(
          builder:
              (context, expRef, child) =>
                  (expRef.watch(showSeeMoreProvider(widget.id)))
                      ? GestureDetector(
                        onTap: () {
                          expRef
                              .read(expandedProvider(widget.id).notifier)
                              .toggle();
                        },
                        child: Consumer(
                          builder:
                              (context, ref, child) => Text(
                                ref.watch(expandedProvider(widget.id))
                                    ? 'See less'
                                    : 'See more',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                        ),
                      )
                      : SizedBox(),
        ),
      ],
    );
  }
}

final expandedProvider = StateNotifierProvider.autoDispose
    .family<ExpandedStateNotifier, bool, int>((ref, id) {
      return ExpandedStateNotifier();
    });

class ExpandedStateNotifier extends StateNotifier<bool> {
  ExpandedStateNotifier() : super(false);

  void toggle() {
    state = !state;
  }
}

final showSeeMoreProvider = StateNotifierProvider.autoDispose
    .family<ShowSeeMore, bool, int>((ref, id) {
      return ShowSeeMore();
    });

class ShowSeeMore extends StateNotifier<bool> {
  ShowSeeMore() : super(false);

  void foo() {
    state = true;
  }
}

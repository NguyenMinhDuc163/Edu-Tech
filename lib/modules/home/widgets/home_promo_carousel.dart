import 'package:easy_localization/easy_localization.dart';
import 'package:ed_tech/init.dart';
import 'package:ed_tech/core/widgets/template/button_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePromoCarousel extends StatefulWidget {
  final VoidCallback? onNavigateToCourseTab;
  final VoidCallback? onNavigateToQuizTab;

  const HomePromoCarousel({super.key, this.onNavigateToCourseTab, this.onNavigateToQuizTab});

  @override
  State<HomePromoCarousel> createState() => _HomePromoCarouselState();
}

class _HomePromoCarouselState extends State<HomePromoCarousel> {
  late final PageController _controller;

  final List<_PromoItem> _items = const [
    _PromoItem(
      title: 'home_screen.promo_1_title',
      cta: 'home_screen.promo_1_cta',
      asset: 'assets/images/intro_step_1.svg',
      background: Color(0xFFE9F1FF),
    ),
    _PromoItem(
      title: 'home_screen.promo_2_title',
      cta: 'home_screen.promo_2_cta',
      asset: 'assets/images/intro_step_2.svg',
      background: Color(0xFFEFF7FF),
    ),
    _PromoItem(
      title: 'home_screen.promo_3_title',
      cta: 'home_screen.promo_3_cta',
      asset: 'assets/images/intro_step_3.svg',
      background: Color(0xFFEFF7FF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.86);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 170,
          child: PageView.builder(
            controller: _controller,
            itemCount: _items.length,
            padEnds: false,
            itemBuilder: (context, i) => _PromoCard(
              item: _items[i],
              onPressed: i == 0
                  ? widget.onNavigateToCourseTab
                  : i == 1
                      ? widget.onNavigateToQuizTab
                      : null,
            ),
          ),
        ),
      ],
    );
  }
}

class _PromoItem {
  final String title;
  final String cta;
  final String asset;
  final Color background;

  const _PromoItem({
    required this.title,
    required this.cta,
    required this.asset,
    required this.background,
  });
}

class _PromoCard extends StatelessWidget {
  final _PromoItem item;
  final VoidCallback? onPressed;
  const _PromoCard({required this.item, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Container(
        decoration: BoxDecoration(
          color: item.background,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            // content
            Padding(
              padding: AppPad.h24,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.tr(),
                          style: AppTextStyles.textHeader3.copyWith(
                            color: AppColors.raisinBlack,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ButtonWidget(
                          title: item.cta.tr(),
                          backgroundColor: AppColors.colorFF7043,
                          padding: AppPad.h16v10,
                          boderRadius: BorderRadius.circular(10),
                          titleStyle: AppTextStyles.textMedium.copyWith(
                            color: AppColors.white,
                          ),
                          onPressed: onPressed ?? () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: SvgPicture.asset(item.asset, fit: BoxFit.contain),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

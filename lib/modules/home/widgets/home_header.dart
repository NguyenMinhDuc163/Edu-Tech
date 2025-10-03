import 'package:ed_tech/init.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({super.key, this.stackChildren = const []});
  final List<Widget> stackChildren;
  @override
  Widget build(BuildContext context) {
    final double headerHeight = 180;
    const double cardHeight = 90;

    return SizedBox(
      height: headerHeight + cardHeight / 2,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Blue background with rounded bottom
          Container(
            height: headerHeight,
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.color3D5CFF),
            child: Padding(
              padding: AppPad.h24.add(AppPad.t24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Greeting texts
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, Nguyen Duc',
                        style: AppTextStyles.textHeader2.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Let's start learning",
                        style: AppTextStyles.text.copyWith(
                          color: AppColors.offWhite,
                        ),
                      ),
                    ],
                  ),
                  // Avatar
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.white,
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),

          // Progress card overlaps bottom
          Positioned(
            left: 24,
            right: 24,
            top: headerHeight - (cardHeight / 2),
            child: _ProgressCard(),
          ),
          ...stackChildren,
        ],
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    const int learnedMinutes = 46;
    const int totalMinutes = 60;
    final double progress =
        (totalMinutes == 0)
            ? 0
            : (learnedMinutes / totalMinutes).clamp(0.0, 1.0);
    return Container(
      padding: AppPad.h16v14,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color.fromRGBO(0, 0, 0, 0.075),
          ),
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 24,
            color: AppColors.shadowBlack15,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Learned today',
                style: AppTextStyles.textMedium.copyWith(
                  color: AppColors.coolGray,
                ),
              ),
              Text('My courses', style: AppTextStyles.textButton),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('${learnedMinutes}min', style: AppTextStyles.textHeader3),
              Text(
                ' / ${totalMinutes}min',
                style: AppTextStyles.text.copyWith(color: AppColors.coolGray),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: progress,
              backgroundColor: AppColors.silverGray,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.colorFF7043,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

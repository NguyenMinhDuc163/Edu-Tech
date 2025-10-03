import 'package:ed_tech/init.dart';

class LearningPlanWidget extends StatelessWidget {
  const LearningPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPad.h24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Learning Plan',
            style: AppTextStyles.textHeader3.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 12),
          Container(
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
                  offset: Offset(0, 10),
                  blurRadius: 20,
                  color: AppColors.shadowBlack15,
                ),
              ],
            ),
            child: Column(
              children: [
                _PlanItem(
                  title: 'Packaging Design',
                  current: 40,
                  total: 48,
                  progressColor: AppColors.color707070,
                ),
                Divider(height: 1, thickness: 0.5, color: AppColors.silverGray),
                _PlanItem(
                  title: 'Product Design',
                  current: 6,
                  total: 24,
                  progressColor: AppColors.color707070,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanItem extends StatelessWidget {
  final String title;
  final int current;
  final int total;
  final Color progressColor;

  const _PlanItem({
    required this.title,
    required this.current,
    required this.total,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final double value = total == 0 ? 0 : (current / total).clamp(0.0, 1.0);
    return Padding(
      padding: AppPad.h16v14,
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colorF4F3FD,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                CircularProgressIndicator(
                  value: value,
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: AppTextStyles.textMedium)),
          RichText(
            text: TextSpan(
              text: '$current',
              style: AppTextStyles.textMedium,
              children: [
                TextSpan(
                  text: '/$total',
                  style: AppTextStyles.text.copyWith(
                    color: AppColors.colorB8B8D2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

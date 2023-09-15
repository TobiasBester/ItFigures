import 'package:it_figures/pages/daily_page.dart';
import 'package:it_figures/pages/home_page.dart';
import 'package:it_figures/pages/infinite_page.dart';
import 'package:it_figures/pages/timed_page.dart';

final itFiguresRoutes = {
  '/daily': (context) => const DailyPage(),
  '/infinite': (context) => const InfinitePage(),
  '/timed': (context) => const TimedPage(),
};

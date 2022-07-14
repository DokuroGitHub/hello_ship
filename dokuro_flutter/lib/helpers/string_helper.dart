import 'package:dokuro_flutter/models/address.dart';
import 'package:dokuro_flutter/models/post_address.dart';
import 'package:dokuro_flutter/models/shipment_address_from.dart';
import 'package:dokuro_flutter/models/shipment_address_to.dart';
import 'package:dokuro_flutter/models/user_address.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:simple_moment/simple_moment.dart';

class StringHelper {
  /// '30/12/2000'
  DateTime? stringToDateTimeV0(String? dateTime) {
    if (dateTime == null) {
      return null;
    }
    try {
      return DateFormat("dd/MM/yyyy").parse(dateTime);
    } catch (_) {}
    return null;
  }

  /// '30/12/2000'
  String dateTimeToStringV0(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    Moment moment = Moment.fromDate(dateTime);
    return moment.format("dd/MM/yyyy");
  }

  /// '3rd August', '3rd August, 2021' / '3 tháng 8, 2021'
  String dateTimeToStringV1(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    int year = dateTime.year;
    int month = dateTime.month;
    //int weekday = dateTime.weekday;
    int day = dateTime.day;
    //int hour = dateTime.hour;
    //int minute = dateTime.minute;
    //int second = dateTime.second;

    String d = '';
    String m = '';
    if (month == 1) {
      m = AppLocalizations.of(Get.context!).month1;
    } else if (month == 2) {
      m = AppLocalizations.of(Get.context!).month2;
    } else if (month == 3) {
      m = AppLocalizations.of(Get.context!).month3;
    } else if (month == 4) {
      m = AppLocalizations.of(Get.context!).month4;
    } else if (month == 5) {
      m = AppLocalizations.of(Get.context!).month5;
    } else if (month == 6) {
      m = AppLocalizations.of(Get.context!).month6;
    } else if (month == 7) {
      m = AppLocalizations.of(Get.context!).month7;
    } else if (month == 8) {
      m = AppLocalizations.of(Get.context!).month8;
    } else if (month == 9) {
      m = AppLocalizations.of(Get.context!).month9;
    } else if (month == 10) {
      m = AppLocalizations.of(Get.context!).month10;
    } else if (month == 11) {
      m = AppLocalizations.of(Get.context!).month11;
    } else if (month == 12) {
      m = AppLocalizations.of(Get.context!).month12;
    }

    if (day == 1) {
      d = AppLocalizations.of(Get.context!).day1;
    } else if (day == 2) {
      d = AppLocalizations.of(Get.context!).day2;
    } else if (day == 3) {
      d = AppLocalizations.of(Get.context!).day3;
    } else if (day == 4) {
      d = AppLocalizations.of(Get.context!).day4;
    } else if (day == 5) {
      d = AppLocalizations.of(Get.context!).day5;
    } else if (day == 6) {
      d = AppLocalizations.of(Get.context!).day6;
    } else if (day == 7) {
      d = AppLocalizations.of(Get.context!).day7;
    } else if (day == 8) {
      d = AppLocalizations.of(Get.context!).day8;
    } else if (day == 9) {
      d = AppLocalizations.of(Get.context!).day9;
    } else if (day == 10) {
      d = AppLocalizations.of(Get.context!).day10;
    } else if (day == 11) {
      d = AppLocalizations.of(Get.context!).day11;
    } else if (day == 12) {
      d = AppLocalizations.of(Get.context!).day12;
    } else if (day == 13) {
      d = AppLocalizations.of(Get.context!).day13;
    } else if (day == 14) {
      d = AppLocalizations.of(Get.context!).day14;
    } else if (day == 15) {
      d = AppLocalizations.of(Get.context!).day15;
    } else if (day == 16) {
      d = AppLocalizations.of(Get.context!).day16;
    } else if (day == 17) {
      d = AppLocalizations.of(Get.context!).day17;
    } else if (day == 18) {
      d = AppLocalizations.of(Get.context!).day18;
    } else if (day == 19) {
      d = AppLocalizations.of(Get.context!).day19;
    } else if (day == 20) {
      d = AppLocalizations.of(Get.context!).day20;
    } else if (day == 21) {
      d = AppLocalizations.of(Get.context!).day21;
    } else if (day == 22) {
      d = AppLocalizations.of(Get.context!).day22;
    } else if (day == 23) {
      d = AppLocalizations.of(Get.context!).day23;
    } else if (day == 24) {
      d = AppLocalizations.of(Get.context!).day24;
    } else if (day == 25) {
      d = AppLocalizations.of(Get.context!).day25;
    } else if (day == 26) {
      d = AppLocalizations.of(Get.context!).day26;
    } else if (day == 27) {
      d = AppLocalizations.of(Get.context!).day27;
    } else if (day == 28) {
      d = AppLocalizations.of(Get.context!).day28;
    } else if (day == 29) {
      d = AppLocalizations.of(Get.context!).day29;
    } else if (day == 30) {
      d = AppLocalizations.of(Get.context!).day30;
    } else if (day == 31) {
      d = AppLocalizations.of(Get.context!).day31;
    }

    if (year == DateTime.now().year) {
      return '$d $m';
    }
    return '$d $m, $year';
  }

  /// 'Mon, 3rd August', 'Mon, 3rd August, 2021' / 'Thứ Hai, 3 tháng 8, 2021'
  String dateTimeToStringV2(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    int year = dateTime.year;
    int month = dateTime.month;
    int weekday = dateTime.weekday;
    int day = dateTime.day;

    String w = '';
    String d = '';
    String m = '';
    if (weekday == 1) {
      w = AppLocalizations.of(Get.context!).weekday1;
    } else if (weekday == 2) {
      w = AppLocalizations.of(Get.context!).weekday2;
    } else if (weekday == 3) {
      w = AppLocalizations.of(Get.context!).weekday3;
    } else if (weekday == 4) {
      w = AppLocalizations.of(Get.context!).weekday4;
    } else if (weekday == 5) {
      w = AppLocalizations.of(Get.context!).weekday5;
    } else if (weekday == 6) {
      w = AppLocalizations.of(Get.context!).weekday6;
    } else if (weekday == 7) {
      w = AppLocalizations.of(Get.context!).weekday7;
    }

    if (month == 1) {
      m = AppLocalizations.of(Get.context!).month1;
    } else if (month == 2) {
      m = AppLocalizations.of(Get.context!).month2;
    } else if (month == 3) {
      m = AppLocalizations.of(Get.context!).month3;
    } else if (month == 4) {
      m = AppLocalizations.of(Get.context!).month4;
    } else if (month == 5) {
      m = AppLocalizations.of(Get.context!).month5;
    } else if (month == 6) {
      m = AppLocalizations.of(Get.context!).month6;
    } else if (month == 7) {
      m = AppLocalizations.of(Get.context!).month7;
    } else if (month == 8) {
      m = AppLocalizations.of(Get.context!).month8;
    } else if (month == 9) {
      m = AppLocalizations.of(Get.context!).month9;
    } else if (month == 10) {
      m = AppLocalizations.of(Get.context!).month10;
    } else if (month == 11) {
      m = AppLocalizations.of(Get.context!).month11;
    } else if (month == 12) {
      m = AppLocalizations.of(Get.context!).month12;
    }

    if (day == 1) {
      d = AppLocalizations.of(Get.context!).day1;
    } else if (day == 2) {
      d = AppLocalizations.of(Get.context!).day2;
    } else if (day == 3) {
      d = AppLocalizations.of(Get.context!).day3;
    } else if (day == 4) {
      d = AppLocalizations.of(Get.context!).day4;
    } else if (day == 5) {
      d = AppLocalizations.of(Get.context!).day5;
    } else if (day == 6) {
      d = AppLocalizations.of(Get.context!).day6;
    } else if (day == 7) {
      d = AppLocalizations.of(Get.context!).day7;
    } else if (day == 8) {
      d = AppLocalizations.of(Get.context!).day8;
    } else if (day == 9) {
      d = AppLocalizations.of(Get.context!).day9;
    } else if (day == 10) {
      d = AppLocalizations.of(Get.context!).day10;
    } else if (day == 11) {
      d = AppLocalizations.of(Get.context!).day11;
    } else if (day == 12) {
      d = AppLocalizations.of(Get.context!).day12;
    } else if (day == 13) {
      d = AppLocalizations.of(Get.context!).day13;
    } else if (day == 14) {
      d = AppLocalizations.of(Get.context!).day14;
    } else if (day == 15) {
      d = AppLocalizations.of(Get.context!).day15;
    } else if (day == 16) {
      d = AppLocalizations.of(Get.context!).day16;
    } else if (day == 17) {
      d = AppLocalizations.of(Get.context!).day17;
    } else if (day == 18) {
      d = AppLocalizations.of(Get.context!).day18;
    } else if (day == 19) {
      d = AppLocalizations.of(Get.context!).day19;
    } else if (day == 20) {
      d = AppLocalizations.of(Get.context!).day20;
    } else if (day == 21) {
      d = AppLocalizations.of(Get.context!).day21;
    } else if (day == 22) {
      d = AppLocalizations.of(Get.context!).day22;
    } else if (day == 23) {
      d = AppLocalizations.of(Get.context!).day23;
    } else if (day == 24) {
      d = AppLocalizations.of(Get.context!).day24;
    } else if (day == 25) {
      d = AppLocalizations.of(Get.context!).day25;
    } else if (day == 26) {
      d = AppLocalizations.of(Get.context!).day26;
    } else if (day == 27) {
      d = AppLocalizations.of(Get.context!).day27;
    } else if (day == 28) {
      d = AppLocalizations.of(Get.context!).day28;
    } else if (day == 29) {
      d = AppLocalizations.of(Get.context!).day29;
    } else if (day == 30) {
      d = AppLocalizations.of(Get.context!).day30;
    } else if (day == 31) {
      d = AppLocalizations.of(Get.context!).day31;
    }

    if (year == DateTime.now().year) {
      return '$w, $d $m';
    }
    return '$w, $d $m, $year';
  }

  /// '3rd August at 11:00:05', '3rd August, 2021 at 11:00:05' / '3 tháng 8, 2021 lúc 11:00:05'
  String dateTimeToStringV3(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    int year = dateTime.year;
    int month = dateTime.month;
    //int weekday = dateTime.weekday;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;

    String d = '';
    String m = '';
    if (month == 1) {
      m = AppLocalizations.of(Get.context!).month1;
    } else if (month == 2) {
      m = AppLocalizations.of(Get.context!).month2;
    } else if (month == 3) {
      m = AppLocalizations.of(Get.context!).month3;
    } else if (month == 4) {
      m = AppLocalizations.of(Get.context!).month4;
    } else if (month == 5) {
      m = AppLocalizations.of(Get.context!).month5;
    } else if (month == 6) {
      m = AppLocalizations.of(Get.context!).month6;
    } else if (month == 7) {
      m = AppLocalizations.of(Get.context!).month7;
    } else if (month == 8) {
      m = AppLocalizations.of(Get.context!).month8;
    } else if (month == 9) {
      m = AppLocalizations.of(Get.context!).month9;
    } else if (month == 10) {
      m = AppLocalizations.of(Get.context!).month10;
    } else if (month == 11) {
      m = AppLocalizations.of(Get.context!).month11;
    } else if (month == 12) {
      m = AppLocalizations.of(Get.context!).month12;
    }

    if (day == 1) {
      d = AppLocalizations.of(Get.context!).day1;
    } else if (day == 2) {
      d = AppLocalizations.of(Get.context!).day2;
    } else if (day == 3) {
      d = AppLocalizations.of(Get.context!).day3;
    } else if (day == 4) {
      d = AppLocalizations.of(Get.context!).day4;
    } else if (day == 5) {
      d = AppLocalizations.of(Get.context!).day5;
    } else if (day == 6) {
      d = AppLocalizations.of(Get.context!).day6;
    } else if (day == 7) {
      d = AppLocalizations.of(Get.context!).day7;
    } else if (day == 8) {
      d = AppLocalizations.of(Get.context!).day8;
    } else if (day == 9) {
      d = AppLocalizations.of(Get.context!).day9;
    } else if (day == 10) {
      d = AppLocalizations.of(Get.context!).day10;
    } else if (day == 11) {
      d = AppLocalizations.of(Get.context!).day11;
    } else if (day == 12) {
      d = AppLocalizations.of(Get.context!).day12;
    } else if (day == 13) {
      d = AppLocalizations.of(Get.context!).day13;
    } else if (day == 14) {
      d = AppLocalizations.of(Get.context!).day14;
    } else if (day == 15) {
      d = AppLocalizations.of(Get.context!).day15;
    } else if (day == 16) {
      d = AppLocalizations.of(Get.context!).day16;
    } else if (day == 17) {
      d = AppLocalizations.of(Get.context!).day17;
    } else if (day == 18) {
      d = AppLocalizations.of(Get.context!).day18;
    } else if (day == 19) {
      d = AppLocalizations.of(Get.context!).day19;
    } else if (day == 20) {
      d = AppLocalizations.of(Get.context!).day20;
    } else if (day == 21) {
      d = AppLocalizations.of(Get.context!).day21;
    } else if (day == 22) {
      d = AppLocalizations.of(Get.context!).day22;
    } else if (day == 23) {
      d = AppLocalizations.of(Get.context!).day23;
    } else if (day == 24) {
      d = AppLocalizations.of(Get.context!).day24;
    } else if (day == 25) {
      d = AppLocalizations.of(Get.context!).day25;
    } else if (day == 26) {
      d = AppLocalizations.of(Get.context!).day26;
    } else if (day == 27) {
      d = AppLocalizations.of(Get.context!).day27;
    } else if (day == 28) {
      d = AppLocalizations.of(Get.context!).day28;
    } else if (day == 29) {
      d = AppLocalizations.of(Get.context!).day29;
    } else if (day == 30) {
      d = AppLocalizations.of(Get.context!).day30;
    } else if (day == 31) {
      d = AppLocalizations.of(Get.context!).day31;
    }

    String at = AppLocalizations.of(Get.context!).atTime;
    if (year == DateTime.now().year) {
      return '$d $m $at $hour:$minute:$second';
    }
    return '$d $m, $year $at $hour:$minute:$second';
  }

  /// 'Mon, 3rd August at 11:00:05', 'Mon, 3rd August, 2021 at 11:00:05' / 'Thứ Hai, 3 tháng 8, 2021 lúc 11:00:05'
  String dateTimeToStringV4(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    int year = dateTime.year;
    int month = dateTime.month;
    int weekday = dateTime.weekday;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;

    String w = '';
    String d = '';
    String m = '';
    if (weekday == 1) {
      w = AppLocalizations.of(Get.context!).weekday1;
    } else if (weekday == 2) {
      w = AppLocalizations.of(Get.context!).weekday2;
    } else if (weekday == 3) {
      w = AppLocalizations.of(Get.context!).weekday3;
    } else if (weekday == 4) {
      w = AppLocalizations.of(Get.context!).weekday4;
    } else if (weekday == 5) {
      w = AppLocalizations.of(Get.context!).weekday5;
    } else if (weekday == 6) {
      w = AppLocalizations.of(Get.context!).weekday6;
    } else if (weekday == 7) {
      w = AppLocalizations.of(Get.context!).weekday7;
    }

    if (month == 1) {
      m = AppLocalizations.of(Get.context!).month1;
    } else if (month == 2) {
      m = AppLocalizations.of(Get.context!).month2;
    } else if (month == 3) {
      m = AppLocalizations.of(Get.context!).month3;
    } else if (month == 4) {
      m = AppLocalizations.of(Get.context!).month4;
    } else if (month == 5) {
      m = AppLocalizations.of(Get.context!).month5;
    } else if (month == 6) {
      m = AppLocalizations.of(Get.context!).month6;
    } else if (month == 7) {
      m = AppLocalizations.of(Get.context!).month7;
    } else if (month == 8) {
      m = AppLocalizations.of(Get.context!).month8;
    } else if (month == 9) {
      m = AppLocalizations.of(Get.context!).month9;
    } else if (month == 10) {
      m = AppLocalizations.of(Get.context!).month10;
    } else if (month == 11) {
      m = AppLocalizations.of(Get.context!).month11;
    } else if (month == 12) {
      m = AppLocalizations.of(Get.context!).month12;
    }

    if (day == 1) {
      d = AppLocalizations.of(Get.context!).day1;
    } else if (day == 2) {
      d = AppLocalizations.of(Get.context!).day2;
    } else if (day == 3) {
      d = AppLocalizations.of(Get.context!).day3;
    } else if (day == 4) {
      d = AppLocalizations.of(Get.context!).day4;
    } else if (day == 5) {
      d = AppLocalizations.of(Get.context!).day5;
    } else if (day == 6) {
      d = AppLocalizations.of(Get.context!).day6;
    } else if (day == 7) {
      d = AppLocalizations.of(Get.context!).day7;
    } else if (day == 8) {
      d = AppLocalizations.of(Get.context!).day8;
    } else if (day == 9) {
      d = AppLocalizations.of(Get.context!).day9;
    } else if (day == 10) {
      d = AppLocalizations.of(Get.context!).day10;
    } else if (day == 11) {
      d = AppLocalizations.of(Get.context!).day11;
    } else if (day == 12) {
      d = AppLocalizations.of(Get.context!).day12;
    } else if (day == 13) {
      d = AppLocalizations.of(Get.context!).day13;
    } else if (day == 14) {
      d = AppLocalizations.of(Get.context!).day14;
    } else if (day == 15) {
      d = AppLocalizations.of(Get.context!).day15;
    } else if (day == 16) {
      d = AppLocalizations.of(Get.context!).day16;
    } else if (day == 17) {
      d = AppLocalizations.of(Get.context!).day17;
    } else if (day == 18) {
      d = AppLocalizations.of(Get.context!).day18;
    } else if (day == 19) {
      d = AppLocalizations.of(Get.context!).day19;
    } else if (day == 20) {
      d = AppLocalizations.of(Get.context!).day20;
    } else if (day == 21) {
      d = AppLocalizations.of(Get.context!).day21;
    } else if (day == 22) {
      d = AppLocalizations.of(Get.context!).day22;
    } else if (day == 23) {
      d = AppLocalizations.of(Get.context!).day23;
    } else if (day == 24) {
      d = AppLocalizations.of(Get.context!).day24;
    } else if (day == 25) {
      d = AppLocalizations.of(Get.context!).day25;
    } else if (day == 26) {
      d = AppLocalizations.of(Get.context!).day26;
    } else if (day == 27) {
      d = AppLocalizations.of(Get.context!).day27;
    } else if (day == 28) {
      d = AppLocalizations.of(Get.context!).day28;
    } else if (day == 29) {
      d = AppLocalizations.of(Get.context!).day29;
    } else if (day == 30) {
      d = AppLocalizations.of(Get.context!).day30;
    } else if (day == 31) {
      d = AppLocalizations.of(Get.context!).day31;
    }

    String at = AppLocalizations.of(Get.context!).atTime;
    if (year == DateTime.now().year) {
      return '$w, $d $m $at $hour:$minute:$second';
    }
    return '$w, $d $m, $year $at $hour:$minute:$second';
  }

  /// 'Mon, 3rd August, 2022 at 11:00:05' / 'Thứ Hai, 3 tháng 8, 2022 lúc 11:00:05'
  String dateTimeToStringV5(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    int year = dateTime.year;
    int month = dateTime.month;
    int weekday = dateTime.weekday;
    int day = dateTime.day;
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    int second = dateTime.second;

    String w = '';
    String d = '';
    String m = '';
    if (weekday == 1) {
      w = AppLocalizations.of(Get.context!).weekday1;
    } else if (weekday == 2) {
      w = AppLocalizations.of(Get.context!).weekday2;
    } else if (weekday == 3) {
      w = AppLocalizations.of(Get.context!).weekday3;
    } else if (weekday == 4) {
      w = AppLocalizations.of(Get.context!).weekday4;
    } else if (weekday == 5) {
      w = AppLocalizations.of(Get.context!).weekday5;
    } else if (weekday == 6) {
      w = AppLocalizations.of(Get.context!).weekday6;
    } else if (weekday == 7) {
      w = AppLocalizations.of(Get.context!).weekday7;
    }

    if (month == 1) {
      m = AppLocalizations.of(Get.context!).month1;
    } else if (month == 2) {
      m = AppLocalizations.of(Get.context!).month2;
    } else if (month == 3) {
      m = AppLocalizations.of(Get.context!).month3;
    } else if (month == 4) {
      m = AppLocalizations.of(Get.context!).month4;
    } else if (month == 5) {
      m = AppLocalizations.of(Get.context!).month5;
    } else if (month == 6) {
      m = AppLocalizations.of(Get.context!).month6;
    } else if (month == 7) {
      m = AppLocalizations.of(Get.context!).month7;
    } else if (month == 8) {
      m = AppLocalizations.of(Get.context!).month8;
    } else if (month == 9) {
      m = AppLocalizations.of(Get.context!).month9;
    } else if (month == 10) {
      m = AppLocalizations.of(Get.context!).month10;
    } else if (month == 11) {
      m = AppLocalizations.of(Get.context!).month11;
    } else if (month == 12) {
      m = AppLocalizations.of(Get.context!).month12;
    }

    if (day == 1) {
      d = AppLocalizations.of(Get.context!).day1;
    } else if (day == 2) {
      d = AppLocalizations.of(Get.context!).day2;
    } else if (day == 3) {
      d = AppLocalizations.of(Get.context!).day3;
    } else if (day == 4) {
      d = AppLocalizations.of(Get.context!).day4;
    } else if (day == 5) {
      d = AppLocalizations.of(Get.context!).day5;
    } else if (day == 6) {
      d = AppLocalizations.of(Get.context!).day6;
    } else if (day == 7) {
      d = AppLocalizations.of(Get.context!).day7;
    } else if (day == 8) {
      d = AppLocalizations.of(Get.context!).day8;
    } else if (day == 9) {
      d = AppLocalizations.of(Get.context!).day9;
    } else if (day == 10) {
      d = AppLocalizations.of(Get.context!).day10;
    } else if (day == 11) {
      d = AppLocalizations.of(Get.context!).day11;
    } else if (day == 12) {
      d = AppLocalizations.of(Get.context!).day12;
    } else if (day == 13) {
      d = AppLocalizations.of(Get.context!).day13;
    } else if (day == 14) {
      d = AppLocalizations.of(Get.context!).day14;
    } else if (day == 15) {
      d = AppLocalizations.of(Get.context!).day15;
    } else if (day == 16) {
      d = AppLocalizations.of(Get.context!).day16;
    } else if (day == 17) {
      d = AppLocalizations.of(Get.context!).day17;
    } else if (day == 18) {
      d = AppLocalizations.of(Get.context!).day18;
    } else if (day == 19) {
      d = AppLocalizations.of(Get.context!).day19;
    } else if (day == 20) {
      d = AppLocalizations.of(Get.context!).day20;
    } else if (day == 21) {
      d = AppLocalizations.of(Get.context!).day21;
    } else if (day == 22) {
      d = AppLocalizations.of(Get.context!).day22;
    } else if (day == 23) {
      d = AppLocalizations.of(Get.context!).day23;
    } else if (day == 24) {
      d = AppLocalizations.of(Get.context!).day24;
    } else if (day == 25) {
      d = AppLocalizations.of(Get.context!).day25;
    } else if (day == 26) {
      d = AppLocalizations.of(Get.context!).day26;
    } else if (day == 27) {
      d = AppLocalizations.of(Get.context!).day27;
    } else if (day == 28) {
      d = AppLocalizations.of(Get.context!).day28;
    } else if (day == 29) {
      d = AppLocalizations.of(Get.context!).day29;
    } else if (day == 30) {
      d = AppLocalizations.of(Get.context!).day30;
    } else if (day == 31) {
      d = AppLocalizations.of(Get.context!).day31;
    }

    String at = AppLocalizations.of(Get.context!).atTime;
    return '$w, $d $m, $year $at $hour:$minute:$second';
  }

  /// 19 hours
  String dateTimeToDurationStringShort(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    var duration = DateTime.now().difference(dateTime);
    if (duration.isNegative) {
      return '';
    }
    int year = duration.inDays ~/ 365;
    int month = duration.inDays ~/ 31;
    int week = duration.inDays ~/ 7;
    int day = duration.inDays;
    int hour = duration.inHours;
    int minute = duration.inMinutes;
    int second = duration.inSeconds;
    if (year > 1) {
      return '$year ${AppLocalizations.of(Get.context!).years}';
    }
    if (year == 1) {
      return '$year ${AppLocalizations.of(Get.context!).year}';
    }
    if (month > 1) {
      return '$month ${AppLocalizations.of(Get.context!).months}';
    }
    if (month == 1) {
      return '$month ${AppLocalizations.of(Get.context!).month}';
    }
    if (week > 1) {
      return '$week ${AppLocalizations.of(Get.context!).weeks}';
    }
    if (week == 1) {
      return '$week ${AppLocalizations.of(Get.context!).week}';
    }
    if (day > 1) {
      return '$day ${AppLocalizations.of(Get.context!).days}';
    }
    if (day == 1) {
      return '$day ${AppLocalizations.of(Get.context!).day}';
    }
    if (hour > 1) {
      return '$hour ${AppLocalizations.of(Get.context!).hours}';
    }
    if (hour == 1) {
      return '$hour ${AppLocalizations.of(Get.context!).hour}';
    }
    if (minute > 1) {
      return '$minute ${AppLocalizations.of(Get.context!).minutes}';
    }
    if (minute == 1) {
      return '$minute ${AppLocalizations.of(Get.context!).minute}';
    }
    if (second > 1) {
      return '$second ${AppLocalizations.of(Get.context!).seconds}';
    }
    if (second == 1) {
      return '$second ${AppLocalizations.of(Get.context!).second}';
    }
    if (second == 0) {
      return '$second ${AppLocalizations.of(Get.context!).second}';
    }
    return '';
  }

  /// 19 hours ago
  String dateTimeToDurationString(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    dateTime = dateTime.toLocal();
    var duration = DateTime.now().difference(dateTime);
    if (duration.isNegative) {
      return '';
    }
    int year = duration.inDays ~/ 365;
    int month = duration.inDays ~/ 31;
    int week = duration.inDays ~/ 7;
    int day = duration.inDays;
    int hour = duration.inHours;
    int minute = duration.inMinutes;
    int second = duration.inSeconds;
    if (year > 1) {
      return '$year ${AppLocalizations.of(Get.context!).years} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (year == 1) {
      return '$year ${AppLocalizations.of(Get.context!).year} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (month > 1) {
      return '$month ${AppLocalizations.of(Get.context!).months} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (month == 1) {
      return '$month ${AppLocalizations.of(Get.context!).month} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (week > 1) {
      return '$week ${AppLocalizations.of(Get.context!).weeks} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (week == 1) {
      return '$week ${AppLocalizations.of(Get.context!).week} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (day > 1) {
      return '$day ${AppLocalizations.of(Get.context!).days} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (day == 1) {
      return '$day ${AppLocalizations.of(Get.context!).day} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (hour > 1) {
      return '$hour ${AppLocalizations.of(Get.context!).hours} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (hour == 1) {
      return '$hour ${AppLocalizations.of(Get.context!).hour} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (minute > 1) {
      return '$minute ${AppLocalizations.of(Get.context!).minutes} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (minute == 1) {
      return '$minute ${AppLocalizations.of(Get.context!).minute} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (second > 1) {
      return '$second ${AppLocalizations.of(Get.context!).seconds} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (second == 1) {
      return '$second ${AppLocalizations.of(Get.context!).second} ${AppLocalizations.of(Get.context!).ago}';
    }
    if (second == 0) {
      return '$second ${AppLocalizations.of(Get.context!).second} ${AppLocalizations.of(Get.context!).ago}';
    }
    return '';
  }

  /// '123':123, '0':0, '-1':0, 'abc':0, '':null
  int? parsePrice(String? price) {
    if (price == null) {
      return null;
    }
    final number = int.tryParse(price);
    if (number == null || number < 0) {
      return 0;
    }
    return number;
  }

  /// 'AStreet' / 'BDistrict' / 'CCity'
  String addressToStringV1({
    UserAddress? userAddress,
    PostAddress? postAddress,
    ShipmentAddressFrom? shipmentAddressFrom,
    ShipmentAddressTo? shipmentAddressTo,
  }) {
    final address = Address(
      details: userAddress?.details ??
          postAddress?.details ??
          shipmentAddressFrom?.details ??
          shipmentAddressTo?.details ??
          '',
      street: userAddress?.street ??
          postAddress?.street ??
          shipmentAddressFrom?.street ??
          shipmentAddressTo?.street ??
          '',
      district: userAddress?.district ??
          postAddress?.district ??
          shipmentAddressFrom?.district ??
          shipmentAddressTo?.district ??
          '',
      city: userAddress?.city ??
          postAddress?.city ??
          shipmentAddressFrom?.city ??
          shipmentAddressTo?.city ??
          '',
      location: userAddress?.location ??
          postAddress?.location ??
          shipmentAddressFrom?.location ??
          shipmentAddressTo?.location,
    );
    if (address.street.isNotEmpty) {
      return address.street;
    }
    if (address.district.isNotEmpty) {
      return address.district;
    }
    if (address.city.isNotEmpty) {
      return address.city;
    }
    return '';
  }

  /// 'AStreet, BDistrict, CCity'
  String addressToStringV2({
    UserAddress? userAddress,
    PostAddress? postAddress,
    ShipmentAddressFrom? shipmentAddressFrom,
    ShipmentAddressTo? shipmentAddressTo,
  }) {
    final address = Address(
      details: userAddress?.details ??
          postAddress?.details ??
          shipmentAddressFrom?.details ??
          shipmentAddressTo?.details ??
          '',
      street: userAddress?.street ??
          postAddress?.street ??
          shipmentAddressFrom?.street ??
          shipmentAddressTo?.street ??
          '',
      district: userAddress?.district ??
          postAddress?.district ??
          shipmentAddressFrom?.district ??
          shipmentAddressTo?.district ??
          '',
      city: userAddress?.city ??
          postAddress?.city ??
          shipmentAddressFrom?.city ??
          shipmentAddressTo?.city ??
          '',
      location: userAddress?.location ??
          postAddress?.location ??
          shipmentAddressFrom?.location ??
          shipmentAddressTo?.location,
    );
    return '${address.street}, ${address.district}, ${address.city}';
  }

  /// '123, AStreet, BDistrict, CCity' // 'AStreet, BDistrict, CCity'
  String addressToStringV3({
    UserAddress? userAddress,
    PostAddress? postAddress,
    ShipmentAddressFrom? shipmentAddressFrom,
    ShipmentAddressTo? shipmentAddressTo,
  }) {
    final address = Address(
      details: userAddress?.details ??
          postAddress?.details ??
          shipmentAddressFrom?.details ??
          shipmentAddressTo?.details ??
          '',
      street: userAddress?.street ??
          postAddress?.street ??
          shipmentAddressFrom?.street ??
          shipmentAddressTo?.street ??
          '',
      district: userAddress?.district ??
          postAddress?.district ??
          shipmentAddressFrom?.district ??
          shipmentAddressTo?.district ??
          '',
      city: userAddress?.city ??
          postAddress?.city ??
          shipmentAddressFrom?.city ??
          shipmentAddressTo?.city ??
          '',
      location: userAddress?.location ??
          postAddress?.location ??
          shipmentAddressFrom?.location ??
          shipmentAddressTo?.location,
    );

    if (address.details.isNotEmpty) {
      return address.details;
    }
    return '${address.street}, ${address.district}, ${address.city}';
  }

  String conversationIdBy2UserIds(String userId1, String userId2) {
    var conversationId = '';
    if (userId1.compareTo(userId2) > 0) {
      conversationId = '${userId1}_$userId2';
    } else {
      conversationId = '${userId2}_$userId1';
    }
    return conversationId;
  }

  String conversationTitleByNames(List<String> names) {
    String title = '';
    var names1 = names.take(2).toList();
    var names2 = names.skip(2).take(10).toList();
    if (names2.isNotEmpty) {
      for (var e in names2) {
        title += '$e, ';
      }
    }
    if (names1.length == 2) {
      title += '${names1[0]} and ${names1[1]}';
    } else {
      if (names1.length == 1) {
        title += names1[0];
      }
    }
    return title;
  }
}

StringHelper stringHelper = StringHelper();

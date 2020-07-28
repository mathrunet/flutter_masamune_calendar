// Copyright 2020 mathru. All rights reserved.

/// Masamune calendar framework library.
///
/// To use, import `package:masamune_calendar/masamune_calendar.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library masamune.calendar;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:masamune_flutter/masamune_flutter.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';
export 'package:masamune_flutter/masamune_flutter.dart';

part 'reservationcalendar.dart';
part 'uicalendar.dart';

part 'calendar/calendar.dart';
part 'calendar/calendar_controller.dart';

part 'calendar/customization/calendar_builders.dart';
part 'calendar/customization/calendar_style.dart';
part 'calendar/customization/days_of_week_style.dart';
part 'calendar/customization/header_style.dart';

part 'calendar/widgets/cell_widget.dart';
part 'calendar/widgets/custom_icon_button.dart';

part of masamune.calendar;

/// Widget for booking calendar.
class ReservationCalendar extends UIWidget {
  /// The default checker passed to ReservationCalendar.
  ///
  /// [reservingDuration]: The time you are trying to book.
  /// [reservationCountMap]: Count map.
  /// Obtained from [ReservationCalendar.reservationCountMap()].
  /// [maxReservationCount]: Maximum number of people that can be reserved.
  /// [duration]: Calendar interval.
  static bool Function(DateTime) reservationChecker(
      {@required Duration reservingDuration,
      @required Map<DateTime, int> reservationCountMap,
      int maxReservationCount = 1,
      Duration duration = const Duration(minutes: 30)}) {
    return (dateTime) {
      for (DateTime time = dateTime;
          time.millisecondsSinceEpoch <
              dateTime.millisecondsSinceEpoch +
                  reservingDuration.inMilliseconds;
          time = time.add(duration)) {
        if (reservationCountMap.containsKey(time) &&
            reservationCountMap[time] >= maxReservationCount) return false;
      }
      return true;
    };
  }

  /// Acquiring reservation data for reservations made by multiple staff.
  ///
  /// [reservationData]: Saved reservation data.
  /// [startTime]: The start time to get.
  /// [endTime]: The end time to get.
  /// [duration]: Interval to get.
  /// [startTimeKey]: The key of the start time in the reservation data.
  /// [endTimeKey]: The key of the end time in the reservation data.
  static Map<DateTime, int> reservationCountMap(
      {@required Iterable<IDataDocument> reservationData,
      DateTime startTime,
      DateTime endTime,
      Duration duration = const Duration(minutes: 30),
      String startTimeKey = "startTime",
      String endTimeKey = "endTime"}) {
    DateTime now = DateTime.now();
    if (startTime == null)
      startTime = DateTime(now.year, now.month, now.day, 0, 0, 0);
    if (endTime == null)
      endTime = DateTime(now.year, now.month, now.day, 0, 0, 0)
          .add(Duration(days: 8));
    Map<DateTime, int> reservation = {};
    for (DateTime time = startTime;
        time.millisecondsSinceEpoch <= endTime.millisecondsSinceEpoch;
        time = time.add(duration)) {
      int start = time.millisecondsSinceEpoch;
      int end = start + duration.inMilliseconds;
      reservation[time] =
          reservationData?.fold<int>(0, (previousValue, element) {
        if (element.getInt(startTimeKey) <= start &&
            start < element.getInt(endTimeKey)) {
          previousValue++;
        } else if (element.getInt(startTimeKey) < end &&
            end <= element.getInt(endTimeKey)) {
          previousValue++;
        }
        return previousValue;
      });
    }
    return reservation;
  }

  /// Processing when tapped.
  final void Function(DateTime dateTime) onTap;

  /// Callback that determines if it is bookable.
  ///
  /// If True is returned, reservation is possible.
  final bool Function(DateTime dateTime) checker;

  /// Background color of the cell when it is bookable.
  final Color enableColor;

  /// Background color of the cell when it is not bookable.
  final Color disableColor;

  /// Icon when booking is possible.
  final Widget enableIcon;

  /// Icon when reservation is not possible.
  final Widget disableIcon;

  /// Reservable date.
  final DateTime startDate;

  /// The date for which you want to display the reservation.
  final DateTime endDate;

  /// Reservable time.
  final DateTime startTime;

  /// Reservable end time.
  final DateTime endTime;

  /// Reservation unit.
  final Duration timeDuration;

  /// Reservation day unit.
  final Duration dateDuration;

  /// Widget for booking calendar.
  ///
  /// [onTap]: Processing when tapped.
  /// [checker]: Callback that determines if it is bookable.
  /// If True is returned, reservation is possible.
  /// [enableColor]: Background color of the cell when it is bookable.
  /// [disableColor]: Background color of the cell when it is not bookable.
  /// [enableIcon]: Icon when booking is possible.
  /// [disableIcon]: Icon when reservation is not possible.
  /// [startDate]: Reservable date.
  /// [startTime]: Reservable time.
  /// [endDate]: The date for which you want to display the reservation.
  /// [endTime]: Reservable end time.
  /// [timeDuration]: Reservation unit.
  /// [dateDuration]: Reservation day unit.
  ReservationCalendar(
      {this.checker,
      this.onTap,
      this.enableColor,
      this.disableColor,
      this.enableIcon,
      this.disableIcon,
      this.startDate,
      this.startTime,
      this.endDate,
      this.endTime,
      this.timeDuration = const Duration(minutes: 30),
      this.dateDuration = const Duration(days: 1)});

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startDate =
        this.startDate ?? DateTime(now.year, now.month, now.day);
    DateTime endDate = this.endDate ?? startDate.add(Duration(days: 7));
    DateTime startTime =
        this.startTime ?? DateTime(now.year, now.month, now.day, 9, 0, 0);
    DateTime endTime =
        this.endTime ?? DateTime(now.year, now.month, now.day, 18, 0, 0);
    return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Row(
          children: <Widget>[
            Container(
                width: 80,
                child: Column(children: <Widget>[
                  Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: context.theme.dividerColor),
                        right: BorderSide(
                            width: 1.0, color: context.theme.dividerColor),
                      ))),
                  for (DateTime time = startTime;
                      time.millisecondsSinceEpoch <=
                          endTime.millisecondsSinceEpoch;
                      time = time.add(timeDuration))
                    Container(
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0, color: context.theme.dividerColor),
                            right: BorderSide(
                                width: 1.0, color: context.theme.dividerColor),
                          ),
                        ),
                        child: Text(
                            "${time.hour.format("00")}:${time.minute.format("00")}"))
                ])),
            Container(
                width: context.mediaQuery.size.width - 80,
                height: (endTime.difference(startTime).inMinutes /
                            timeDuration.inMinutes +
                        2) *
                    50,
                child: ListView(
                    physics: const ClampingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for (DateTime date = startDate;
                          date.millisecondsSinceEpoch <=
                              endDate.millisecondsSinceEpoch;
                          date = date.add(dateDuration))
                        Container(
                            width: 100,
                            child: Column(children: <Widget>[
                              Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                        width: 1.0,
                                        color: context.theme.dividerColor),
                                    right: BorderSide(
                                        width: 1.0,
                                        color: context.theme.dividerColor),
                                  )),
                                  child: Text(
                                      "${date.month}/${date.day} (${date.shortLocalizedWeekDay})")),
                              for (DateTime time = startTime;
                                  time.millisecondsSinceEpoch <=
                                      endTime.millisecondsSinceEpoch;
                                  time = time.add(timeDuration))
                                this._getCell(context, date, time)
                            ]))
                    ]))
          ],
        ));
  }

  Widget _getCell(BuildContext context, DateTime date, DateTime time) {
    DateTime dateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute, time.second);
    bool enabled = (this.checker != null) ? this.checker(dateTime) : false;
    return GestureDetector(
        onTap: () {
          if (!enabled) return;
          if (this.onTap != null) this.onTap(dateTime);
        },
        child: Container(
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: enabled ? enableColor : disableColor,
                border: Border(
                  bottom:
                      BorderSide(width: 1.0, color: context.theme.dividerColor),
                  right:
                      BorderSide(width: 1.0, color: context.theme.dividerColor),
                )),
            child: enabled ? enableIcon : disableIcon));
  }
}

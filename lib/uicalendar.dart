part of masamune.calendar;

/// Widget that provides a calendar function.
///
/// Tap the date on the monthly calendar to display the event details.
///
/// You can also tap the event to take action.
class UICalendar extends StatefulWidget {
  /// Widget that provides a calendar function.
  ///
  /// Tap the date on the monthly calendar to display the event details.
  ///
  /// You can also tap the event to take action.
  /// [events]: Event list.
  /// [onTap]: Processing when an event is tapped.
  /// [holidays]: Holiday list.
  /// [initialDay]: First date to choose.
  /// [startTimeKey]: Key for event start time.
  /// [endTimeKey]: Key for event end time.
  /// [titleBuilder]: Builder for getting the title.
  /// [textBuilder]: Builder for getting text.
  /// [allDayKey]: True if the event is all day.
  /// [animationTime]: Animation time.
  /// [expand]: Display the calendar in the full width of the parent widget.
  /// [heightOfDayOfWeekLabel]: DayOfWeek label height.
  /// [calendarContentBorder]: Specify all borders of the calendar.
  /// [highlightTodayColor]: Color for highlighting today.
  /// [highlightSelectedDayColor]: The color when the selected date is highlighted.
  /// [dayBuilder]: Day builder.
  /// [selectedDayBuilder]: Selected day builder.
  /// [todayDayBuilder]: Today day builder.
  /// [titleKey]: The name key.
  /// [textKey]: The text key.
  /// [markersBuilder]: Markers builder.
  /// [onDaySelect]: What happens when a date is selected.
  /// [onDayLongPressed]: What happens when a date is long pressed.
  /// [highlightToday]: True to highlight today.
  /// [highlightSelectedDay]: True to highlight the selected days.
  /// [markerIcon]: Icons for markers.
  /// [markerType]: Marker type of calendar.
  /// [markerItemBuilder]: Builder for each item in the marker.
  UICalendar(
      {Key key,
      this.events,
      this.holidays,
      this.initialDay,
      this.markerIcon,
      this.markerType = UICalendarMarkerType.count,
      this.markerItemBuilder,
      this.onTap,
      this.startTimeKey = "startTime",
      this.endTimeKey = "endTime",
      this.titleKey = "name",
      this.textKey = "text",
      this.titleBuilder,
      this.textBuilder,
      this.allDayKey = "allDay",
      this.expand = false,
      this.heightOfDayOfWeekLabel = 20,
      this.calendarContentBorder,
      this.dayBuilder,
      this.selectedDayBuilder,
      this.highlightTodayColor,
      this.highlightSelectedDayColor,
      this.highlightSelectedDay = true,
      this.highlightToday = true,
      this.todayDayBuilder,
      this.markersBuilder,
      this.onDaySelect,
      this.onDayLongPressed,
      this.animationTime = const Duration(milliseconds: 300)})
      : assert(markerType == UICalendarMarkerType.icon && markerIcon != null ||
            markerType == UICalendarMarkerType.list &&
                markerItemBuilder != null),
        super(key: key);

  /// Display the calendar in the full width of the parent widget.
  final bool expand;

  /// DayOfWeek label height.
  final double heightOfDayOfWeekLabel;

  /// Specify all borders of the calendar.
  final TableBorder calendarContentBorder;

  /// Event list.
  final IDataCollection events;

  /// Processing when an event is tapped.
  final void Function(EventData eventData) onTap;

  /// Holiday list.
  final IDataCollection holidays;

  /// First date to choose.
  final DateTime initialDay;

  /// Key for event start time.
  final String startTimeKey;

  /// Key for event end time.
  final String endTimeKey;

  /// True to highlight today.
  final bool highlightToday;

  /// Color for highlighting today.
  final Color highlightTodayColor;

  /// True to highlight the selected days.
  final bool highlightSelectedDay;

  /// The color when the selected date is highlighted.
  final Color highlightSelectedDayColor;

  /// Builder for getting the title.
  final String Function(IDataDocument document) titleBuilder;

  /// Builder for getting text.
  final String Function(IDataDocument document) textBuilder;

  /// The name key.
  final String titleKey;

  /// The text key.
  final String textKey;

  /// True if the event is all day.
  final String allDayKey;

  /// Animation time.
  final Duration animationTime;

  /// Day builder.
  final Widget Function(
      BuildContext context, DateTime date, List<EventData> events) dayBuilder;

  /// Selected day builder.
  final Widget Function(
          BuildContext context, DateTime date, List<EventData> events)
      selectedDayBuilder;

  /// Today day builder.
  final Widget Function(
          BuildContext context, DateTime date, List<EventData> events)
      todayDayBuilder;

  /// Markers builder.
  final List<Widget> Function(BuildContext context, DateTime date,
      List<EventData> events, List<EventData> holidays) markersBuilder;

  /// What happens when a date is selected.
  final void Function(
          DateTime day, List<EventData> events, List<EventData> holidays)
      onDaySelect;

  /// What happens when a date is long pressed.
  final void Function(
          DateTime day, List<EventData> events, List<EventData> holidays)
      onDayLongPressed;

  /// Marker type of calendar.
  final UICalendarMarkerType markerType;

  /// Builder for each item in the marker.
  final Widget Function(EventData event) markerItemBuilder;

  /// Icons for markers.
  final Widget markerIcon;

  @override
  _UICalendarState createState() => _UICalendarState();
}

class _UICalendarState extends State<UICalendar> with TickerProviderStateMixin {
  Map<DateTime, List<EventData>> _events = MapPool.get();
  Map<DateTime, List<EventData>> _holidays = MapPool.get();
  List<EventData> _selectedEvents = ListPool.get();
  AnimationController _animationController;
  CalendarController _calendarController;
  @override
  void initState() {
    super.initState();
    this.widget.events?.listen(this._notifyUpdate);
    this.widget.holidays?.listen(this._notifyUpdate);
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    this.widget.events?.unlisten(this._notifyUpdate);
    this.widget.holidays.unlisten(this._notifyUpdate);
    super.dispose();
  }

  void _notifyUpdate(IDataCollection path) {
    setState(() {});
  }

  void _onDaySelected(
      DateTime day, List<EventData> events, List<EventData> holidays) {
    setState(() {});
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {}
  void _initEventData() {
    if (this.widget.events == null) return;
    this._events.clear();
    for (IDataDocument doc in this.widget.events) {
      if (doc == null) continue;
      DateTime startTime = doc.containsKey(this.widget.startTimeKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              doc.getInt(this.widget.startTimeKey))
          : null;
      DateTime endTime = doc.containsKey(this.widget.endTimeKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              doc.getInt(this.widget.endTimeKey))
          : null;
      if (startTime == null) continue;
      DateTime startDay =
          DateTime(startTime.year, startTime.month, startTime.day, 12).toUtc();
      if (this._events.containsKey(startDay)) {
        this._events[startDay].add(EventData(
            startTime: startTime,
            endTime: endTime,
            data: doc,
            title: this.widget.titleBuilder != null
                ? this.widget.titleBuilder(doc)
                : doc.getString(this.widget.titleKey) ?? Const.empty,
            text: this.widget.textBuilder != null
                ? this.widget.textBuilder(doc)
                : doc.getString(this.widget.textKey) ?? Const.empty,
            allDay: doc.getBool(this.widget.allDayKey, false)));
      } else {
        this._events[startDay] = [
          EventData(
              startTime: startTime,
              endTime: endTime,
              data: doc,
              title: this.widget.titleBuilder != null
                  ? this.widget.titleBuilder(doc)
                  : doc.getString(this.widget.titleKey) ?? Const.empty,
              text: this.widget.textBuilder != null
                  ? this.widget.textBuilder(doc)
                  : doc.getString(this.widget.textKey) ?? Const.empty,
              allDay: doc.getBool(this.widget.allDayKey, false))
        ];
      }
    }
  }

  void _initHolidayData() {
    if (this.widget.holidays == null) return;
    this._holidays.clear();
    for (IDataDocument doc in this.widget.holidays) {
      if (doc == null) continue;
      DateTime startTime = doc.containsKey(this.widget.startTimeKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              doc.getInt(this.widget.startTimeKey))
          : null;
      if (startTime == null) continue;
      DateTime startDay =
          DateTime(startTime.year, startTime.month, startTime.day, 12).toUtc();
      if (this._events.containsKey(startDay)) {
        this._events[startDay].add(EventData(
            startTime: startDay,
            data: doc,
            title: this.widget.titleBuilder != null
                ? this.widget.titleBuilder(doc)
                : doc.getString(this.widget.titleKey) ?? Const.empty,
            text: this.widget.textBuilder != null
                ? this.widget.textBuilder(doc)
                : doc.getString(this.widget.textKey) ?? Const.empty,
            allDay: true));
      } else {
        this._events[startDay] = [
          EventData(
              startTime: startDay,
              data: doc,
              title: this.widget.titleBuilder != null
                  ? this.widget.titleBuilder(doc)
                  : doc.getString(this.widget.titleKey) ?? Const.empty,
              text: this.widget.textBuilder != null
                  ? this.widget.textBuilder(doc)
                  : doc.getString(this.widget.textKey) ?? Const.empty,
              allDay: true)
        ];
      }
    }
  }

  void _initSelectedEvents() {
    if (this._events == null) return;
    if (this._calendarController == null ||
        this._calendarController.focusedDay == null) return;
    DateTime date = DateTime(
            this._calendarController.focusedDay.year,
            this._calendarController.focusedDay.month,
            this._calendarController.focusedDay.day,
            12)
        .toUtc();
    this._selectedEvents = this._events[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    this._initEventData();
    this._initHolidayData();
    this._initSelectedEvents();
    if (this.widget.expand) {
      return _buildTableCalendarWithBuilders();
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildTableCalendarWithBuilders()),
          Expanded(child: _buildEventList()),
        ],
      );
    }
  }

  Widget _buildTableCalendarWithBuilders() {
    return _TableCalendar(
      initialSelectedDay: this.widget.initialDay ?? DateTime.now(),
      locale: Localize.locale,
      weekendDays: [7],
      calendarController: this._calendarController,
      events: this._events,
      holidays: this._holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: Const.empty,
        CalendarFormat.week: Const.empty,
      },
      expand: this.widget.expand,
      calendarContentBorder: this.widget.calendarContentBorder,
      heightOfDayOfWeekLabel: this.widget.heightOfDayOfWeekLabel,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        contentPadding: this.widget.expand
            ? const EdgeInsets.all(0)
            : const EdgeInsets.only(bottom: 4.0, left: 8.0, right: 8.0),
        weekendStyle: TextStyle(color: Colors.red[800]),
        holidayStyle: TextStyle(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          if (this.widget.dayBuilder != null) {
            return this
                .widget
                .dayBuilder(context, date, events.cast<EventData>());
          }
          return Container(
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: context.theme.backgroundColor,
            constraints: BoxConstraints.expand(),
            child: Text(
              "${date.day}",
              style: TextStyle(fontSize: 16.0),
            ),
          );
        },
        selectedDayBuilder: this.widget.selectedDayBuilder != null
            ? (context, date, events) {
                return this.widget.selectedDayBuilder(
                    context, date, events.cast<EventData>());
              }
            : (this.widget.highlightSelectedDay
                ? (context, date, _) {
                    return FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0)
                          .animate(_animationController),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                        color: this.widget.highlightSelectedDayColor ??
                            context.theme.primaryColor,
                        constraints: BoxConstraints.expand(),
                        width: 100,
                        height: 100,
                        child: Text(
                          "${date.day}",
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                      ),
                    );
                  }
                : null),
        todayDayBuilder: this.widget.todayDayBuilder != null
            ? (context, date, events) {
                return this
                    .widget
                    .todayDayBuilder(context, date, events.cast<EventData>());
              }
            : (this.widget.highlightToday
                ? (context, date, _) {
                    return Container(
                      padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                      color: this.widget.highlightTodayColor ??
                          context.theme.primaryColor.withOpacity(0.5),
                      constraints: BoxConstraints.expand(),
                      child: Text(
                        "${date.day}",
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    );
                  }
                : null),
        markersBuilder: (context, date, events, holidays) {
          if (this.widget.markersBuilder != null) {
            return this.widget.markersBuilder(context, date,
                events.cast<EventData>(), holidays.cast<EventData>());
          }
          return _defaultMarkers(context, date, events.cast<EventData>(),
              holidays.cast<EventData>());
        },
      ),
      onDaySelected: (date, events, holidays) {
        final firstDate = DateTime(date.year, date.month, date.day);
        _onDaySelected(
            firstDate, events.cast<EventData>(), holidays.cast<EventData>());
        if (this.widget.onDaySelect != null)
          this.widget.onDaySelect(
              firstDate, events.cast<EventData>(), holidays.cast<EventData>());
        _animationController.forward(from: 0.0);
      },
      onDayLongPressed: (date, events, holidays) {
        final firstDate = DateTime(date.year, date.month, date.day);
        if (this.widget.onDayLongPressed != null)
          this.widget.onDayLongPressed(
              firstDate, events.cast<EventData>(), holidays.cast<EventData>());
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  List<Widget> _defaultMarkers(BuildContext context, DateTime date,
      List<EventData> events, List<EventData> holidays) {
    switch (this.widget.markerType) {
      case (UICalendarMarkerType.icon):
        return [
          Container(
            constraints: BoxConstraints.expand(),
            padding: const EdgeInsets.only(
              top: 30,
              left: 4,
              right: 4,
              bottom: 4,
            ),
            child: Center(
              child: this.widget.markerIcon,
            ),
          )
        ];
      case (UICalendarMarkerType.list):
        return [
          DefaultTextStyle(
            style: TextStyle(
                fontSize: 10,
                color: _calendarController.isToday(date)
                    ? Colors.white
                    : context.theme.textTheme.bodyText1.color),
            child: Container(
              constraints: BoxConstraints.expand(),
              padding: const EdgeInsets.only(
                top: 30,
                left: 4,
                right: 0,
                bottom: 0,
              ),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  ...events.mapAndRemoveEmpty(
                      (item) => this.widget.markerItemBuilder(item)),
                  ...holidays.mapAndRemoveEmpty(
                      (item) => this.widget.markerItemBuilder(item))
                ],
              ),
            ),
          )
        ];
      default:
        return [
          if (events.isNotEmpty)
            Positioned(
              right: 1,
              bottom: 1,
              child: _buildEventsMarker(date, events),
            ),
          if (holidays.isNotEmpty)
            Positioned(
              right: -2,
              top: -2,
              child: _buildHolidaysMarker(),
            ),
        ];
    }
  }

  Widget _buildEventsMarker(DateTime date, List<EventData> events) {
    return AnimatedContainer(
      duration: this.widget.animationTime,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? context.theme.accentColor
            : _calendarController.isToday(date)
                ? context.theme.accentColor
                : context.theme.accentColor.withOpacity(0.5),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          "${events.length}",
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Container(
        alignment: Alignment.center,
        color: context.theme.accentColor,
        child: Icon(Icons.add, size: 20.0, color: Colors.white));
  }

  Widget _buildEventList() {
    return ListView(children: [
      Container(
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
              DateFormat.yMMMd(Localize.locale).format(
                  this._calendarController.selectedDay ?? DateTime.now()),
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ...this._selectedEvents.mapAndRemoveEmpty((event) => Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: (isNotEmpty(event.text))
                ? ListTile(
                    isThreeLine: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text("${event.timeString}")),
                        Flexible(child: Text("${event.title}"))
                      ],
                    ),
                    subtitle: Text(event.text),
                    onTap: () {
                      if (this.widget.onTap != null) this.widget.onTap(event);
                    },
                  )
                : ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text("${event.timeString}")),
                        Flexible(child: Text("${event.title}"))
                      ],
                    ),
                    onTap: () {
                      if (this.widget.onTap != null) this.widget.onTap(event);
                    },
                  ),
          ))
    ]);
  }
}

/// Class for storing event data.
class EventData {
  /// Start date and time.
  final DateTime startTime;

  /// End date and time.
  final DateTime endTime;

  /// Event title.
  final String title;

  /// Event details.
  final String text;

  /// True if the event is all day.
  final bool allDay;

  /// Raw data for the event.
  final IDataDocument data;

  /// Class for storing event data.
  ///
  /// [startTime]: Start date and time.
  /// [endTime]: End date and time.
  /// [title]: Event title.
  /// [text]: Event details.
  /// [allDay]: True if the event is all day.
  /// [data]: Raw data for the event.
  const EventData(
      {@required this.startTime,
      this.data,
      this.endTime,
      @required this.title,
      this.text,
      this.allDay = false});

  /// Gets the time string.
  ///
  /// If it is all day, it will be displayed as all day.
  ///
  /// If there is no end time, only the start time is displayed.
  String get timeString {
    if (this.allDay) return Localize.get("All day");
    String tmp =
        "${this.startTime.hour.format("00")}:${this.startTime.minute.format("00")} -";
    if (endTime == null ||
        startTime.millisecondsSinceEpoch >= endTime.millisecondsSinceEpoch)
      return tmp;
    return "$tmp ${this.endTime.hour.format("00")}:${this.endTime.minute.format("00")}";
  }
}

/// Marker type of calendar.
enum UICalendarMarkerType {
  /// Show a number of events.
  count,

  /// Show a icon.
  icon,

  /// Show a list of events.
  list
}

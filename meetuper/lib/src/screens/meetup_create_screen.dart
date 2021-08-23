import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetuper/src/models/category.dart';
import 'package:meetuper/src/models/forms.dart';
import 'package:meetuper/src/screens/meetup_detail_screen.dart';
import 'package:meetuper/src/screens/meetup_home_screen.dart';
import 'package:meetuper/src/services/meetup_api_service.dart';
import 'package:intl/intl.dart';
import 'package:meetuper/src/utils/generate_times.dart';
import 'package:meetuper/src/widget/select_input.dart';

class MeetupCreateScreen extends StatefulWidget {
  static final String route = '/meetupCreate';

  MeetupCreateScreenState createState() => MeetupCreateScreenState();
}

class MeetupCreateScreenState extends State<MeetupCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late BuildContext _scaffoldContext;
  List<Category> _categories = [];
  final List<String> _times = generateTimes();

  MeetupFormData _meetupFormData = MeetupFormData();
  MeetupApiService _api = MeetupApiService();

  @override
  void initState() {
    _fetchCategories();
    super.initState();
  }

  void _fetchCategories() async {
    final categories = await _api.fetchCategories();
    setState(() {
      _categories = categories;
    });
  }

  void _submitCreate() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      _api.createMeetup(_meetupFormData).then((String meetupId) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    MeetupDetailScreen(meetupId: meetupId)),
            ModalRoute.withName('/'));
      }).catchError((e) {
        print(e);
      });
    }
  }

  _handleDateChange(DateTime selectedDate) {
    _meetupFormData.startDate = selectedDate;
  }

  _handleCategoryChange(Category category) {
    _meetupFormData.category = category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create Meetup')),
        body: Builder(builder: (context) {
          _scaffoldContext = context;
          return Padding(padding: EdgeInsets.all(20.0), child: _buildForm());
        }));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          _buildTitle(),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Location',
            ),
            onSaved: (value) {
              if (value != null) {
                _meetupFormData.location = value;
              }
            },
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Title',
            ),
            onSaved: (value) {
              if (value != null) {
                _meetupFormData.title = value;
              }
            },
          ),
          _DatePicker(onDateChange: _handleDateChange),
          SelectInput<Category>(
              items: _categories,
              onChange: _handleCategoryChange,
              label: 'Category',
              value: null),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(30)],
            decoration: InputDecoration(
              hintText: 'Image',
            ),
            onSaved: (value) {
              if (value != null) {
                _meetupFormData.image = value;
              }
            },
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(100)],
            decoration: InputDecoration(
              hintText: 'Short Info',
            ),
            onSaved: (value) {
              if (value != null) {
                _meetupFormData.shortInfo = value;
              }
            },
          ),
          TextFormField(
            style: Theme.of(context).textTheme.headline6,
            inputFormatters: [LengthLimitingTextInputFormatter(200)],
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            onSaved: (value) {
              if (value != null) {
                _meetupFormData.description = value;
              }
            },
          ),
          SelectInput<String>(
              items: _times,
              onChange: (String t) {
                _meetupFormData.timeFrom = t;
              },
              label: 'Time from',
              value: null),
          SelectInput<String>(
              items: _times,
              onChange: (String t) {
                _meetupFormData.timeTo = t;
              },
              label: 'Time to',
              value: null),
          _buildSubmitBtn()
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Text(
        'Register Today',
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return Container(
        alignment: Alignment(-1.0, 0.0),
        child: RaisedButton(
          textColor: Colors.white,
          color: Theme.of(context).primaryColor,
          child: const Text('Submit'),
          onPressed: _submitCreate,
        ));
  }
}

class _CategorySelect extends StatelessWidget {
  final List<Category> _categories;
  final MeetupFormData _meetupFormData;

  _CategorySelect(
      {required List<Category> categories,
      required MeetupFormData meetupFormData})
      : _meetupFormData = meetupFormData,
        _categories = categories;

  @override
  Widget build(BuildContext context) {
    return FormField<Category>(
      builder: (FormFieldState<Category> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.color_lens),
            labelText: 'Category',
          ),
          isEmpty: _meetupFormData.category == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Category>(
              value: _meetupFormData.category,
              isDense: true,
              onChanged: (Category? newCategory) {
                // setState(() {
                if (newCategory != null) {
                  state.didChange(newCategory);
                  _meetupFormData.category = newCategory;
                }
                // });
              },
              items: _categories.map((Category category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _DatePicker extends StatefulWidget {
  final Function(DateTime date) onDateChange;
  final String title = '';

  _DatePicker({required Function(DateTime date) onDateChange})
      : onDateChange = onDateChange;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePicker> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _dateNow = DateTime.now();
  DateTime _initialDate = DateTime.now();
  final _dateFormat = new DateFormat('dd/MM/yyyy');

  _DatePickerState() {
    _dateController.text = _initialDate.toString();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _initialDate, // current date,
        firstDate: _dateNow, // Time Now,
        lastDate: DateTime(_dateNow.year + 1, _dateNow.month, _dateNow.day));

    if (picked != null && picked != _initialDate) {
      widget.onDateChange(picked);
      setState(() {
        _dateController.text = _dateFormat.format(picked);
        _initialDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: new TextFormField(
        enabled: false,
        decoration: new InputDecoration(
          icon: const Icon(Icons.calendar_today),
          hintText: 'Enter date when meetup starts',
          labelText: 'Dob',
        ),
        controller: _dateController,
        keyboardType: TextInputType.datetime,
      )),
      IconButton(
        icon: new Icon(Icons.more_horiz),
        tooltip: 'Choose date',
        onPressed: (() {
          _selectDate(context);
        }),
      )
    ]);
  }
}

class _TimeSelect extends StatefulWidget {
  final Function(String) onTimeChange;
  final String label;
  final List<String> _times = generateTimes();

  _TimeSelect({required Function(String) onTimeChange, String? label})
      : onTimeChange = onTimeChange,
        label = label ?? 'Time';

  @override
  State<StatefulWidget> createState() {
    return _TimeSelectState();
  }
}

class _TimeSelectState extends State<_TimeSelect> {
  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.timer),
            labelText: widget.label,
          ),
          isEmpty: _selectedTime == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedTime,
              isDense: true,
              onChanged: (String? newTime) {
                // setState(() {
                if (newTime != null) {
                  widget.onTimeChange(newTime);
                  state.didChange(newTime);
                  _selectedTime = newTime;
                }
                // });
              },
              items: widget._times.map((String time) {
                return DropdownMenuItem<String>(
                  value: time,
                  child: Text(time),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

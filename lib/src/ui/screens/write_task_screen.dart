import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/models/task_model.dart';
import '../../core/providers/task_provider.dart';
import '../../core/providers/category_provider.dart';
import '../shared/platform/platform_exception_alert_dialog.dart';
import '../global/style_list.dart';

class WriteTaskScreen extends StatefulWidget {
  final TaskModel task;
  WriteTaskScreen({
    Key key,
    @required this.task,
  })  : assert(task != null),
        super(key: key);

  @override
  _WriteTaskScreenState createState() => _WriteTaskScreenState();
}

class _WriteTaskScreenState extends State<WriteTaskScreen> {
  String _category;
  DateTime _date;
  bool _isDone;
  bool _isBottom;

  TextEditingController _titleController;
  TextEditingController _newCategoryController;
  ScrollController _categoryController;

  TaskModel get task => widget.task;
  String get title => _titleController.text;
  String get newCategory => _newCategoryController.text;

  @override
  void initState() {
    super.initState();
    _categoryController = ScrollController()..addListener(_scrollListener);
    _newCategoryController = TextEditingController();
    _titleController = TextEditingController(text: task.title);
    _category = task.category;
    _date = task.date;
    _isDone = task.isDone;
    _isBottom = false;
  }

  @override
  void dispose() {
    _categoryController.removeListener(_scrollListener);
    _categoryController.dispose();
    _newCategoryController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_categoryController.offset >=
            _categoryController.position.maxScrollExtent &&
        !_categoryController.position.outOfRange) {
      setState(() {
        _isBottom = true;
      });
    } else {
      setState(() {
        _isBottom = false;
      });
    }
  }

  void _scrollToTop() {
    _categoryController.animateTo(_categoryController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void _addNewCategory() {
    if (newCategory.isNotEmpty) {
      Provider.of<CategoryProvider>(context, listen: false)
          .checkCategory(newCategory);
      setState(() {
        _category = newCategory;
      });
      _scrollToTop();
      _newCategoryController.clear();
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  Future<DateTime> _pickDate() async {
    final Brightness _appliedBrightness =
        Theme.of(context).primaryColor == Colors.white
            ? Brightness.dark
            : Brightness.light;
    final Color _appliedColor = Theme.of(context).primaryColor == Colors.white
        ? Colors.black
        : Colors.white;
    final tempDate = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1960),
      lastDate: DateTime(2050),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData(
            // For only datepicker
            primaryColor: Theme.of(context).primaryColor,
            accentColor: Theme.of(context).accentColor,
            dialogBackgroundColor: Theme.of(context).primaryColor,
            accentColorBrightness: _appliedBrightness,
            primaryColorDark: Theme.of(context).primaryColor,
            textTheme: TextTheme(
              body1: TextStyle(
                color: _appliedColor,
              ),
              subhead: TextStyle(
                color: _appliedColor,
              ),
              caption: TextStyle(
                color: _appliedColor,
              ),
            ),
            iconTheme: IconThemeData(
              color: _appliedColor,
            ),
          ),
          child: child,
        );
      },
    );
    if (tempDate == null) {
      return _date;
    }
    return tempDate;
  }

  void _addNewDate() async {
    final pickedDate = await _pickDate();
    setState(() {
      _date = pickedDate;
    });
  }

  Future<void> _addUpdateTask() async {
    try {
      TaskProvider taskProvider =
          Provider.of<TaskProvider>(context, listen: false);
      if (title.isNotEmpty && _category.isNotEmpty) {
        task.title = title;
        task.category = _category;
        task.date = _date;
        task.isDone = _isDone;
        if (task.id != null) {
          await taskProvider.updateTask(task);
        } else {
          await taskProvider.addTask(task);
        }

        // with final and string id
        // if (task.id.isNotEmpty) {
        //   taskProvider.updateTask(
        //     task,
        //     TaskModel(
        //       id: task.id,
        //       title: title,
        //       category: _category,
        //       date: _date,
        //       isDone: _isDone,
        //     ),
        //   );
        // } else {
        //   taskProvider.addTask(
        //     TaskModel(
        //       id: task.id.isNotEmpty ? task.id : taskProvider.uuid.v4(),
        //       title: title,
        //       category: _category,
        //       date: _date,
        //       isDone: _isDone,
        //     ),
        //   );
        // }
        Navigator.pop(context);
      }
    } catch (e) {
      PlatformExceptionAlertDialog(
        title: 'ERROR',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: StyleList.basePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Text(
                  task.title.isNotEmpty ? 'Edit Task' : 'New Task',
                  textAlign: TextAlign.start,
                  style: StyleList.titleTextStyle,
                ),
              ),
              StyleList.baseVerticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _titleController,
                        autofocus: true,
                        cursorColor: Theme.of(context).accentColor,
                        decoration: InputDecoration(
                          hintText: 'What\'s your task?',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 10.0,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      StyleList.baseVerticalSpace,
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          // minHeight: 0.0,
                          maxHeight: 100.0,
                        ),
                        child: Consumer<CategoryProvider>(
                          builder: (context, categoryProvider, child) {
                            final _categories =
                                categoryProvider.taskCategoryList;
                            return ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              controller: _categoryController,
                              itemCount: categoryProvider.categoryCount,
                              itemBuilder: (context, index) {
                                final eachCategory = _categories[index];
                                return RadioListTile(
                                  activeColor: Theme.of(context).accentColor,
                                  title: Text(
                                    eachCategory,
                                    style: TextStyle(
                                      color: _category == eachCategory
                                          ? Theme.of(context).accentColor
                                          : Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                  value: eachCategory,
                                  groupValue: _category,
                                  onChanged: (pickedVal) {
                                    setState(() {
                                      _category = pickedVal;
                                    });
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Consumer<CategoryProvider>(
                        builder: (context, categoryProvider, child) {
                          return _isBottom || categoryProvider.categoryCount < 2
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                    top: 5.0,
                                    // bottom: 10.0,
                                  ),
                                  child: newCategoryField())
                              : SizedBox.shrink();
                        },
                      ),
                      StyleList.baseVerticalSpace,
                      datePickerButton(),
                      // StyleList.baseVerticalSpace,
                      Container(
                        width: double.infinity,
                        child: taskAddUpdateButton(),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget newCategoryField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: Theme.of(context).accentColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: TextField(
                controller: _newCategoryController,
                textCapitalization: TextCapitalization.words,
                cursorColor: Theme.of(context).accentColor,
                onEditingComplete: _addNewCategory,
                decoration: InputDecoration(
                  hintText: 'New Category',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 10.0,
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: RawMaterialButton(
              onPressed: _addNewCategory,
              padding: const EdgeInsets.all(0.0),
              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              constraints: BoxConstraints(
                minWidth: 50.0,
                minHeight: 50.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  5.0,
                ),
              ),
              splashColor: Theme.of(context).accentColor,
              child: Icon(
                Icons.add,
                size: 24.0,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget datePickerButton() {
    return FlatButton(
      onPressed: _addNewDate,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '${DateFormat.MMMEd().format(_date)}',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          Icon(
            Icons.calendar_today,
            size: 20.0,
            color: Theme.of(context).accentColor,
          ),
        ],
      ),
      splashColor: Theme.of(context).accentColor,
    );
  }

  Widget taskAddUpdateButton() {
    return FlatButton(
      onPressed: () async => await _addUpdateTask(),
      color: Theme.of(context).accentColor,
      child: Text(
        task.title.isNotEmpty ? 'Edit' : 'Add',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

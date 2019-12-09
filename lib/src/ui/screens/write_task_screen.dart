import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/models/task_model.dart';
import '../../core/providers/task_provider.dart';
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
  String category;
  DateTime date;
  bool isDone;
  bool isBottom;

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
    category = task.category;
    date = task.date;
    isDone = task.isDone;
    isBottom = false;
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
        isBottom = true;
      });
    } else {
      setState(() {
        isBottom = false;
      });
    }
  }

  void _scrollToTop() {
    _categoryController.animateTo(_categoryController.position.minScrollExtent,
        duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void _addNewCategory() {
    if (newCategory.isNotEmpty) {
      Provider.of<TaskProvider>(context, listen: false)
          .addCategory(newCategory);
      setState(() {
        category = newCategory;
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
      initialDate: date,
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
      return date;
    }
    return tempDate;
  }

  void _addNewDate() async {
    final pickedDate = await _pickDate();
    setState(() {
      date = pickedDate;
    });
  }

  void _addUpdateTask() {
    TaskProvider taskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    if (title.isNotEmpty && category.isNotEmpty) {
      taskProvider.updateTask(
        task,
        TaskModel(
          id: task.id.isNotEmpty ? task.id : taskProvider.uuid.v4(),
          title: title,
          category: category,
          date: date,
          isDone: isDone,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    TaskProvider taskProvider = Provider.of<TaskProvider>(context);
    final List<String> categories = taskProvider.taskCategoryList;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Text(
                  widget.task.title.isNotEmpty ? 'Edit Task' : 'New Task',
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
                      Container(
                        height: 100.0,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: _categoryController,
                          itemCount: taskProvider.categoryCount,
                          itemBuilder: (context, index) {
                            final eachCategory = categories[index];
                            return RadioListTile(
                              activeColor: Theme.of(context).accentColor,
                              title: Text(
                                eachCategory,
                                style: TextStyle(
                                  color: category == eachCategory
                                      ? Theme.of(context).accentColor
                                      : Theme.of(context).primaryColorDark,
                                ),
                              ),
                              value: eachCategory,
                              groupValue: category,
                              onChanged: (pickedVal) {
                                setState(() {
                                  category = pickedVal;
                                });
                              },
                            );
                          },
                        ),
                      ),
                      isBottom || taskProvider.categoryCount <= 2
                          ? newCategoryField()
                          : SizedBox.shrink(),
                      datePickerButton(),
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
            '${DateFormat.MMMEd().format(date)}',
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
      onPressed: _addUpdateTask,
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

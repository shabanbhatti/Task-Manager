class Tasks {
  final int? taskPrimaryKey;
  final String? title;
  final String? description;
  final String? importance;
  final String? date;
  final String? time;
  final bool? isCompleted;

  Tasks({
    this.taskPrimaryKey,
    this.title,
    this.description,
    this.time,
    this.importance,
    this.date,
    this.isCompleted = false,
  });

  
  static const String TASK_TABLE_NAME = 'task_table';

  static const String COL_PRIMARYKEY = 'primary_key_col_task';
  static const String COL_TITLE = 'title_col_task';
  static const String COL_DESCRIPTION = 'description_col_task';
  static const String COL_IMPORTANCE = 'importance_col_task';
  static const String COL_DATE = 'date_col_task';
  static const String COL_TIME = 'time_col_task';
  static const String COL_ISCOMPLETED = 'is_completed_col_task';

  static const String CREATE_TABLE = '''
    CREATE TABLE $TASK_TABLE_NAME (
      $COL_PRIMARYKEY INTEGER PRIMARY KEY AUTOINCREMENT,
      $COL_TITLE TEXT,
      $COL_DESCRIPTION TEXT,
      $COL_IMPORTANCE TEXT,
      $COL_DATE TEXT,
      $COL_TIME TEXT,
      $COL_ISCOMPLETED INTEGER
    )
  ''';

  
  Map<String, dynamic> toMap() {
    return {
      COL_PRIMARYKEY: taskPrimaryKey,
      COL_TITLE: title,
      COL_DESCRIPTION: description,
      COL_IMPORTANCE: importance,
      COL_DATE: date,
      COL_ISCOMPLETED: isCompleted == true ? 1 : 0,
      COL_TIME: time
    };
  }

  
  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      taskPrimaryKey: map[COL_PRIMARYKEY],
      title: map[COL_TITLE],
      description: map[COL_DESCRIPTION],
      importance: map[COL_IMPORTANCE],
      date: map[COL_DATE],
      time: map[COL_TIME],
      isCompleted: map[COL_ISCOMPLETED] == 1,
    );
  }


   Tasks copyWith({
    int? taskPrimaryKey,
    String? title,
    String? description,
    String? importance,
    String? date,
    String? time,
    bool? isCompleted,
  }) {
    return Tasks(
      taskPrimaryKey: taskPrimaryKey ?? this.taskPrimaryKey,
      title: title ?? this.title,
      description: description ?? this.description,
      importance: importance ?? this.importance,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

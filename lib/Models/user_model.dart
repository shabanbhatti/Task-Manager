class User {

    final int? primaryKey;
  final String? userName;
  final String? nickName;
  final String? age;
  final String? gender;
  final String? imgPath;
  final String? occupation;

  
  static const TABLE_NAME = 'user_data';

  static const COL_PRIMARYKEY = 'COL_PRIMARYKEY';
  static const COL_USERNAME = 'COL_USERNAME';
  static const COL_NICKNAME = 'COL_NICKNAME';
  static const COL_AGE = 'COL_AGE';
  static const COL_GENDER = 'COL_GENDER';
  static const COL_IMGPATH = 'COL_imgPath';
  static const COL_OCCUPATION = 'COL_occupation';

  
  static const CREATETABLE = '''
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
      $COL_PRIMARYKEY INTEGER PRIMARY KEY AUTOINCREMENT,
      $COL_USERNAME TEXT NOT NULL,
      $COL_NICKNAME TEXT,
      $COL_OCCUPATION TEXT,
      $COL_IMGPATH TEXT,
      $COL_AGE INTEGER,
      $COL_GENDER TEXT
    )
  ''';

  

  
  User({
    this.primaryKey,
    this.userName,
    this.nickName,
    this.age,
    this.gender,
    this.occupation,
    this.imgPath
  });

  
  Map<String, dynamic> toMap() {
    return {
      COL_PRIMARYKEY: primaryKey,
      COL_USERNAME: userName,
      COL_NICKNAME: nickName,
      COL_AGE: age,
      COL_GENDER: gender,
      COL_IMGPATH: imgPath,
COL_OCCUPATION:occupation
    };
  }

  
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      primaryKey: map[COL_PRIMARYKEY],
      userName: map[COL_USERNAME],
      nickName: map[COL_NICKNAME],
      age: map[COL_AGE]?.toString(),
      gender: map[COL_GENDER],
      imgPath:  map[COL_IMGPATH],
      occupation: map[COL_OCCUPATION]
    );
  }

  
  User copyWith({
    int? primaryKey,
    String? userName,
    String? nickName,
    String? age,
    String? gender,
    String? imgPath,
    String? occupation
  }) {
    return User(
      primaryKey: primaryKey ?? this.primaryKey,
      userName: userName ?? this.userName,
      nickName: nickName ?? this.nickName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      imgPath: imgPath??this.imgPath,
      occupation: occupation??this.occupation
    );
  }
}

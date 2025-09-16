
String dateFormat(DateTime dateTime){

 return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year.toString().padLeft(2, '0')}';

}
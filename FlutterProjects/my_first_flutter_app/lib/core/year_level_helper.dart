int yearLevelToNumber(String text) {
  switch (text.trim().toLowerCase()) {
    case '1st year':
      return 1;
    case '2nd year':
      return 2;
    case '3rd year':
      return 3;
    case '4th year':
      return 4;
    default:
      return 0;
  }
}

String yearLevelToText(int number) {
  switch (number) {
    case 1:
      return '1st Year';
    case 2:
      return '2nd Year';
    case 3:
      return '3rd Year';
    case 4:
      return '4th Year';
    default:
      return '$number';
  }
}

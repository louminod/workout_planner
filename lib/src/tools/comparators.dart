abstract class Comparators {
  static bool dateAreEquals(DateTime date1, DateTime date2) {
    return (date1.day == date2.day && date1.month == date2.month && date1.year == date2.year);
  }
}
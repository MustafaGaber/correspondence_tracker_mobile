/// Mimics the 'getLocalISOString' function, which likely produces
/// an ISO string without timezone information (YYYY-MM-DDTHH:mm:ss).
String getLocalISOString(DateTime dt) {
  // Formats to "yyyy-MM-ddTHH:mm:ss"
  return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}T${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
}
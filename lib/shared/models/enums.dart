// Based on the 'CorrespondenceDirection' and 'PriorityLevel' types in models.ts

enum CorrespondenceDirection { incoming, outgoing }

enum PriorityLevel {
  critical,
  urgentAndImportant,
  urgent,
  important,
  medium,
  low,
}

// Helper extensions to convert from/to integer values if needed
extension CorrespondenceDirectionInt on CorrespondenceDirection {
  int get value {
    switch (this) {
      case CorrespondenceDirection.incoming:
        return 1; // Example value
      case CorrespondenceDirection.outgoing:
        return 2; // Example value
    }
  }

  static CorrespondenceDirection fromValue(int val) {
    return val == 2
        ? CorrespondenceDirection.outgoing
        : CorrespondenceDirection.incoming;
  }
}

extension PriorityLevelInt on PriorityLevel {
  int get value {
    switch (this) {
      case PriorityLevel.critical:
        return 10;
      case PriorityLevel.urgentAndImportant:
        return 20;
      case PriorityLevel.urgent:
        return 30;
      case PriorityLevel.important:
        return 40;
      case PriorityLevel.medium:
        return 50;
      case PriorityLevel.low:
        return 60;
    }
  }

  static PriorityLevel fromValue(int val) {
    if (val == 10) return PriorityLevel.critical;
    if (val == 20) return PriorityLevel.urgentAndImportant;
    if (val == 30) return PriorityLevel.urgent;
    if (val == 40) return PriorityLevel.important;
    if (val == 50) return PriorityLevel.medium;
    return PriorityLevel.low;
  }
}

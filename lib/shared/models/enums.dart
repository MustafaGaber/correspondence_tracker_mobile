// Based on the 'CorrespondenceDirection' and 'PriorityLevel' types in models.ts

enum CorrespondenceDirection {
  incoming,
  outgoing,
}

enum PriorityLevel {
  normal,
  medium,
  high,
  // Add other potential values
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
    return val == 2 ? CorrespondenceDirection.outgoing : CorrespondenceDirection.incoming;
  }
}

extension PriorityLevelInt on PriorityLevel {
  int get value {
    switch (this) {
      case PriorityLevel.normal:
        return 0; // Example value
      case PriorityLevel.medium:
        return 1; // Example value
      case PriorityLevel.high:
        return 2; // Example value
    }
  }

  static PriorityLevel fromValue(int val) {
    // Note: Provides a default, adjust as needed
    return PriorityLevel.values.firstWhere(
      (e) => e.value == val,
      orElse: () => PriorityLevel.normal,
    );
  }
}
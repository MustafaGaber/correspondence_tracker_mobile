// Based on the 'CorrespondenceDirection' and 'PriorityLevel' types in models.ts

enum CorrespondenceDirection {
  incoming,
  outgoing,
  // Add other potential values based on your backend
  // (e.g., if '0' is incoming, '1' is outgoing)
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
        return 0; // Example value
      case CorrespondenceDirection.outgoing:
        return 1; // Example value
    }
  }

  static CorrespondenceDirection fromValue(int val) {
    // Note: Provides a default, adjust as needed
    return CorrespondenceDirection.values.firstWhere(
      (e) => e.value == val,
      orElse: () => CorrespondenceDirection.incoming,
    );
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
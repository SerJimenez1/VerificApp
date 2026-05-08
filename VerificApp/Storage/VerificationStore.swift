import Combine
import Foundation

final class VerificationStore: ObservableObject {
    @Published private(set) var records: [VerificationRecord] = [] {
        didSet {
            save()
        }
    }

    private let storageKey = "verificapp.records.v1"
    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        self.records = Self.loadRecords(from: userDefaults, key: storageKey)
    }

    var sortedRecords: [VerificationRecord] {
        records.sorted { $0.createdAt > $1.createdAt }
    }

    var stats: VerificationStats {
        guard records.isEmpty == false else { return .empty }

        return VerificationStats(
            total: records.count,
            probablyTrue: records.filter { $0.verdict == .probablyTrue }.count,
            doubtful: records.filter { $0.verdict == .doubtful }.count,
            probablyFalse: records.filter { $0.verdict == .probablyFalse }.count
        )
    }

    func add(_ record: VerificationRecord) {
        records.append(record)
    }

    func delete(records recordsToDelete: [VerificationRecord]) {
        let ids = Set(recordsToDelete.map(\.id))
        records.removeAll { ids.contains($0.id) }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        userDefaults.set(data, forKey: storageKey)
    }

    private static func loadRecords(from userDefaults: UserDefaults, key: String) -> [VerificationRecord] {
        guard
            let data = userDefaults.data(forKey: key),
            let records = try? JSONDecoder().decode([VerificationRecord].self, from: data)
        else {
            return []
        }

        return records
    }
}

import Foundation

struct MissionStep: Identifiable {
    let id: UUID
    let instruction: String
    let targetItemID: UUID

    init(instruction: String, targetItemID: UUID) {
        self.id = UUID()
        self.instruction = instruction
        self.targetItemID = targetItemID
    }
}

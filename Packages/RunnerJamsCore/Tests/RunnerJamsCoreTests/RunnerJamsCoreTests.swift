import Testing
@testable import RunnerJamsCore

@Test func versionIsSet() {
    #expect(!RunnerJamsCore.version.isEmpty)
}

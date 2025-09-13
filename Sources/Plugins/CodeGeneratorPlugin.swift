protocol CodeGeneratorPlugin: Sendable {
    func run() async throws
}

protocol CodeGeneratorPlugin: Sendable {
    func initilize() async throws
    func run() async throws
}

extension CodeGeneratorPlugin {
    func initilize() async throws {}
}

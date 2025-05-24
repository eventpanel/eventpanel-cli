protocol CodeGeneratorPlugin: Sendable {
    func initilize() async throws
    func run() async throws
}

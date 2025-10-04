import Foundation
import Yams
import StencilEventPanelKit

enum TypeScriptGenGeneratorError: LocalizedError {
    case generateFailed(String)

    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate TypeScript file: \(message)"
        }
    }
}

struct TypeScriptGenGenerator {
    private let config: TypeScriptGenPlugin

    init(config: TypeScriptGenPlugin) {
        self.config = config
    }

    func generate(
        scheme: TypeScriptGenWorkspaceScheme,
        stencilTemplate: TypeScriptGenStencilTemplate
    ) throws -> String {
        let environment = stencilSwiftEnvironment(
            templates: [stencilTemplate.name: stencilTemplate.template]
        )
        let template = TypeScriptGenTemplateContext(
            files: [TypeScriptGenTemplateContext.File(
                document: TypeScriptGenTemplateContext.Document(data: scheme)
            )]
        )
        let parameters = try codableToDictionary(
            TypeScriptGenParams(
                namespace: config.namespace,
                eventClassName: config.eventClassName,
                documentation: config.documentation,
                shouldGenerateType: config.shouldGenerateType
            ),
            keyEncodingStrategy: .useDefaultKeys
        )!
        let context = try codableToDictionary(template)!
        let dict = try StencilContext.enrich(context: context, parameters: parameters, environment: [:])

        do {
            let rendered = try environment.renderTemplate(
                name: stencilTemplate.name,
                context: dict
            )
            return rendered
        } catch {
            throw TypeScriptGenGeneratorError.generateFailed(error.localizedDescription)
        }
    }
}

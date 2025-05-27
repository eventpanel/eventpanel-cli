import Foundation
import Yams
import StencilSwiftKit

enum SwiftgenGeneratorError: LocalizedError {
    case generateFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate file: \(message)"
        }
    }
}

struct SwiftgenGenerator {
    private let config: SwiftgenPlugin
    
    init(config: SwiftgenPlugin) {
        self.config = config
    }
    
    func generate(scheme: SwiftgenWorkspaceScheme, stencilTemplate: SwiftgenStenillTemplate) throws -> String {
        let environment = stencilSwiftEnvironment(
            templates: [stencilTemplate.name: stencilTemplate.template],
            templateClass: StencilSwiftTemplate.self,
            trimBehaviour: .nothing
        )
        let template = TemplateContext(files: [File(document: Document(data: scheme))])
        let parameters = try codableToDictionary(
            SwiftgenParams(
                enumName: config.namespace,
                eventClassName: config.eventTypeName,
                documentation: config.documentation
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
            throw SwiftgenGeneratorError.generateFailed(error.localizedDescription)
        }
    }
} 

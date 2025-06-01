import Foundation
import Yams
import StencilEventPanelKit

enum SwiftGenGeneratorError: LocalizedError {
    case generateFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate file: \(message)"
        }
    }
}

struct SwiftGenGenerator {
    private let config: SwiftGenPlugin
    
    init(config: SwiftGenPlugin) {
        self.config = config
    }
    
    func generate(scheme: SwiftGenWorkspaceScheme, stencilTemplate: SwiftGenStenillTemplate) throws -> String {
        let environment = stencilSwiftEnvironment(
            templates: [stencilTemplate.name: stencilTemplate.template]
        )
        let template = SwiftGenTemplateContext(
            files: [SwiftGenTemplateContext.File(
                document: SwiftGenTemplateContext.Document(data: scheme)
            )]
        )
        let parameters = try codableToDictionary(
            SwiftGenParams(
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
            throw SwiftGenGeneratorError.generateFailed(error.localizedDescription)
        }
    }
} 

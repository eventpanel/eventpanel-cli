import Foundation
import Yams
import StencilSwiftKit

enum KotlinGenGeneratorError: LocalizedError {
    case generateFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .generateFailed(let message):
            return "Can't generate Kotlin file: \(message)"
        }
    }
}

struct KotlinGenGenerator {
    private let config: KotlinGenPlugin
    
    init(config: KotlinGenPlugin) {
        self.config = config
    }
    
    func generate(scheme: KotlinGenWorkspaceScheme, stencilTemplate: KotlinGenStencilTemplate) throws -> String {
        let environment = stencilSwiftEnvironment(
            templates: [stencilTemplate.name: stencilTemplate.template]
        )
        let template = KotlinGenTemplateContext(
            files: [KotlinGenTemplateContext.File(
                document: KotlinGenTemplateContext.Document(data: scheme)
            )]
        )
        let parameters = try codableToDictionary(
            KotlinGenParams(
                packageName: config.packageName,
                eventClassName: config.eventClassName,
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
            throw KotlinGenGeneratorError.generateFailed(error.localizedDescription)
        }
    }
} 

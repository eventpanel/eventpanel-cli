import StencilEventPanelKit

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
            throw KotlinGenError.generateFailed(error.localizedDescription)
        }
    }
} 

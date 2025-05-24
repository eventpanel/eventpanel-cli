var swiftgenStenillTemplate: String {
    """
    // swiftlint:disable all
    // Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

    {% if files %}
    {% set accessModifier %}{% if param.publicAccess %}public{% else %}internal{% endif %}{% endset %}
    {% set eventClassName %}{{param.eventClassName|default:"AnalyticsEvent"}}{% endset %}
    import Foundation

    // swiftlint:disable superfluous_disable_command
    // swiftlint:disable file_length
    {% macro fileBlock file %}
      {% call documentBlock file file.document %}
    {% endmacro %}
    {% macro documentBlock file document %}
      {% call categoriesBlock document %}
    {% endmacro %}
    {% macro categoriesBlock document %}
      {% for category in document.data.categories %}
      {{accessModifier}} enum {{category.name|swiftIdentifier:"pretty"|escapeReservedKeywords}} {
        {% call eventsBlock document category.id %}
      }
      {% endfor %}
    {% endmacro %}
    {% macro customTypesBlock document %}
      {% for customType in document.data.custom_types %}
      {% if customType.type == "enum" %}
      {{accessModifier}} enum {{customType.name|swiftIdentifier:"pretty"|escapeReservedKeywords}}: {{customType.data_type}} {
        {% for case in customType.cases %}
        case {{case|swiftIdentifier:"pretty"|lowerFirstWord}} = "{{case}}"
        {% endfor %}
      }
      {% endif %}
      {% endfor %}
    {% endmacro %}
    {% macro eventDocumentationBlock event indent %}
      {% filter indent:indent %}
      /// {{event.description}}
      {% for property in event.properties where not property.value %}
      {% if property.description.count > 0 %}
      /// - Parameters:
      {% break %}
      {% endif %}
      {% endfor %}
      {% for property in event.properties where not property.value %}
      {% if property.description.count > 0 %}
      ///     - {{property.name}}: {{property.description}}
      {% endif %}
      {% endfor %}
      {% endfilter %}
    {%- endmacro %}
    {% macro functionBlock functionName arguments returnValue functionBody indent %}
      {% filter indent:indent %}
      {{accessModifier}} static func {{functionName}}({{arguments}}) -> {{returnValue}} {
        {{functionBody}}      
      }
      {% endfilter %}
    {%- endmacro %}
    {% macro mapFoundationType type %}
      {%- if type == "Array<String>" -%}
        [String]
      {%- else -%}
        {{type}}
      {%- endif -%}
    {% endmacro %}
    {% macro propertyType property %}
      {%- if property.type == "enum" -%}
        {{property.name|swiftIdentifier:"pretty"}}
      {%- else -%}
        {% call mapFoundationType property.data_type %}
      {%- endif -%}
    {% endmacro %}
    {% macro propertyValue property %}
      {%- if property.value -%}
        "{{property.value}}"
      {%- elif property.type == "enum" -%}
        {{property.name|swiftIdentifier:"pretty"|lowerFirstWord}}.rawValue
      {%- else -%}
        {{property.name|swiftIdentifier:"pretty"|lowerFirstWord}}
      {%- endif -%}
    {% endmacro %}
    {% macro typeBlock property -%}
      {%- if property.required -%}
      {% call propertyType property %}
      {%- else -%}
      {% call propertyType property %}?
      {%- endif -%}
    {%- endmacro -%}
    {% macro enumBlock property indent %}
      {% filter indent:indent %}
      {% if property.type == "enum" and property.cases.count > 0 %}
      {{accessModifier}} enum {{property.name|swiftIdentifier:"pretty"}}: {{property.data_type}} {
        {% for case in property.cases %}
        case {{case|swiftIdentifier:"pretty"|lowerFirstWord}} = "{{case}}"
        {% endfor %}
      }
      {% endif %}
      {% endfilter %}
    {% endmacro %}
    {% macro eventsBlock document categoryId %}
      {% for event in document.data.events %}
        {% for eventCategoryId in event.category_ids %}
        {% if eventCategoryId == categoryId %}
        {%- set functionName %}{{event.name|swiftIdentifier:"pretty"|lowerFirstWord}}{% endset -%}
        {%- set arguments %}{% call eventArgumentsBlock event.properties %}{% endset -%}
        {%- set functionBody %}{% call eventInstanceBlock event 2 %}{% endset %}
        {% if param.documentation %}
        {%- call eventDocumentationBlock event 2 -%}
        {% endif%}
        {% for property in event.properties where property.type == "enum" %}
          {% call enumBlock property 2 %}
        {% endfor %}
        {% call functionBlock functionName arguments eventClassName functionBody 2 %}
        {% break %}
        {% endif%}
        {% endfor %}
      {% endfor %}
    {% endmacro %}
    {% macro eventInstanceBlock event indent %}
      {% filter indent:indent %}
      {{eventClassName}}(
        name: "{{event.name}}",
        parameters: {% call eventPropertiesBlock event.properties 2 %}
      )
      {% endfilter %}
    {% endmacro %}
    {% macro eventArgumentsBlock properties %}
      {%- for property in properties where not property.value -%}
        {%- set type %}{% call typeBlock property %}{% endset %}
        {{property.name|swiftIdentifier:"pretty"|lowerFirstWord}}: {{type}}{{ "," if not forloop.last }}
      {% endfor -%}
    {% endmacro %}
    {% macro eventPropertiesBlock properties indent %}
      {%- filter indent:indent -%}
      {%- if not properties -%}
      [:]
      {%- else -%}
      [ 
      {% for property in properties %}
        "{{property.name}}": {% call propertyValue property %}{{ "," if not forloop.last }}
      {% endfor %}
      ]{% for property in properties %}{% if not property.required and not property.value %}.byExcludingNilValues(){% break %}{% endif %}{% endfor %}
      {% endif %}
      {% endfilter %}
    {% endmacro %}

    // swiftlint:disable identifier_name line_length number_separator type_body_length
    {{accessModifier}} enum {{param.enumName|default:"GeneratedAnalyticsEvents"}} {
      {% if files.count > 1 or param.forceFileNameEnum %}
      {% for file in files %}
      {{accessModifier}} enum {{file.name|swiftIdentifier:"pretty"|escapeReservedKeywords}} {
        {% filter indent:2," ",true %}{% call fileBlock file %}{% endfilter %}
      }
      {% endfor %}
      {% else %}
      {% call fileBlock files.first %}
      {% endif %}
    }

    extension {{param.enumName|default:"GeneratedAnalyticsEvents"}} {
      {% if files.count > 1 or param.forceFileNameEnum %}
      {% for file in files %}
      {% filter indent:2," ",true %}{% call customTypesBlock file.document %}{% endfilter %}
      {% endfor %}
      {% else %}
      {% call customTypesBlock files.first.document %}
      {% endif %}
    }
    // swiftlint:enable identifier_name line_length number_separator type_body_length
    {% else %}
    // No files found
    {% endif %}

    private extension Dictionary where Value == Any? {
        /// Returns dictionary with filtered out `nil` and `NSNull` values
        func byExcludingNilValues() -> [Key: Any] {
            return compactMapValues { value -> Any? in
                value is NSNull ? nil : value
            }
        }
    }
    """
}

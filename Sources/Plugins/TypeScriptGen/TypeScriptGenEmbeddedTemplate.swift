import Foundation

struct TypeScriptGenEmbeddedTemplate {
    static let template: String = """
// Generated using EventPanel — https://github.com/eventpanel/eventpanel-cli
{% if files %}
{% set accessModifier %}{% if param.publicAccess %}export{% else %}{% endif %}{% endset %}
{% set eventClassName %}{{param.eventClassName|default:"AnalyticsEvent"}}{% endset %}
{% macro fileBlock file %}
  {% call documentBlock file file.document %}
{% endmacro %}
{% macro documentBlock file document %}
  {% call categoriesBlock document %}
{% endmacro %}
{% macro categoriesBlock document %}
  {% for category in document.data.categories %}
  {% if param.documentation %}
  {% call categoryDocumentationBlock category %}
  {% endif %}
  {{accessModifier}} namespace {{category.name|swiftIdentifier:"pretty"|escapeReservedKeywords}} {
    {% call categoryBlock document category.id %}
  }
  {% endfor %}

  {% for event in document.data.events %}
  {% if not event.category_ids or event.category_ids.count == 0 %}
    {% call eventBlock event %}
  {% endif %}
  {% endfor %}
{% endmacro %}
{% macro customTypesBlock document %}
{% for customType in document.data.custom_types %}
{% if customType.type == "enum" %}
{{accessModifier}} enum {{customType.name|swiftIdentifier:"pretty"|escapeReservedKeywords}} {
  {% for case in customType.cases %}
  {{case|swiftIdentifier:"pretty"}} = "{{case}}"{% if not forloop.last %},{% endif +%}
  {% endfor %}
}
{% endif %}
{% endfor %}
{% endmacro %}
{% macro categoryDocumentationBlock category %}
  {% if category.description.count > 0 %}
  /**
   * {{category.description}}
   */
  {% endif %}
{%- endmacro %}
{% macro eventDocumentationBlock event %}
  {% if event.description.count != 0 %}
  /**
   * {{event.description}}
  {% for property in event.properties %}
  {% if property.description.count > 0 %}
   * @param {{property.name|swiftIdentifier:"pretty"|lowerFirstWord}} {{property.description}}
  {% endif %}
  {% endfor %}
   */
  {% endif %}
{%- endmacro %}
{% macro propertyType property %}
  {%- if property.type == "enum" -%}
    {{property.name|swiftIdentifier:"pretty"}}
  {%- else -%}
    {{property.data_type|swiftIdentifier:"pretty"}}
  {%- endif -%}
{% endmacro %}
{% macro typeBlock property -%}
  {%- if property.required -%}
  {% call propertyType property %}
  {%- else -%}
  {% call propertyType property %} | undefined
  {%- endif -%}
{%- endmacro -%}
{% macro categoryBlock document categoryId %}
  {% for event in document.data.events %}
    {% for eventCategoryId in event.category_ids %}
    {% if eventCategoryId == categoryId +%}
    {% filter indent:2," ",true %}{% call eventBlock event %}{% endfilter %}
    {% break %}
    {% endif%}
    {% endfor %}
  {% endfor %}
{% endmacro %}
{% macro eventBlock event %}
  {% set functionName %}{{event.name|swiftIdentifier:"pretty"|lowerFirstWord}}{% endset %}
  {% set arguments %}{% call eventArgumentsBlock event.properties %}{% endset %}
  {% set functionBody %}{% call eventInstanceBlock event %}{% endset %}
  {% if param.documentation %}
  {%- call eventDocumentationBlock event %}
  {% endif %}
  {% if event.properties.count > 0 %}
  {{accessModifier}} function {{functionName}}(
  {%- filter indent:2," ",true %}{{arguments}}{% endfilter %}
  ): {{eventClassName}} {
  {% else %}
  {{accessModifier}} function {{functionName}}(): {{eventClassName}} {
  {% endif %}
  {% filter indent:2," ",true %}{{functionBody}}{% endfilter %}
  }
{% endmacro %}
{% macro eventInstanceBlock event %}
  return {
  {% filter indent:2," ",true %}
  name: '{{event.name}}',
  parameters: {%+ call eventPropertiesBlock event.properties +%},
  {% endfilter %}
  };
{% endmacro %}
{% macro eventArgumentsBlock properties %}
  {% if properties.count > 0 +%}
  {% for property in properties %}
  {% set type %}{% call typeBlock property %}{% endset %}
  {{property.name|swiftIdentifier:"pretty"|lowerFirstWord}}: {{type}},
  {% endfor %}
  {% endif %}
{% endmacro %}
{% macro eventPropertiesBlock properties %}
  {%- if not properties -%}
  {}
  {%- else -%}
  {
  {% filter indent:2," ",true %}
  {% for property in properties %}
  {{property.name}}: {{property.name|swiftIdentifier:"pretty"|lowerFirstWord}},
  {% endfor %}
  {% endfilter %}
  }{% for property in properties %}{% if not property.required and not property.value %}{% if forloop.first %}{% else %}{% endif %}{% endif %}{% endfor %}
  {% endif %}
{% endmacro %}

{{accessModifier}} namespace {{param.namespace|default:"GeneratedAnalyticsEvents"}} {
  {% if files.count > 1 or param.forceFileNameEnum %}
  {% for file in files %}
  {{accessModifier}} namespace {{file.name|swiftIdentifier:"pretty"|escapeReservedKeywords}} {
    {% filter indent:2," ",true %}{% call fileBlock file %}{% endfilter %}
  }
  {% endfor %}
  {% else %}
  {% call fileBlock files.first %}
  {% endif %}
}
{% for file in files %}
{% if file.document.data.custom_types.count > 0 %}

// Custom types for {{file.name}}
{% call customTypesBlock file.document %}
{% endif %}
{% endfor %}
{% if param.shouldGenerateType %}

{{accessModifier}} interface {{eventClassName}} {
  name: string;
  parameters: Record<string, unknown>;
}
{% endif %}
{% else %}
// No files found
{% endif %}
"""
}

import Foundation

struct KotlinGenEmbeddedTemplate {
    static let template: String = """
// Generated using EventPanel — https://github.com/eventpanel/eventpanel-cli

{% if files %}
package {{param.packageName}}
{% set accessModifier %}{% if param.publicAccess %}public{% else %}internal{% endif %}{% endset %}
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
  {{accessModifier}} object {{category.name|kotlinIdentifier:"pretty"|escapeReservedKeywords}} {
    {% call categoryBlock document category.id %}
  }
  {% endfor %}

  {% for event in document.data.events %}
  {% if event.category_ids.count == 0 %}
    {% call eventBlock event %}
  {% endif %}
  {% endfor %}
{% endmacro %}
{% macro customTypesBlock document %}
{% for customType in document.data.custom_types %}
{% if customType.type == "enum" %}
{{accessModifier}} enum class {{customType.name|kotlinIdentifier:"pretty"|escapeReservedKeywords}}(val value: {{customType.data_type}}) {
  {% for case in customType.cases %}
  {{case|kotlinIdentifier:"pretty"}}("{{case}}"){% if not forloop.last %},{% endif +%}
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
   * @param {{property.name}} {{property.description}}
  {% endif %}
  {% endfor %}
   */
  {% endif %}
{%- endmacro %}
{% macro propertyType property %}
  {%- if property.type == "enum" -%}
    {{property.name|kotlinIdentifier:"pretty"}}
  {%- else -%}
    {{property.data_type}}
  {%- endif -%}
{% endmacro %}
{% macro typeBlock property -%}
  {%- if property.required -%}
  {% call propertyType property %}
  {%- else -%}
  {% call propertyType property %}?
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
  {% set functionName %}{{event.name|kotlinIdentifier:"pretty"|lowerFirstWord}}{% endset %}
  {% set arguments %}{% call eventArgumentsBlock event.properties %}{% endset %}
  {% set functionBody %}{% call eventInstanceBlock event %}{% endset %}
  {% if param.documentation %}
  {%- call eventDocumentationBlock event %}
  {% endif %}
  {% if event.properties.count > 0 %}
  {{accessModifier}} fun {{functionName}}(
  {%- filter indent:2," ",true %}{{arguments}}{% endfilter %}
  ): {{eventClassName}} {
  {% else %}
  {{accessModifier}} fun {{functionName}}(): {{eventClassName}} {
  {% endif %}
  {% filter indent:2," ",true %}{{functionBody}}{% endfilter %}
  }
{% endmacro %}
{% macro eventInstanceBlock event %}
  return {{eventClassName}}(
  {% filter indent:2," ",true %}
  name = "{{event.name}}",
  parameters = {%+ call eventPropertiesBlock event.properties +%}
  {% endfilter %}
  )
{% endmacro %}
{% macro eventArgumentsBlock properties %}
  {% if properties.count > 0 +%}
  {% for property in properties %}
  {% set type %}{% call typeBlock property %}{% endset %}
  {{property.name|kotlinIdentifier:"pretty"|lowerFirstWord}}: {{type}}{{ "," if not forloop.last }}
  {% endfor %}
  {% endif %}
{% endmacro %}
{% macro eventPropertiesBlock properties %}
  {%- if not properties -%}
  emptyMap()
  {%- else -%}
  mapOf(
  {% filter indent:2," ",true %}
  {% for property in properties %}
  "{{property.name}}" to {{property.name|kotlinIdentifier:"pretty"|lowerFirstWord}}{{ "," if not forloop.last }}
  {% endfor %}
  {% endfilter %}
  ){% for property in properties %}{% if not property.required and not property.value %}.withoutNulls(){% break %}{% endif %}{% endfor %}
  {% endif %}
{% endmacro %}

{{accessModifier}} object {{param.enumName|default:"GeneratedAnalyticsEvents"}} {
  {% if files.count > 1 or param.forceFileNameEnum %}
  {% for file in files %}
  {{accessModifier}} object {{file.name|kotlinIdentifier:"pretty"|escapeReservedKeywords}} {
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

{{accessModifier}} data class {{eventClassName}}(
  {{accessModifier}} val name: String,
  {{accessModifier}} val parameters: Map<String, Any> = emptyMap()
)
{% endif %}
{% else %}
// No files found
{% endif %}

private fun Map<String, Any?>.withoutNulls(): Map<String, Any> =
    this.filterValues { it != null }.mapValues { it.value!! }
"""
}

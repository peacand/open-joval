<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oval="http://oval.mitre.org/XMLSchema/oval-common-5" xmlns:oval-res="http://oval.mitre.org/XMLSchema/oval-results-5" xmlns:oval-def="http://oval.mitre.org/XMLSchema/oval-definitions-5" xmlns:oval-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5" version="1.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
<xsl:param name="archiveDirParameter"/>
<xsl:param name="archiveNameParameter"/>
<xsl:param name="fileNameParameter"/>
<xsl:param name="fileDirParameter"/>

<!--PHASES-->


<!--PROLOG-->
<xsl:output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" method="xml" omit-xml-declaration="no" standalone="yes" indent="yes"/>

<!--KEYS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
<xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="namespace-uri()=''">
<xsl:value-of select="name()"/>
<xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])"/>
<xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:text>*[local-name()='</xsl:text>
<xsl:value-of select="local-name()"/>
<xsl:text>' and namespace-uri()='</xsl:text>
<xsl:value-of select="namespace-uri()"/>
<xsl:text>']</xsl:text>
<xsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])"/>
<xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="@*" mode="schematron-get-full-path">
<xsl:text>/</xsl:text>
<xsl:choose>
<xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
</xsl:when>
<xsl:otherwise>
<xsl:text>@*[local-name()='</xsl:text>
<xsl:value-of select="local-name()"/>
<xsl:text>' and namespace-uri()='</xsl:text>
<xsl:value-of select="namespace-uri()"/>
<xsl:text>']</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
<xsl:for-each select="ancestor-or-self::*">
<xsl:text>/</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:if test="preceding-sibling::*[name(.)=name(current())]">
<xsl:text>[</xsl:text>
<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:if test="not(self::*)">
<xsl:text/>/@<xsl:value-of select="name(.)"/>
</xsl:if>
</xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path"/>
<xsl:template match="text()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
</xsl:template>
<xsl:template match="comment()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
</xsl:template>
<xsl:template match="processing-instruction()" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
</xsl:template>
<xsl:template match="@*" mode="generate-id-from-path">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:value-of select="concat('.@', name())"/>
</xsl:template>
<xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
<xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
<xsl:text>.</xsl:text>
<xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
</xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
<xsl:for-each select="ancestor-or-self::*">
<xsl:text>/</xsl:text>
<xsl:value-of select="name(.)"/>
<xsl:if test="parent::*">
<xsl:text>[</xsl:text>
<xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
<xsl:text>]</xsl:text>
</xsl:if>
</xsl:for-each>
<xsl:if test="not(self::*)">
<xsl:text/>/@<xsl:value-of select="name(.)"/>
</xsl:if>
</xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
<xsl:template match="*" mode="generate-id-2" priority="2">
<xsl:text>U</xsl:text>
<xsl:number level="multiple" count="*"/>
</xsl:template>
<xsl:template match="node()" mode="generate-id-2">
<xsl:text>U.</xsl:text>
<xsl:number level="multiple" count="*"/>
<xsl:text>n</xsl:text>
<xsl:number count="node()"/>
</xsl:template>
<xsl:template match="@*" mode="generate-id-2">
<xsl:text>U.</xsl:text>
<xsl:number level="multiple" count="*"/>
<xsl:text>_</xsl:text>
<xsl:value-of select="string-length(local-name(.))"/>
<xsl:text>_</xsl:text>
<xsl:value-of select="translate(name(),':','.')"/>
</xsl:template>
<!--Strip characters-->
<xsl:template match="text()" priority="-1"/>

<!--SCHEMA METADATA-->
<xsl:template match="/">
<svrl:schematron-output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Schematron validation for an OVAL Results file" schemaVersion="">
<xsl:comment>
<xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
</xsl:comment>
<svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-common-5" prefix="oval"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-results-5" prefix="oval-res"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-definitions-5" prefix="oval-def"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5" prefix="oval-sc"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval_none_exist_value_dep</xsl:attribute>
<xsl:attribute name="name">oval_none_exist_value_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M10"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-res_directives_include_oval_definitions</xsl:attribute>
<xsl:attribute name="name">oval-res_directives_include_oval_definitions</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M11"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-res_system</xsl:attribute>
<xsl:attribute name="name">oval-res_system</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M12"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-res_mask_rule</xsl:attribute>
<xsl:attribute name="name">oval-res_mask_rule</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M13"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-res_directives</xsl:attribute>
<xsl:attribute name="name">oval-res_directives</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M14"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-res_testids</xsl:attribute>
<xsl:attribute name="name">oval-res_testids</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M15"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_empty_def_doc</xsl:attribute>
<xsl:attribute name="name">oval-def_empty_def_doc</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M16"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_required_criteria</xsl:attribute>
<xsl:attribute name="name">oval-def_required_criteria</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M17"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_test_type</xsl:attribute>
<xsl:attribute name="name">oval-def_test_type</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M18"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_setobjref</xsl:attribute>
<xsl:attribute name="name">oval-def_setobjref</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M19"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_literal_component</xsl:attribute>
<xsl:attribute name="name">oval-def_literal_component</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M20"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_arithmeticfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_arithmeticfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M21"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_beginfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_beginfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M22"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_concatfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_concatfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M23"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_endfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_endfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M24"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_escaperegexfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_escaperegexfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M25"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_splitfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_splitfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M26"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_substringfunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_substringfunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M27"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_timedifferencefunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_timedifferencefunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M28"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_regexcapturefunctionrules</xsl:attribute>
<xsl:attribute name="name">oval-def_regexcapturefunctionrules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M29"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_definition_entity_rules</xsl:attribute>
<xsl:attribute name="name">oval-def_definition_entity_rules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M30"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_no_var_ref_with_records</xsl:attribute>
<xsl:attribute name="name">oval-def_no_var_ref_with_records</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M31"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-def_definition_entity_type_check_rules</xsl:attribute>
<xsl:attribute name="name">oval-def_definition_entity_type_check_rules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M32"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-sc_entity_rules</xsl:attribute>
<xsl:attribute name="name">oval-sc_entity_rules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M33"/>
</svrl:schematron-output>
</xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron validation for an OVAL Results file</svrl:text>

<!--PATTERN oval_none_exist_value_dep-->


	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:tests/child::*" priority="1000" mode="M10">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions/oval-def:tests/child::*"/>

		<!--REPORT -->
<xsl:if test="@check='none exist'">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@check='none exist'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                             DEPRECATED ATTRIBUTE VALUE IN: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ATTRIBUTE VALUE:
                                        </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M10"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M10"/>
<xsl:template match="@*|node()" priority="-2" mode="M10">
<xsl:apply-templates select="@*|*" mode="M10"/>
</xsl:template>

<!--PATTERN oval-res_directives_include_oval_definitions-->


	<!--RULE -->
<xsl:template match="oval-res:oval_results/oval-res:directives[@include_source_definitions='true' or @include_source_definitions='1' or not(@include_source_definitions)]" priority="1001" mode="M11">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:oval_results/oval-res:directives[@include_source_definitions='true' or @include_source_definitions='1' or not(@include_source_definitions)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-res:oval_results[oval-def:oval_definitions]"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-res:oval_results[oval-def:oval_definitions]">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                                  The source OVAL Definition document must be included when the directives include_source_definitions attribute is set to true.
                                             </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M11"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:oval_results/oval-res:directives[@include_source_definitions='false' or @include_source_definitions='0']" priority="1000" mode="M11">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:oval_results/oval-res:directives[@include_source_definitions='false' or @include_source_definitions='0']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-res:oval_results[not(oval-def:oval_definitions)]"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-res:oval_results[not(oval-def:oval_definitions)]">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                                  The source OVAL Definition document must not be included when the directives include_source_definitions attribute is set to false.
                                             </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M11"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M11"/>
<xsl:template match="@*|node()" priority="-2" mode="M11">
<xsl:apply-templates select="@*|*" mode="M11"/>
</xsl:template>

<!--PATTERN oval-res_system-->


	<!--RULE -->
<xsl:template match="oval-res:system[oval-res:tests]" priority="1001" mode="M12">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:system[oval-res:tests]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="/oval-res:oval_results/oval-res:directives/*[@reported='true' or @reported='1']/@content='full'                                                 or /oval-res:oval_results/oval-res:directives/*[(@reported='true' or @reported='1') and not(@content)]                                                 or /oval-res:oval_results/oval-res:class_directives/*[@reported='true' or @reported='1']/@content='full'                                                 or /oval-res:oval_results/oval-res:class_directives/*[(@reported='true' or @reported='1') and not(@content)]"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="/oval-res:oval_results/oval-res:directives/*[@reported='true' or @reported='1']/@content='full' or /oval-res:oval_results/oval-res:directives/*[(@reported='true' or @reported='1') and not(@content)] or /oval-res:oval_results/oval-res:class_directives/*[@reported='true' or @reported='1']/@content='full' or /oval-res:oval_results/oval-res:class_directives/*[(@reported='true' or @reported='1') and not(@content)]">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   The tests element should not be included unless full results are to be provided (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M12"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:system[not(oval-res:tests)]" priority="1000" mode="M12">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:system[not(oval-res:tests)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(oval-res:oval_results/oval-res:directives/*[@reported='true' or @reported='1']/@content='full')                                                  and not(/oval-res:oval_results/oval-res:directives/*[(@reported='true' or @reported='1') and not(@content)])                                                 and not(/oval-res:oval_results/oval-res:class_directives/*[@reported='true' or @reported='1']/@content='full')                                                 and not(/oval-res:oval_results/oval-res:class_directives/*[(@reported='true' or @reported='1') and not(@content)])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(oval-res:oval_results/oval-res:directives/*[@reported='true' or @reported='1']/@content='full') and not(/oval-res:oval_results/oval-res:directives/*[(@reported='true' or @reported='1') and not(@content)]) and not(/oval-res:oval_results/oval-res:class_directives/*[@reported='true' or @reported='1']/@content='full') and not(/oval-res:oval_results/oval-res:class_directives/*[(@reported='true' or @reported='1') and not(@content)])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   The tests element should be included when full results are specified (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M12"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M12"/>
<xsl:template match="@*|node()" priority="-2" mode="M12">
<xsl:apply-templates select="@*|*" mode="M12"/>
</xsl:template>

<!--PATTERN oval-res_mask_rule-->


	<!--RULE -->
<xsl:template match="/oval-res:oval_results/oval-res:results/oval-res:system/oval-sc:oval_system_characteristics/oval-sc:system_data/*/*|/oval-res:oval_results/oval-res:results/oval-res:system/oval-sc:oval_system_characteristics/oval-sc:system_data/*/*/*" priority="1000" mode="M13">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="/oval-res:oval_results/oval-res:results/oval-res:system/oval-sc:oval_system_characteristics/oval-sc:system_data/*/*|/oval-res:oval_results/oval-res:results/oval-res:system/oval-sc:oval_system_characteristics/oval-sc:system_data/*/*/*"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@mask) or @mask='false' or @mask='0' or .=''"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@mask) or @mask='false' or @mask='0' or .=''">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>item <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a value for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity should only be supplied if the mask attribute is 'false'.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M13"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M13"/>
<xsl:template match="@*|node()" priority="-2" mode="M13">
<xsl:apply-templates select="@*|*" mode="M13"/>
</xsl:template>

<!--PATTERN oval-res_directives-->


	<!--RULE -->
<xsl:template match="oval-res:definition[@result='true' and oval-res:criteria]" priority="1011" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='true' and oval-res:criteria]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='1')                                    and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='1') and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of TRUE should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@content='full')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@content='full')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@content='full') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@content='full')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of TRUE should contain THIN content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='true' and not(oval-res:criteria)]" priority="1010" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='true' and not(oval-res:criteria)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_true/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of TRUE should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@content='thin')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@content='thin')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_true/@content='thin') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_true/@content='thin')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of TRUE should contain FULL content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='false' and oval-res:criteria]" priority="1009" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='false' and oval-res:criteria]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of FALSE should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@content='full')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@content='full')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@content='full') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@content='full')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of FALSE should contain THIN content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='false' and not(oval-res:criteria)]" priority="1008" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='false' and not(oval-res:criteria)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_false/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of FALSE should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@content='thin')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@content='thin')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_false/@content='thin') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_false/@content='thin')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of FALSE should contain FULL content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='unknown' and oval-res:criteria]" priority="1007" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='unknown' and oval-res:criteria]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of UNKNOWN should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@content='full')                                    and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@content='full')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@content='full') and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@content='full')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of UNKNOWN should contain THIN content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='unknown' and not(oval-res:criteria)]" priority="1006" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='unknown' and not(oval-res:criteria)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of UNKNOWN should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@content='thin')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@content='thin')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_unknown/@content='thin') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@content='thin')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of UNKNOWN should contain FULL content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='error' and oval-res:criteria]" priority="1005" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='error' and oval-res:criteria]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of ERROR should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@content='full')                                    and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@content='full')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@content='full') and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@content='full')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of ERROR should contain THIN content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='error' and not(oval-res:criteria)]" priority="1004" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='error' and not(oval-res:criteria)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_error/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_unknown/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of ERROR should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@content='thin')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@content='thin')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_error/@content='thin') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_error/@content='thin')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of ERROR should contain FULL content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='not evaluated' and oval-res:criteria]" priority="1003" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='not evaluated' and oval-res:criteria]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT EVALUATED should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@content='full')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@content='full')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@content='full') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@content='full')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT EVALUATED should contain THIN content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='not evaluated' and not(oval-res:criteria)]" priority="1002" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='not evaluated' and not(oval-res:criteria)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT EVALUATED should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@content='thin')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@content='thin')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_evaluated/@content='thin') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_evaluated/@content='thin')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT EVALUATED should contain FULL content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='not applicable' and oval-res:criteria]" priority="1001" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='not applicable' and oval-res:criteria]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT APPLICABLE should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@content='full')                                    and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@content='full')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@content='full') and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@content='full')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT APPLICABLE should contain THIN content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-res:definition[@result='not applicable' and not(oval-res:criteria)]" priority="1000" mode="M14">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:definition[@result='not applicable' and not(oval-res:criteria)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='1')                                    and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='1')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@reported='1') and not(/oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='true' or /oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@reported='1')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT APPLICABLE should not be included (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@content='thin')                                    and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class]))                                    or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@content='thin')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="((/oval-res:oval_results/oval-res:directives/oval-res:definition_not_applicable/@content='thin') and not(oval-res:oval_results/oval-res:class_directives[@class = ./@class])) or (/oval-res:oval_results/oval-res:class_directives[@class = ./@class]/oval-res:definition_not_applicable/@content='thin')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                   <xsl:text/>
<xsl:value-of select="@definition_id"/>
<xsl:text/> - definitions with a result of NOT APPLICABLE should contain FULL content (see directives)
                              </svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M14"/>
<xsl:template match="@*|node()" priority="-2" mode="M14">
<xsl:apply-templates select="@*|*" mode="M14"/>
</xsl:template>

<!--PATTERN oval-res_testids-->


	<!--RULE -->
<xsl:template match="oval-res:test" priority="1000" mode="M15">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-res:test"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@test_id = ../../oval-res:definitions//oval-res:criterion/@test_ref"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@test_id = ../../oval-res:definitions//oval-res:criterion/@test_ref">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="@test_id"/>
<xsl:text/> - the specified test is not used in any definition's criteria</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M15"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M15"/>
<xsl:template match="@*|node()" priority="-2" mode="M15">
<xsl:apply-templates select="@*|*" mode="M15"/>
</xsl:template>

<!--PATTERN oval-def_empty_def_doc-->


	<!--RULE -->
<xsl:template match="oval-def:oval_definitions" priority="1000" mode="M16">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="oval-def:definitions or oval-def:tests or oval-def:objects or oval-def:states or oval-def:variables"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oval-def:definitions or oval-def:tests or oval-def:objects or oval-def:states or oval-def:variables">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A valid OVAL Definition document must contain at least one definitions, tests, objects, states, or variables element. The optional definitions, tests, objects, states, and variables sections define the specific characteristics that should be evaluated on a system to determine the truth values of the OVAL Definition Document. To be valid though, at least one definitions, tests, objects, states, or variables element must be present.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M16"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M16"/>
<xsl:template match="@*|node()" priority="-2" mode="M16">
<xsl:apply-templates select="@*|*" mode="M16"/>
</xsl:template>

<!--PATTERN oval-def_required_criteria-->


	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[(@deprecated='false' or @deprecated='0') or not(@deprecated)]" priority="1000" mode="M17">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions/oval-def:definitions/oval-def:definition[(@deprecated='false' or @deprecated='0') or not(@deprecated)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="oval-def:criteria"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="oval-def:criteria">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A valid OVAL Definition must contain a criteria unless the definition is a deprecated definition.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M17"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M17"/>
<xsl:template match="@*|node()" priority="-2" mode="M17">
<xsl:apply-templates select="@*|*" mode="M17"/>
</xsl:template>

<!--PATTERN oval-def_test_type-->


	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:tests/*[@check_existence='none_exist']" priority="1000" mode="M18">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions/oval-def:tests/*[@check_existence='none_exist']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(*[local-name()='state'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(*[local-name()='state'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/> - No state should be referenced when check_existence has a value of 'none_exist'.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M18"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M18"/>
<xsl:template match="@*|node()" priority="-2" mode="M18">
<xsl:apply-templates select="@*|*" mode="M18"/>
</xsl:template>

<!--PATTERN oval-def_setobjref-->


	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:objects/*/oval-def:set/oval-def:object_reference" priority="1002" mode="M19">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions/oval-def:objects/*/oval-def:set/oval-def:object_reference"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="name(./../..) = name(ancestor::oval-def:oval_definitions/oval-def:objects/*[@id=current()])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="name(./../..) = name(ancestor::oval-def:oval_definitions/oval-def:objects/*[@id=current()])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../../@id"/>
<xsl:text/> - Each object referenced by the set must be of the same type as parent object</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M19"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:objects/*/oval-def:set/oval-def:set/oval-def:object_reference" priority="1001" mode="M19">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions/oval-def:objects/*/oval-def:set/oval-def:set/oval-def:object_reference"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="name(./../../..) = name(ancestor::oval-def:oval_definitions/oval-def:objects/*[@id=current()])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="name(./../../..) = name(ancestor::oval-def:oval_definitions/oval-def:objects/*[@id=current()])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../../../@id"/>
<xsl:text/> - Each object referenced by the set must be of the same type as parent object</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M19"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:objects/*/oval-def:set/oval-def:set/oval-def:set/oval-def:object_reference" priority="1000" mode="M19">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:oval_definitions/oval-def:objects/*/oval-def:set/oval-def:set/oval-def:set/oval-def:object_reference"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="name(./../../../..) = name(ancestor::oval-def:oval_definitions/oval-def:objects/*[@id=current()])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="name(./../../../..) = name(ancestor::oval-def:oval_definitions/oval-def:objects/*[@id=current()])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../../../../@id"/>
<xsl:text/> - Each object referenced by the set must be of the same type as parent object</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M19"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M19"/>
<xsl:template match="@*|node()" priority="-2" mode="M19">
<xsl:apply-templates select="@*|*" mode="M19"/>
</xsl:template>

<!--PATTERN oval-def_literal_component-->


	<!--RULE -->
<xsl:template match="oval-def:literal_component" priority="1000" mode="M20">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype='record')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype='record')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="ancestor::*/@id"/>
<xsl:text/> - The 'record' datatype is prohibited on variables.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M20"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M20"/>
<xsl:template match="@*|node()" priority="-2" mode="M20">
<xsl:apply-templates select="@*|*" mode="M20"/>
</xsl:template>

<!--PATTERN oval-def_arithmeticfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:arithmetic/oval-def:literal_component" priority="1001" mode="M21">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:arithmetic/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='float' or @datatype='int'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='float' or @datatype='int'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by an arithmetic function must have a datatype of float or int.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M21"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:arithmetic/oval-def:variable_component" priority="1000" mode="M21">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:arithmetic/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='float' or ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='int'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='float' or ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='int'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the arithmetic function must have a datatype of float or int.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M21"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M21"/>
<xsl:template match="@*|node()" priority="-2" mode="M21">
<xsl:apply-templates select="@*|*" mode="M21"/>
</xsl:template>

<!--PATTERN oval-def_beginfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:begin/oval-def:literal_component" priority="1001" mode="M22">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:begin/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the begin function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M22"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:begin/oval-def:variable_component" priority="1000" mode="M22">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:begin/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the begin function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M22"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M22"/>
<xsl:template match="@*|node()" priority="-2" mode="M22">
<xsl:apply-templates select="@*|*" mode="M22"/>
</xsl:template>

<!--PATTERN oval-def_concatfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:concat/oval-def:literal_component" priority="1001" mode="M23">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:concat/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the concat function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M23"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:concat/oval-def:variable_component" priority="1000" mode="M23">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:concat/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the concat function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M23"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M23"/>
<xsl:template match="@*|node()" priority="-2" mode="M23">
<xsl:apply-templates select="@*|*" mode="M23"/>
</xsl:template>

<!--PATTERN oval-def_endfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:end/oval-def:literal_component" priority="1001" mode="M24">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:end/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the end function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M24"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:end/oval-def:variable_component" priority="1000" mode="M24">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:end/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the end function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M24"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M24"/>
<xsl:template match="@*|node()" priority="-2" mode="M24">
<xsl:apply-templates select="@*|*" mode="M24"/>
</xsl:template>

<!--PATTERN oval-def_escaperegexfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:escape_regex/oval-def:literal_component" priority="1001" mode="M25">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:escape_regex/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the escape_regex function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M25"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:escape_regex/oval-def:variable_component" priority="1000" mode="M25">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:escape_regex/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the escape_regex function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M25"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M25"/>
<xsl:template match="@*|node()" priority="-2" mode="M25">
<xsl:apply-templates select="@*|*" mode="M25"/>
</xsl:template>

<!--PATTERN oval-def_splitfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:split/oval-def:literal_component" priority="1001" mode="M26">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:split/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the split function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M26"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:split/oval-def:variable_component" priority="1000" mode="M26">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:split/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the split function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M26"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M26"/>
<xsl:template match="@*|node()" priority="-2" mode="M26">
<xsl:apply-templates select="@*|*" mode="M26"/>
</xsl:template>

<!--PATTERN oval-def_substringfunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:substring/oval-def:literal_component" priority="1001" mode="M27">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:substring/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the substring function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M27"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:substring/oval-def:variable_component" priority="1000" mode="M27">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:substring/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the substring function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M27"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M27"/>
<xsl:template match="@*|node()" priority="-2" mode="M27">
<xsl:apply-templates select="@*|*" mode="M27"/>
</xsl:template>

<!--PATTERN oval-def_timedifferencefunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:time_difference/oval-def:literal_component" priority="1001" mode="M28">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:time_difference/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string' or @datatype='int'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string' or @datatype='int'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the time_difference function must have a datatype of string or int.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M28"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:time_difference/oval-def:variable_component" priority="1000" mode="M28">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:time_difference/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='string' or ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='int'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='string' or ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype='int'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the time_difference function must have a datatype of string or int.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M28"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M28"/>
<xsl:template match="@*|node()" priority="-2" mode="M28">
<xsl:apply-templates select="@*|*" mode="M28"/>
</xsl:template>

<!--PATTERN oval-def_regexcapturefunctionrules-->


	<!--RULE -->
<xsl:template match="oval-def:regex_capture/oval-def:literal_component" priority="1001" mode="M29">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:regex_capture/oval-def:literal_component"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@datatype) or @datatype='string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@datatype) or @datatype='string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>A literal_component used by the regex_capture function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M29"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:regex_capture/oval-def:variable_component" priority="1000" mode="M29">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:regex_capture/oval-def:variable_component"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype = 'string'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The variable referenced by the regex_capture function must have a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M29"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M29"/>
<xsl:template match="@*|node()" priority="-2" mode="M29">
<xsl:apply-templates select="@*|*" mode="M29"/>
</xsl:template>

<!--PATTERN oval-def_definition_entity_rules-->


	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@var_ref]|oval-def:objects/*/*/*[@var_ref]|oval-def:states/*/*[@var_ref]|oval-def:states/*/*/*[@var_ref]" priority="1017" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@var_ref]|oval-def:objects/*/*/*[@var_ref]|oval-def:states/*/*[@var_ref]|oval-def:states/*/*/*[@var_ref]"/>
<xsl:variable name="var_ref" select="@var_ref"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test=".=''"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".=''">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a var_ref has been supplied for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity so no value should be provided</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="( (not(@datatype)) and ('string' = ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype) ) or (@datatype = ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="( (not(@datatype)) and ('string' = ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype) ) or (@datatype = ancestor::oval-def:oval_definitions/oval-def:variables/*[@id=$var_ref]/@datatype)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="$var_ref"/>
<xsl:text/> - inconsistent datatype between the variable and an associated var_ref</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@var_ref]|oval-def:objects/*/*/*[@var_ref]" priority="1016" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@var_ref]|oval-def:objects/*/*/*[@var_ref]"/>

		<!--REPORT -->
<xsl:if test="not(@var_check)">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@var_check)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a var_ref has been supplied for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity so a var_check should also be provided</svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@var_check]|oval-def:objects/*/*/*[@var_check]" priority="1015" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@var_check]|oval-def:objects/*/*/*[@var_check]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@var_ref"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@var_ref">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a var_check has been supplied for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity so a var_ref must also be provided</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:states/*/*[@var_ref]|oval-def:states/*/*/*[@var_ref]" priority="1014" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:states/*/*[@var_ref]|oval-def:states/*/*/*[@var_ref]"/>

		<!--REPORT -->
<xsl:if test="not(@var_check)">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@var_check)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a var_ref has been supplied for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity so a var_check should also be provided</svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:states/*/*[@var_check]|oval-def:states/*/*/*[@var_check]" priority="1013" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:states/*/*[@var_check]|oval-def:states/*/*/*[@var_check]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@var_ref"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@var_ref">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a var_check has been supplied for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity so a var_ref must also be provided</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[not(@datatype)]|oval-def:objects/*/*/*[not(@datatype)]|oval-def:states/*/*[not(@datatype)]|oval-def:states/*/*/*[not(@datatype)]" priority="1012" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[not(@datatype)]|oval-def:objects/*/*/*[not(@datatype)]|oval-def:states/*/*[not(@datatype)]|oval-def:states/*/*/*[not(@datatype)]"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='case insensitive equals' or @operation='case insensitive not equal' or @operation='pattern match'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='case insensitive equals' or @operation='case insensitive not equal' or @operation='pattern match'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given the lack of a declared datatype (hence a default datatype of string).</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='binary']|oval-def:objects/*/*/*[@datatype='binary']|oval-def:states/*/*[@datatype='binary']|oval-def:states/*/*/*[@datatype='binary']" priority="1011" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='binary']|oval-def:objects/*/*/*[@datatype='binary']|oval-def:states/*/*[@datatype='binary']|oval-def:states/*/*/*[@datatype='binary']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of binary.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='boolean']|oval-def:objects/*/*/*[@datatype='boolean']|oval-def:states/*/*[@datatype='boolean']|oval-def:states/*/*/*[@datatype='boolean']" priority="1010" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='boolean']|oval-def:objects/*/*/*[@datatype='boolean']|oval-def:states/*/*[@datatype='boolean']|oval-def:states/*/*/*[@datatype='boolean']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of boolean.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='evr_string']|oval-def:objects/*/*/*[@datatype='evr_string']|oval-def:states/*/*[@datatype='evr_string']|oval-def:states/*/*/*[@datatype='evr_string']" priority="1009" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='evr_string']|oval-def:objects/*/*/*[@datatype='evr_string']|oval-def:states/*/*[@datatype='evr_string']|oval-def:states/*/*/*[@datatype='evr_string']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or  @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of evr_string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='fileset_revision']|oval-def:objects/*/*/*[@datatype='fileset_revision']|oval-def:states/*/*[@datatype='fileset_revision']|oval-def:states/*/*/*[@datatype='fileset_revision']" priority="1008" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='fileset_revision']|oval-def:objects/*/*/*[@datatype='fileset_revision']|oval-def:states/*/*[@datatype='fileset_revision']|oval-def:states/*/*/*[@datatype='fileset_revision']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or  @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of fileset_revision.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='float']|oval-def:objects/*/*/*[@datatype='float']|oval-def:states/*/*[@datatype='float']|oval-def:states/*/*/*[@datatype='float']" priority="1007" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='float']|oval-def:objects/*/*/*[@datatype='float']|oval-def:states/*/*[@datatype='float']|oval-def:states/*/*/*[@datatype='float']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of float.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='ios_version']|oval-def:objects/*/*/*[@datatype='ios_version']|oval-def:states/*/*[@datatype='ios_version']|oval-def:states/*/*/*[@datatype='ios_version']" priority="1006" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='ios_version']|oval-def:objects/*/*/*[@datatype='ios_version']|oval-def:states/*/*[@datatype='ios_version']|oval-def:states/*/*/*[@datatype='ios_version']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of ios_version.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='int']|oval-def:objects/*/*/*[@datatype='int']|oval-def:states/*/*[@datatype='int']|oval-def:states/*/*/*[@datatype='int']" priority="1005" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='int']|oval-def:objects/*/*/*[@datatype='int']|oval-def:states/*/*[@datatype='int']|oval-def:states/*/*/*[@datatype='int']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal' or @operation='bitwise and' or @operation='bitwise or'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal' or @operation='bitwise and' or @operation='bitwise or'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of int.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='ipv4_address']|oval-def:objects/*/*/*[@datatype='ipv4_address']|oval-def:states/*/*[@datatype='ipv4_address']|oval-def:states/*/*/*[@datatype='ipv4_address']" priority="1004" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='ipv4_address']|oval-def:objects/*/*/*[@datatype='ipv4_address']|oval-def:states/*/*[@datatype='ipv4_address']|oval-def:states/*/*/*[@datatype='ipv4_address']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal' or @operation='subset of' or @operation='superset of'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal' or @operation='subset of' or @operation='superset of'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of ipv4_address.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='ipv6_address']|oval-def:objects/*/*/*[@datatype='ipv6_address']|oval-def:states/*/*[@datatype='ipv6_address']|oval-def:states/*/*/*[@datatype='ipv6_address']" priority="1003" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='ipv6_address']|oval-def:objects/*/*/*[@datatype='ipv6_address']|oval-def:states/*/*[@datatype='ipv6_address']|oval-def:states/*/*/*[@datatype='ipv6_address']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal' or @operation='subset of' or @operation='superset of'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal' or @operation='subset of' or @operation='superset of'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of ipv6_address.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='string']|oval-def:objects/*/*/*[@datatype='string']|oval-def:states/*/*[@datatype='string']|oval-def:states/*/*/*[@datatype='string']" priority="1002" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='string']|oval-def:objects/*/*/*[@datatype='string']|oval-def:states/*/*[@datatype='string']|oval-def:states/*/*/*[@datatype='string']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='case insensitive equals' or @operation='case insensitive not equal' or @operation='pattern match'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='case insensitive equals' or @operation='case insensitive not equal' or @operation='pattern match'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of string.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='version']|oval-def:objects/*/*/*[@datatype='version']|oval-def:states/*/*[@datatype='version']|oval-def:states/*/*/*[@datatype='version']" priority="1001" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='version']|oval-def:objects/*/*/*[@datatype='version']|oval-def:states/*/*[@datatype='version']|oval-def:states/*/*/*[@datatype='version']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals' or @operation='not equal' or @operation='greater than' or @operation='greater than or equal' or @operation='less than' or @operation='less than or equal'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of version.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='record']|oval-def:states/*/*[@datatype='record']" priority="1000" mode="M30">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='record']|oval-def:states/*/*[@datatype='record']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@operation) or @operation='equals'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@operation) or @operation='equals'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of '<xsl:text/>
<xsl:value-of select="@operation"/>
<xsl:text/>' for the operation attribute of the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is not valid given a datatype of record.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M30"/>
<xsl:template match="@*|node()" priority="-2" mode="M30">
<xsl:apply-templates select="@*|*" mode="M30"/>
</xsl:template>

<!--PATTERN oval-def_no_var_ref_with_records-->


	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[@datatype='record']|oval-def:states/*/*[@datatype='record']" priority="1000" mode="M31">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[@datatype='record']|oval-def:states/*/*[@datatype='record']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@var_ref)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@var_ref)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The use of var_ref is prohibited when the datatype is 'record'.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M31"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M31"/>
<xsl:template match="@*|node()" priority="-2" mode="M31">
<xsl:apply-templates select="@*|*" mode="M31"/>
</xsl:template>

<!--PATTERN oval-def_definition_entity_type_check_rules-->


	<!--RULE -->
<xsl:template match="oval-def:objects/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and not(@var_ref) and @datatype='int']|oval-def:objects/*/*/*[not(@var_ref) and @datatype='int']|oval-def:states/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and not(@var_ref) and @datatype='int']|oval-def:states/*/*/*[not(@var_ref) and @datatype='int']" priority="1000" mode="M32">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-def:objects/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and not(@var_ref) and @datatype='int']|oval-def:objects/*/*/*[not(@var_ref) and @datatype='int']|oval-def:states/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and not(@var_ref) and @datatype='int']|oval-def:states/*/*/*[not(@var_ref) and @datatype='int']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="(not(contains(.,'.'))) and (number(.) = floor(.))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(not(contains(.,'.'))) and (number(.) = floor(.))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The datatype for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is 'int' but the value is not an integer.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M32"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M32"/>
<xsl:template match="@*|node()" priority="-2" mode="M32">
<xsl:apply-templates select="@*|*" mode="M32"/>
</xsl:template>

<!--PATTERN oval-sc_entity_rules-->


	<!--RULE -->
<xsl:template match="oval-sc:system_data/*/*|oval-sc:system_data/*/*/*" priority="1001" mode="M33">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-sc:system_data/*/*|oval-sc:system_data/*/*/*"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="not(@status) or @status='exists' or .=''"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="not(@status) or @status='exists' or .=''">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>item <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - a value for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity should only be supplied if the status attribute is 'exists'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M33"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="oval-sc:system_data/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and @datatype='int']|oval-sc:system_data/*/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and @datatype='int']" priority="1000" mode="M33">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-sc:system_data/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and @datatype='int']|oval-sc:system_data/*/*/*[not((@xsi:nil='1' or @xsi:nil='true')) and @datatype='int']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="(not(contains(.,'.'))) and (number(.) = floor(.))"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="(not(contains(.,'.'))) and (number(.) = floor(.))">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - The datatype for the <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> entity is 'int' but the value is not an integer.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M33"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M33"/>
<xsl:template match="@*|node()" priority="-2" mode="M33">
<xsl:apply-templates select="@*|*" mode="M33"/>
</xsl:template>
</xsl:stylesheet>

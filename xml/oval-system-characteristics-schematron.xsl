<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:oval="http://oval.mitre.org/XMLSchema/oval-common-5" xmlns:oval-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5" xmlns:ind-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#independent" xmlns:aix-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#aix" xmlns:apache-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#apache" xmlns:catos-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#catos" xmlns:esx-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#esx" xmlns:freebsd-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#freebsd" xmlns:hpux-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#hpux" xmlns:ios-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#ios" xmlns:linux-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#linux" xmlns:macos-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#macos" xmlns:pixos-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#pixos" xmlns:sp-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#sharepoint" xmlns:sol-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#solaris" xmlns:unix-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#unix" xmlns:win-sc="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#windows" xmlns:oval-def="http://oval.mitre.org/XMLSchema/oval-definitions-5" version="1.0">
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
<svrl:schematron-output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="Schematron validation for an OVAL System Characteristics file" schemaVersion="">
<xsl:comment>
<xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
</xsl:comment>
<svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-common-5" prefix="oval"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5" prefix="oval-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#independent" prefix="ind-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#aix" prefix="aix-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#apache" prefix="apache-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#catos" prefix="catos-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#esx" prefix="esx-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#freebsd" prefix="freebsd-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#hpux" prefix="hpux-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#ios" prefix="ios-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#linux" prefix="linux-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#macos" prefix="macos-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#pixos" prefix="pixos-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#sharepoint" prefix="sp-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#solaris" prefix="sol-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#unix" prefix="unix-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-system-characteristics-5#windows" prefix="win-sc"/>
<svrl:ns-prefix-in-attribute-values uri="http://oval.mitre.org/XMLSchema/oval-definitions-5" prefix="oval-def"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval_none_exist_value_dep</xsl:attribute>
<xsl:attribute name="name">oval_none_exist_value_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M32"/>
<svrl:active-pattern>
<xsl:attribute name="id">oval-sc_entity_rules</xsl:attribute>
<xsl:attribute name="name">oval-sc_entity_rules</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M33"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_filehash_item_dep</xsl:attribute>
<xsl:attribute name="name">ind-sc_filehash_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M34"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_environmentvariable_item_dep</xsl:attribute>
<xsl:attribute name="name">ind-sc_environmentvariable_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M35"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_ldap57_itemvalue</xsl:attribute>
<xsl:attribute name="name">ind-sc_ldap57_itemvalue</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M36"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_sql_item_dep</xsl:attribute>
<xsl:attribute name="name">ind-sc_sql_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M37"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_sql57_itemresult</xsl:attribute>
<xsl:attribute name="name">ind-sc_sql57_itemresult</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M38"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_txtitemline</xsl:attribute>
<xsl:attribute name="name">ind-sc_txtitemline</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M39"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_ldaptype_timestamp_value_dep</xsl:attribute>
<xsl:attribute name="name">ind-sc_ldaptype_timestamp_value_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M40"/>
<svrl:active-pattern>
<xsl:attribute name="id">ind-sc_ldaptype_email_value_dep</xsl:attribute>
<xsl:attribute name="name">ind-sc_ldaptype_email_value_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M41"/>
<svrl:active-pattern>
<xsl:attribute name="id">apache-sc_httpd_item_dep</xsl:attribute>
<xsl:attribute name="name">apache-sc_httpd_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M42"/>
<svrl:active-pattern>
<xsl:attribute name="id">catos-sc_versionitemcatos_major_release</xsl:attribute>
<xsl:attribute name="name">catos-sc_versionitemcatos_major_release</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M43"/>
<svrl:active-pattern>
<xsl:attribute name="id">catos-sc_versionitemcatos_individual_release</xsl:attribute>
<xsl:attribute name="name">catos-sc_versionitemcatos_individual_release</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M44"/>
<svrl:active-pattern>
<xsl:attribute name="id">catos-sc_versionitemcatos_version_id</xsl:attribute>
<xsl:attribute name="name">catos-sc_versionitemcatos_version_id</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M45"/>
<svrl:active-pattern>
<xsl:attribute name="id">esx-sc_patchitempatch_number</xsl:attribute>
<xsl:attribute name="name">esx-sc_patchitempatch_number</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M46"/>
<svrl:active-pattern>
<xsl:attribute name="id">ios-sc_versionitemmajor_release</xsl:attribute>
<xsl:attribute name="name">ios-sc_versionitemmajor_release</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M47"/>
<svrl:active-pattern>
<xsl:attribute name="id">ios-sc_versionitemtrain_number</xsl:attribute>
<xsl:attribute name="name">ios-sc_versionitemtrain_number</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M48"/>
<svrl:active-pattern>
<xsl:attribute name="id">linux-sc_rpmverify_item_dep</xsl:attribute>
<xsl:attribute name="name">linux-sc_rpmverify_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M49"/>
<svrl:active-pattern>
<xsl:attribute name="id">macos-sc_inetlisteningserveritem_dep</xsl:attribute>
<xsl:attribute name="name">macos-sc_inetlisteningserveritem_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M50"/>
<svrl:active-pattern>
<xsl:attribute name="id">macos-sc_pwpolicy_item_dep</xsl:attribute>
<xsl:attribute name="name">macos-sc_pwpolicy_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M51"/>
<svrl:active-pattern>
<xsl:attribute name="id">sp-sc_spjobdefinition_item_dep</xsl:attribute>
<xsl:attribute name="name">sp-sc_spjobdefinition_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M52"/>
<svrl:active-pattern>
<xsl:attribute name="id">unix-sc_processitem_dep</xsl:attribute>
<xsl:attribute name="name">unix-sc_processitem_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M53"/>
<svrl:active-pattern>
<xsl:attribute name="id">unix-sc_sccsitem_dep</xsl:attribute>
<xsl:attribute name="name">unix-sc_sccsitem_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M54"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_activedirectory57_itemvalue</xsl:attribute>
<xsl:attribute name="name">win-sc_activedirectory57_itemvalue</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M55"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_cmdletitemparameters</xsl:attribute>
<xsl:attribute name="name">win-sc_cmdletitemparameters</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M56"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_cmdletitemselect</xsl:attribute>
<xsl:attribute name="name">win-sc_cmdletitemselect</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M57"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_cmdletitemvalue</xsl:attribute>
<xsl:attribute name="name">win-sc_cmdletitemvalue</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M58"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_fileaudititemtrustee_name</xsl:attribute>
<xsl:attribute name="name">win-sc_fileaudititemtrustee_name</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M59"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_feritemtrustee_name</xsl:attribute>
<xsl:attribute name="name">win-sc_feritemtrustee_name</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M60"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_regitemkey</xsl:attribute>
<xsl:attribute name="name">win-sc_regitemkey</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M61"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_rapitemtrustee_name</xsl:attribute>
<xsl:attribute name="name">win-sc_rapitemtrustee_name</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M62"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_rapitemstandard_synchronize</xsl:attribute>
<xsl:attribute name="name">win-sc_rapitemstandard_synchronize</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M63"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_reritemtrustee_name</xsl:attribute>
<xsl:attribute name="name">win-sc_reritemtrustee_name</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M64"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_reritemstandard_synchronize</xsl:attribute>
<xsl:attribute name="name">win-sc_reritemstandard_synchronize</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M65"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_wmi_item_dep</xsl:attribute>
<xsl:attribute name="name">win-sc_wmi_item_dep</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M66"/>
<svrl:active-pattern>
<xsl:attribute name="id">win-sc_wmi57_itemresult</xsl:attribute>
<xsl:attribute name="name">win-sc_wmi57_itemresult</xsl:attribute>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M67"/>
</svrl:schematron-output>
</xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl">Schematron validation for an OVAL System Characteristics file</svrl:text>

<!--PATTERN oval_none_exist_value_dep-->


	<!--RULE -->
<xsl:template match="oval-def:oval_definitions/oval-def:tests/child::*" priority="1000" mode="M32">
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

<!--PATTERN ind-sc_filehash_item_dep-->


	<!--RULE -->
<xsl:template match="ind-sc:filehash_item" priority="1000" mode="M34">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ind-sc:filehash_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M34"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M34"/>
<xsl:template match="@*|node()" priority="-2" mode="M34">
<xsl:apply-templates select="@*|*" mode="M34"/>
</xsl:template>

<!--PATTERN ind-sc_environmentvariable_item_dep-->


	<!--RULE -->
<xsl:template match="ind-sc:environmentvariable_item" priority="1000" mode="M35">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ind-sc:environmentvariable_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M35"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M35"/>
<xsl:template match="@*|node()" priority="-2" mode="M35">
<xsl:apply-templates select="@*|*" mode="M35"/>
</xsl:template>

<!--PATTERN ind-sc_ldap57_itemvalue-->


	<!--RULE -->
<xsl:template match="ind-sc:ldap57_item/ind-sc:value" priority="1000" mode="M36">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ind-sc:ldap57_item/ind-sc:value"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the value entity of a ldap57_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M36"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M36"/>
<xsl:template match="@*|node()" priority="-2" mode="M36">
<xsl:apply-templates select="@*|*" mode="M36"/>
</xsl:template>

<!--PATTERN ind-sc_sql_item_dep-->


	<!--RULE -->
<xsl:template match="ind-sc:sql_item" priority="1000" mode="M37">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ind-sc:sql_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M37"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M37"/>
<xsl:template match="@*|node()" priority="-2" mode="M37">
<xsl:apply-templates select="@*|*" mode="M37"/>
</xsl:template>

<!--PATTERN ind-sc_sql57_itemresult-->


	<!--RULE -->
<xsl:template match="ind-sc:sql57_item/ind-sc:result" priority="1000" mode="M38">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ind-sc:sql57_item/ind-sc:result"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the result entity of a sql57_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M38"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M38"/>
<xsl:template match="@*|node()" priority="-2" mode="M38">
<xsl:apply-templates select="@*|*" mode="M38"/>
</xsl:template>

<!--PATTERN ind-sc_txtitemline-->


	<!--RULE -->
<xsl:template match="ind-sc:textfilecontent_item/ind-sc:line" priority="1000" mode="M39">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ind-sc:textfilecontent_item/ind-sc:line"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M39"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M39"/>
<xsl:template match="@*|node()" priority="-2" mode="M39">
<xsl:apply-templates select="@*|*" mode="M39"/>
</xsl:template>

<!--PATTERN ind-sc_ldaptype_timestamp_value_dep-->


	<!--RULE -->
<xsl:template match="oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap_item/ind-sc:ldaptype|oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap57_item/ind-sc:ldaptype" priority="1000" mode="M40">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap_item/ind-sc:ldaptype|oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap57_item/ind-sc:ldaptype"/>

		<!--REPORT -->
<xsl:if test=".='LDAPTYPE_TIMESTAMP'">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".='LDAPTYPE_TIMESTAMP'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                                  DEPRECATED ELEMENT VALUE IN: ldap_item ELEMENT VALUE: <xsl:text/>
<xsl:value-of select="."/>
<xsl:text/> 
                                             </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M40"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M40"/>
<xsl:template match="@*|node()" priority="-2" mode="M40">
<xsl:apply-templates select="@*|*" mode="M40"/>
</xsl:template>

<!--PATTERN ind-sc_ldaptype_email_value_dep-->


	<!--RULE -->
<xsl:template match="oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap_item/ind-sc:ldaptype|oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap57_item/ind-sc:ldaptype" priority="1000" mode="M41">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap_item/ind-sc:ldaptype|oval-sc:oval_system_characteristics/oval-sc:system_data/ind-sc:ldap57_item/ind-sc:ldaptype"/>

		<!--REPORT -->
<xsl:if test=".='LDAPTYPE_EMAIL'">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test=".='LDAPTYPE_EMAIL'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
                                                  DEPRECATED ELEMENT VALUE IN: ldap_item ELEMENT VALUE: <xsl:text/>
<xsl:value-of select="."/>
<xsl:text/> 
                                             </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M41"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M41"/>
<xsl:template match="@*|node()" priority="-2" mode="M41">
<xsl:apply-templates select="@*|*" mode="M41"/>
</xsl:template>

<!--PATTERN apache-sc_httpd_item_dep-->


	<!--RULE -->
<xsl:template match="apache-sc:httpd_item" priority="1000" mode="M42">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="apache-sc:httpd_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M42"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M42"/>
<xsl:template match="@*|node()" priority="-2" mode="M42">
<xsl:apply-templates select="@*|*" mode="M42"/>
</xsl:template>

<!--PATTERN catos-sc_versionitemcatos_major_release-->


	<!--RULE -->
<xsl:template match="catos-sc:version_item/catos-sc:catos_major_release" priority="1000" mode="M43">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="catos-sc:version_item/catos-sc:catos_major_release"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M43"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M43"/>
<xsl:template match="@*|node()" priority="-2" mode="M43">
<xsl:apply-templates select="@*|*" mode="M43"/>
</xsl:template>

<!--PATTERN catos-sc_versionitemcatos_individual_release-->


	<!--RULE -->
<xsl:template match="catos-sc:version_item/catos-sc:catos_individual_release" priority="1000" mode="M44">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="catos-sc:version_item/catos-sc:catos_individual_release"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M44"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M44"/>
<xsl:template match="@*|node()" priority="-2" mode="M44">
<xsl:apply-templates select="@*|*" mode="M44"/>
</xsl:template>

<!--PATTERN catos-sc_versionitemcatos_version_id-->


	<!--RULE -->
<xsl:template match="catos-sc:version_item/catos-sc:catos_version_id" priority="1000" mode="M45">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="catos-sc:version_item/catos-sc:catos_version_id"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M45"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M45"/>
<xsl:template match="@*|node()" priority="-2" mode="M45">
<xsl:apply-templates select="@*|*" mode="M45"/>
</xsl:template>

<!--PATTERN esx-sc_patchitempatch_number-->


	<!--RULE -->
<xsl:template match="esx-sc:patch_item/esx-sc:patch_number" priority="1000" mode="M46">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="esx-sc:patch_item/esx-sc:patch_number"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M46"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M46"/>
<xsl:template match="@*|node()" priority="-2" mode="M46">
<xsl:apply-templates select="@*|*" mode="M46"/>
</xsl:template>

<!--PATTERN ios-sc_versionitemmajor_release-->


	<!--RULE -->
<xsl:template match="ios-sc:version_item/ios-sc:major_release" priority="1000" mode="M47">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ios-sc:version_item/ios-sc:major_release"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M47"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M47"/>
<xsl:template match="@*|node()" priority="-2" mode="M47">
<xsl:apply-templates select="@*|*" mode="M47"/>
</xsl:template>

<!--PATTERN ios-sc_versionitemtrain_number-->


	<!--RULE -->
<xsl:template match="ios-sc:version_item/ios-sc:train_number" priority="1000" mode="M48">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ios-sc:version_item/ios-sc:train_number"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M48"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M48"/>
<xsl:template match="@*|node()" priority="-2" mode="M48">
<xsl:apply-templates select="@*|*" mode="M48"/>
</xsl:template>

<!--PATTERN linux-sc_rpmverify_item_dep-->


	<!--RULE -->
<xsl:template match="linux-sc:rpmverify_item" priority="1000" mode="M49">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="linux-sc:rpmverify_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M49"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M49"/>
<xsl:template match="@*|node()" priority="-2" mode="M49">
<xsl:apply-templates select="@*|*" mode="M49"/>
</xsl:template>

<!--PATTERN macos-sc_inetlisteningserveritem_dep-->


	<!--RULE -->
<xsl:template match="macos-sc:inetlisteningserver_item" priority="1000" mode="M50">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="macos-sc:inetlisteningserver_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M50"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M50"/>
<xsl:template match="@*|node()" priority="-2" mode="M50">
<xsl:apply-templates select="@*|*" mode="M50"/>
</xsl:template>

<!--PATTERN macos-sc_pwpolicy_item_dep-->


	<!--RULE -->
<xsl:template match="macos-sc:pwpolicy_item" priority="1000" mode="M51">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="macos-sc:pwpolicy_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M51"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M51"/>
<xsl:template match="@*|node()" priority="-2" mode="M51">
<xsl:apply-templates select="@*|*" mode="M51"/>
</xsl:template>

<!--PATTERN sp-sc_spjobdefinition_item_dep-->


	<!--RULE -->
<xsl:template match="sp-sc:spjobdefinition_item" priority="1000" mode="M52">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sp-sc:spjobdefinition_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M52"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M52"/>
<xsl:template match="@*|node()" priority="-2" mode="M52">
<xsl:apply-templates select="@*|*" mode="M52"/>
</xsl:template>

<!--PATTERN unix-sc_processitem_dep-->


	<!--RULE -->
<xsl:template match="unix-sc:process_item" priority="1000" mode="M53">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="unix-sc:process_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M53"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M53"/>
<xsl:template match="@*|node()" priority="-2" mode="M53">
<xsl:apply-templates select="@*|*" mode="M53"/>
</xsl:template>

<!--PATTERN unix-sc_sccsitem_dep-->


	<!--RULE -->
<xsl:template match="unix-sc:sccs_item" priority="1000" mode="M54">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="unix-sc:sccs_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M54"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M54"/>
<xsl:template match="@*|node()" priority="-2" mode="M54">
<xsl:apply-templates select="@*|*" mode="M54"/>
</xsl:template>

<!--PATTERN win-sc_activedirectory57_itemvalue-->


	<!--RULE -->
<xsl:template match="win-sc:activedirectory57_item/win-sc:value" priority="1000" mode="M55">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:activedirectory57_item/win-sc:value"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the value entity of a activedirectory57_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M55"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M55"/>
<xsl:template match="@*|node()" priority="-2" mode="M55">
<xsl:apply-templates select="@*|*" mode="M55"/>
</xsl:template>

<!--PATTERN win-sc_cmdletitemparameters-->


	<!--RULE -->
<xsl:template match="win-sc:cmdlet_item/win-sc:parameters" priority="1000" mode="M56">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:cmdlet_item/win-sc:parameters"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the parameters entity of a cmdlet_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M56"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M56"/>
<xsl:template match="@*|node()" priority="-2" mode="M56">
<xsl:apply-templates select="@*|*" mode="M56"/>
</xsl:template>

<!--PATTERN win-sc_cmdletitemselect-->


	<!--RULE -->
<xsl:template match="win-sc:cmdlet_item/win-sc:select" priority="1000" mode="M57">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:cmdlet_item/win-sc:select"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the select entity of a cmdlet_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M57"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M57"/>
<xsl:template match="@*|node()" priority="-2" mode="M57">
<xsl:apply-templates select="@*|*" mode="M57"/>
</xsl:template>

<!--PATTERN win-sc_cmdletitemvalue-->


	<!--RULE -->
<xsl:template match="win-sc:cmdlet_item/win-sc:value" priority="1000" mode="M58">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:cmdlet_item/win-sc:value"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the value entity of a cmdlet_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M58"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M58"/>
<xsl:template match="@*|node()" priority="-2" mode="M58">
<xsl:apply-templates select="@*|*" mode="M58"/>
</xsl:template>

<!--PATTERN win-sc_fileaudititemtrustee_name-->


	<!--RULE -->
<xsl:template match="win-sc:fileauditedpermissions_item/win-sc:trustee_name" priority="1000" mode="M59">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:fileauditedpermissions_item/win-sc:trustee_name"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M59"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M59"/>
<xsl:template match="@*|node()" priority="-2" mode="M59">
<xsl:apply-templates select="@*|*" mode="M59"/>
</xsl:template>

<!--PATTERN win-sc_feritemtrustee_name-->


	<!--RULE -->
<xsl:template match="win-sc:fileeffectiverights_item/win-sc:trustee_name" priority="1000" mode="M60">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:fileeffectiverights_item/win-sc:trustee_name"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M60"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M60"/>
<xsl:template match="@*|node()" priority="-2" mode="M60">
<xsl:apply-templates select="@*|*" mode="M60"/>
</xsl:template>

<!--PATTERN win-sc_regitemkey-->


	<!--RULE -->
<xsl:template match="win-sc:registry_item/win-sc:key[@xsi:nil='true' or @xsi:nil='1']" priority="1000" mode="M61">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:registry_item/win-sc:key[@xsi:nil='true' or @xsi:nil='1']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="../win-sc:name/@xsi:nil='true' or ../win-sc:name/@xsi:nil='1'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="../win-sc:name/@xsi:nil='true' or ../win-sc:name/@xsi:nil='1'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - name entity must be nil when key is nil</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M61"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M61"/>
<xsl:template match="@*|node()" priority="-2" mode="M61">
<xsl:apply-templates select="@*|*" mode="M61"/>
</xsl:template>

<!--PATTERN win-sc_rapitemtrustee_name-->


	<!--RULE -->
<xsl:template match="win-sc:regkeyauditedpermissions_item/win-sc:trustee_name" priority="1000" mode="M62">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:regkeyauditedpermissions_item/win-sc:trustee_name"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M62"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M62"/>
<xsl:template match="@*|node()" priority="-2" mode="M62">
<xsl:apply-templates select="@*|*" mode="M62"/>
</xsl:template>

<!--PATTERN win-sc_rapitemstandard_synchronize-->


	<!--RULE -->
<xsl:template match="win-sc:regkeyauditedpermissions_item/win-sc:standard_synchronize" priority="1000" mode="M63">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:regkeyauditedpermissions_item/win-sc:standard_synchronize"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M63"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M63"/>
<xsl:template match="@*|node()" priority="-2" mode="M63">
<xsl:apply-templates select="@*|*" mode="M63"/>
</xsl:template>

<!--PATTERN win-sc_reritemtrustee_name-->


	<!--RULE -->
<xsl:template match="win-sc:regkeyeffectiverights_item/win-sc:trustee_name" priority="1000" mode="M64">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:regkeyeffectiverights_item/win-sc:trustee_name"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M64"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M64"/>
<xsl:template match="@*|node()" priority="-2" mode="M64">
<xsl:apply-templates select="@*|*" mode="M64"/>
</xsl:template>

<!--PATTERN win-sc_reritemstandard_synchronize-->


	<!--RULE -->
<xsl:template match="win-sc:regkeyeffectiverights_item/win-sc:standard_synchronize" priority="1000" mode="M65">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:regkeyeffectiverights_item/win-sc:standard_synchronize"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ELEMENT: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M65"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M65"/>
<xsl:template match="@*|node()" priority="-2" mode="M65">
<xsl:apply-templates select="@*|*" mode="M65"/>
</xsl:template>

<!--PATTERN win-sc_wmi_item_dep-->


	<!--RULE -->
<xsl:template match="win-sc:wmi_item" priority="1000" mode="M66">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:wmi_item"/>

		<!--REPORT -->
<xsl:if test="true()">
<svrl:successful-report xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="true()">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>DEPRECATED ITEM: <xsl:text/>
<xsl:value-of select="name()"/>
<xsl:text/> ID: <xsl:text/>
<xsl:value-of select="@id"/>
<xsl:text/>
         </svrl:text>
</svrl:successful-report>
</xsl:if>
<xsl:apply-templates select="@*|*" mode="M66"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M66"/>
<xsl:template match="@*|node()" priority="-2" mode="M66">
<xsl:apply-templates select="@*|*" mode="M66"/>
</xsl:template>

<!--PATTERN win-sc_wmi57_itemresult-->


	<!--RULE -->
<xsl:template match="win-sc:wmi57_item/win-sc:result" priority="1000" mode="M67">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="win-sc:wmi57_item/win-sc:result"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@datatype='record'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@datatype='record'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>
            <xsl:text/>
<xsl:value-of select="../@id"/>
<xsl:text/> - datatype attribute for the result entity of a wmi57_item must be 'record'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*" mode="M67"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M67"/>
<xsl:template match="@*|node()" priority="-2" mode="M67">
<xsl:apply-templates select="@*|*" mode="M67"/>
</xsl:template>
</xsl:stylesheet>

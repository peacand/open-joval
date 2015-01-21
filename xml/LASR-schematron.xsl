<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:ar="http://scap.nist.gov/schema/asset-reporting-format/1.0" xmlns:ai="http://scap.nist.gov/schema/asset-identification/1.0" xmlns:sr="http://scap.nist.gov/schema/lightweight-asset-summary-results/1.0" xmlns:xNL="urn:oasis:names:tc:ciq:xnl:3" xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="1.0">
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
<svrl:schematron-output xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" title="" schemaVersion="">
<xsl:comment>
<xsl:value-of select="$archiveDirParameter"/>   
		 <xsl:value-of select="$archiveNameParameter"/>  
		 <xsl:value-of select="$fileNameParameter"/>  
		 <xsl:value-of select="$fileDirParameter"/>
</xsl:comment>
<svrl:ns-prefix-in-attribute-values uri="http://scap.nist.gov/schema/asset-reporting-format/1.0" prefix="ar"/>
<svrl:ns-prefix-in-attribute-values uri="http://scap.nist.gov/schema/asset-identification/1.0" prefix="ai"/>
<svrl:ns-prefix-in-attribute-values uri="http://scap.nist.gov/schema/lightweight-asset-summary-results/1.0" prefix="sr"/>
<svrl:ns-prefix-in-attribute-values uri="urn:oasis:names:tc:ciq:xnl:3" prefix="xNL"/>
<svrl:ns-prefix-in-attribute-values uri="http://www.w3.org/2001/XMLSchema" prefix="xsd"/>
<svrl:active-pattern>
<xsl:apply-templates/>
</svrl:active-pattern>
<xsl:apply-templates select="/" mode="M5"/>
</svrl:schematron-output>
</xsl:template>

<!--SCHEMATRON PATTERNS-->


<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ar:Subject" priority="1013" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ar:Subject"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(*) eq count(ai:Organization)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(*) eq count(ai:Organization)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The ar:Subject MUST be populated with only ai:Organization elements</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ar:Subject/ai:Organization" priority="1012" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ar:Subject/ai:Organization"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(xNL:OrganisationName)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(xNL:OrganisationName)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>Each ai:Organization in ar:Subject MUST have at least one xNL:OrganisationName</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ar:ReportMetadata" priority="1011" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ar:ReportMetadata"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(ar:Tool/ai:Software)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(ar:Tool/ai:Software)">
<xsl:attribute name="flag">warning</xsl:attribute>
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The ar:Tool in ar:ReportMetadata SHOULD exist and it SHOULD contain at least one ai:Software</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ai:Software" priority="1010" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ai:Software"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(ai:CPE)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(ai:CPE)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The ai:Software MUST contain at least one ai:CPE</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="matches(ai:CPE,'^[c][pP][eE]:/[AHOaho]?(:[A-Za-z0-9\._\-~%]*){0,6}$')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(ai:CPE,'^[c][pP][eE]:/[AHOaho]?(:[A-Za-z0-9\._\-~%]*){0,6}$')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The ai:CPE in ai:Software MUST contain a CPE</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:AggregateValue[@type='COUNT']" priority="1009" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:AggregateValue[@type='COUNT']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="matches(.,'^[1-9]\d*$')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(.,'^[1-9]\d*$')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>Each sr:AggregateValue with @type = 'COUNT' MUST contain an integer value</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:AggregateValue[@type='AVERAGE']" priority="1008" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:AggregateValue[@type='AVERAGE']"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="matches(.,'^(0|[1-9]\d*|\d+\.\d+)$')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(.,'^(0|[1-9]\d*|\d+\.\d+)$')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>Each sr:AggregateValue with @type = 'AVERAGE' MUST contain a decimal value</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="ar:ReportPayload" priority="1007" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="ar:ReportPayload"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:SummaryReport)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:SummaryReport)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The ar:ReportPayload MUST contain a sr:SummaryReport as an immediate child</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:SummaryReport" priority="1006" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:SummaryReport"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@id eq 'FISMA_auto_feed_fy10'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@id eq 'FISMA_auto_feed_fy10'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The sr:SummaryReport MUST have an @id with value 'FISMA_auto_feed_fy10'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="@version eq '1.0beta1'"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="@version eq '1.0beta1'">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The sr:SummaryReport MUST have a @version with value '1.0beta1'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:DataPoint) eq 3"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:DataPoint) eq 3">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>Exactly 3 sr:DataPoint MUST be provided on sr:SummaryReport</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:DataPoint[@id eq 'configuration_management_agency_deviations'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:DataPoint[@id eq 'configuration_management_agency_deviations'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>sr:DataPoint with @id = 'configuration_management_agency_deviations' MUST exists on sr:SummaryReport</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:DataPoint[@id eq 'vulnerability_management_product_vulnerabilities'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:DataPoint[@id eq 'vulnerability_management_product_vulnerabilities'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>sr:DataPoint with @id = 'vulnerability_management_product_vulnerabilities' MUST exists on sr:SummaryReport</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:DataPoint[@id eq 'inventory_management_product_inventory'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:DataPoint[@id eq 'inventory_management_product_inventory'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>sr:DataPoint with @id = 'inventory_management_product_inventory' MUST exists on sr:SummaryReport</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData" priority="1005" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:NamedAttribute[@name eq 'checklist_name'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:NamedAttribute[@name eq 'checklist_name'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have a sr:NamedAttribute with @name = 'checklist_name'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData/sr:GroupedData" priority="1004" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData/sr:GroupedData"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:NamedAttribute[@name eq 'checklist_version'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:NamedAttribute[@name eq 'checklist_version'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The second level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have a sr:NamedAttribute with @name = 'checklist_version'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData/sr:GroupedData/sr:GroupedData" priority="1003" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData/sr:GroupedData/sr:GroupedData"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:NamedAttribute[@name eq 'checklist_profile'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:NamedAttribute[@name eq 'checklist_profile'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The third level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have a sr:NamedAttribute with @name = 'checklist_profile'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue) eq 1"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue) eq 1">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The third level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have exactly one sr:AggregateValue</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue) eq count(sr:AggregateValue[@name eq 'number_of_systems' and @type eq 'COUNT'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue) eq count(sr:AggregateValue[@name eq 'number_of_systems' and @type eq 'COUNT'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>Each sr:AggregateValue in the third level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have @name = 'number_of_systems' and @type = 'COUNT'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="number(sr:AggregateValue) ge number(sr:GroupedData/sr:AggregateValue)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="number(sr:AggregateValue) ge number(sr:GroupedData/sr:AggregateValue)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The sr:AggregateValue in the third level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST be an integer.  The sr:AggregateValue in the sr:GroupData below the previous one MUST also be an integer.  The former integer MUST be greater than or equal to the latter integer.</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData/sr:GroupedData/sr:GroupedData/sr:GroupedData" priority="1002" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:DataPoint[@id eq 'configuration_management_agency_deviations']/sr:GroupedData/sr:GroupedData/sr:GroupedData/sr:GroupedData"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:NamedAttribute[@name eq 'http://cce.mitre.org'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:NamedAttribute[@name eq 'http://cce.mitre.org'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The forth level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have a sr:NamedAttribute with @name = 'http://cce.mitre.org'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="matches(sr:NamedAttribute, '^CCE-\d{4}-\d$') and (sum(for $j in (for $i in reverse(string-to-codepoints(concat(substring(sr:NamedAttribute,5,4),substring(sr:NamedAttribute,10,1))))[position() mod 2 eq 0] return ($i - 48) * 2, for $i in reverse(string-to-codepoints(concat(substring(sr:NamedAttribute,5,4),substring(sr:NamedAttribute,10,1))))[position() mod 2 eq 1] return ($i - 48)) return ($j mod 10, $j idiv 10)) mod 10) eq 0"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="matches(sr:NamedAttribute, '^CCE-\d{4}-\d$') and (sum(for $j in (for $i in reverse(string-to-codepoints(concat(substring(sr:NamedAttribute,5,4),substring(sr:NamedAttribute,10,1))))[position() mod 2 eq 0] return ($i - 48) * 2, for $i in reverse(string-to-codepoints(concat(substring(sr:NamedAttribute,5,4),substring(sr:NamedAttribute,10,1))))[position() mod 2 eq 1] return ($i - 48)) return ($j mod 10, $j idiv 10)) mod 10) eq 0">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The forth level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have a sr:NamedAttribute with a CCE as a value</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue) eq 2"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue) eq 2">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The forth level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have exactly two sr:AggregateValue</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue[@name eq 'non_compliant_systems' and @type eq 'COUNT']) eq 1"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue[@name eq 'non_compliant_systems' and @type eq 'COUNT']) eq 1">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The forth level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have sr:AggregateValue with @name = 'non_compliant_systems' and @type = 'COUNT'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue[@name eq 'number_of_exceptions' and @type eq 'COUNT']) eq 1"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue[@name eq 'number_of_exceptions' and @type eq 'COUNT']) eq 1">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The forth level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have sr:AggregateValue with @name = 'number_of_exceptions' and @type = 'COUNT'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:GroupedData) eq 0"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:GroupedData) eq 0">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The forth level sr:GroupedData in sr:DataPoint with @id 'configuration_management_agency_deviations' MUST have no nested sr:GroupedData</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:DataPoint[@id eq 'vulnerability_management_product_vulnerabilities']/sr:GroupedData" priority="1001" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:DataPoint[@id eq 'vulnerability_management_product_vulnerabilities']/sr:GroupedData"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:NamedAttribute[@name eq 'http://cve.mitre.org'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:NamedAttribute[@name eq 'http://cve.mitre.org'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'vulnerability_management_product_vulnerabilities' MUST have a sr:NamedAttribute with @name = 'http://cve.mitre.org'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="starts-with(sr:NamedAttribute,'CVE-')"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="starts-with(sr:NamedAttribute,'CVE-')">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'vulnerability_management_product_vulnerabilities' MUST have a sr:NamedAttribute with a CVE as a value</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:GroupedData) eq 0"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:GroupedData) eq 0">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'vulnerability_management_product_vulnerabilities' MUST have no nested sr:GroupedData</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue) eq 1"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue) eq 1">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'vulnerability_management_product_vulnerabilities' MUST have exactly one sr:AggregateValue</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue[@name eq 'number_of_affected_systems' and @type eq 'COUNT']) eq 1"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue[@name eq 'number_of_affected_systems' and @type eq 'COUNT']) eq 1">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'vulnerability_management_product_vulnerabilities' MUST have sr:AggregateValue with @name = 'number_of_affected_systems' and @type = 'COUNT'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>

	<!--RULE -->
<xsl:template match="sr:DataPoint[@id eq 'inventory_management_product_inventory']/sr:GroupedData" priority="1000" mode="M5">
<svrl:fired-rule xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" context="sr:DataPoint[@id eq 'inventory_management_product_inventory']/sr:GroupedData"/>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:AssetAttribute/ai:Software)"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:AssetAttribute/ai:Software)">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'inventory_management_product_inventory' MUST have a sr:AssetAttribute with a ai:Software</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:AssetAttribute[@name eq 'operating_system'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:AssetAttribute[@name eq 'operating_system'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'inventory_management_product_inventory' MUST have a sr:AssetAttribute with @name = 'operating_system'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:GroupedData) eq 0"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:GroupedData) eq 0">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'inventory_management_product_inventory' MUST have no nested sr:GroupedData</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="count(sr:AggregateValue) eq 1"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="count(sr:AggregateValue) eq 1">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'inventory_management_product_inventory' MUST have exactly one sr:AggregateValue</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>

		<!--ASSERT -->
<xsl:choose>
<xsl:when test="exists(sr:AggregateValue[@name eq 'number_of_systems' and @type eq 'COUNT'])"/>
<xsl:otherwise>
<svrl:failed-assert xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:svrl="http://purl.oclc.org/dsdl/svrl" test="exists(sr:AggregateValue[@name eq 'number_of_systems' and @type eq 'COUNT'])">
<xsl:attribute name="location">
<xsl:apply-templates select="." mode="schematron-get-full-path"/>
</xsl:attribute>
<svrl:text>The first level sr:GroupedData in sr:DataPoint with @id 'inventory_management_product_inventory' MUST have a sr:AggregateValue with @name = 'number_of_systems' and @type = 'COUNT'</svrl:text>
</svrl:failed-assert>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>
<xsl:template match="text()" priority="-1" mode="M5"/>
<xsl:template match="@*|node()" priority="-2" mode="M5">
<xsl:apply-templates select="@*|*|comment()|processing-instruction()" mode="M5"/>
</xsl:template>
</xsl:stylesheet>

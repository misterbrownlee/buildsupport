<?xml version="1.0" encoding="UTF-8"?>
<!--
ADOBE SYSTEMS INCORPORATED
Copyright 2010 Adobe Systems Incorporated
All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file
in accordance with the terms of the license agreement accompanying it.
-->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<xsl:import href="filter.xsl"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	
	<xsl:param name="filter-path"/>
	
	<xsl:template match="/">
		<xsl:variable name="filter" as="item()*">
			<xsl:choose>
				<xsl:when test="doc-available($filter-path)">
					<xsl:variable name="doc" select="document($filter-path)"/>
					<xsl:copy-of select="$doc//pkgStartWith"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<as_codecoverage level="0" playerVersion="10">
			<xsl:choose>
				<xsl:when test="not(empty($filter))">
					<xsl:call-template name="apply-filter">
						<xsl:with-param name="filters" select="$filter"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:copy-of select="/"/>
				</xsl:otherwise>
				
			</xsl:choose>
		</as_codecoverage>
	</xsl:template>
		
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!--
ADOBE SYSTEMS INCORPORATED
Copyright 2010 Adobe Systems Incorporated
All Rights Reserved.

NOTICE: Adobe permits you to use, modify, and distribute this file
in accordance with the terms of the license agreement accompanying it.
-->
<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:functx="http://com.adobe.livecycle.code.coverage"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs functx">
	
	<xsl:import href="function.xsl"/>
	
	<xsl:template name="apply-filter">
		<xsl:param name="filters" as="item()*"/>
		
		<fileToClassName>
			<xsl:apply-templates select="*/fileToClassName/entry">
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</fileToClassName>
		
        <fileToDebugLines>
			<xsl:apply-templates select="*/fileToDebugLines/entry">
				<xsl:with-param name="map" select="*/classNameToFile/entry"/>
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</fileToDebugLines>
		
		<fileToExecutedLines>
			<xsl:apply-templates select="*/fileToExecutedLines/entry">
				<xsl:with-param name="map" select="*/classNameToFile/entry"/>
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</fileToExecutedLines>

		<packageToClassNames>
			<xsl:apply-templates select="*/packageToClassNames/entry">
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</packageToClassNames>
		
		<classNameToFile>
			<xsl:apply-templates select="*/classNameToFile/entry">
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</classNameToFile>
		
		<classNameToExecutedMethods>
			<xsl:apply-templates select="*/classNameToExecutedMethods/entry">
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</classNameToExecutedMethods>
		
		<classNameToMethods>
			<xsl:apply-templates select="*/classNameToMethods/entry">
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</classNameToMethods>
		
		<packageToMissedClassesAndFiles>
			<xsl:apply-templates select="*/packageToMissedClassesAndFiles/entry">
				<xsl:with-param name="filters" select="$filters"/>
			</xsl:apply-templates>
		</packageToMissedClassesAndFiles>

	</xsl:template>
	
	<xsl:template match="*/fileToClassName/* | */packageToClassNames/* |
    */classNameToFile/* | */classNameToExecutedMethods/* |
    */classNameToMethods/* | */packageToMissedClassesAndFiles/*">

		<xsl:param name="filters" as="item()*"/>
		
		<xsl:variable name="element" select="."/>
		
		<xsl:if test="functx:copy-if-not-filtered($element, $filters)">
			<xsl:copy-of select="$element"/>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="*/fileToDebugLines/* | */fileToExecutedLines/*">
		<xsl:param name="map" as="item()*"/>
		<xsl:param name="filters" as="item()*"/>
		
        <xsl:variable name="elementToCopy" select="."/>
		<xsl:variable name="file" as="xs:string" select="./@file"/>
		<xsl:variable name="elements" select="$map[@file and @file=$file]"/>
		
		<xsl:for-each select="$elements">
			<xsl:variable name="element" select="."/>
			
			<xsl:if test="functx:copy-if-not-filtered($element, $filters)">
				<xsl:copy-of select="$elementToCopy"/>
			</xsl:if>		
		</xsl:for-each>
		
	</xsl:template>
		
	<xsl:attribute-set name="pkg-set">
		<xsl:attribute name="pkg" select="@pkg" />
	</xsl:attribute-set>
		
</xsl:stylesheet>


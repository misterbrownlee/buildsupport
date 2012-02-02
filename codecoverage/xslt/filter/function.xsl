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
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:functx="http://com.adobe.livecycle.code.coverage"
	exclude-result-prefixes="xs functx">
	
	<xsl:function name="functx:copy-if-not-filtered" as="xs:boolean">
		<xsl:param name="element" as="item()*"/>
		<xsl:param name="inclusions" as="item()*"/>
		
		<xsl:choose>
			<xsl:when test="not(empty($element))">
				<xsl:variable name="pkg" select="$element/@pkg" as="xs:string"/>
				
				<xsl:choose>
					<xsl:when test="not(functx:is-filtered($pkg, $inclusions))">
						<xsl:value-of select="true()"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="false()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<xsl:function name="functx:is-filtered" as="xs:boolean">
		<xsl:param name="pkg" as="xs:string"/>
		<xsl:param name="inclusions" as="item()*"/>
		
		<xsl:choose>
			<xsl:when test="not(empty($inclusions))">
				<xsl:variable name="result" as="xs:boolean*">
					<xsl:for-each select="$inclusions">
						<xsl:variable name="inclusion" as="xs:string" select="./text()"/>
						<xsl:choose>
							<xsl:when test="starts-with($pkg, $inclusion)">
								<xsl:sequence select="false()"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:sequence select="true()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="empty(index-of($result, false()))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="true()"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:function>
		
</xsl:stylesheet>

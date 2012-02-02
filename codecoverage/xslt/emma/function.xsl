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
	
	<xsl:function name="functx:get-file-path" as="xs:string">
		<xsl:param name="pkg" as="xs:string"/>
		<xsl:param name="cls" as="xs:string"/>
		<xsl:param name="entries" as="item()*"/>
		
		<!-- search the entry element, which has the corresponding package name and class name -->
		<xsl:variable name="result" select="$entries[(@pkg = $pkg) and (@cls = $cls)]" as="item()*"/>
		
		<xsl:choose>
			<xsl:when test="not(empty($result))">
				<!-- return source file path -->
				<xsl:value-of select="$result/@file"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- no source file found, return empty string -->
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="functx:get-file-name" as="xs:string">
		<!-- path e.g. 'C:\lc_eagle\branches\main\controller\controller-admin\src;com\adobe\livecycle\admin\application;StopClusterCommand.as' -->
		<xsl:param name="path" as="xs:string"/>
		
		<!-- split file path with delimiter ';' -->
		<xsl:variable name="splits" select="tokenize($path, ';')" as="xs:string*"/>
		
		<xsl:choose>
			<xsl:when test="not(empty($splits))">
				<!-- the last part is file name -->
				<xsl:value-of select="$splits[last()]"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- return empty string -->
				<xsl:value-of select="''"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="functx:get-lines" as="xs:integer">
		<xsl:param name="file" as="xs:string"/>
		<xsl:param name="entries" as="item()*"/>
		
		<!-- search the entry element, which has the corresponding file path -->
		<xsl:variable name="result" select="$entries[@file = $file]" as="item()*"/>
		
		<xsl:choose>
			<xsl:when test="not(empty($entries))">
				<!-- count the line number -->
				<xsl:value-of select="count($result/*)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>
	
	<xsl:function name="functx:get-percent" as="xs:string">
		<xsl:param name="numerator" as="xs:integer"/>
		<xsl:param name="denominator" as="xs:integer"/>
		
		<xsl:choose>
			<xsl:when test="$denominator != 0">
				<!-- calculate the percentage value -->
				<xsl:variable name="result" select="round(($numerator div $denominator) * 100)" />
				<!-- return percentage% -->
				<xsl:value-of select="concat($result, '%')"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- denominator is 0, returns 0% -->
				<xsl:value-of select="concat('0', '%')"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	<xsl:function name="functx:get-methods" as="xs:string*">
		<xsl:param name="pkg" as="xs:string"/>
		<xsl:param name="cls" as="xs:string"/>
		<xsl:param name="entries" as="item()*"/>
		
		<!-- search the entry element, which has the corresponding package name and class name -->
		<xsl:variable name="result" select="$entries[(@pkg = $pkg) and (@cls = $cls)]" as="item()*"/>
		
		<xsl:variable name="names" as="xs:string*">
			<xsl:if test="not(empty($result))">
				<xsl:variable name="methods" select="$result[1]/*" as="item()*"/>
				
				<!-- iterate the methods elements -->
				<xsl:for-each select="$methods">
					<!-- save the method names into sequence -->
					<xsl:sequence select="./@name"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		
		<xsl:copy-of select="$names"/>

	</xsl:function>
	
	<xsl:function name="functx:format-value" as="xs:string">
		<xsl:param name="percent" as="xs:string"/>
		<xsl:param name="executed" as="xs:integer"/>
		<xsl:param name="total" as="xs:integer"/>
		
		<!-- return e.g. '59% (335/565)' -->
		<xsl:value-of select="concat($percent,  ' (', $executed, '/', $total, ')')"/>
	</xsl:function>
	
	<xsl:function name="functx:sum-total" as="xs:integer">
		<xsl:param name="coverages" as="item()*"/>
		
		<xsl:variable name="all" as="xs:double*">
			<xsl:for-each select="$coverages">
				<!-- parse the denominator. e.g. in '59% (335/565)', get 565 -->
				<xsl:variable name="value" select="number(substring-before(substring-after(./@value, '/'), ')'))" as="xs:double"/>
				<xsl:sequence select="$value"/>	
					
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="sum" select="sum($all)" as="xs:double"/>
		<!-- cast double to integer -->
		<xsl:value-of select="xs:integer($sum)"/>
		
	</xsl:function>
	
	<xsl:function name="functx:sum-executed" as="xs:integer">
		<xsl:param name="coverages" as="item()*"/>
		
		<xsl:variable name="executed" as="xs:double*">
			<xsl:for-each select="$coverages">
				<!-- parse the denominator. e.g. in '59% (335/565)', get 335 -->
				<xsl:variable name="value" select="number(substring-after(substring-before(./@value, '/'), '('))" as="xs:double"/>
				<xsl:sequence select="$value"/>
				
			</xsl:for-each>
		</xsl:variable>

		<xsl:variable name="sum" select="sum($executed)" as="xs:double"/>
		<!-- cast double to integer -->
		<xsl:value-of select="xs:integer($sum)"/>
		
	</xsl:function>
	
	<xsl:function name="functx:format-sum-value" as="xs:string">
		<xsl:param name="coverages" as="item()*"/>
		
		<xsl:variable name="sumTotal" select="functx:sum-total($coverages)" as="xs:integer"/>
		<xsl:variable name="sumExecuted" select="functx:sum-executed($coverages)" as="xs:integer"/>
		<!-- calculate the percentage of sumExecuted/sumTotal -->
		<xsl:variable name="percent" select="functx:get-percent($sumExecuted, $sumTotal)"/>
		
		<xsl:value-of select="functx:format-value($percent,  $sumExecuted, $sumTotal)"/>
	</xsl:function>

</xsl:stylesheet>
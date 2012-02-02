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
	
	<xsl:template name="report">
		<xsl:variable name="data" as="item()*">
			<xsl:apply-templates select="*/packageToClassNames/entry"/>
		</xsl:variable>

		<report>
			<stats>
				<!-- output e.g. <packages value="14"/> -->
				<packages value="{count($data)}"/>
				<!-- output e.g. <classes value="54"/> -->
				<classes value="{count($data//class)}"/>
				<!-- output e.g. <methods value="565"/> -->
				<methods value="{count($data//method)}"/>
				<!-- output e.g. <srcfiles value="54"/> -->
				<srcfiles value="{count($data//srcfile)}"/>
				<!-- output e.g. <srclines value="2115"/> -->
				<xsl:variable name="lines" select="$data/coverage[contains(@type, 'line')]" as="item()*"/>
				<srclines value="{functx:sum-total($lines)}"/>
			</stats>
		<data>
			<all name="all classes">
				<!-- output e.g. <coverage type="class, %" value="100% (54/54)"/> -->
				<xsl:variable name="classes" select="$data/coverage[contains(@type, 'class')]" as="item()*"/>
				<coverage type="class, %" value="{functx:format-sum-value($classes)}"/>
				<!-- output e.g. <coverage type="method, %" value="59% (335/565)"/> -->
				<xsl:variable name="methods" select="$data/coverage[contains(@type, 'method')]" as="item()*"/>
				<coverage type="method, %" value="{functx:format-sum-value($methods)}"/>
				<!-- output e.g. <coverage type="block, %" value="59% (335/565)"/> -->
				<xsl:variable name="blocks" select="$data/coverage[contains(@type, 'block')]" as="item()*"/>
				<coverage type="block, %" value="{functx:format-sum-value($blocks)}"/>
				<!-- output e.g. <coverage type="line, %" value="53% (1120/2115)"/> -->
				<xsl:variable name="lines" select="$data/coverage[contains(@type, 'line')]" as="item()*"/>
				<coverage type="line, %" value="{functx:format-sum-value($lines)}"/>
				
				<xsl:copy-of select="$data"/>
			</all>
		</data>
		</report>
	</xsl:template>
	
	<xsl:template match="*/packageToClassNames/*">
		<xsl:variable name="pkg" select="./@pkg"/>

		<package name="{$pkg}">
			<xsl:variable name="children" as="item()*">
				<!-- save the classes info -->
				<xsl:apply-templates select="*"/>
			</xsl:variable>
			
			<!-- output e.g. <coverage type="class, %" value="100% (54/54)"/> -->
			<xsl:variable name="classes" select="$children/coverage[contains(@type, 'class')]" as="item()*"/>
			<coverage type="class, %" value="{functx:format-sum-value($classes)}"/>
			<!-- output e.g. <coverage type="method, %" value="59% (335/565)"/> -->
			<xsl:variable name="methods" select="$children/coverage[contains(@type, 'method')]" as="item()*"/>
			<coverage type="method, %" value="{functx:format-sum-value($methods)}"/>
			<!-- output e.g. <coverage type="block, %" value="59% (335/565)"/> -->
			<xsl:variable name="blocks" select="$children/coverage[contains(@type, 'block')]" as="item()*"/>
			<coverage type="block, %" value="{functx:format-sum-value($blocks)}"/>
			<!-- output e.g. <coverage type="line, %" value="53% (1120/2115)"/> -->
			<xsl:variable name="lines" select="$children/coverage[contains(@type, 'line')]" as="item()*"/>
			<coverage type="line, %" value="{functx:format-sum-value($lines)}"/>
			
			<xsl:copy-of select="$children"/>
		</package>

	</xsl:template>
	
	<xsl:template match="*/ packageToClassNames/*/*">
		<!-- define package name -->
		<xsl:variable name="pkg" select="./@ns"/>
		<!-- define class name -->
		<xsl:variable name="cls" select="./@name"/>
		
		<!-- get file path -->
		<xsl:variable name="file" select="functx:get-file-path($pkg, $cls, //classNameToFile/entry)"/>
		<xsl:if test="$file != ''">
			<!-- get file name -->
			<xsl:variable name="fileName" select="functx:get-file-name($file)"/>
			
			<!-- output e.g. <srcfile name="EagleButtonScrollingCanvas.as"> -->
			<srcfile name="{$fileName}">
				
				<!-- get number of total debug lines -->
				<xsl:variable name="totalLines" select="functx:get-lines($file, //fileToDebugLines/entry)" as="xs:integer"/>
				<!-- get number of executed lines -->
				<xsl:variable name="executeLines" select="functx:get-lines($file, //fileToExecutedLines/entry)"  as="xs:integer"/>
				<!-- calculate percentage of executeLines/totalLines -->
				<xsl:variable name="linePercent" select="functx:get-percent($executeLines, $totalLines)" as="xs:string"/>
				
				<!-- get all the methods names -->
				<xsl:variable name="totalMethods" select="functx:get-methods($pkg, $cls, //classNameToMethods/entry)" as="xs:string*"/>
				<!-- get executed methods names -->
				<xsl:variable name="executedMethods" select="functx:get-methods($pkg, $cls, //classNameToExecutedMethods/entry)" as="xs:string*"/>
				
				<!-- get number of total methods -->
				<xsl:variable name="totalMethodsCount" select="count($totalMethods)" as="xs:integer"/>
				<!-- get number of executed methods -->
				<xsl:variable name="executedMethodsCount" select="count($executedMethods)" as="xs:integer"/>
				<!-- calculate percentage of executedMethodsCount/totalMethodsCount -->
				<xsl:variable name="methodPercent" select="functx:get-percent($executedMethodsCount, $totalMethodsCount)" as="xs:string"/>
				
				<!-- check if the class is covered by unit test -->
				<xsl:variable name="covered" select="($executeLines > 0) or ($executedMethodsCount > 0)" as="xs:boolean"/>
				
				<!-- output e.g. <coverage type="class, %" value="100% (1/1)"/> -->
				<xsl:choose>
					<xsl:when test="$covered">
						<!-- the class is covered by unit tests -->
						<coverage type="class, %" value="100% (1/1)"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- the class is not covered by unit tests -->
						<coverage type="class, %" value="0% (0/1)"/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- output e.g. <coverage type="method, %" value="50%  (4/8)"/> -->
				<coverage type="method, %" value="{functx:format-value($methodPercent, $executedMethodsCount, $totalMethodsCount)}"/>
				<!-- output e.g. <coverage type="block, %" value="50%  (4/8)"/> -->
				<coverage type="block, %" value="{functx:format-value($methodPercent, $executedMethodsCount, $totalMethodsCount)}"/>
				<!-- output e.g. <coverage type="line, %" value="100%  (4/4)"/> -->
				<coverage type="line, %" value="{functx:format-value($linePercent, $executeLines, $totalLines)}"/>
					
				<class name="{$cls}">
					<xsl:choose>
						<xsl:when test="$covered">
							<!-- the class is covered by unit tests -->
							<coverage type="class, %" value="100% (1/1)"/>
						</xsl:when>
						<xsl:otherwise>
							<!-- the class is not covered by unit tests -->
							<coverage type="class, %" value="0% (0/1)"/>
						</xsl:otherwise>
					</xsl:choose>
					<coverage type="method, %" value="{functx:format-value($methodPercent, $executedMethodsCount, $totalMethodsCount)}"/>
					<coverage type="block, %" value="{functx:format-value($methodPercent, $executedMethodsCount, $totalMethodsCount)}"/>
					<coverage type="line, %" value="{functx:format-value($linePercent, $executeLines, $totalLines)}"/>
					
					<xsl:call-template name="iterate-methods">
						<xsl:with-param name="total" select="$totalMethods"/>
						<xsl:with-param name="executed" select="$executedMethods"/>
					</xsl:call-template>
				</class>
				
			</srcfile>
		</xsl:if>

	</xsl:template>
	
	<xsl:template name="iterate-methods">
		<xsl:param name="total" as="xs:string*"/>
		<xsl:param name="executed" as="xs:string*"/>
		
		<xsl:for-each select="$total">
			<xsl:variable name="name" select="."/>

			<method name="{$name}">
				<xsl:variable name="covered" select="not(empty(index-of($executed, $name)))" as="xs:boolean"/>
				
				<xsl:choose>
					<xsl:when test="$covered">
						<!-- output e.g. <coverage type="method, %" value="100% (1/1)"/> -->
						<coverage type="method, %" value="100% (1/1)"/>
						<!-- output e.g. <coverage type="block, %" value="100%  (1/1)"/> -->
						<coverage type="block, %" value="100%  (1/1)"/>
						<!-- output e.g. <coverage type="line, %" value="100%  (1/1)"/> -->
						<coverage type="line, %" value="100%  (1/1)"/>
					</xsl:when>
					<xsl:otherwise>
						<!-- output e.g. <coverage type="method, %" value="0% (0/1)"/> -->
						<coverage type="method, %" value="0% (0/1)"/>
						<!-- output e.g. <coverage type="block, %" value="0%  (0/1)"/> -->
						<coverage type="block, %" value="0%  (0/1)"/>
						<!-- output e.g. <coverage type="line, %" value="0%  (0/1)"/> -->
						<coverage type="line, %" value="0%  (0/1)"/>
					</xsl:otherwise>
				</xsl:choose>
			</method>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
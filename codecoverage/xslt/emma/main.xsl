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
	
	<xsl:import href="emma.xsl"/>
	
	<xsl:output method="xml" version="1.0" encoding="UTF-8" omit-xml-declaration="no" indent="yes"/>
	
	<xsl:template match="/">
		<xsl:call-template name="report"/>
	</xsl:template>

</xsl:stylesheet>
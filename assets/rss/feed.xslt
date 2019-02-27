<?xml version="1.0" encoding="utf-8"?><!DOCTYPE xsl:stylesheet  [
	<!ENTITY nbsp   "&#160;">
	<!ENTITY copy   "&#169;">
	<!ENTITY reg    "&#174;">
	<!ENTITY trade  "&#8482;">
	<!ENTITY mdash  "&#8212;">
	<!ENTITY ldquo  "&#8220;">
	<!ENTITY rdquo  "&#8221;">
	<!ENTITY pound  "&#163;">
	<!ENTITY yen    "&#165;">
	<!ENTITY euro   "&#8364;">

]>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:atom="http://www.w3.org/2005/Atom">
<xsl:output method="xml" version="1.0" encoding="utf-8"
	doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
<xsl:template match="/">
	<xsl:apply-templates select="rss/channel"/>
</xsl:template>

<xsl:template match="rss/channel">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title><xsl:value-of select="atom:title"/></title>
<link rel="stylesheet" type="text/css" href="styles.css"/>
<link rel="stylesheet" type="text/css" href="http://osric.com/chris/accidental-developer/wp-content/themes/defusion/style.css"/>
</head>

<body>
<h1><xsl:apply-templates select="title"/></h1>
<p>This RSS feed provides the latest posts from <xsl:apply-templates select="title"/>.</p>

<h2>What is an RSS feed?</h2>
<p>An RSS feed is an XML-based data format that allows publishers to syndicate information. It allows you to stay up to date on topics that interest you&mdash;all in one place&mdash;without visiting 20-30 different web sites to check for new content. All you need to do to get started is to add the URL (web address) for this feed to your RSS reader.</p>
<p>The URL for this RSS feed is: <xsl:apply-templates select="atom:link"/></p>
<h3>Recommended RSS readers:</h3>
<ul>
	<li><a href="http://www.google.com/reader/">Google Reader</a></li>
	<li><a href="http://www.bloglines.com/">Bloglines</a></li>
	<li><a href="http://www.newsgator.com/Individuals/NewsGatorOnline/Default.aspx">Newsgator Online</a></li>
</ul>
<p>You can also add content from RSS feeds to your <a href="http://my.yahoo.com">My Yahoo</a> or <a href="http://www.google.com/ig">iGoogle</a> page.</p>

<xsl:apply-templates select="item"/>

</body>
</html>

</xsl:template>

<xsl:template match="item">
	<p><xsl:apply-templates select="title"/></p>
</xsl:template>

<xsl:template match="title">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="description">
	<xsl:value-of select="."/>
</xsl:template>


</xsl:stylesheet>

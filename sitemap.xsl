<?xml version="1.0" encoding="UTF-8"?>
<!-- <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
<xsl:stylesheet version="1.0"
  xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- <xsl:stylesheet version="2.0"
  xmlns:html="http://www.w3.org/TR/REC-html40"
  xmlns:image="http://www.google.com/schemas/sitemap-image/1.1"
  xmlns:sitemap="http://www.sitemaps.org/schemas/sitemap/0.9"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> -->
  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head>
        <title>Site Map</title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style>
        <!--
        body { font-family: Arial, sans-serif; margin: 2rem; }
        .url { margin: 1rem 0; padding: 1rem; background: #f5f5f5; }
        -->
        </style>
        <style type="text/css">
        body {
          font-family: Helvetica, Arial, sans-serif;
          font-size: 15px;
          color: #545353;
          margin: 10px 40px 50px;
        }
        table {
          border: none;
          border-collapse: collapse;
          __margin: 0 auto;
          width: 800px;
        }
        #sitemap tr:nth-child(odd) td {
          background-color: #eee !important;
        }
        #sitemap tbody tr:hover td {
          background-color: #ccc;
        }
        #sitemap tbody tr:hover td, #sitemap tbody tr:hover td a {
          color: #000;
        }
        #content {
          margin: 0 auto;
          width: 1000px;
        }
        .expl {
          margin: 18px 3px;
          line-height: 1.2em;
        }
        .expl a {
          color: #da3114;
          font-weight: 600;
        }
        .expl a:visited {
          color: #da3114;
        }
        a {
          color: #000;
          text-decoration: none;
        }
        a:visited {
          color: #777;
        }
        a:hover {
          text-decoration: underline;
        }
        td {
          font-size:13px;
        }
        th {
          text-align:left;
          padding-right:30px;
          font-size:11px;
        }
        thead th {
          border-bottom: 1px solid #000;
        }
        </style>
      </head>
      <body>
        <h1>Mapa strony</h1>
        <div class="expl">
          ° <a href="/sitemap-index.xml">sitemap-index.xml</a>
          ° <a href="/sitemap-0.xml">sitemap-0.xml</a>
          ° <a href="/sitemap-pdf.xml">sitemap-pdf.xml</a>
        </div>
        <!-- -->
        <xsl:if test="count(sitemap:sitemapindex/sitemap:sitemap) &gt; 0">
          <p class="expl">
            This XML <a href="{loc}">Sitemap Index</a> file contains
            <xsl:value-of select="count(sitemap:sitemapindex/sitemap:sitemap)"/> sitemaps.
          </p>
          <table id="sitemap" cellpadding="3">
            <thead>
            <tr>
              <th width="75%">Sitemap</th>
              <th width="25%">Last Modified</th>
            </tr>
            </thead>
            <tbody>
            <xsl:for-each select="sitemap:sitemapindex/sitemap:sitemap">
              <xsl:variable name="sitemapURL">
                <xsl:value-of select="sitemap:loc"/>
              </xsl:variable>
              <tr>
                <td>
                  <a href="{$sitemapURL}"><xsl:value-of select="sitemap:loc"/></a>
                </td>
                <td>
                  <xsl:value-of select="concat(substring(sitemap:lastmod,0,11),
                    concat(' ', substring(sitemap:lastmod,12,5)))"/>
                </td>
              </tr>
            </xsl:for-each>
            </tbody>
          </table>
        </xsl:if>
        <!-- -->
        <xsl:if test="count(sitemap:sitemapindex/sitemap:sitemap) &lt; 1">
          <p class="expl">
            This XML <a href="{loc}">Sitemap</a> contains
            <xsl:value-of select="count(sitemap:urlset/sitemap:url)"/> URLs.
          </p>
          <table id="sitemap" cellpadding="3">
            <thead>
            <tr>
              <th width="80%">URL</th>
              <th title="Last Modification Time" width="20%">Last Modified</th>
            </tr>
            </thead>
            <tbody>
            <xsl:for-each select="sitemap:urlset/sitemap:url">
              <xsl:variable name="itemURL">
                <xsl:value-of select="sitemap:loc"/>
              </xsl:variable>
              <tr>
                <td>
                  <a href="{$itemURL}"><xsl:value-of select="sitemap:loc"/></a>
                </td>
                <td>
                  <xsl:value-of select="concat(substring(sitemap:lastmod,0,11),
                    concat(' ', substring(sitemap:lastmod,12,5)))"/>
                </td>
              </tr>
            </xsl:for-each>
            </tbody>
          </table>
        </xsl:if>
        <!-- -->
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>

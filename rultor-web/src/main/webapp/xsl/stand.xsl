<?xml version="1.0"?>
<!--
 * Copyright (c) 2009-2013, rultor.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met: 1) Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer. 2) Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 * with the distribution. 3) Neither the name of the rultor.com nor
 * the names of its contributors may be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" version="2.0" exclude-result-prefixes="xs">
    <xsl:output method="xml" omit-xml-declaration="yes"/>
    <xsl:include href="./layout.xsl"/>
    <xsl:include href="./snapshot.xsl"/>
    <xsl:include href="/stylesheets/all.xsl"/>
    <xsl:template name="head">
        <title>
            <xsl:value-of select="/page/stand"/>
        </title>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="/page/links/link[@rel='root']/@href"/>
                <xsl:text>js/stand.js?</xsl:text>
                <xsl:value-of select="/page/version/revision"/>
            </xsl:attribute>
            <!-- this is for W3C compliance -->
            <xsl:text> </xsl:text>
        </script>
    </xsl:template>
    <xsl:template name="content">
        <h2>
            <xsl:value-of select="/page/stand"/>
        </h2>
        <xsl:apply-templates select="/page/widgets"/>
        <xsl:choose>
            <xsl:when test="/page/pulses/pulse">
                <xsl:if test="/page/since">
                    <div class="spacious">
                        <ul class="list-inline">
                            <li>
                                <xsl:text>Since </xsl:text>
                                <span class="timeago"><xsl:value-of select="/page/since"/></span>
                            </li>
                            <li>
                                <a title="back to start">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="//links/link[@rel='latest']/@href"/>
                                    </xsl:attribute>
                                    <xsl:text>back to start</xsl:text>
                                </a>
                            </li>
                        </ul>
                    </div>
                </xsl:if>
                <xsl:apply-templates select="/page/pulses/pulse[snapshot or error]" mode="open"/>
                <xsl:apply-templates select="/page/pulses/pulse[not(snapshot)]" mode="closed"/>
                <xsl:if test="//links/link[@rel='more']">
                    <div class="spacious">
                        <xsl:text>See </xsl:text>
                        <a title="more">
                            <xsl:attribute name="href">
                                <xsl:value-of select="//links/link[@rel='more']/@href"/>
                            </xsl:attribute>
                            <xsl:text>more</xsl:text>
                        </a>
                        <xsl:text> pulses.</xsl:text>
                    </div>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <p class="spacious">
                    <xsl:text>No pulses yet.</xsl:text>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="widgets">
        <div class="row">
            <xsl:for-each select="widget">
                <div>
                    <xsl:attribute name="class">
                        <xsl:text>col-lg-</xsl:text>
                        <xsl:call-template name="grid">
                            <xsl:with-param name="width" select="width"/>
                        </xsl:call-template>
                        <xsl:text> col-md-</xsl:text>
                        <xsl:call-template name="grid">
                            <xsl:with-param name="width" select="width * 1.3"/>
                        </xsl:call-template>
                        <xsl:text> col-sm-</xsl:text>
                        <xsl:call-template name="grid">
                            <xsl:with-param name="width" select="width * 2"/>
                        </xsl:call-template>
                        <xsl:text> col-xs-</xsl:text>
                        <xsl:call-template name="grid">
                            <xsl:with-param name="width" select="width * 4"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <xsl:value-of select="title"/>
                        </div>
                        <div class="panel-body">
                            <xsl:apply-templates select="." />
                        </div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template name="grid">
        <xsl:param name="width" as="xs:integer"/>
        <xsl:choose>
            <xsl:when test="$width &gt; 12">
                <xsl:text>12</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="round($width)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="pulse" mode="open">
        <div class="panel panel-default">
            <xsl:attribute name="data-fetch-url">
                <xsl:value-of select="links/link[@rel='fetch']/@href"/>
            </xsl:attribute>
            <div class="panel-heading">
                <ul class="list-inline">
                    <xsl:apply-templates select="coordinates"/>
                    <li class="heart text-muted icon" title="click to stop fetching">
                        <i class="icon-cloud-download"><xsl:comment>heart</xsl:comment></i>
                    </li>
                    <li class="pull-right icon">
                        <a title="close and stop fetching" class="close">
                            <xsl:attribute name="href">
                                <xsl:value-of select="links/link[@rel='close']/@href"/>
                            </xsl:attribute>
                            <xsl:text>&#215;</xsl:text>
                        </a>
                    </li>
                </ul>
            </div>
            <div class="panel-body snapshot">
                <xsl:if test="error">
                    <pre class="text-danger"><xsl:value-of select="error"/></pre>
                </xsl:if>
                <xsl:apply-templates select="snapshot"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="pulse" mode="closed">
        <div class="panel panel-default spacious">
            <div class="panel-body">
                <a class="pull-right icon" title="open for full view">
                    <xsl:attribute name="href">
                        <xsl:value-of select="links/link[@rel='open']/@href"/>
                    </xsl:attribute>
                    <i class="icon-zoom-in"><xsl:comment>open</xsl:comment></i>
                </a>
                <ul class="list-inline spacious-inline-list">
                    <xsl:apply-templates select="coordinates"/>
                    <xsl:apply-templates select="tags/tag"/>
                </ul>
                <xsl:if test="tags/tag/markdown">
                    <ul class="list-unstyled tag-detailed-list">
                        <xsl:apply-templates select="tags/tag[markdown]" mode="detailed"/>
                    </ul>
                </xsl:if>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="coordinates">
        <li>
            <xsl:value-of select="rule"/>
        </li>
        <li>
            <xsl:value-of select="scheduled"/>
        </li>
    </xsl:template>
</xsl:stylesheet>

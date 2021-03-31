<%  // not sure it matters, but just in case, don't have any whitespace before doctype declaration (and possible redirects)
	if (org.voyanttools.voyant.Voyant.preProcess(request, response)) {return;}
%><%@ page contentType="text/html;charset=UTF-8" %><% 
	StringBuilder url = new StringBuilder();
/*
	url.append(request.getScheme()).append("://").append(request.getServerName());
	int serverPort = request.getServerPort();
	if (serverPort != 80 && serverPort != 443) {
		url.append(":").append(serverPort);
	}
*/
	url.append(request.getContextPath());
	
	String base = url.toString();

	//default to en
	String lang = "en";
	
	//hard-coded for now
	String[] langs = new String[]{"ar","bs","cz","de","en","es","fr","he","hr","it","ja","pt","sr"};
	
	//try first with parameter
	if (request.getParameter("lang")!=null) {
		String p = request.getParameter("lang").toLowerCase();
		for (String l : langs) {
			if (p.equals(l)) {
				lang = p;
				break;
			}
		}
	} else {
		java.util.Enumeration locales = request.getLocales();
		boolean hasLang = false;
	 	while (locales.hasMoreElements() && hasLang==false) {
			java.util.Locale locale = (java.util.Locale) locales.nextElement();
			for (String l : langs) {
				if (locale.getLanguage().equals(new java.util.Locale(l).getLanguage())) {
					lang = l;
					hasLang = true;
					break;
				}
			}
			if (hasLang) {break;}
		}
	}
	
	// default to no rtl
	String rtl = "";
	if (request.getParameter("rtl")!=null) {
		String r = request.getParameter("rtl").toLowerCase();
		if (r.isEmpty()==false && r.equals("false")==false || r.equals("0")==false) {
			rtl = "-rtl";
		}
	} else if (lang.equals("he") || lang.equals("ar")) {
		rtl = "-rtl";
	}

	String spyral = "";
	if (request.getServletPath().contains("/spyral") == true) {
		spyral = "_spyral";
	}

	// store variables for use in other jsp files
	request.setAttribute("base", base);
	request.setAttribute("lang", lang);
	request.setAttribute("rtl", rtl);

	String title = (String) request.getAttribute("title");
	if (title == null) {
		title = "Voyant Tools";
	}
%><!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<title><%= title %></title>

<link rel="shortcut icon" type="image/ico" href="<%= base %>/resources/voyant/favicon<%= spyral %>.ico" />

<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-MZ8WDV5DGZ"></script>
<script>
	var isLocalHost = window.location.hostname=='localhost' || window.location.hostname=='127.0.0.1';
	if (isLocalHost) {
		window['ga-disable-G-MZ8WDV5DGZ'] = true;
	}
	window.dataLayer = window.dataLayer || [];
	function gtag(){dataLayer.push(arguments);}
	gtag('js', new Date());

	gtag('config', 'G-MZ8WDV5DGZ');
</script>

<!-- EXTJS CLASSIC -->
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/ext/6.2.0/charts-all<%= rtl %>.css" />
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/ext/6.2.0/theme-crisp/resources/theme-crisp-all<%= rtl %>_1.css" />
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/ext/6.2.0/theme-crisp/resources/theme-crisp-all<%= rtl %>_2.css" />
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/ext/6.2.0/theme-crisp/resources/ux-all<%= rtl %>-debug.css" />
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/ext/6.2.0/examples/style.css" />

<!-- jQuery -->
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/jquery/current/jquery-ui.min.css" />
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/jquery/current/jquery-ui.theme.min.css" />

<!-- vis.js -->
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/visjs/vis.min.css" />

<!-- ACE Editor (used by Spyral and the widget.codeeditor -->
<script src="<%= base %>/resources/ace/1.4.12/src-min-noconflict/ace.js"></script>

<!-- FontAwesome -->
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/fontawesome/4.4.0/font-awesome-all<%= rtl %>.css" />

<!-- spectrum -->
<link rel="stylesheet" type="text/css" href="<%= base %>/resources/spectrum/spectrum.css" />

<link rel="stylesheet" type="text/css" href="<%= base %>/resources/css/styles.css" />

<%
	// check to see if there's CSS in the URL
	if (request.getParameter("cssInline")!=null) { 
		for (String cssInline : request.getParameterValues("cssInline")) { %>
			<style type="text/css"><%= cssInline %></style>
	<% } 
	}
	
	// check to see for CSS URL
	if (request.getParameter("cssUri")!=null) { 
		for (String cssUri : request.getParameterValues("cssUri")) { %>
		<link rel="stylesheet" href="<%= cssUri %>" type="text/css" charset="utf-8">
	<% } 
} %>

<% // ridiculous hack for Safari 11 that seems to hide fieldsets, tested with desktop and iPad
	// https://www.sencha.com/forum/showthread.php?423768&p=1282921&viewfull=1#post1282921
String userAgent = request.getHeader("user-agent");
if (userAgent.indexOf("Safari") > -1 && (userAgent.indexOf("Version/13.") > -1 || userAgent.indexOf("Version/11.") > -1 || userAgent.indexOf("Version/12.") > -1 || (userAgent.indexOf("Version/11.") > -1 && userAgent.indexOf("Mobile")>-1))) { %>	<style>
	/* ridiculous hack for Safari 11 that seems to hide fieldsets */
	.x-fieldset {overflow: visible;}
	</style>
<% } %>

<%@ page import = "org.voyanttools.voyant.Trombone" %>
<% if (Trombone.hasVoyantServerResource("header-include.html")) { %>
	<%= Trombone.getVoyantServerResource("header-include.html") %>
<% } %>
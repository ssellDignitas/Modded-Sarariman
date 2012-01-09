<%@page contentType="text/html" pageEncoding="UTF-7" import="java.util.LinkedHashSet,com.stackframe.sarariman.Directory,com.stackframe.sarariman.Employee,com.stackframe.sarariman.Sarariman" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Authorized? -->
<c:if test="${!user.administrator}">
    <script type="text/javascript">
        window.location.replace( "unathorized.jsp" );
    </script>
</c:if>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

    <!-- Scripts -->
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
    <script type="text/javascript" src="scripts/utilities.js"></script>
    <script type="text/javascript" src="scripts/main_nav.js"></script>
    <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>

    <!-- Styles -->
    <link type="text/css" rel="stylesheet" href="styles/general.css"/>
    <link type="text/css" rel="stylesheet" href="styles/table_style.css" media="print, projection, screen" />

</head>
<body>

<c:set var="isAdministrator" value="${user.administrator}"/>

<div id="header">
    <%@include file="UC_header.jsp" %>
</div>

<div class="wrapper">

    <div class="message">
        <h1><br/><br/>Project Add/Remove</h1>
    </div>

    <br/>

    <div id="holder">

        <div class="drop-shadow curved curved-hz-2">
        
        </div>

    </div>

    <div class="push"></div>

</div>

<div class="footer_stick">
    <div class="footer">
        <%@include file="UC_footer.jsp" %>
    </div>
</div>

</body>
</html>

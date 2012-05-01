<%--
  Copyright (C) 2010 StackFrame, LLC
  This code is licensed under GPLv2.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sarariman : Time Tracking Service</title>

        <!-- Scripts -->
        <script type="text/javascript" src="http://code.jquery.com/jquery-latest.js"></script> 
        <script type="text/javascript" src="scripts/main_nav.js"></script> 

        <!-- Styles -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />

    </head>
    <body>

        <div id="container">

            <div id="header">
                <!-- Main Navigation Pane -->
                <%@include file="UC_header.jsp" %>
            </div>

            <div id="body">
                
                <h1>401 - Not Authorized</h1>
                
                <p>
                    You do not have the proper permissions to view this page.
                </p>
                
                <br><br>
                
            </div>

            <div id="footer">
                <%@include file="UC_footer.jsp" %>
            </div>

        </div>

    </body>
</html>
<%-- 
    Document   : UC_time
    Created on : Jun 13, 2011, 11:07:18 AM
    Author     : root
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
        <title>Time</title>
        
        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/utilities.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script>
        <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>
        <script type="text/javascript" src="http://cdn.jquerytools.org/1.2.5/jquery.tools.min.js"></script>
        
        <script type="text/javascript">
            $(function() {		
            $("#timeWeek_table").tablesorter({ headers: { 0:{sorter: false}, 1:{sorter: false}, 2:{sorter: false}, 3:{sorter: false}, 4:{sorter: false}, 5:{sorter: false}, 6:{sorter: false} }, widgets: ['zebra']});
        });	
        </script> 
        
        <!-- Style -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />  
        <link rel="stylesheet" href="styles/table_style.css" type="text/css" id="" media="print, projection, screen" />

    </head>
    <body>
        <fmt:parseDate var="week" value="${param.week}" type="date" pattern="dd"/>

        <div id="container">

            <div id="header">
                <!-- Main Navigation Pane -->
                <%@include file="UC_header.jsp" %>
            </div>

            <div id="body">
                <!-- Body Segment -->
                <br>
                <h1>Welcome back, ${user.fullName}</h1>

                <p>
                    
               
                    
                </p>
                
                <br><br>
            </div>

            <div id="footer">
                <%@include file="UC_footer.jsp" %>
            </div>

        </div>

    </body>
</html>

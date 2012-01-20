<%-- 
    Document   : UC_employees.jsp
    Created on : Jun 8, 2011, 11:49:36 AM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"
        import="java.util.LinkedHashSet,com.stackframe.sarariman.Directory,com.stackframe.sarariman.Employee,
        com.stackframe.sarariman.Sarariman" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- Authorized? -->
<c:if test="${!user.administrator}">
    <script type="text/javascript">
        window.location.replace( "unauthorized.jsp" );
    </script>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        
        <title>Employee List</title>
        
        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/utilities.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script>
        <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>
        
        <script type="text/javascript">
            $(function() {		
            $("#employee_table").tablesorter({sortList:[[0,0]], widgets: ['zebra']});
        });	
        </script>  
        </script>
        
        <!-- Style -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />  
        <link rel="stylesheet" href="styles/table_style.css" type="text/css" id="" media="print, projection, screen" />

        <style type="text/css">
            #list_pad
            {
                padding-left:10px;
            }
        </style>
        
    </head>
    <body>                  

        <!-- Set var for later use -->
        <c:set var="isAdministrator" value="${user.administrator}"/>

        <div id="header">
            <!-- Main Navigation Pane -->
            <%@include file="UC_header.jsp" %>
        </div>

        <div class="wrapper">
            <!-- Body Segment -->
            <div class="message">
                <h1><br><br>Employees</h1>

                            </div>
                            <br>
                                    <div id="holder">
                                        <div class="drop-shadow curved curved-hz-2">
                <p>
                    What follows is a list of all active employees tracked by Sarariman.
                    <br>You can view and edit their details by visiting the links next to their name.<br>
                    
                    <table id="employee_table" class="tablesorter">
                        
                        <thead>
                            <th>#</th>
                            <th>Employee Name</th>
                            <th>Action</th>
                        </thead>
                        
                        <tbody>
                            <c:forEach var="employeeEntry" items="${directory.byUserName}">
                                <c:set var="employee" value="${employeeEntry.value}"/>
                                
                                <tr>
                                    <td>
                                        ${employee.number}
                                    </td>
                                    
                                    <td>
                                        ${employee.fullName}
                                    </td>
                                        
                                    <td>
                                        <c:url var="link" value="employee">
                                            <c:param name="id" value="${employee.number}"/>
                                        </c:url>
                                            
                                        <a href="${fn:escapeXml(link)}">View Details</a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    
                </p>
                
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
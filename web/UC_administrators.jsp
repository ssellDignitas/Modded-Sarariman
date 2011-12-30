<%-- 
    Document   : UC_administrators
    Created on : Jun 7, 2011, 1:56:34 PM
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

        <title>Administrator Add/Remove</title>

        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/utilities.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script>
        <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>

        <script type="text/javascript">
            $(function() {		
                $("#admin_table").tablesorter({sortList:[[0,0]], widgets: ['zebra']});
            });	
        </script>

        <!-- Style -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />  
        <link rel="stylesheet" href="styles/table_style.css" type="text/css" id="" media="print, projection, screen" />

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
                <h1><br><br>Administrator Add/Remove</h1>

                            </div>
                            <br>
                                <div id="holder">
                                    <div class="drop-shadow curved curved-hz-2">
                                        <h2>Add New Administrator</h2>                    

                                        <%
                                            Directory directory = (Directory)getServletContext().getAttribute("directory");
                                            Sarariman sarariman = (Sarariman)getServletContext().getAttribute("sarariman");
                                            LinkedHashSet<Employee> employees = new LinkedHashSet(directory.getByUserName().values());
                                            employees.removeAll(sarariman.getAdministrators());
                                            request.setAttribute("addableUsers", employees);
                                        %>
                                        <div id="list_pad"><br>
                                                <form method="POST" action="employeeTableController">
                                                    <input type="hidden" name="action" value="add"/>
                                                    <input type="hidden" name="table" value="administrators"/>
                                                    <select id="employee" name="employee">
                                                        <c:forEach var="employee" items="${addableUsers}">
                                                            <option value="${employee.number}">${fn:escapeXml(employee.fullName)}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <input type="submit" name="add" value="Add" <c:if test="${!isAdministrator}">disabled="true"</c:if> />
                                                    </form>
                                            </div>

                                            <h2><br><br>Current Administrators<br></h2><br>
                                                                <table id="admin_table" class="tablesorter">
                                                                    <thead>
                                                                        <th>Administrator Name</th>
                                                                        <!-- Allow only admins to add/remove other admins -->
                                                                    <c:if test="${isAdministrator}"><th>Action</th></c:if>
                                                                    </thead>
                                                                    <tbody>

                                                                        <!-- Populate Table -->
                                                                    <c:forEach var="employee" items="${sarariman.administrators}">
                                                                        <tr>
                                                                            <td>${employee.fullName}</td>

                                                                            <c:if test="${isAdministrator}">
                                                                                <td>
                                                                                    <form method="POST" action="employeeTableController">
                                                                                        <input type="hidden" name="action" value="remove"/>
                                                                                        <input type="hidden" name="table" value="administrators"/>
                                                                                        <input type="hidden" name="employee" value="${employee.number}"/>
                                                                                        <input type="submit" name="remove" value="Remove"/>
                                                                                    </form>
                                                                                </td>
                                                                            </c:if>
                                                                        </tr>
                                                                    </c:forEach>

                                                                </tbody>
                                                            </table>



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

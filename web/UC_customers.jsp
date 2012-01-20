<%-- 
    Document   : UC_customer
    Created on : Jun 13, 2011, 10:19:59 AM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${!user.administrator}">
    <jsp:forward page="unauthorized.jsp"/>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>

        <title>Customers</title>

        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/utilities.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script>
        <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>

        <script type="text/javascript">
            $(function() {		
                $("#customers_table").tablesorter({sortList:[[0,0]], widgets: ['zebra']});
            });	
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
                <h1><br><br>Customers</h1>

                            </div>
                            <br>
                                <div id="holder">
                                    <div class="drop-shadow curved curved-hz-2">
                                        <h2>Create A New Customer</h2>

                                        <div id="list_pad"><br>

                                                <form method="POST" action="customerController">
                                                    <label for="name">Name: </label>
                                                    <input type="text" size="40" id="name" name="name" value="" />
                                                    <input type="hidden" name="action" value="create"/>
                                                    <input type="submit" name="create" value="Create" <c:if test="${!user.administrator}">disabled="true"</c:if>/>
                                                    </form>

                                            </div>

                                            <h2><br><br>Existing Customers<br></h2>

                                                            <table id="customer_table" class="tablesorter">
                                                                <thead>
                                                                    <th>ID</th>
                                                                    <th>Name</th>
                                                                <c:if test="${user.administrator}"><th>Action</th></c:if>
                                                                </thead>
                                                                <tbody>
                                                                <c:forEach var="entry" items="${sarariman.customers}">
                                                                    <tr>

                                                                        <td><a href="customer?id=${entry.key}">${entry.key}</a></td>
                                                                        <td><a href="customer?id=${entry.key}">${fn:escapeXml(entry.value.name)}</a></td>

                                                                        <c:if test="${user.administrator}">
                                                                            <td>
                                                                                <form method="POST" action="customerController">
                                                                                    <input type="hidden" name="action" value="delete"/>
                                                                                    <input type="hidden" name="id" value="${entry.key}"/>
                                                                                    <input type="submit" name="delete" value="Delete"/>
                                                                                </form>
                                                                            </td>
                                                                        </c:if>
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

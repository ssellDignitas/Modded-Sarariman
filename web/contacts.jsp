<%--
  Copyright (C) 2010 StackFrame, LLC
  This code is licensed under GPLv2.
--%>

<%@page contentType="application/xhtml+xml" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${!user.administrator}">
    <jsp:forward page="unauthorized"/>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link href="style.css" rel="stylesheet" type="text/css"/>
        <title>Contacts</title>
        <script type="text/javascript" src="utilities.js"/>
        
        <!-- YUI DataTable -->
        <script type="text/javascript" src="http://yui.yahooapis.com/3.3.0/build/yui/yui-min.js" charset="utf-8" ></script> 
        
    </head>
    <body onload="altRows()">
        <%@include file="header.jsp" %>
        
        <h1>Contacts</h1>
        
        <script type="text/javascript">
            
            //Create a new YUI instance with the required modules
            YUI( ).use( 'datatable', function( Y )
            { 
                var columns = [ "name", "title", "phone", "email" ];
                var rows = [ { name:"Test Name", title:"Test Title", phone:"555-5555", email:"test@test" } ];
                
                var table = new Y.DataTable.Base( 
                {
                    columnset: columns,
                    recordset: rows
                } ).render( "#testDataTable" );
                
            } );
            
        </script>
        
        <h1>Contacts - Old</h1>

        <c:url var="createLink" value="contact">
            <c:param name="action" value="create"/>
        </c:url>
        <a href="${createLink}">Create a new contact</a>

        <sql:query dataSource="jdbc/sarariman" var="contacts">
            SELECT * from contacts
        </sql:query>

        <table id="contacts" class="altrows">
            <tr><th>Name</th><th>Title</th><th>Phone</th><th>Email</th></tr>
            <c:forEach var="contact" items="${contacts.rows}">
                <tr>
                    <c:url var="link" value="contact">
                        <c:param name="id" value="${contact.id}"/>
                    </c:url>
                    <td><a href="${link}" title="edit contact information for ${contact.name}">${contact.name}</a></td>
                    <td><a href="${link}" title="edit contact information for ${contact.name}">${contact.title}</a></td>
                    <td><a href="${link}" title="edit contact information for ${contact.name}">${contact.phone}</a></td>
                    <td><a href="mailto:${contact.email}" title="send email to ${contact.name}">${contact.email}</a></td>
                </tr>
            </c:forEach>
        </table>

        <%@include file="footer.jsp" %>
    </body>
</html>

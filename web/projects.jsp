<%@page contentType="text/html" pageEncoding="UTF-8" import="java.util.LinkedHashSet,com.stackframe.sarariman.Directory,com.stackframe.sarariman.Employee,com.stackframe.sarariman.Sarariman" %>

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

    <script type="text/javascript">
        $( document ).ready( function( )
        {
            $( "#project_table" ).tablesorter( { sortList:[[0,0]], widgets:['zebra'] } );

            $( ".delete_check" ).bind( 'click', function( )
            {
                var really = confirm( "Are you sure you wish to delete this entry?" );

                if( really )
                {
                    var number = $( this ).attr( 'id' );
                    number = number.substr( 13 );
                    
                    $( "#delete_" + number ).trigger( 'click' );
                }
            } );
        } );
    </script>

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

        <div class="drop-shadow curved curved-hz-2" style="width:45%;float:left;">

            <h2>Current Projects</h2><br/> 
            
            <table id="project_table" class="tablesorter" style="font-size: 14px;">
                <thead>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Customer</th>
                    <c:if test="${user.administrator}"><th>Action</th></c:if>
                </thead>
                <tbody>

                    <c:forEach var="entry" items="${sarariman.projects}">
                    <tr>
                        <td><a href="project?id=${entry.key}">${entry.key}</a></td>
                        <td><a href="project?id=${entry.key}">${fn:escapeXml(entry.value.name)}</a></td>
                        <c:set var="customer_name" value="${fn:escapeXml(sarariman.customers[entry.value.customer].name)}"/>
                        <td><a href="project?id=${entry.key}">${customer_name}</a></td>
                        <c:if test="${user.administrator}">
                            <td style="text-align:center;">
                                <form method="POST" action="projectController" style="text-align:center;">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="id" value="${entry.key}"/>
                                    <input class="button" type="submit" id="delete_${entry.key}" name="delete" value="Delete" style="display:none;"/>
                                </form>
                                    <input class="button delete_check" id="delete_check_${entry.key}" type="button" value="Delete"/>
                            </td>
                        </c:if>
                    </tr> 
                    </c:forEach>

                </tbody>
            </table>
        </div>
        <div class="drop-shadow curved curved-hz-2" style="width:45%;float:left;position:fixed;margin-left:45%;">
       
        <!-- ########################################## -->

            <c:set var="customers" value="${sarariman.customers}"/>

            <h2>Create a New Project</h2><br/>

            <form method="POST" action="projectController">

                <input type="hidden" name="action" value="create" />

                <table border="0" cellspacing="15">

                    <tr>
                        <td style="text-align:right;"><label for="name">Name</label></td>
                        <td><input type="text" size="40" id="name" name="name" value="${fn:escapeXml(project.name)}"/></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;"><label for="customer">Customer</label></td>
                        <td>
                            <select id="customer" name="customer">
                                <c:forEach var="entry" items="${customers}">
                                    <option value="${entry.key}">${fn:escapeXml(entry.value.name)}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">Start Date</td>
                        <td><input type="text" id="pop_start" name="pop_start"/> <span style="font-size:12px;font-family:Courier,mono-space;">[YYYY-MM-DD]</span></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">End Date</td>
                        <td><input type="text" id="pop_end" name="pop_end"/> <span style="font-size:12px;font-family:Courier,mono-space;">[YYYY-MM-DD]</span></td>
                    </tr>
                </table>

                <br/>

                <div style="float:right;"><input class="button" type="submit" name="create" value="Create" <c:if test="${!user.administrator}">disabled="true"</c:if> /></div>

            </form> 

        <!-- ########################################## -->
 
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

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
            $( "#admin_table" ).tablesorter( { sortList:[[0,0]], widgets:['zebra'] } );

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
        <h1><br/><br/>Administrator Add/Remove</h1>
    </div>

    <br/>

    <div id="holder">
        
        <!-- ########## ADMINISTRATOR LIST DIV : begin ########## -->
        <div class="drop-shadow curved curved-hz-2" style="width:45%;float:left;">
       
            <% 
                Directory directory = ( Directory )getServletContext( ).getAttribute( "directory" );
                Sarariman sarariman = ( Sarariman )getServletContext( ).getAttribute( "sarariman" );
                LinkedHashSet< Employee > employees = new LinkedHashSet( directory.getByUserName( ).values( ) );
                
                employees.removeAll( sarariman.getAdministrators( ) );
                request.setAttribute( "addableUsers", employees );
            %>

            <h2>Current Administrators</h2><br/>

            <table id="admin_table" class="tablesorter" style="font-size:14px;">
                <thead>
                    <th>Name</th>
                    <c:if test="${isAdministrator}"><th>Action</th></c:if>
                </thead>
                <tbody>
                    <c:forEach var="employee" items="${sarariman.administrators}">
                        <tr>
                            <td>${employee.fullName}</td>
                            
                            <c:if test="${isAdministrator}">
                            <td style="text-align:center;">
                                <form method="POST" action="employeeTableController">
                                    <input type="hidden" name="action" value="remove"/>
                                    <input type="hidden" name="table" value="administrators"/>
                                    <input type="hidden" name="employee" value="${employee.number}"/>
                                    <input type="submit" name="remove" id="delete_${employee.number}" style="display:none;"/>
                                </form>

                                <!-- Confirm that they wish to proceed with the deletion --> 
                                <input type="button" id="delete_check_${employee.number}" class="button delete_check" value="Remove"/>
                            </td>
                            </c:if>
                        </tr>
                    </c:forEach> 
                </tbody>
            </table>
 
        </div>
        <!-- ######### ADMINISTRATOR LIST DIV : end   ########### -->


        <!-- ######### ADMINISTRATOR MAKE DIV : begin ########### -->
        <div class="drop-shadow curved curved-hz-2" style="width:45%;float:left;position:fixed;margin-left:45%;">
            <h2>Add Administrator</h2><br/>

            <form method="POST" action="employeeTableController">
                <input type="hidden" name="action" value="add"/>
                <input type="hidden" name="table" value="administrators"/>

                <table border="0" cellspacing="15">
                    <tr>
                        <td style="text-align:right;">Select</td>
                        <td>
                            <select id="employee" name="employee">
                                <c:forEach var="employee" items="${addableUsers}">
                                    <option value="${employee.number}">${fn:escapeXml(employee.fullName)}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                </table>

                <br/>
                
                <div style="float:right;"><input class="button" type="submit" name="add" value="Add" <c:if test="${!isAdministrator}">disabled="true"</c:if>/></div>
            </form>
        </div>
        <!-- ######### ADMINISTRATOR MAKE DIV : end   ########### -->

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

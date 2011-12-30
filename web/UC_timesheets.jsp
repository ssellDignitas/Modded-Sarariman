<%-- 
    Document   : UC_timesheets
    Created on : Jun 9, 2011, 1:21:37 PM
    Author     : root
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="sarariman" uri="/WEB-INF/tlds/sarariman" %>

<c:if test="${!user.administrator}">
    <jsp:forward page="unauthorized.jsp"/>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
        
        <title>TimeSheet Records</title>
        
        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/utilities.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script>
        <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>
        
        <script type="text/javascript">
            $(function() {		
            $("#timesheet_table").tablesorter({sortList:[[0,0]], widgets: ['zebra']});
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
                <h1><br><br>TimeSheets</h1>

                            </div>
                            <br>
                                    <div id="holder">
                                        <div class="drop-shadow curved curved-hz-2">
                <p>
                    <c:choose>
                        <c:when test="${!empty pararm.week}">
                            <fmt:parseDate var="week" value="${pararm.week}" type="date" pattern="yyyy-MM-dd"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="week" value="${du:weekStart(du:now())}"/>
                        </c:otherwise>
                    </c:choose>
                    
                    <div id="list_pad">
                        
                        <form action="$request.requestURI}" method="get">
                            
                            <fmt:formatDate var="prevWeekString" value="${du:prevWeek(week)}" type="date" pattern="yyyy-MM-dd"/>
                            <input type="submit" name="week" value="${prevWeekString}"/>
                            
                            <fmt:formatDate var="nextWeekString" value="${du:nextWeek(week)}" type="date" pattern="yyyy-MM-dd"/>
                            <input type="submit" name="week" value="${nextWeekString}"/>
                        </form>
                    </div>
                        
                    <fmt:formatDate var="thisWeekStart" value="${week}" type="date" pattern="yyyy-MM-dd"/>
                    
                    <h2><br><br>TimeSheets for the week of ${thisWeekStart}<br></h2>
                    
                    <!-- Dignitas does NOT have PTO or holiday hours -->
                    <table id="timesheet_table" class="tablesorter">
                        <thead>
                            <th>#</th>
                            <th>Employee</th>
                            <th>Hours</th>
                            <th>Approved</th>
                            <th>Submitted</th>
                        </thead>
                        <tbody>
                            <c:forEach var="employeeEntry" items="${directory.byUserName}">
                                <c:set var="employee" value="${employeeEntry.value}"/>
                                <tr>
                                    <c:set var="timesheet" value="${sarariman:timesheet(sarariman, employee.number, week)}"/>
                                    <c:set var="hours" value="${timesheet.totalHours}"/>
                                    
                                    <td>
                                        ${employee.number}
                                    </td>
                                    <td>
                                        <c:url var="timesheetLink" value="timesheet">
                                            <c:param name="employee" value="${employee.number}"/>
                                            <c:param name="week" value="${thisWeekStart}"/>
                                        </c:url>
                                        
                                        <a href="${fn:escapeXml(timesheetLink)}">${employee.fullName}</a>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${hours}" minFractionDigits="2"/>
                                    </td>
                                    
                                        <c:choose>
                                            <c:when test="${!timesheet.submitted}">
                                                <c:set var="approved" value="false"/>
                                                <c:set var="submitted" value="false"/>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="approved" value="${timesheet.approved}"/>
                                                <c:set var="submitted" value="true"/>
                                            </c:otherwise>
                                        </c:choose>
                                    
                                    <td class="checkbox">
                                        <form>
                                            <input type="checkbox" name="approved" id="approved" disabled="true"
                                                   <c:if test="${approved}">checked="checked"</c:if>/>
                                        </form>
                                    </td>
                                        
                                    <td class="checkbox">
                                        <form>
                                            <input type="checkbox" name="submitted" id="approved" disabled="true"
                                                   <c:if test="${submitted}">checked="checked"</c:if>/>
                                        </form>
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
<%--
  Copyright (C) 2009-2010 StackFrame, LLC
  This code is licensed under GPLv2.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"
        import="java.util.LinkedHashSet,com.stackframe.sarariman.Directory,com.stackframe.sarariman.Employee,
        com.stackframe.sarariman.Sarariman" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="joda" uri="http://www.joda.org/joda/time/tags" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<!-- Authorized? -->
<c:if test="${!user.administrator}">
    <script type="text/javascript">
        window.location.replace( "unauthorized.jsp" );
    </script>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
    
    <c:set var="employee" value="${directory.byNumber[param.id]}"/>
    
    <head>
        <link type="text/css" rel="stylesheet" href="styles/general.css" />  
        <title>Details of ${employee.fullName}</title>
        
        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/utilities.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script>
        <script type="text/javascript" src="scripts/jquery.tablesorter.js"></script>
        
        <script type="text/javascript">
            $(function() {		
            $("#user_admin_table").tablesorter({sortList:[[0,0]], widgets: ['zebra']});
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
                <!-- Body Segment -->   
                    <h1><br><br>${employee.fullName}</h1>
                    <a href="employees.jsp">Back to Employee List</a><br />
            </div>
                    <p>
                    <div id="holder">
                                        <div class="drop-shadow curved curved-hz-2">
                                            <c:if test="${user.administrator}">
                        
                        <h2>Info</h2>
                        <div id="list_pad"><br>
                        Birthdate: <joda:format value="${directory.byNumber[param.id].birthdate}" style="L-" /><br/>
                        Age: ${directory.byNumber[param.id].age}
                        </div>
                            
                        <h2><br><br>Direct Rate<br></h2>
                        
                        <sql:query dataSource="jdbc/sarariman" var="resultSet">
                            SELECT rate, effective
                            FROM direct_rate
                            WHERE employee=?
                            ORDER BY effective DESC
                            <sql:param value="${param.id}"/>
                        </sql:query>
                            
                            <table id="user_admin_table" class="tablesorter">
                                <thead>
                                    <th>Rate</th>
                                    <th>Effective Date</th>
                                    <th>Duration</th>
                                </thead>
                                <tbody>
                                    <c:set var="endDate" value="${du:now()}"/>
                                    <c:forEach var="rate_row" items="${resultSet.rows}" varStatus="varStatus">
                                        <tr>
                                            <td><fmt:formatNumber type="currency" value="${rate_row.rate}"/></td>
                                            <fmt:parseDate var="effective" value="${rate_row.effective}" pattern="yyyy-MM-dd"/>
                                            <td><fmt:formatDate value="${effective}" pattern="yyyy-MM-dd"/></td>
                                            <td>${du:daysBetween(effective, endDate)} days</td>
                                            <c:set var="endDate" value="${effective}"/>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                         </table>
                    </c:if>

                    <sql:query dataSource="jdbc/sarariman" var="resultSet">
                        SELECT project FROM project_managers WHERE employee=?
                        <sql:param value="${param.id}"/>
                    </sql:query>
                    <c:if test="${resultSet.rowCount != 0}">
                        <h2><br><br>Projects Managed<br></h2>
                        <ul>
                            <c:forEach var="mapping_row" items="${resultSet.rows}">
                                <c:set var="project" value="${sarariman.projects[mapping_row.project]}"/>
                                <c:set var="customer" value="${sarariman.customers[project.customer]}"/>
                                <c:url var="link" value="project">
                                    <c:param name="id" value="${mapping_row.project}"/>
                                </c:url>
                                <li><a href="${link}">${fn:escapeXml(project.name)} - ${fn:escapeXml(customer.name)}</a></li>
                            </c:forEach>
                        </ul>
                    </c:if>

                    <h2><br><br>Task Assignments<br></h2>
                    <div id="list_pad">
                    <form method="POST" action="TaskAssignmentController">
                        <input type="hidden" name="employee" value="${param.id}"/>
                        <input type="hidden" name="action" value="delete"/>
                        <ul>
                            <sql:query dataSource="jdbc/sarariman" var="resultSet">
                                SELECT a.task, t.name, t.project
                                FROM task_assignments AS a
                                JOIN tasks AS t ON t.id = a.task
                                WHERE a.employee=?
                                <sql:param value="${param.id}"/>
                            </sql:query>
                            <c:forEach var="mapping_row" items="${resultSet.rows}">
                                <c:url var="link" value="task">
                                    <c:param name="task_id" value="${mapping_row.task}"/>
                                </c:url>
                                <c:if test="${!empty mapping_row.project}">
                                    <c:set var="project" value="${sarariman.projects[mapping_row.project]}"/>
                                    <c:set var="customer" value="${sarariman.customers[project.customer]}"/>
                                </c:if>
                                <li><a href="${link}">${fn:escapeXml(mapping_row.name)} (${mapping_row.task})
                                        <c:if test="${!empty mapping_row.project}">
                                            - ${fn:escapeXml(project.name)} - ${fn:escapeXml(customer.name)}
                                        </c:if>
                                    </a>
                                    <c:if test="${user.administrator}">
                                        <button type="submit" name="task" value="${mapping_row.task}">X</button>
                                    </c:if>
                                </li>
                            </c:forEach>
                        </ul>
                    </form>
                    </div>

                    <c:if test="${user.administrator}">
                        <div id="list_pad"><br>
                        <form method="POST" action="TaskAssignmentController">
                            <input type="hidden" name="employee" value="${param.id}"/>
                            <input type="hidden" name="action" value="add"/>
                            <select name="task">
                                <sql:query dataSource="jdbc/sarariman" var="resultSet">
                                    SELECT id, name
                                    FROM tasks
                                    WHERE active = 1
                                </sql:query>
                                <c:forEach var="row" items="${resultSet.rows}">
                                    <option value="${row.id}">${row.id} - ${fn:escapeXml(row.name)}</option>
                                </c:forEach>
                            </select>
                            <input type="submit" name="Add" value="Add"/>
                        </form>
                        </div>
                    </c:if>

                    <h2><br><br>Tasks Worked<br></h2>
                    <ul>
                        <sql:query dataSource="jdbc/sarariman" var="resultSet">
                            SELECT DISTINCT(h.task), t.name, t.project
                            FROM hours AS h
                            JOIN tasks AS t ON t.id = h.task
                            WHERE h.employee=?
                            <sql:param value="${param.id}"/>
                        </sql:query>
                        <c:forEach var="mapping_row" items="${resultSet.rows}">
                            <c:url var="link" value="task">
                                <c:param name="task_id" value="${mapping_row.task}"/>
                            </c:url>
                            <c:if test="${!empty mapping_row.project}">
                                <c:set var="project" value="${sarariman.projects[mapping_row.project]}"/>
                                <c:set var="customer" value="${sarariman.customers[project.customer]}"/>
                            </c:if>
                            <li><a href="${link}">${fn:escapeXml(mapping_row.name)} (${mapping_row.task})
                                    <c:if test="${!empty mapping_row.project}">
                                        - ${fn:escapeXml(project.name)} - ${fn:escapeXml(customer.name)}
                                    </c:if>
                                </a>
                            </li>
                        </c:forEach>
                    </ul>

                </p>
                
                <br><br>
                                
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

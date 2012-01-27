<%--
  Copyright (C) 2009-2010 StackFrame, LLC
  This code is licensed under GPLv2.
--%>

<%@page contentType="application/xhtml+xml" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:if test="${!user.administrator && user.number != param.employee}">
    <jsp:forward page="unauthorized"/>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<c:set var="employeeNumber" value="${user.number}"/>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <link href="style.css" rel="stylesheet" type="text/css"/>
        <title>Edit Entry</title>
        <script type="text/javascript" src="utilities.js"/>
        
        <link type="text/css" rel="stylesheet" href="styles/timeGrid.css" />          
        
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/editSheet.js"></script>
        
        <!-- TinyMCE -->
        <script type="text/javascript" src="tiny_mce/tiny_mce.js"></script>
        <script type="text/javascript">
            tinyMCE.init({
                mode : "textareas",
                theme : "simple"
            });
        </script>
        <!-- /TinyMCE -->
                
        <style type="text/css">

            html, body
            {
                margin:0;
                padding:0;
                border:0;
                
                vertical-align:baseline;
                
                overflow:hidden;
            }
            
            #errorMessages
            {
                position:fixed;
                
                width:100%;
                min-height:20px;
    
                background-color: #FF3800;

                margin-top:0px;
                margin-bottom:10px;

                padding:5px;
                
                font-weight: bold;
            }
            
            .errorButton
            {
                background-color: #FF3800;
                border: 0px;

                background-repeat:no-repeat;
                background-position:left center;
                
                padding-left:18px;
                
                width:100%;
                
                font-family: 'Courier New', monospace;
                font-size: 1em;
                text-align:left;
                color: #000;
            }
            
            .sep
            {
                background-color: #EFEFEF;
                padding: 5px;
                padding-left: 8px;
                
                text-align:left;
                
                border: 1px solid #EFEFEF;
                border-radius: 5px;
                moz-border-radius: 5px;
            }
        </style>

    </head>
    <body onload="altRows()">
        
        <!-- ############### Start Error Message Box ############### -->

        <div id="errorMessages" class="hide_me">

        <!-- Errors that can be displayed are: no description, no modification reason, and no duration -->

        </div>        

        <!-- ###############  End Error Message Box  ############### -->
            
        <c:set var="canModify" value="${user.administrator || user.number == param.employee}"/>
        <c:if test="${!empty param.modifyEntry}">
            <c:if test="${!canModify}">
                <p class="error">Must be an administrator to change another employee's entries</p>
                <c:set var="updateError" value="true"/>
            </c:if>

            <c:set var="updateDescription" value="${fn:trim(param.description)}"/>
            <c:if test="${empty updateDescription}">
                <p class="error">Must have a description.</p>
                <c:set var="updateError" value="true"/>
            </c:if>

            <c:set var="updateReason" value="${fn:trim(param.reason)}"/>
            <c:if test="${empty updateReason}">
                <fmt:formatDate var="today" value="${du:now()}" type="date" pattern="yyyy-MM-dd"/>
                <c:choose>
                    <c:when test="${today == param.date}">
                        <c:set var="updateReason" value="Modification on same day.  No reason required."/>
                    </c:when>
                    <c:otherwise>
                        <p class="error">Must have a reason for the modification.</p>
                        <c:set var="updateError" value="true"/>
                    </c:otherwise>
                </c:choose>
            </c:if>

            <c:set var="updateDuration" value="${fn:trim(param.duration)}"/>
            <c:if test="${empty updateDuration}">
                <p class="error">Must have a duration for the modification.</p>
                <c:set var="updateError" value="true"/>
            </c:if>
            <!-- FIXME: Need to also check the duration is a valid number. -->

        </c:if>

        <sql:query dataSource="jdbc/sarariman" var="entries">
            SELECT hours.task, hours.description, hours.date, hours.duration, tasks.name
            FROM hours
            INNER JOIN tasks ON hours.task=tasks.id
            WHERE employee=? AND hours.date=? AND hours.task=?
            <sql:param value="${param.employee}"/>
            <sql:param value="${param.date}"/>
            <sql:param value="${param.task}"/>
        </sql:query>
        <c:if test="${entries.rowCount != 1}">Did not get the expected row.  rowCount=${rowCount}</c:if>
        <c:set var="entry" value="${entries.rows[0]}"/>
        
        <div style="width:90%;margin:auto;text-align:center;">
            
        <br/>
        
        <div class="sep">
            <b>Employee:</b> ${directory.byNumber[param.employee].fullName}<br/>
            <b>Date:</b> ${entry.date}<br/>
            <b>Task:</b> ${fn:escapeXml(entry.name)} (${entry.task})<br/>
        </div>
        
        <form id="submit_edit_sheet" method="post" target="take_it">            
            
            <br/> 
            <input type="hidden" name="date" value="${entry.date}"/>
            <input type="hidden" name="employee" value="25"/>
            <input type="hidden" name="task" value="18"/>
            
            <div class="sep">
                <label for="duration">Duration:</label>
                <input size="5" type="text" name="duration" id="duration" value="${entry.duration}" style="border:1px solid #CCC;"/>
            </div>
            
            <br/>
            
            <div class="sep">
                <label for="description">Description of Time Worked (optional): </label><br/>
                <textarea cols="48" rows="10" name="description" id="description" style="border:1px solid #CCC;width:98%;">${fn:escapeXml(entry.description)}</textarea><br/> 
            </div>
            
            <br/>
            
            <div class="sep" style="text-align:center;">
            <label for="reason">Reason for Change: </label>
            <input size="30" type="text" name="reason" id="reason" value="reason for" style="border:1px solid #CCC;"/>
            <input id="modify" type="submit" name="modifyEntry" value="Modify"/>
            <button id="visible_modify" type="button" enabled="${canModify}" class="button_tg submit">Modify</button>
            </div>
        </form>
            
        <br/>
                
        </div>
        
        
        
        <div class="hide_me">
            
            
            
        <h2>Audit log for this entry</h2>
        <sql:query dataSource="jdbc/sarariman" var="entries">
            SELECT * FROM hours_changelog WHERE task=? and employee=? and date=? ORDER BY timestamp DESC
            <sql:param value="${param.task}"/>
            <sql:param value="${param.employee}"/>
            <sql:param value="${param.date}"/>
        </sql:query>
        <table class="altrows" id="entries">
            <tr><th>Timestamp</th><th>Date</th><th>Task #</th><th>Duration</th><th>Employee</th><th>Remote Address</th><th>Remote User</th><th>Reason</th></tr>
            <c:forEach var="entry" items="${entries.rows}">
                <tr>
                    <td>${entry.timestamp}</td>
                    <td>${entry.date}</td>
                    <td>${entry.task}</td>
                    <td>${entry.duration}</td>
                    <td>${directory.byNumber[entry.employee].userName}</td>
                    <td>${entry.remote_address}</td>
                    <td>${directory.byNumber[entry.remote_user].userName}</td>
                    <td>${entry.reason}</td>
                </tr>
            </c:forEach>
        </table>
            
            
        </div>
        
            <frameset cols="100%" class="hide_me">
                <frame />
            </frameset>
        <iframe class="hide_me" name="take_it" id="take_it"></iframe>
    </body>
</html>

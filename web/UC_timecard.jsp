<%-- 
    Document   : UC_timecard
    Created on : Jun 9, 2011, 4:21:20 PM
    Author     : root
--%>

<%@page contentType="application/xhtml+xml" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="sarariman" uri="/WEB-INF/tlds/sarariman" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<c:set var="employeeNumber" value="${user.number}"/>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
            <title>Sarariman : Time Tracking Service</title>

            <!-- Scripts -->
            <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
            <script type="text/javascript" src="http://cdn.jquerytools.org/1.2.5/full/jquery.tools.min.js"></script>
            <script type="text/javascript" src="scripts/timeGrid.js"></script>

            <!-- Styles -->
            <link type="text/css" rel="stylesheet" href="styles/general.css" />
            <link type="text/css" rel="stylesheet" href="styles/timeGrid.css" />  
            <link type="text/css" rel="stylesheet" href="http://static.flowplayer.org/tools/css/overlay-apple.css"/>
        
        <style type="text/css">
            
            #errorMessages
            {
                position:fixed;
                
                min-width:540px;
                max-width:540px;
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

            .green
            {
                border-bottom: 2px solid #00FF00;
            }

            .not_green
            {
                border-bottom: 2px solid #FF0000;
            }
        </style>

    </head>
    <body>

        <!-- ########################################################################### -->
        
        <c:set var="count" value="0" />

        <c:choose>
            <c:when test="${!empty param.week}">
                <fmt:parseDate var="week" value="${param.week}" type="date" pattern="yyyy-MM-dd"/>
            </c:when>
            <c:otherwise>
                <c:set var="week" value="${du:weekStart(du:now())}"/>
            </c:otherwise>
        </c:choose>

        <c:set var="timesheet" value="${sarariman:timesheet(sarariman, employeeNumber, week)}"/>
        <c:set var="submitted" value="${timesheet.submitted}"/>

        <c:if test="${!submitted && param.submit}">
            <c:set var="submitted" value="${sarariman:submitTimesheet(timesheet)}"/>
        </c:if>

        <c:if test="${!empty param.recordTime}">

            <c:choose>
                <c:when test="${!empty param.unbillable_task && !empty param.billable_task}">
                    <p class="error">You must enter a task only from billable or unbillable.</p>
                    <c:set var="insertError" value="true"/>
                </c:when>
                <c:when test="${!empty param.unbillable_task}">
                    <c:set var="task" value="${param.unbillable_task}"/>
                </c:when>
                <c:when test="${!empty param.billable_task}">
                    <c:set var="task" value="${param.billable_task}"/>
                </c:when>
                <c:otherwise>
                    <p class="error">You must enter a task.</p>
                    <c:set var="insertError" value="true"/>
                </c:otherwise>
            </c:choose>

            <!-- FIXME: Check that the time is not already in a submitted sheet. -->
            <!-- FIXME: Check that the day is not more than 24 hours on timesheet submit. -->
            <!-- FIXME: Enforce that entry has a comment. -->
     f( week.html( ) != ( last_saturday[ 0 ] + "-" + last_saturday[ 1 ] + "-" + last_saturday[ 2 ] ) )
    {
        week.html( last_saturday[ 0 ] + "-" + last_saturday[ 1 ] + "-" + last_saturday[ 2 ] );

        if( day != 0 )
        {
            var yyyy = last_saturday[ 0 ];
            var mm   = last_saturday[ 1 ];
            var dd   = last_saturday[ 2 ] + day;

            if( dd > dayCount[ mm - 1 ] )
            {
                dd = dd - dayCount[ mm - 1 ];
                mm = mm == 12 ? 1 : mm + 1;
            }

            date.html( yyyy + "-" + mm + "-" + dd );
        }
    }
       <sql:query dataSource="jdbc/sarariman" var="existing" sql="SELECT * FROM hours WHERE task=? AND date=? AND employee=?">
                <sql:param value="${task}"/>
                <sql:param value="${param.date}"/>
                <sql:param value="${employeeNumber}"/>
            </sql:query>
            <c:if test="${!empty existing.rows}">
                <p class="error">Cannot have more than one entry for a given task and date.</p>
                <c:set var="insertError" value="true"/>
            </c:if>

            <c:set var="entryDescription" value="${fn:trim(param.description)}"/>
            <c:if test="${empty entryDescription}">
                <p class="error">You must enter a description.</p>
                <c:set var="insertError" value="true"/>
            </c:if>

            <fmt:parseDate var="parsedParamDate" value="${param.date}" type="date" pattern="yyyy-MM-dd"/>

            <c:set var="timesheetOfSubmission" value="${sarariman:timesheet(sarariman, employeeNumber, du:weekStart(parsedParamDate))}"/>
            <c:if test="${timesheetOfSubmission.submitted}">
                <p class="error">Cannot modify a submitted timesheet.</p>
                <c:set var="insertError" value="true"/>
            </c:if>


            <c:choose> 
                <c:when test="${empty param.duration}">
                    <p class="error">You must have a duration.</p>
                    <c:set var="insertError" value="true"/>
                </c:when>
                <c:otherwise>
                    <c:if test="${param.duration <= 0.0}">
                        <p class="error">Duration must be positive.</p>
                        <c:set var="insertError" value="true"/>
                    </c:if>

                    <c:if test="${param.duration > 24.0}">
                        <p class="error">Duration must be less than 24 hours.</p>
                        <c:set var="insertError" value="true"/>
                    </c:if>
                </c:otherwise>
            </c:choose>

            <c:if test="${!insertError}">
                <sql:update dataSource="jdbc/sarariman" var="rowsInserted">
                    INSERT INTO hours (employee, task, date, description, duration) values(?, ?, ?, ?, ?)
                    <sql:param value="${employeeNumber}"/>
                    <sql:param value="${task}"/>
                    <sql:param value="${param.date}"/>
                    <sql:param value="${entryDescription}"/>
                    <sql:param value="${param.duration}"/>
                </sql:update>
                <c:choose>
                    <c:when test="${rowsInserted == 1}">
                        <sql:update dataSource="jdbc/sarariman" var="rowsInserted">
                            INSERT INTO hours_changelog (employee, task, date, reason, remote_address, remote_user, duration) values(?, ?, ?, ?, ?, ?, ?)
                            <sql:param value="${employeeNumber}"/>
                            <sql:param value="${task}"/>
                            <sql:param value="${param.date}"/>
                            <sql:param value="Entry created."/>
                            <sql:param value="${pageContext.request.remoteHost}"/>
                            <sql:param value="${employeeNumber}"/>
                            <sql:param value="${param.duration}"/>
                        </sql:update>
                        <c:if test="${rowsInserted != 1}">
                            <p class="error">There was an error creating the audit log for your entry.</p>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <p class="error">There was an error creating your entry.</p>
                    </c:otherwise>
                </c:choose>
            </c:if>
        </c:if>
        
        
        
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->

        <div id="header">
            <!-- Main Navigation Pane -->
            <%@include file="UC_header.jsp" %>
        </div>

        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->

        <div class="wrapper">
            <div class="message">
                <fmt:formatDate var="thisWeekStart" value="${week}" type="date" pattern="yyyy-MM-dd" />
                <h1><br/><br/>${user.fullName}'s TimeSheet for the Week of <a href="#"><span id="week_start">${thisWeekStart}</span></a></h1>
            </div>
            <br/><br/>

        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->


    <div id="holder" style="font-size:1.2em;margins:auto;width:90%;">
    
        <!-- ##### Prev / Next Week Temp Buttons ##### -->


        <!-- -->
        
        <span style="padding-right:5px;border-right:1px solid #CCC;font-size:9px;vertical-align:middle;">
            <button type="button" id="TimeGrid_Remove" class="removeFields button_tg remove" style="width:10%;">Remove Row</button>
            <button type="button" id="TimeGrid_Add" class="addFields button_tg add" style="width:10%;">Add Row</button>
            <button type="button" id="descriptionButton" class="button_tg description" style="width:10%;">Description</button>
            <button type="button" id="submitButton" class="button_tg submit" style="width:10%;">Save Changes</button>

            <form action="${request.requestURI}" method="post" style="margin:0;padding:0;display:inline;">
                <input type="hidden" value="true" name="submit"/>
                <input type="submit" style="display:none;" id="submitReal" value="Submit"/>
                <fmt:formatDate var="weekString" value="${week}" pattern="yyyy-MM-dd"/>
                <input type="hidden" name="week" value="${weekString}"/>

                <button id="submitHoursButton" class="button_tg" style="width:10%;" <c:if test="${submitted}">disabled="true"</c:if>>Submit Sheet</button>
            </form>
            
            <form action="${request.requestURI}" method="post" style="margin:0;padding:0;display:inline;">
                <fmt:formatDate var="prevWeekString" value="${du:prevWeek(week)}" type="date" pattern="yyyy-MM-dd"/>
                <input type="submit" class="button_tg back" style="width:10%;" name="week" value="${prevWeekString}"/>
		<fmt:formatDate var="nextWeekString" value="${du:nextWeek(week)}" type="date" pattern="yyyy-MM-dd"/>
                <input type="submit" class="button_tg next" style="width:10%;" name="week" value="${nextWeekString}"/>
                <!-- Used for page refresh after submitting from dialogue -->
                <fmt:formatDate var="currentWeek" value="${week}" type="date" pattern="yyyy-MM-dd"/>
                <input type="submit" id="refresh_week" style="display:none;" name="week" value="${currentWeek}"/>
            </form>

            <button type="button" class="button_tg <c:if test='${!submitted}'>not_</c:if>green" style="width:10%;" disabled="true">Submitted</button>
            <button type="button" class="button_tg <c:if test='${!approved}'>not_</c:if>green"  style="width:10%;" disabled="true">Approved</button>

        </span>
        
        <br />
        <textarea cols="80" rows="10" name="description" id="description" class="hide_me" style="margin-top:5px;border:1px solid #CCC;width:80%;">I did work today!</textarea>
        
        
        <br /><br />
        <form action="${request.requestURI}" method="post" id='copy_form' target="take_the_punch"></form>
        <form action="${request.requestURI}" method="post" id='main_form' target="take_the_punch">
            
        <fmt:formatDate var="now" value="${du:now()}" type="date" pattern="yyyy-MM-dd" />
        <input size="10" type="text" name="date" id="date" value="${now}" class="hide_me"/>
        
        <input type="hidden" name="week" id="week" value="${weekString}"/>
        
        <select name="unbillable_task" id="unbillable_task" class="hide_me" onchange="resetSelect('billable_task');enable('submit');">
                        <option selected="true"></option>
                        <c:forEach var="task" items="${sarariman:unbillableTasks(sarariman, user)}">
                            <option value="${task.id}">${fn:escapeXml(task.name)} (${task.id})
                                <c:if test="${!empty task.project}">
                                    - ${fn:escapeXml(task.project.name)}:${fn:escapeXml(sarariman.customers[task.project.customer].name)}
                                </c:if>
                            </option>
                        </c:forEach>
                    </select>  
        
        <table id="TimeGrid">
            
            <thead>
                <tr>
                    <th style="margin-right:30px;">Task Name</th>
                    <th>Sat</th>
                    <th>Sun</th>
                    <th>Mon</th>
                    <th>Tue</th>
                    <th>Wed</th>
                    <th>Thu</th>
                    <th>Fri</th>
                    <th style="background-color:#FFF;border:0px;">total</th>
                </tr>
            </thead>
            <tbody>
                
                <!-- Row Template -->
                <tr id="task_row">
                    <td id="task">
                        
                        <select id="billable" onchange="resetSelect('unbillable_task');enable('submit');">
                            <option selected="true"></option>
                            <c:forEach var="task" items="${sarariman:billableTasks(sarariman,user)}">
                                <option value="${task.id}">${fn:escapeXml(task.name)} (${task.id})
                                    <c:if test="${!empty task.project}">
                                        ${fn:escapeXml(task.project.name)}:${fn:escapeXml(sarariman.customers[task.project.customer].name)}
                                    </c:if>
                               </option>
                            </c:forEach>
                        </select>   
                    </td>
                    
                    <td id="task_sat" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Sat" disabled="true" style="width:85px;"/>              
                        <input type="submit" value="Record" id="submit_Sat" class="hide_me"/>
                    </td>
                    
                    <td id="task_sun" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Sun" disabled="true" style="width:85px;"/>              
                        <input type="submit" value="Record" id="submit_Sun" class="hide_me"/>
                    </td>
                    
                    <td id="task_mon" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Mon" disabled="true" style="width:85px;"/>              
                        <input type="submit" value="Record" id="submit_Mon" class="hide_me"/>
                    </td>
                    
                    <td id="task_tue" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Tue" disabled="true" style="width:85px;"/>              
                        <input type="submit" value="Record" id="submit_Tue" class="hide_me"/>
                    </td>
                    
                    <td id="task_wed" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Wed" disabled="true" style="width:85px;"/>              
                        <input type="submit" value="Record" id="submit_Wed" class="hide_me"/>
                    </td>
                    
                    <td id="task_thu" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Thu" disabled="true" style="width:85px;"/>             
                        <input type="submit" value="Record" id="submit_Thu" class="hide_me"/>
                    </td>
                    
                    <td id="task_fri" style="min-height:20px;height:20px;max-height:20px;">
                        <input size="5" type="text" id="duration_Fri" disabled="true" style="width:85px;"/>              
                        <input type="submit" value="Record" id="submit_Fri" class="hide_me"/>
                    </td>
                    
                    <td id="task_total" style="min-height:20px;height:20px;max-height:20px;font: 1em 'Courier New', monospace;text-align:center;"></td>
                    
                </tr>
                
                <!-- ############################################################################### -->
                
                
                
                <!-- ############################################################################### -->
                
                <tr id="totals">
                    <td id="rowTotalTitle" style="text-align:right;">total</td>
                    <td id="Sat_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Sun_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Mon_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Tue_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Wed_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Thu_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Fri_totals" style="font: 1em 'Courier New', monospace;"></td>
                    <td id="Total_totals" style="font: 1em 'Courier New', monospace;border:1px solid #CCC;border-radius:5px;moz-border-radius:5px;"></td>
                </tr>
                
                <!-- ############################################################################### -->
                 
            </tbody>
            
        </table>
        
        <br /><br />
        
        <!-- ########################################################################### -->
        <!-- ### Drop-down Form for future/past unfilled dates ### -->
       
        
        <!-- ########################################################################### -->
        <!-- ### Modal Overlay Form for future/past unfilled dates ### -->
        <div id="overlay_native" class="hide_me" style="width:550px;height:550px;overflow:hidden;border-color:#CCC;background-color:#FFF;">
        
            <div style="width:100%;height:490px;border:0px;padding-bottom:0;">
                
                <div id="errorMessages" class="hide_me">

                    <!-- Errors that can be displayed are: no description, no modification reason, and no duration -->

                </div> 
                
                <div style="width:90%;margin:auto;text-align:center;">
                
                    <br/>
                    
                    <div class="sep">
                        <b>Employee:</b> ${user.fullName}<br/>
                        <b>Date:</b> <input size="10" type="text" id="newEntryDate" value="${now}" disabled="true"/><br/>
                        <b>Task:</b> <span id="newEntryTask"></span>
                    </div>
                        
                    <br/>
                    
                    <div class="sep">
                        Duration:
                        <input size="5" type="text" val="" id="newEntryDuration" style="border:1px solid #CCC;"/>
                    </div>

                    <br/>

                    <div class="sep">
                        Description:<br/>
                        <textarea cols="48" rows="10" id="newEntryDescription" style="border:1px solid #CCC;width:98%;"></textarea><br/> 
                    </div>
                    
                    <br/><br/>
                    
                    <div class="sep" style="text-align:center;">
                        <button type="button" id="newEntrySubmit" class="button submit">Submit</button>
                        <input type="submit" value="Record" class="hide_me" id="newEntryTrueSubmit"/>
                    </div>

                    <br/>
                    
                    <span class="hide_me" id="select_name"></span>
                    
                </div>
                
            </div>
            
            <div style="text-align:center;background-color:#FFF;border:0px;width:95%;margin:auto;">
                <button type="button" id="closeEditButton" class="close" style="border:1px solid #CCC;width:30%;min-height:40px;background-color:#EFEFEF;font-size:1.2em;">close</button>
            </div>
            
        </div>
        
        </form>
        
        <iframe name="take_the_punch" id="take_the_punch" class="hide_me"/>
        
        <div id="formHolder" class="hide_me">
            
        </div>
        
        <!-- ########################################################################### -->
        
        <div id="overlay" class="hide_me" style="width:550px;height:550px;overflow:hidden;border-color:#CCC;background-color:#FFF;">
            
            <iframe id="displayEdit" name="displayEdit" style="width:100%;height:490px;border:0px;overflow:hidden;padding-bottom:0;" scrolling="no" FRAMEBORDER="0"></iframe>
            <!--<div class="contentWrap" id="content"></div>-->
            
            <div style="text-align:center;background-color:#FFF;border:0px;width:95%;margin:auto;">
                <button type="button" id="closeEditButton" class="close" style="border:1px solid #CCC;width:30%;min-height:40px;background-color:#EFEFEF;font-size:1.2em;">close</button>
            </div>
            
        </div>
        
        <!-- ########################################################################### -->

        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        <!-- 
                Above is the grid itself and the visual/interactive aspects of it.
                Below is the unseen Sarariman querying and data retrieval.
        
                It is mostly old Stackframe code migrated over almost verbatim.
        -->
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        <!-- ########################################################################### -->
        
        <!-- ########################################################################### -->
        
        <div class="hide_me">
        <fmt:formatDate var="thisWeekStart" value="${week}" type="date" pattern="yyy-MM-dd" />

        <sql:query dataSource="jdbc/sarariman" var="entries">
            SELECT hours.task, hours.description, hours.date, hours.duration, tasks.name
            FROM hours INNER JOIN tasks ON hours.task=tasks.id
            WHERE employee=? AND hours.date >= ? AND hours.date < DATE_ADD(?, INTERVAL 7 DAY)
            ORDER BY hours.date DESC, hours.task ASC
            <sql:param value="${employeeNumber}"/>
            <sql:param value="${thisWeekStart}"/>
            <sql:param value="${thisWeekStart}"/>
        </sql:query>
            
        <c:set var="totalHours" value="0.0"/>
        <c:set var="totalRegular" value="0.0"/>
        <c:set var="totalPTO" value="0.0"/>
        <c:set var="totalHoliday" value="0.0"/>
        
        <!-- 
                Do !NOT! delete this despite its name. Very important for the grid to function. 
                Places the queried database data into easy to find divs that populate the grid.
        -->
        <div id="DELETE_ME">
            
            <c:forEach var="entry" items="${entries.rows}">
                
                <fmt:formatDate var="entryDate" value="${entry.date}" pattern="E"/>
                
                <div id="${entryDate}">
                    <div id="taskNumba">${entry.task}</div>
                    <div id="taskName">${fn:escapeXml(entry.name)}</div>
                    <div id="durate">${entry.duration}</div>
                </div>
            </c:forEach>
                
        </div>
        
        <br />
        <br />
        
        
        <!-- ########################################################################### -->
        
        <div id="sheetView" class="hide_me">
            <fmt:formatDate var="thisWeekStart" value="${week}" type="date" pattern="yyyy-MM-dd" />

            <h2>Timesheet for the week of ${thisWeekStart}</h2>

            <table class="altrows" id="days">
                <c:set var="dayTotals" value="${timesheet.hoursByDay}"/>
                <tr>
                    <c:forEach items="${dayTotals}" var="entry">
                        <fmt:formatDate var="day" value="${entry.key.time}" pattern="E"/>
                        <th>${day}</th>
                    </c:forEach>
                </tr>
                <tr>
                    <c:forEach items="${dayTotals}" var="entry">
                        <td class="duration">${entry.value}</td>
                    </c:forEach>
                </tr>
            </table>

            <br/>

            <!-- FIXME: Can I do the nextWeek part in SQL? -->
            <sql:query dataSource="jdbc/sarariman" var="entries">
                SELECT hours.task, hours.description, hours.date, hours.duration, tasks.name
                FROM hours INNER JOIN tasks ON hours.task=tasks.id
                WHERE employee=? AND hours.date >= ? AND hours.date < DATE_ADD(?, INTERVAL 7 DAY)
                ORDER BY hours.date DESC, hours.task ASC
                <sql:param value="${employeeNumber}"/>
                <sql:param value="${thisWeekStart}"/>
                <sql:param value="${thisWeekStart}"/>
            </sql:query>
            <c:set var="totalHours" value="0.0"/>
            <c:set var="totalRegular" value="0.0"/>
            <c:set var="totalPTO" value="0.0"/>
            <c:set var="totalHoliday" value="0.0"/>
            <table class="altrows" id="hours">
                <tr><th>Date</th><th>Task</th><th>Task #</th><th>Duration</th><th>Description</th>
                    <c:if test="${!timesheet.submitted}">
                        <th></th>
                    </c:if>
                </tr>
                <c:forEach var="entry" items="${entries.rows}">
                    <tr>
                        <fmt:formatDate var="entryDate" value="${entry.date}" pattern="E, MMM d"/>
                        <td class="date">${entryDate}</td>
                        <td>${fn:escapeXml(entry.name)}</td>
                        <td class="task">${entry.task}</td>
                        <td class="duration">${entry.duration}</td>
                        <c:set var="entryDescription" value="${entry.description}"/>
                        <c:if test="${sarariman:containsHTML(entryDescription)}">
                            <!-- FIXME: I really only want to escape XML entities in the above fixup. -->
                            <c:set var="entryDescription" value="${entryDescription}"/>
                        </c:if>
                        <td>${entryDescription}</td>
                        <c:if test="${!timesheet.submitted}">
                            <td>
                                <c:url var="editLink" value="editentry">
                                    <c:param name="task" value="${entry.task}"/>
                                    <c:param name="date" value="${entry.date}"/>
                                    <c:param name="employee" value="${employeeNumber}"/>
                                </c:url>
                                
                                <fmt:formatDate var="entryDateShort" value="${entry.date}" pattern="E"/>
                                <!-- @@@ @@@ @@@ @@@ -->
                                <span id="${entryDateShort}_task${entry.task}">${fn:escapeXml(editLink)}</span>
                            </td>
                        </c:if>
                        <c:set var="totalHours" value="${totalHours + entry.duration}"/>
                        <c:choose>
                            <%-- FIXME: This needs to look this up somewhere. --%>
                            <c:when test="${entry.task == 5}">
                                <c:set var="totalPTO" value="${totalPTO + entry.duration}"/>
                            </c:when>
                            <c:when test="${entry.task == 4}">
                                <c:set var="totalHoliday" value="${totalHoliday + entry.duration}"/>
                            </c:when>
                            <c:otherwise>
                                <c:set var="totalRegular" value="${totalRegular + entry.duration}"/>
                            </c:otherwise>
                        </c:choose>
                    </tr>
                </c:forEach>
                <tr>
                    <td colspan="3"><b>Total</b></td>
                    <td class="duration"><b>${totalHours}</b></td>
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td colspan="3"><b>Total Regular</b></td>
                    <td class="duration"><b>${totalRegular}</b></td>
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td colspan="3"><b>Total Holiday</b></td>
                    <td class="duration"><b>${totalHoliday}</b></td>
                    <td colspan="2"></td>
                </tr>
                <tr>
                    <td colspan="3"><b>Total PTO</b></td>
                    <td class="duration"><b>${totalPTO}</b></td>
                    <td colspan="2"></td>
                </tr>
            </table>

        </div>
        </div>
                        
    </div>

    </div>


    <div class="push"></div>
    
    <div class="footer_stick">
        <div class="footer">
            <%@include file="UC_footer.jsp" %>
        </div>
    </div>

    </body>
    </html>

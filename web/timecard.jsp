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
    
    <!-- Scripts -->
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
    <script type="text/javascript" src="http://cdn.jquerytools.org/1.2.5/full/jquery.tools.min.js"></script>
    <script type="text/javascript" src="scripts/timecard.js"></script>

    <!-- Styles -->
    <link type="text/css" rel="stylesheet" href="styles/site.css" />
    <link type="text/css" rel="stylesheet" href="http://static.flowplayer.org/tools/css/overlay-apple.css"/>

    <style type="text/css">
    .hide_me
    {
        display:none;
    }

    #grid_main_holder
    {
        margin:50px;
        min-height:600px;

        overflow: auto;
    }

    #holder
    {
        float:left;
        width:70%;
        min-height:500px;
        margin:1%;
        padding:0;
        overflow:auto;
    }

    #grid
    {
        background-color:#FFFFFF;

        min-height:400px;
        padding:10px;
        padding-top:20px;
        padding-bottom:30px;

        overflow: auto;

        border-radius:5px;
        border:1px solid #BFC2CF;
    }

    #extra_details
    {
        float:right;
        position: relative;
        min-height:500px;
        
        width:23%;
        margin:1%;
        overflow: auto;
    }

    #date_display
    {
        height:35px;
        width:100%;
      
        text-align:right;
         
        font-size:18px;
    }

    #date_display, #prevWeekButton, #nextWeekButton, #todayButton
    {
        margin-bottom:30px;
    }

    #prevWeekButton, #nextWeekButton, #todayButton, #saveButton, #submitButton, #retractButton, #approvedButton
    {
        height:35px;

        background-color: #FFFFFF;
        border: 1px solid #BFC2CF;
        border-radius:3px;
    }

    #prevWeekButton
    {
        width:35px;
        float:left;

        border-radius:0px;
        border-top-left-radius:3px;
        border-bottom-left-radius:3px;
        border-right:0px;

        background-repeat:no-repeat;
        background-position:center center;
        background-image:url('images/icons/left_caret.png');
    }

    #nextWeekButton
    {
        width:35px;
        float:left;

        border-radius:0px;
        border-top-right-radius:3px;
        border-bottom-right-radius:3px;
        border-left:0px;

        background-repeat:no-repeat;
        background-position:center center;
        background-image:url('images/icons/right_caret.png');
    }

    #todayButton
    {
        width:100px;
        float:left;
        text-align:center;

        border-radius:0px;
        border-right:0px;
        border-left:0px;
    }

    #saveButton
    {
        margin-top:30px;
    }

    #saveButton, #submitButton, #retractButton, #approvedButton
    {
        font-size:15px;
        text-align:center;
        width:170px;
        background-color:#B2C986;
    }

    #retractButton
    {
        background-color:#993129;
    }

    #saveButton
    {
        margin-top:65px;
    }
   
    #submitButton, #retractButton, #approvedButton
    {
        margin-top:10px;
    }

    #prevWeekButton:hover, #nextWeekButton:hover, #todayButton:hover, #saveButton:hover, #submitButton:hover, #retractButton:hover, #approvedButton:hover,
    #duration_Mon:hover, #duration_Tue:hover, #duration_Wed:hover, #duration_Thu:hover, #duration_Fri:hover, #duration_Sat:hover, #duration_Sun:hover
    {
        background-color:#C6CACC;
        cursor:pointer;
    }

    .duration_input
    {
        text-align:center;
        border:0px;
    }

    .task_input
    {
        border:0px solid #BFC2CF;
    }

    .enter_cell
    {
        width:10%;
        max-width:10%;
        border-bottom:1px solid #BFC2CF;
        padding-top:10px;
        padding-bottom:10px;
    }
    </style>

</head>
<body>

    <!-- Header Include -->
    <%@include file="header.jsp"%>

    <!-- Logic Set Up -->



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






    <!-- Main Body Content -->
    <div id="grid_main_holder">
        <div id="extra_details">

           <form action="${request.requestURI}" method="post" style="display:none;">
               <fmt:formatDate var="prevWeekString" value="${du:prevWeek(week)}" type="date" pattern="yyyy-MM-dd"/>
               <input type="submit" id="prev_week" name="week" value="${prevWeekString}"/>
               <fmt:formatDate var="nextWeekString" value="${du:nextWeek(week)}" type="date" pattern="yyyy-MM-dd"/>
               <input type="submit" id="next_week" name="week" value="${nextWeekString}"/>
               <fmt:formatDate var="currentWeek" value="${week}" type="date" pattern="yyyy-MM-dd"/>
               <input type="submit" id="refresh_week" name="week" value="${currentWeek}"/>
               <fmt:formatDate var="actualWeek" value="${du:weekStart(du:now())}" type="date" pattern="yyyy-MM-dd"/>
               <input type="submit" id="return_to_today" name="week" value="${actualWeek}"/>
           </form>

           <div id="prevWeekButton"></div>

            <div id="todayButton">
                <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Today</div>
            </div>

            <div id="nextWeekButton"></div>

            <!-- -->

            <div id="saveButton" <c:if test="${submitted}">style="background-color:#FFFFFF;color:#BBBBBB;cursor:default;" class="saveButton_disabled"</c:if>>
                <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Save</div>
            </div>
            
            <c:if test="${!timesheet.submitted}">
            <div id="submitButton">
                <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Submit</div>
            </div>
            </c:if>
            <c:if test="${timesheet.submitted}">
                <c:if test="${!approved}">
                    <div id="retractButton">
                        <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Retract</div>
                    </div>
                </c:if>
                <c:if test="${approved}">
                    <div id="approvedButton" style="background-color:#FFFFFF;color:#BBBBBB;cursor:default;">
                        <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Approved</div>
                    </div>
                </c:if>
            </c:if>
        </div>

        <!-- HOLDER -->        
        <div id="holder">

            <div id="date_display">
                <fmt:formatDate var="thisWeekStart" value="${week}" type="date" pattern="yyyy-MM-dd" />
                <div style="padding:0;margin:0;position:relative;top:25%;"><span id="week_start" class="hide_me">${thisWeekStart}</span><span id="visible_week"></span></div>
            </div>
 
            <!-- MAIN GRID --> 
            <div id="grid">

                <table id="TimeGrid" border="0" cellspacing="0" style="margin:0;padding:0;width:100%;">
                    <thead style="font-size:18px;font-weight:normal;">
                        <th style="width:5%;max-width:5%;"></th>
                        <th style="width:15%;max-width:15%;">Task</th>
                        <th style="width:10%;max-width:10%;">S</th>
                        <th style="width:10%;max-width:10%;">S</th>
                        <th style="width:10%;max-width:10%;">M</th>
                        <th style="width:10%;max-width:10%;">T</th>
                        <th style="width:10%;max-width:10%;">W</th>
                        <th style="width:10%;max-width:10%;">T</th>
                        <th style="width:10%;max-width:10%;">F</th>
                        <th style="width:10%;max-width:10%;"></th>
                    </thead>

                    <tbody>
                        <tr id="task_row" class="hide_me">
 
                            <!-- Cell for potentential add/remove buttons -->
                            <td id="plus_minus_row" style="min-width:35px;width:35px;padding-top:10px;padding-bottom:10px;">
                            </td>

                            <!-- Cell for task listings -->
                            <td id="task" class="enter_cell">
                                <select id="billable" onchange="resetSelect('unbillable_task');enable('submit');" class="task_input" style="text-align:center;">
                                    <option selected="true">...</option>
                                    <c:forEach var="task" items="${sarariman:billableTasks(sarariman,user)}">
                                        <option value="${task.id}">${fn:escapeXml(task.name)} (${task.id})
                                            <c:if test="${!empty task.project}">
                                                ${fn:escapeXml(task.project.name)}:${fn:escapeXml(sarariman.customers[task.project.customer].name)}
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                            </td>

                            <td id="task_sat" class="enter_cell">
                                <input size="5" type="text" id="duration_Sat" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Sat" class="hide_me"/>
                            </td>

                            <td id="task_sun" class="enter_cell">
                                <input size="5" type="text" id="duration_Sun" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Sun" class="hide_me"/>
                            </td>

                            <td id="task_mon" class="enter_cell">
                                <input size="5" type="text" id="duration_Mon" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Mon" class="hide_me"/>
                            </td>

                            <td id="task_tue" class="enter_cell">
                                <input size="5" type="text" id="duration_Tue" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Tue" class="hide_me"/>
                            </td>

                            <td id="task_wed" class="enter_cell">
                                <input size="5" type="text" id="duration_Wed" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Wed" class="hide_me"/>
                            </td>

                            <td id="task_thu" class="enter_cell">
                                <input size="5" type="text" id="duration_Thu" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Thu" class="hide_me"/>
                            </td>

                            <td id="task_fri" class="enter_cell">
                                <input size="5" type="text" id="duration_Fri" class="duration_input" style="width:100%;"/>
                                <input type="submit" value="Record" id="submit_Fri" class="hide_me"/>
                            </td>

                            <td id="task_total" class="total_cell" style="width:10%;max-width:10%;"></td>

                        </tr>

  
                        <!-- ############################################################ -->

                           <!-- Extra Rows Placed in here -->

                        <!-- ############################################################ -->

                        <tr id="totals" style="text-align:center;">
                            <td></td>
                            <td id="rowTotalTitle"></td>
                            <td id="Sat_totals"></td>
                            <td id="Sun_totals"></td>
                            <td id="Mon_totals"></td>
                            <td id="Tue_totals"></td>
                            <td id="Wed_totals"></td>
                            <td id="Thu_totals"></td>
                            <td id="Fri_totals"></td>
                            <td id="Total_totals" style="text-align:left;"></td>
                        </tr>                      

                    </tbody>
                </table>

            </div> <!-- End MAIN GRID -->

        </div> <!-- End HOLDER -->

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
                        

</body>
</html>


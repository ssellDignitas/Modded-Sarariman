<%@page contentType="application/xhtml+xml" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="sarariman" uri="/WEB-INF/tlds/sarariman" %>
<%@ page import="com.dignitastechnologies.sarariman.EntryWriter"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<c:set var="employeeNumber" value="${user.number}"/>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    
    <!-- Scripts -->
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    <script type="text/javascript" src="http://cdn.jquerytools.org/1.2.5/full/jquery.tools.min.js"></script>
    <script type="text/javascript" src="scripts/timecard.js"></script>

    <!-- Styles -->
    <link type="text/css" rel="stylesheet" href="styles/site.css" />

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

    #modifyField
    {
        margin-top:65px;
        background-color:#FFFFFF;
        border: 1px solid #BFC2CF;
        border-radius: 5px;
 
        padding: 5px;
    }

    #prevWeekButton:hover, #nextWeekButton:hover, #todayButton:hover, #saveButton:hover, #submitButton:hover, #retractButton:hover, #approvedButton:hover, duration_input:hover
    {
        background-color:#C6CACC;
        cursor:pointer;
    }

    .duration_input
    {
        background-color: transparent;
        text-align:center;
        border:0px;
        height:100%;
    }

    .task_input
    {
        border:0px solid #BFC2CF;
    }

    .enter_cell
    {
        width:10%;
        max-width:10%;
        border-bottom:1px dashed #DDDDDD;
        border-right:1px dashed #DDDDDD;
        padding-top:10px;
        padding-bottom:10px;
    }

    .active_day, .alternate_header, .alt_total
    }
    </style>

</head>
<body>

    <!-- Header Include -->
    <%@include file="header.jsp"%>

    <input type="hidden" name="remote_user" id="remote_user_original" value="${employeeNumber}"/>
    <input type="hidden" name="remote_address" id="remote_address_original" value="${pageContext.request.remoteHost}"/>
    <div id="employee_param" class="hide_me">${employeeNumber}</div>

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
            <c:if test="${!timesheet.submitted}">
            <div id="modifyField" class="hide_me">
                 Because this TimeSheet does not belong to the current week, you must provide a reason for modifying it:

                 <center><textarea id="modifyArea" style="width:95%;margin-top:15px;height:100px;"></textarea></center>
            </div>
            </c:if>
            <div id="saveButton" <c:if test="${submitted}">style="background-color:#FFFFFF;color:#BBBBBB;cursor:default;" class="saveButton_disabled"</c:if>>
                <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Save</div>
            </div>
            
            <c:if test="${!timesheet.submitted}">
            <form action="${request.requestURI}" method="post" style="margin:0;padding:0;display:inline;" target="take_the_punch">
                <input type="hidden" value="true" name="submit"/>
                <fmt:formatDate var="weekString" value="${week}" pattern="yyyy-MM-dd"/>
                <input type="hidden" name="week" value="${weekString}"/>
                <input type="submit" style="display:none;" id="submitReal" value="Submit"/>
                <input id="modify" type="submit" name="modifyEntry" value="Modify" style="display:none;"/>
            </form>

            <div id="submitButton">
                <div style="padding:0;margin:0;position:relative;top:25%;text-align:center;">Submit</div>
            </div>
            </c:if>

            <c:if test="${timesheet.submitted}">
                <c:if test="${!approved}">

                <form method="post" action="timesheetController" target="take_the_punch">
                    <fmt:formatDate var="weekString" value="${week}" pattern="yyyy-MM-dd"/>
                    <input type="hidden" value="${weekString}" name="week"/>
                    <input type="hidden" value="${employeeNumber}" name="employee"/>
                    <!-- FIXME: Only allow this if the time has not been invoiced. -->
                    <input type="submit" name="action" class="hide_me" id="retractReal"  value="Reject"/>
                 </form>

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
                <fmt:formatDate var="thisWeekStart" value="${week}" type="date" pattern="yyyy-MM-dd" /><fmt:formatDate var="actualWeek" value="${du:weekStart(du:now())}" type="date" pattern="yyyy-MM-dd"/>
                <div style="padding:0;margin:0;position:relative;top:25%;">
                    <span id="true_week" class="hide_me">${actualWeek}</span>
                    <span id="week_start" class="hide_me">${thisWeekStart}</span>
                    <span id="visible_week"></span>
                </div>
            </div>
 
            <!-- MAIN GRID --> 
            <div id="grid">

                <!-- BEGIN variable/clone setting  -->

               <textarea cols="80" rows="10" name="description" id="description" class="hide_me" style="margin-top:5px;border:1px solid #CCC;width:80%;">I did work today!</textarea>
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

                <!-- END variable/clone setting -->

                <table id="TimeGrid" border="0" cellspacing="0" style="margin:0;padding:0;width:100%;">
                    <thead style="font-size:18px;font-weight:normal;">
                        <th style="width:5%;max-width:5%;"></th>
                        <th style="width:15%;max-width:15%;padding-bottom:20px;">Task</th>
                        <th id="Header_Sat" style="width:10%;max-width:10%;padding-bottom:20px;">S</th>
                        <th id="Header_Sun" style="width:10%;max-width:10%;padding-bottom:20px;">S</th>
                        <th id="Header_Mon" style="width:10%;max-width:10%;padding-bottom:20px;">M</th>
                        <th id="Header_Tue" style="width:10%;max-width:10%;padding-bottom:20px;">T</th>
                        <th id="Header_Wed" style="width:10%;max-width:10%;padding-bottom:20px;">W</th>
                        <th id="Header_Thu" style="width:10%;max-width:10%;padding-bottom:20px;">T</th>
                        <th id="Header_Fri" style="width:10%;max-width:10%;padding-bottom:20px;">F</th>
                        <th style="width:10%;max-width:10%;padding-bottom:20px;"></th>
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

                            <td id="task_total" class="total_cell" style="width:10%;max-width:10%;text-align:center;font-weight:bold;color:#AAAAAA;"></td>

                        </tr>

  
                        <!-- ############################################################ -->

                           <!-- Extra Rows Placed in here -->

                        <!-- ############################################################ -->

                        <tr id="totals" style="text-align:center;font-weight:bold;color:#AAAAAA;">
                            <td></td>
                            <td id="rowTotalTitle"></td>
                            <td id="Sat_totals" style="padding-top:20px;"></td>
                            <td id="Sun_totals" style="padding-top:20px;"></td>
                            <td id="Mon_totals" style="padding-top:20px;"></td>
                            <td id="Tue_totals" style="padding-top:20px;"></td>
                            <td id="Wed_totals" style="padding-top:20px;"></td>
                            <td id="Thu_totals" style="padding-top:20px;"></td>
                            <td id="Fri_totals" style="padding-top:20px;"></td>
                            <td id="Total_totals" style="padding-top:20px;"></td>
                        </tr>                      

                    </tbody>
                </table>

                </form>
                <iframe name="take_the_punch" id="take_the_punch" class="hide_me"/>
                <div id="formHolder" class="hide_me"></div>

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


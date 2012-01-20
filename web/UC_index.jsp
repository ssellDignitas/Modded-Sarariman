<%-- 
    Document   : UC_index
    Created on : Jun 3, 2011, 10:27:14 AM
    Author     : ssell
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="du" uri="/WEB-INF/tlds/DateUtils" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sarariman : Time Tracking Service</title>

        <!-- Styles -->
        <link type="text/css" rel="stylesheet" href="styles/general.css" />

        <style type="text/css">

            p.GET_IN_THE_BOX
            {
                font:3.5em Georgia,sans-serif;
                color:#6ebae2;

                margin-left:35px;
                margin-top:8px;
            }
            
            .show_tools
            {
                display:none;
            }

            .tools_list
            {

            }
        </style>

        <!-- Scripts -->
        <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
        <script type="text/javascript" src="scripts/main_nav.js"></script> 

    </head>
    <body>

        <script type="text/javascript">
            $(document).ready(function(){
                
                //
                $(".tools_list").hide();
                $(".show_tools").show();
                
                $('.show_tools').click(
                function(){
                    $(".tools_list").slideToggle();
                } );
                
            } );
        </script>

        <div id="header">
            <!-- Main Navigation Pane -->
            <%@include file="UC_header.jsp" %>
        </div>

        <div class="wrapper">
            <div class="message">
                <h1><br><br>Welcome back, ${user.fullName}</h1><br>
                <h2>
                    This is your sarariman homepage.<br>
                    From here you may edit your timesheets,
                    use any tools that you have access to,
                    and get any assistance that you may require.
                    <br><br>
                    You currently have <a href="0">0</a> notifications
                </h2></div>
            <br><br>
            <div id="holder">
                <div class="drop-shadow_indexSpecial curved curved-hz-2drop-shadow">

                    <a href="UC_timecard.jsp">
                        <img src="images/calendar.png" align="left" border="0">

                        <p class="GET_IN_THE_BOX">&nbsp;&nbsp;TimeSheets</p>

                    </a>

                </div>
                <div class="drop-shadow_indexSpecial curved curved-hz-2">

                    <a href="#" class="show_tools"">
                        <img src="images/tool.png" align="left" border="0">
                        <p class="GET_IN_THE_BOX">&nbsp;&nbsp;Tools</p>
                    </a>

                    <div class="tools_list">
                        <br>
                        <h2>Public Tools</h2><br>
                        <li><a href="help.xhtml">Help</a></li>
                        <c:if test="${user.administrator}">
                            <br><br><h2>Administrator Tools</h2><br>
                            <li><a href="UC_administrators.jsp">Administrators</a></li>
                            <li><a href="UC_approvers.jsp">Approvers</a></li>
                            <li><a href="UC_employees.jsp">Employees</a></li>
                            <li><a href="UC_invoices.jsp">Invoices</a></li>
                            <li><a href="UC_invoicemanagers.jsp">Invoice Managers</a></li>
                            <li><a href="uninvoicedprojects">Uninvoiced Projects</a></li>
                            <li><a href="UC_timesheets.jsp">Timesheets</a></li>
                            <li><a href="UC_customers.jsp">Customers</a></li>
                            <li><a href="laborcategoryassignments">Labor Category Assignments</a></li>
                            <li><a href="taskGroupings">Task Groupings</a></li>
                            <li><a href="projects">Projects</a></li>
                            <li><a href="tasks">Tasks</a></li>
                            <li><a href="serviceagreements">Service Agreements</a></li>
                            <li>
                                <fmt:formatDate var="week" value="${du:weekStart(du:now())}" type="date" pattern="yyyy-MM-dd"/>
                                <c:url var="weekBilled" value="weekBilled">
                                    <c:param name="week" value="${week}"/>
                                </c:url>
                                <a href="${fn:escapeXml(weekBilled)}">Weekly Billing Report</a>
                            </li>
                            <li><a href="changelog">Changelog</a></li>
                            <li><a href="day">Daily Activity</a></li>
                            <li><a href="contacts">Contacts</a></li>
                            <li><a href="timereportsbyproject">Time reports by project</a></li>
                        </c:if>
                        <c:if test="${user.invoiceManager}">
                            <br><br><h2>Invoice Manager Tools</h2><br>
                            <li><a href="laborcategories">Labor Categories</a></li>
                            <li><a href="uninvoicedbillable">Uninvoiced Billable</a></li>
                            <li><a href="saic/">SAIC Tools</a></li>
                            <li><a href="unbilledservices">Unbilled Services</a></li>
                            <li><a href="expenses">Expenses</a></li>
                            
                            <br><br><h2>QuickBooks Tools</h2><br>
                            <li><a href="qb_settings.jsp">Export Settings</a></li>
                            <li><a href="qb_status.jsp">System Status</a></li>
                            <li><a href="qb_help.jsp">QBWC Help</a></li>
                        </c:if>

                    </div>
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
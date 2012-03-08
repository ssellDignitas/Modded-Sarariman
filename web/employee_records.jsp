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
    <script type="text/javascript" src="scripts/employee_records.js"></script>
    
    <!-- Styles -->
    <link type="text/css" rel="stylesheet" href="styles/site.css" />

    <style type="text/css">
        .hide_me
        {
            display: none;
        }

        #container
        {
            width: 900px;
            margin: 0 auto;
            margin-top: 50px;
            padding: 15px;

            background-color: #FFFFFF;
            border: 1px solid #BFC2CF;
            border-radius: 5px;
        }

        .spacer
        {
            width: 15px;
        }

        td
        {
            padding:8px;
            border-bottom: 1px dotted #BFC2CF;
        } 
 
        .yes
        {
            background-image: url( "images/icons/active/action_check.png" );
            background-repeat: no-repeat;
            background-position: center center;
        }

        .yes:hover
        {
            background-image: url( "images/icons/active/action_delete.png" );
            cursor:pointer;
        }

        .no:hover
        {
            background-image: url( "images/icons/disabled/action_check.png" );
            background-repeat: no-repeat;
            background-position: center center;
            cursor: pointer;
        }

        .more
        { 
            cursor: pointer;
        }

        .more_display
        {
            background-color: #00FF00;
        }

    </style>
</head>
<body>

    <%@include file="header.jsp"%>
    <iframe class="hide_me" id="target_frame" name="target_frame"></iframe>

    <div id="container">

        <table border="0" cellspacing="0" style="margin: 0 auto;">
 
            <thead>
                <tr>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="text-align:center;padding-bottom:20px;border:0px;">Name</td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="text-align:center;padding-bottom:20px;border:0px;">Pending</td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="text-align:center;padding-bottom:20px;border:0px;">Assigned Tasks</td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="text-align:center;padding-bottom:20px;border:0px;">Admin</td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="text-align:center;padding-bottom:20px;border:0px;">Approver</td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="text-align:center;padding-bottom:20px;border:0px;">Manager</td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                    <td style="padding-bottom:20px;border:0px;"></td>
                    <td class="spacer" style="padding-bottom:20px;border:0px;"></td>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="employeeEntry" items="${directory.byUserName}">
                    <c:set var="employee" value="${employeeEntry.value}"/>
                    <tr id="${employee.number}">
                        <td class="spacer"></td>
                        <td class="employee_name">${employee.fullName}</td>
                        <td class="spacer"></td>
                        <td class="timesheets_pending" style="text-align: center;">?</td>
                        <td class="spacer"></td>
                        <td class="employee_tasks" style="text-align:center;">...</td>
                        <td class="spacer"></td>
                        <td class="employee_is_admin"></td>
                        <td class="spacer"></td>
                        <td class="employee_is_approver"></td>
                        <td class="spacer"></td>
                        <td class="employee_is_manager"></td>
                        <td class="spacer"></td>
                        <td class="more">more</td>
                        <td class="spacer"></td>
                    </tr>
                    <tr>
                        <td colspan="100%" id="${employee.number}_more" class="hide_me more_display">
                            more information...
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
      
        </table>
    </div>

   <!-- Hidden Read from the Database -->

   <div id="who_is_admin" class="hide_me">
       <c:forEach var="emp" items="${sarariman.administrators}">
           <div class="${emp.number}"></div>
       </c:forEach>
   </div>

   <div id="who_is_appr" class="hide_me">
       <c:forEach var="emp" items="${sarariman.approvers}">
           <div class="${emp.number}"></div>
       </c:forEach>
   </div>

   <div id="who_is_mgr" class="hide_me">
       <c:forEach var="emp" items="${sarariman.invoiceManagers}">
           <div class="${emp.number}"></div>
       </c:forEach>
   </div>

   <div id="form_holder" class="hide_me"></div>
   <iframe name="target_frame" id="target_frame" class="hide_me"></iframe>
</body>
</html>

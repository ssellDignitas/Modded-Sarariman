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
    <script type="text/javascript" src="scripts/project_management.js"></script>
    <!-- Styles -->
    <link type="text/css" rel="stylesheet" href="styles/site.css" />

    <style type="text/css">
        .hide_me
        {
            display:none;
        }

        #container
        {
            width: 100%;
            min-height:600px;

            margin:20px
            margin-top:50px;

            overflow:auto;
        }

        #employees, #tasks, #projects, #customers
        {
            min-height:500px;
            width:20%;
            overflow:auto;

            background-color:transparent;

            float:left;
            margin-left:4%;
            margin-top:50px;
        }

        .title
        {
            font-size:20px;
            text-align:center;
            padding:5px;
            margin-bottom:30px;
        }

        .row_holder
        {
            background-color:#FFFFFF;
            border: 1px solid #BFC2CF;
            border-radius:5px;
        }

        .row, .row_active
        {
             margin:5px;
             margin-bottom:12px;
             margin-top:10px;
             font-size:16px;
             padding:3px;
             cursor:pointer;
        }

        .row
        {
        }
 
        .row_active, .row_edit
        {
            border-bottom:1px solid #272132;
            background-color:#B2C986;
            border: 1px solid #BFC2CF;
            border-radius:3px;
        }

        .row_edit
        {
            background-color:#7A895B;
            color: #FFFFFF;
        }

        .name_input
        {
            border: 1px solid #FFFFFF;
            border-radius: 2px;
            background-color:#FFFFFF;
        }
    </style>
</head>
<body>

    <!-- Header Include -->
    <%@include file="header.jsp"%>

    <div id="container">

        <div id="customers">
            <div class="title">Customers</div>
            <div class="row_holder" id="customer_holder">
                <c:forEach var="entry" items="${sarariman.customers}">
                    <div class="row customers">
                        <span class="name">${fn:escapeXml(entry.value.name)}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div id="projects">
            <div class="title">Projects</div>
            <div class="row_holder" id="project_holder">
                <c:forEach var="entry" items="${sarariman.projects}">
                    <div class="row projects">
                        <span class="name">${fn:escapeXml(entry.value.name)}</span>
                        <span id="${fn:escapeXml(entry.value.name)}_parent" style="display:none;" >${fn:escapeXml(sarariman.customers[entry.value.customer].name)}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div id="tasks"> 
            <div class="title">Tasks</div>
            <div class="row_holder" id="task_holder">
                <c:forEach var="entry" items="${sarariman.tasks}">
                    <div class="row tasks">
                        <span class="name">${fn:escapeXml(entry.name)}</span>
                        <span id="${fn:escapeXml(entry.name)}_parent" style="">${fn:escapeXml(entry.project.name)}</span>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div id="employees">
            <div class="title">Employees</div>
            <div class="row_holder" id="employee_holder">
                <c:forEach var="entry" items="${directory.byUserName}">
                    <div class="row employees">${entry.value.fullName}</div>
                </c:forEach>
            </div>
        </div>

    </div>
</body>
</html>

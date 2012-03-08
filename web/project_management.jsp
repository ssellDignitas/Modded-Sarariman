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

            padding-left:5%;

            overflow:auto;
        }

        #tasks, #projects, #customers
        {
            min-height:500px;
            width:22%;
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

            border:2px;
            border-bottom-left-radius: 0px 0px;
            border-bottom-right-radius: 0px 0px;
        }

        .name_input
        {
            border: 1px solid #FFFFFF;
            border-radius: 2px;
            background-color:#FFFFFF;
        }

        .edit
        {
            margin:5px;
            margin-top:-15px;

            padding:3px;
            padding-top:8px;

            border: 2px solid #7A895B;
            border-radius:2px;
        }

        .save_remove
        {
            margin:-3px;
            margin-top:8px;
 
            background-color:#7A895B;

            text-align:right;
        }

        .save, .remove
        {
            font-size:10px;
            background-color:transparent;
            border:0px;
            color:#FFFFFF;
            cursor:pointer;
        }

        .save
        {
        }

        .remove
        {
        }
    </style>
</head>
<body>

    <!-- Header Include -->
    <%@include file="header.jsp"%>
    <iframe class="hide_me" id="target_frame" name="target_frame"></iframe>
    <div id="container">

        <div id="customers">
            <div class="title">Customers</div>
            <div class="row_holder" id="customer_holder">
                <c:forEach var="entry" items="${sarariman.customers}">
                    <div class="row customers">
                        <span class="name">${fn:escapeXml(entry.value.name)}</span>
                    </div>
                    <div class="edit hide_me" id="${fn:escapeXml(entry.value.name)}_edit">

                        <span style="font-size:10px;color:#AAAAAA;">
                       
                        <form method="POST" action="customerController" id="${fn:escapeXml(entry.value.name)}_form">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="id" value="${entry.key}"/>
                        <table cellspacing="0">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Name</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_string" type="text" name="name" value="${fn:escapeXml(entry.value.name)}"></input></td>
                                </tr>
                            </tbody>
                        </table>
                        </form>
                        <div class="save_remove">
                            <button class="save">Save</button> 
                            <form method="POST" action="customerController" style="display:inline;" target="target_frame">
                                <input type="hidden" name="action" value="delete"/>
                                <input type="hidden" name="id" value="${entry.key}"/>
                                <input type="submit" name="delete" class="remove" value="Remove"/>
                            </form>
                        </div>
                        </span>
                    </div>
                </c:forEach>
                <div class="row new_customer"><span style="color:#AAAAAA;"><i>New Customer...</i></span></div>
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
                    <div class="edit hide_me" id="${fn:escapeXml(entry.value.name)}_edit">

                        <span style="font-size:10px;color:#AAAAAA;">
                        
                        <form method="POST" action="projectController">
                        <input type="hidden" name="action" value="update"/>
                        <input type="hidden" name="id" value="${entry.key}"/>
                        <input type="hidden" name="contract" value="${fn:escapeXml(entry.value.contract)}"/>
                        <input type="hidden" name="subcontract" value="${fn:escapeXml(entry.value.subcontract)}"/>
                        <input type="hidden" name="funded" value="${fn:escapeXml(entry.value.funded)}"/>
                        <input type="hidden" name="previously_billed" value="${fn:escapeXml(entry.value.previouslyBilled)}"/>
                        <input type="hidden" name="terms" value="${entry.value.terms}"/> 
                        <input type="hidden" name="odc_fee" value="${entry.value.ODCFee}"/>
                        <input type="hidden" name="active" value="${entry.value.active}"/>

                        <table cellspacing="0">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Name</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_string" type="text" name="name" value="${fn:escapeXml(entry.value.name)}"></input></td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Customer</td>
                                    <td style="width:5px;"></td>
                                    <td>
                                        <select class="edit_select" name="customer" >
                                            <c:forEach var="cust_entry" items="${sarariman.customers}">
                                                <option value="${cust_entry.key}" <c:if test="${cust_entry.key == entry.value.customer}">selected="selected"</c:if>>${fn:escapeXml(cust_entry.value.name)}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Start</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_string" type="text" name="pop_start" value="<fmt:formatDate value='${entry.value.pop.start}' pattern='yyyy-MM-dd'/>"></input> [YYYY-MM-DD]</td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">End</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_string" type="text" name="pop_end" value="<fmt:formatDate value='${entry.value.pop.end}' pattern='yyyy-MM-dd'/>"></input> [YYYY-MM-DD]</td>
                                </tr>
                            </tbody>
                        </table>

                        </form>
                        </span>

                        <div class="save_remove">
                            <button class="save">Save</button>
                            <form method="POST" action="projectController" style="display:inline;" target="target_frame">
                                <input type="hidden" name="action" value="delete"/>
                                <input type="hidden" name="id" value="${entry.key}"/>
                                <input type="submit" name="delete" class="remove" value="Remove"/>
                            </form>
                        </div>
                    </div>
                </c:forEach>
                <div class="row new_project"><span style="color:#AAAAAA;"><i>New Project...</i></span></div>
            </div>
        </div>

        <div id="tasks"> 
            <div class="title">Tasks</div>
            <div class="row_holder" id="task_holder">
                <c:forEach var="entry" items="${sarariman.tasks}">
                    <div class="row tasks">
                        <span class="name">${fn:escapeXml(entry.name)}</span>
                        <span id="${fn:escapeXml(entry.name)}_parent" style="display:none;">${fn:escapeXml(entry.project.name)}</span>
                    </div>

                    <div class="edit hide_me" id="${fn:escapeXml(entry.name)}_edit">

                        <span style="font-size:10px;color:#AAAAAA;">
                        <table cellspacing="0">
                            <thead>
                                <tr>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Name</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_string" type="text" value="${fn:escapeXml(entry.name)}"></input></td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Project</td>
                                    <td style="width:5px;"></td>
                                    <td><select class="edit_select"></select></td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Billable</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_checkbox" type="checkbox"></input></td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Active</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_checkbox" type="checkbox"></input></td>
                                </tr>
                                <tr>
                                    <td style="text-align:right;border-right:1px solid #DDD;padding-right:3px;">Description</td>
                                    <td style="width:5px;"></td>
                                    <td><input class="edit_string" type="text"></input></td>
                                </tr>
                            </tbody>
                        </table>
                        </span>
                       
                        <div class="save_remove"><input type="submit" class="save" value="Save"/><input type="submit" class="remove" value="Remove"/></div>
                    </div>
                </c:forEach>
                <div class="row new_task"><span style="color:#AAAAAA;"><i>New Task...</i></span></div>
            </div>
        </div>

    </div>
</body>
</html>

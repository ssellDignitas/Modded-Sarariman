<%-- 
    Document   : currentForm
    Created on : Jul 13, 2011, 3:26:20 PM
    Author     : root
--%>

<!--    
        CURRENT FORM

        This is displayed on the pane that belongs to the current day of the week.
-->

<fmt:formatDate var="now" value="${du:now()}" type="date" pattern="yyyy-MM-dd" />
<div class="currentFormTemplate">
               
        <div style="position:relative; float:left; width:70%;">
            
            <!-- Charge Number Drop-Down -->
            <label for="billable_task">Task:</label>
            <select name="billable_task" id="billable" onchange="resetSelect('unbillable_task');enable('submit');">

                <option selected="true"></option>

                <c:forEach var="task" items="${sarariman:billableTasks(sarariman,user)}">

                    <option value="${task.id}">${fn:escapeXml(task.name)} (${task.id})

                        <c:if test="${!empty task.project}">

                            ${fn:escapeXml(task.project.name)}:${fn:escapeXml(sarariman.customers[task.project.customer].name)}

                        </c:if>

                    </option>

                </c:forEach>

            </select>   
        </div>
                            
        <div style="position:relative; float:right;">

            <label for="duration">Duration:</label>
            <input size="5" type="text" name="duration" id="duration" />
        
        </div>

</div>    
        
        <!---------------------------------------------------------------------->     
        
<div class="currentForm">
    <form action="${request.requestURI}" method="post">

        <!-- LHS of Form -->
        <div style="position:relative; float:left; width:30%;">

            <div class="LHS_interior" style="overflow:auto;border-bottom:1px solid #E1E1E1;margin-bottom:5px;padding-bottom:5px;">
                <br />
            </div>

            <div style="position:relative; float:right;">
                <button type="button" class="removeFields button remove">Remove</button>
                <button type="button" class="addFields button add">Add</button>            
            </div>

        </div>

        <!-- RHS of Form -->

        <div class="stripe_back" style="position:relative; float:right; width:67%;border-left:1px solid #E1E1E1;padding-left:15px;">

            <label for="description">Description:</label>

            <br />

            <textarea cols="100" rows="10" name="description" id="description">i did work today</textarea>

            <fmt:formatDate var="weekString" value="${week}" type="date" pattern="yyyy-MM-dd" />

            <input type="hidden" name="week" value="${weekString}" />
            <br />

            <div style="position:relative; float:right;">

                <br />
                <input type="submit" name="recordTime" value="Record" id="submit" class="button submit" disabled="true"/>
            </div>
         </div>

    </form>
</div>
            
            
<!--    
        LOCKED FORM

        
-->

<div class="lockedForm">
   
    <div class="locked">
        <img src="images/lock.png"> locked
    </div>
    
    <div class="locked_message">
        This TimeSheet is currently locked. If you need to edit it, you must <a href="open">request for it to be opened</a>.<br>
    </div>
    
    <br />
    
    <!-- ------------------------>
    
    <form action="${request.requestURI}" method="post">

        <!-- LHS of Form -->
        <div style="position:relative; float:left; width:30%;">

            <div class="LHS_interior_locked" style="overflow:auto;border-bottom:1px solid #E1E1E1;margin-bottom:5px;padding-bottom:5px;">
                <br />
                
                <div style="position:relative; float:left; width:70%;">
            
            <!-- Charge Number Drop-Down -->
            <label for="billable_task_locked">Task:</label>
            <select name="billable_task_locked" id="billable_locked" onchange="resetSelect('unbillable_task');enable('submit');" disabled="true">

                <option selected="true"></option>

                <c:forEach var="task" items="${sarariman:billableTasks(sarariman,user)}">

                    <option value="${task.id}">${fn:escapeXml(task.name)} (${task.id})

                        <c:if test="${!empty task.project}">

                            ${fn:escapeXml(task.project.name)}:${fn:escapeXml(sarariman.customers[task.project.customer].name)}

                        </c:if>

                    </option>

                </c:forEach>

            </select>   
        </div>
                            
        <div style="position:relative; float:right;">

            <label for="duration_locked">Duration:</label>
            <input size="5" type="text" name="duration_locked" id="duration" disabled="true"/>
        
        </div>
                
                
            </div>

            <div style="position:relative; float:right;">
                <button type="button" class="removeFields button remove" disabled="true">Remove</button>
                <button type="button" class="addFields button add" disabled="true">Add</button>            
            </div>

        </div>

        <!-- RHS of Form -->

        <div class="stripe_back" style="position:relative; float:right; width:67%;border-left:1px solid #E1E1E1;padding-left:15px;">

            <label for="description_locked">Description:</label>

            <br />

            <textarea cols="100" rows="10" name="description_locked" id="description_locked" disabled="true">text</textarea>

            <fmt:formatDate var="weekString" value="${week}" type="date" pattern="yyyy-MM-dd" />

            <input type="hidden" name="week_locked" value="${weekString}" />
            <br />

            <div style="position:relative; float:right;">

                <br />
                <input type="submit" name="recordTime_locked" value="Record" id="submit_locked" class="button submit" disabled="true"/>
            </div>
         </div>

    </form>
</div>
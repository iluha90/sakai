<%@ page contentType="text/html;charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib uri="http://java.sun.com/jsf/html" prefix="h" %>
<%@ taglib uri="http://java.sun.com/jsf/core" prefix="f" %>
<%@ taglib uri="http://www.sakaiproject.org/samigo" prefix="samigo" %>
<%@ taglib uri="http://sakaiproject.org/jsf/sakai" prefix="sakai" %>
  
<!DOCTYPE html
     PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
     "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  

<!--
$Id$
<%--
***********************************************************************************
*
* Copyright (c) 2004, 2005, 2006 The Sakai Foundation.
*
* Licensed under the Educational Community License, Version 1.0 (the"License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.opensource.org/licenses/ecl1.php
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License. 
*
**********************************************************************************/
--%>
-->

<f:view>
    <f:loadBundle
     basename="org.sakaiproject.tool.assessment.bundle.EvaluationMessages"
     var="msg"/>
   <f:loadBundle
     basename="org.sakaiproject.tool.assessment.bundle.GeneralMessages"
     var="genMsg"/>
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head><%= request.getAttribute("html.head") %>
      <title><h:outputText
        value="#{msg.sub_status}" /></title>
      </head>
      <body onload="<%= request.getAttribute("html.body.onload") %>">
<!-- content... -->

<!-- JAVASCRIPT -->
<%@ include file="/js/delivery.js" %>

 <div class="portletBody">
<h:form id="editTotalResults">
  <h:inputHidden id="publishedId" value="#{totalScores.publishedId}" />
  <h:inputHidden id="itemId" value="#{totalScores.firstItem}" />

  <!-- HEADINGS -->
  <%@ include file="/jsf/evaluation/evaluationHeadings.jsp" %>

  <h3>
    <h:outputText value="#{msg.sub_status}"/>
    <h:outputText value="#{msg.column} "/>
    <h:outputText value="#{totalScores.assessmentName} "/>
  </h3>
  <p class="navViewAction">
    <h:outputText value="#{msg.sub_status}" />
    <h:outputText value=" #{msg.separator} " />
    <h:commandLink title="#{msg.t_totalScores}" action="totalScores" immediate="true">
    <f:actionListener type="org.sakaiproject.tool.assessment.ui.listener.evaluation.ResetTotalScoreListener" />
    <f:actionListener type="org.sakaiproject.tool.assessment.ui.listener.evaluation.TotalScoreListener" />
      <h:outputText value="#{msg.title_total}" />
    </h:commandLink>
    <h:outputText value=" #{msg.separator} " rendered="#{totalScores.firstItem ne ''}" />
    <h:commandLink title="#{msg.t_questionScores}" action="questionScores" immediate="true"
      rendered="#{totalScores.firstItem ne ''}" >
      <h:outputText value="#{msg.q_view}" />
      <f:actionListener
        type="org.sakaiproject.tool.assessment.ui.listener.evaluation.QuestionScoreListener" />
    </h:commandLink>
    <h:outputText value=" #{msg.separator} " rendered="#{totalScores.firstItem ne '' && !totalScores.hasRandomDrawPart}" />
    <h:commandLink title="#{msg.t_histogram}" action="histogramScores" immediate="true"
      rendered="#{totalScores.firstItem ne '' && !totalScores.hasRandomDrawPart}" >
      <h:outputText value="#{msg.stat_view}" />
      <f:param name="hasNav" value="true"/>
      <f:actionListener
        type="org.sakaiproject.tool.assessment.ui.listener.evaluation.HistogramListener" />
    </h:commandLink>
  </p>

  <h:messages styleClass="validation"/>

  <div class="tier1">
     <h:outputText value="#{msg.max_score_poss}" style="instruction"/>
     <h:outputText value="#{totalScores.maxScore}" style="instruction"/>
     <br />


<sakai:flowState bean="#{submissionStatus}" />
<h:panelGrid columns="2" columnClasses="samLeftNav,samRightNav" width="100%">
  <h:panelGroup>
    <h:panelGrid columns="1" columnClasses="samLeftNav" width="100%">
	  <h:panelGroup>
        <!-- SECTION AWARE -->
        <h:outputText value="#{msg.view}"/>
        <h:outputText value="#{msg.column}"/>
        <h:selectOneMenu value="#{submissionStatus.selectedSectionFilterValue}" id="sectionpicker" required="true" onchange="document.forms[0].submit();">
          <f:selectItems value="#{totalScores.sectionFilterSelectItems}"/>
          <f:valueChangeListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener"/>
        </h:selectOneMenu>
      </h:panelGroup>
	
	  <h:panelGroup>
			<h:outputText value="#{msg.search}"/>
            <h:outputText value="#{msg.column}"/>
			<h:inputText
				id="searchString"
				value="#{submissionStatus.searchString}"
				onfocus="clearIfDefaultString(this, '#{msg.search_default_student_search_string}')"
				onkeypress="return submitOnEnter(event, 'editTotalResults:searchSubmitButton');"/>
			<f:verbatim> </f:verbatim>
			<h:commandButton actionListener="#{submissionStatus.search}" value="#{msg.search_find}" id="searchSubmitButton" />
			<f:verbatim> </f:verbatim>
			<h:commandButton actionListener="#{submissionStatus.clear}" value="#{msg.search_clear}"/>
	  </h:panelGroup>
    </h:panelGrid>
  </h:panelGroup>

  <h:panelGroup>
	<div>
	<sakai:pager id="pager" totalItems="#{submissionStatus.dataRows}" firstItem="#{submissionStatus.firstRow}" pageSize="#{submissionStatus.maxDisplayedRows}" textStatus="#{msg.paging_status}" />
	</div>
  </h:panelGroup>
</h:panelGrid>

  <!-- STUDENT RESPONSES AND GRADING -->
  <!-- note that we will have to hook up with the back end to get N at a time -->
<div class="tier2">
  <h:dataTable cellpadding="0" cellspacing="0" styleClass="listHier" id="totalScoreTable" value="#{submissionStatus.agents}"
    var="description">
    <!-- NAME/SUBMISSION ID -->

    <h:column rendered="#{submissionStatus.sortType ne 'lastName'}">
     <f:facet name="header">
        <h:commandLink title="#{msg.t_sortLastName}" immediate="true" id="lastName" action="submissionStatus">
          <h:outputText value="#{msg.name}" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
        <f:param name="sortBy" value="lastName" />
        <f:param name="sortAscending" value="true"/>
        </h:commandLink>
     </f:facet>
     <h:panelGroup>
       <h:outputText value="<a name=\"" escape="false" />
       <h:outputText value="#{description.lastInitial}" />
       <h:outputText value="\"></a>" escape="false" />
       <h:outputText value="#{description.firstName}" />
       <h:outputText value=" " />
       <h:outputText value="#{description.lastName}" />
       <h:outputText value="#{msg.na}" rendered="#{description.lastInitial eq 'Anonymous'}" />
     </span>
     </h:panelGroup>
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'lastName' && submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortLastName}" action="submissionStatus">
          <h:outputText value="#{msg.name}" />
          <f:param name="sortBy" value="lastName" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{msg.alt_sortLastNameDescending}" rendered="#{submissionStatus.sortAscending}" url="/images/sortascending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
     <h:panelGroup>
       <h:outputText value="<a name=\"" escape="false" />
       <h:outputText value="#{description.lastInitial}" />
       <h:outputText value="\"></a>" escape="false" />
       <h:outputText value="#{description.firstName}" />
       <h:outputText value=" " />
       <h:outputText value="#{description.lastName}" />
       <h:outputText value="#{msg.na}" rendered="#{description.lastInitial eq 'Anonymous'}" />
     </span>
     </h:panelGroup>
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'lastName' && !submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortLastName}" action="submissionStatus">
          <h:outputText value="#{msg.name}" />
          <f:param name="sortBy" value="lastName" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{msg.alt_sortLastNameAscending}" rendered="#{!submissionStatus.sortAscending}" url="/images/sortdescending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
     <h:panelGroup>
       <h:outputText value="<a name=\"" escape="false" />
       <h:outputText value="#{description.lastInitial}" />
       <h:outputText value="\"></a>" escape="false" />
       <h:outputText value="#{description.firstName}" />
       <h:outputText value=" " />
       <h:outputText value="#{description.lastName}" />
       <h:outputText value="#{msg.na}" rendered="#{description.lastInitial eq 'Anonymous'}" />
     </span>
     </h:panelGroup>
    </h:column>


   <!-- STUDENT ID -->
    <h:column  rendered="#{submissionStatus.sortType ne 'idString'}" >
     <f:facet name="header">
       <h:commandLink title="#{msg.t_sortUserId}" id="idString" action="submissionStatus" >
          <h:outputText value="#{msg.uid}" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
        <f:param name="sortBy" value="idString" />
        <f:param name="sortAscending" value="true"/>
        </h:commandLink>
     </f:facet>
        <h:outputText value="#{description.agentEid}" />
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'idString' && submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortUserId}" action="submissionStatus">
          <h:outputText value="#{msg.uid}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{msg.alt_sortUserIdDescending}" rendered="#{submissionStatus.sortAscending}" url="/images/sortascending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
       <h:outputText value="#{description.agentEid}" />
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'idString' && !submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortUserId}" action="submissionStatus">
          <h:outputText value="#{msg.uid}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{msg.alt_sortUserIdAscending}" rendered="#{!submissionStatus.sortAscending}" url="/images/sortdescending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
       <h:outputText value="#{description.agentEid}" />
    </h:column>


    <!-- ROLE -->
    <h:column rendered="#{submissionStatus.sortType ne 'role'}">
     <f:facet name="header" >
        <h:commandLink title="#{msg.t_sortRole}" id="role" action="submissionStatus">
          <h:outputText value="#{msg.role}" />
        <f:actionListener
           type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
        <f:param name="sortBy" value="role" />
        <f:param name="sortAscending" value="true"/>
        </h:commandLink>
     </f:facet>
        <h:outputText value="#{description.role}"/>
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'role' && submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortRole}" action="submissionStatus">
          <h:outputText value="#{msg.role}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{msg.alt_sortRoleDescending}" rendered="#{submissionStatus.sortAscending}" url="/images/sortascending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
       <h:outputText value="#{description.role}" />
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'role' && !submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortRole}" action="submissionStatus">
          <h:outputText value="#{msg.role}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{msg.alt_sortRoleAscending}" rendered="#{!submissionStatus.sortAscending}" url="/images/sortdescending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
       <h:outputText value="#{description.role}" />
    </h:column>

    <!-- DATE -->
    <h:column rendered="#{submissionStatus.sortType ne 'submittedDate'}">
     <f:facet name="header">
        <h:commandLink title="#{msg.t_sortSubmittedDate}" id="submittedDate" action="submissionStatus">
          <h:outputText value="#{msg.date}" />
        <f:actionListener
          type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
        <f:param name="sortBy" value="submittedDate" />
        </h:commandLink>
     </f:facet>
        <h:outputText rendered="#{description.submittedDate !=null && description.submittedDate ne ''}" value="#{description.submittedDate}">
          <f:convertDateTime pattern="#{genMsg.output_date_picker}"/>
        </h:outputText>
		<h:outputText rendered="#{description.submittedDate == null || description.submittedDate eq ''}" value="#{msg.no_submission}"/>
    </h:column>
	
	<h:column rendered="#{submissionStatus.sortType eq 'submittedDate' && submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortSubmittedDate}" action="submissionStatus">
          <h:outputText value="#{msg.date}" />
          <f:param name="sortAscending" value="false" />
          <h:graphicImage alt="#{msg.alt_sortSubmittedDateDescending}" rendered="#{submissionStatus.sortAscending}" url="/images/sortascending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText rendered="#{description.submittedDate !=null && description.submittedDate ne ''}" value="#{description.submittedDate}">
           <f:convertDateTime pattern="#{genMsg.output_date_picker}"/>
        </h:outputText>
		<h:outputText rendered="#{description.submittedDate == null || description.submittedDate eq ''}" value="#{msg.no_submission}"/>
    </h:column>

	<h:column rendered="#{submissionStatus.sortType eq 'submittedDate' && !submissionStatus.sortAscending}">
      <f:facet name="header">
        <h:commandLink title="#{msg.t_sortSubmittedDate}" action="submissionStatus">
          <h:outputText value="#{msg.date}" />
          <f:param name="sortAscending" value="true" />
          <h:graphicImage alt="#{msg.alt_sortSubmittedDateAscending}" rendered="#{!submissionStatus.sortAscending}" url="/images/sortdescending.gif"/>
          <f:actionListener
             type="org.sakaiproject.tool.assessment.ui.listener.evaluation.SubmissionStatusListener" />
          </h:commandLink>    
      </f:facet>
        <h:outputText rendered="#{description.submittedDate !=null && description.submittedDate ne ''}" value="#{description.submittedDate}">
           <f:convertDateTime pattern="#{genMsg.output_date_picker}"/>
        </h:outputText>
		<h:outputText rendered="#{description.submittedDate == null || description.submittedDate eq ''}" value="#{msg.no_submission}"/>
    </h:column>

  </h:dataTable>
</div>
</div>

</h:form>
</div>
  <!-- end content -->
      </body>
    </html>
  </f:view>

<%--
  - Author(s):          KHYATI
  - Date:               15-MAY-2015
  - Copyright Notice:   Copyright (c) 2015 Quix Creation Pte. Ltd. All Rights Reserved.
  - Description:        
--%>

<%@page import="com.quix.aia.cn.imo.constants.SessionAttributes"%>
<%@page import="com.quix.aia.cn.imo.data.locale.LocaleObject"%>
<%@page import="com.quix.aia.cn.imo.utilities.Pager"%>
<%@page import="com.quix.aia.cn.imo.constants.RequestAttributes"%>
<%@page import="com.quix.aia.cn.imo.constants.PagingInfo"%>
<%@page import="com.quix.aia.cn.imo.interfaces.FormPageInterface"%>

<%@ taglib uri="http://jsptags.com/tags/navigation/pager" prefix="pg"%>

<script type='text/javascript' src='dwr/engine.js'></script>
<script type='text/javascript' src='dwr/interface/ImoUtilityData.js'></script>
<script src="js/imocn.js" type="text/javascript" charset="utf-8" ></script>
<script type="text/javascript" src="js/jquery-1.9.1.js" ></script>


<%
LocaleObject localeObj = (LocaleObject)session.getAttribute(SessionAttributes.LOCALE_OBJ);
Pager pager = (com.quix.aia.cn.imo.utilities.Pager) request.getAttribute(com.quix.aia.cn.imo.constants.RequestAttributes.PAGING_OBJECT);
%>
<script type="text/javascript">
function submitForm(){
	document.BUForm.submit();
}
	$(function(){
		$(".data_table tr:odd").addClass("odd");
        $(".data_table tr:not(.odd)").addClass("even");  
	});
</script>
		<div id="maincontainer">
					<div class="head">
						<h2 align="center"><%=localeObj.getTranslatedText("Loged In Details")%></h2>
					</div>
					<div class="content" style="background-color:#ffffff;">
						<form action="ContentManager" name="BUForm" method="post" class="PT20">
							<input type="hidden" name="token" id="token" value="<%=request.getSession().getAttribute("Token")+"" %>">
							<table class="formDesign">
								
								<tr>
									<td ><span style="color:#ec2028;">* </span><label><%=localeObj.getTranslatedText("Branch")%></label></td>
									<td ><!-- <input type="text" name="name" id="name" class="textObj" value=""> -->
									
										<select name="branch" id="branch"  class="comboObj" >
                            			<option value=""><%=localeObj.getTranslatedText("All")%></option> 	                                 	
                            	</select>
									</td>
								</tr>
								
								<tr >
									<td colspan="2" class="MT30 MB30" style="text-align:center;padding-top:20px">
										<a href="#" class="btn1" onclick="javascript:submitForm();"><%=localeObj.getTranslatedText("Search")%></a>
										<a href="javascript:document.BUForm.reset();" class="ML10 btn1"><%=localeObj.getTranslatedText("Clear")%></a>
									</td>
								</tr>
							</table>
							
							<div class="MT30" >
								<table style="width:100%">
										<%
										int noOfAnnouncements = 0;
										if(pager != null){
											 noOfAnnouncements = ((com.quix.aia.cn.imo.utilities.Pager)request.getAttribute(com.quix.aia.cn.imo.constants.RequestAttributes.PAGING_OBJECT)).getActualSize();
										}%>								
										<tr>
										<td align="right" style="font-weight:bold;padding-right:10px"><%=localeObj.getTranslatedText("Search Results")%> : <%=noOfAnnouncements %></td></tr>
								</table>
							</div>
							
							<div class="data_table  MT20 MB20" style="width:100%" >
							<table class="subFormDesign">
								<thead>
										<tr>
											
											<th><label><%=localeObj.getTranslatedText("LogedIn ID")%></label></th>
											<th><label><%=localeObj.getTranslatedText("LogedIn Name")%></label></th>
											<th><label><%=localeObj.getTranslatedText("No. of Login")%></label></th>
											<th width="10%"><label><%=localeObj.getTranslatedText("No. of Contacts")%></label></th>
										</tr>
								</thead>
								<tbody>
									<%if(pager != null){ %>
									<pg:pager items="<%= pager.getItems().size() %>"
										maxPageItems="500"
										maxIndexPages="<%= pager.getMaxIndexPages() %>"
										isOffset="<%= pager.isOffset() %>"
										export="offset,currentPageNumber=pageNumber" scope="request"
										url="/ContentManager">

										<%for (int i = offset.intValue(),l = Math.min(i + pager.getMaxPageItems(), pager.getItems().size());i < l; i++)
										{%>
										<pg:item>
											<%=(String)pager.getItems().get(i)%>
										</pg:item>
										<%}%>
										<%if(pager.getItems().size() <= 0){%>
										<tr>
											<td colspan="3" bordercolor="#FFFFFF">
												<div align="center">
													<strong><%=localeObj.getTranslatedText("No Record Found")%></strong>
												</div></td>
										</tr>
										<%}%>
									</pg:pager>

									<pg:pager items="<%= pager.getItems().size() %>"
										maxPageItems="<%= pager.getMaxPageItems() %>"
										maxIndexPages="<%= pager.getMaxIndexPages() %>"
										isOffset="<%= pager.isOffset() %>"
										export="offset,currentPageNumber=pageNumber" scope="request"
										url="ContentManager">

										<pg:param name="<%=RequestAttributes.PARAMETER_KEY%>"
											value="<%=(String)((FormPageInterface)request.getAttribute(RequestAttributes.CONTENT_PAGE)).getKey()%>" />
										<%-- save pager offset during form changes --%>
										<input type="hidden" name="pager.offset" value="<%= offset %>">
										<%if(pager.getItems().size() > pager.getMaxPageItems()){%>
										<table class="data_table_pagination" width="100%" cellpadding="0" cellspacing="0">
											<tr >
												<td style="width: 10%">
													<div align="center">
														<span class="button_label"> <!-- Prev Page Link -->
															<pg:prev export="pageUrl">
																<a href="<%= pageUrl%>" class="button_label"
																	style="text-decoration: none; color: #ffffff; font-weight: bold"><%=localeObj.getTranslatedText("Previous")%></a>
															</pg:prev> </span>
													</div>
												</td>
												<td>
													<div align="center">
														<pg:pages>
															<%if (pageNumber.intValue() < PagingInfo.SEARCH_INDEX_SIZE) {%> 
																&nbsp;
															<%}if (pageNumber == currentPageNumber) {%>
															<span style="color: orange"><b> <%= pageNumber %>
															</b>
															</span>
															<%} else {%>
															<a href="<%= pageUrl %>"
																style="text-decoration: none; color: #ffffff; font-weight: bold; padding: 5px;"><%= pageNumber %></a>
															<%}%>
															&nbsp;
														</pg:pages>
													</div></td>
												<td style="width: 10%">
													<div align="center">
														<span class="button_label"> <!-- Prev Page Link -->
															<pg:next export="pageUrl">
																<a href="<%= pageUrl%>" class="button_label"
																	style="text-decoration: none; color: #ffffff; font-weight: bold"><%=localeObj.getTranslatedText("Next")%></a>
															</pg:next> </span>
													</div>
												</td>
											</tr>
										</table>
										<%}%>
									</pg:pager>
									<%}
								  	else
								  	{%>
								<tr>
									<td colspan="3" bordercolor="#FFFFFF">
										<div align="center">
											<strong><%=localeObj.getTranslatedText("No Record Found")%></strong>
										</div></td>
								</tr>
								<%} %>
								</tbody>
							</table>
							
							</div>
							
							<table class="subFormDesign">
			     		 <tr>                         
                   			<td colspan="17" class="MT30 MB30" style="text-align:center;padding-top:20px">
                   				<%
                   					String str="";
                   					if(request.getAttribute("path")!=null){
                   						str=request.getAttribute("path")+"";
                   					}
                   				%>
       		 					<a href="<%=str%>" class="ML10 btn1"><%=localeObj.getTranslatedText("Download into Excel")%></a> 
       		 					 
                  	 		</td>                                     			   
                   		 </tr>
			    	    <tr><td colspan="17" class="MT30 MB30" style="text-align:right;padding-top:20px"></td></tr>
                   		          
			     </table>
						</form>
											
					</div>
		</div>	
<script>
getBranchForLogin('2', '', 'L');
</script>
/*******************************************************************************
 * -----------------------------------------------------------------------------
 * <br>
 * <p><b>Copyright (c) 2015 Quix Creation Pte. Ltd. All Rights Reserved.</b> 
 * <br>
 * <br>
 * This SOURCE CODE FILE, which has been provided by Quix as part
 * of a Quix Creations product for use ONLY by licensed users of the product,
 * includes CONFIDENTIAL and PROPRIETARY information of Quix Creations.
 * <br>
 * USE OF THIS SOFTWARE IS GOVERNED BY THE TERMS AND CONDITIONS
 * OF THE LICENSE STATEMENT AND LIMITED WARRANTY FURNISHED WITH
 * THE PRODUCT.<br>
 * <br>
 * </p>
 * -----------------------------------------------------------------------------
 * <br>
 * <br>
 * Modification History:
 * Date              Developer          Change Description
 * 07-May-2015       Jay   
 * 18-Nov-2015            Nibedita          Error stored in db       

 ****************************************** *********************************** */
package com.quix.aia.cn.imo.rest;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.reflect.Type;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonParseException;
import com.quix.aia.cn.imo.data.auditTrail.AuditTrail;
import com.quix.aia.cn.imo.data.logedInDetail.LogedInDetails;
import com.quix.aia.cn.imo.data.user.User;
import com.quix.aia.cn.imo.mapper.AuditTrailMaintenance;
import com.quix.aia.cn.imo.mapper.LogsMaintenance;
import com.quix.aia.cn.imo.mapper.UserMaintenance;
import com.quix.aia.cn.imo.utilities.LMSUtil;

@Path("/user")
public class UserAuthRest {

	static Logger log = Logger.getLogger(UserAuthRest.class.getName());

	@GET
	@Path("/getUserAuth")
	@Produces({ MediaType.APPLICATION_JSON })
	public Response getUser(@Context HttpServletRequest request,
			@Context ServletContext context) {

		log.log(Level.INFO, "UserAuthRest --> getUser ");
		MsgBeans beans = new MsgBeans();
		String userID = request.getParameter("agentId");
		String psw = request.getParameter("psw");
		String branch = request.getParameter("branch");

		AuditTrailMaintenance auditTrailMaint = new AuditTrailMaintenance();

		try {

			UserMaintenance userMaintenance = new UserMaintenance();
			User user = userMaintenance.authenticateUser(userID, psw, branch, context);
			ArrayList<User> list = new ArrayList<User>();
			list.add(user);
			Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").setExclusionStrategies().create(); // .serializeNulls()
			String json = gson.toJson(list);
			// auditTrailMaint.insertAuditTrail(new AuditTrail("Rest",
			// AuditTrail.MODULE_ANNOUNCEMENT, AuditTrail.FUNCTION_REST,
			// "SUCCESS"));
			return Response.status(200).entity(json).build();

		} catch (Exception e) {
			log.log(Level.INFO, "UserAuthRest --> getUserAuth --> Exception..... ");
			log.log(Level.SEVERE, e.getMessage());
			e.printStackTrace();
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			LogsMaintenance logsMain = new LogsMaintenance();
			logsMain.insertLogs("UserAuthRest", Level.SEVERE + "",
					errors.toString());
			// auditTrailMaint.insertAuditTrail(new AuditTrail("Rest",
			// AuditTrail.MODULE_ANNOUNCEMENT, AuditTrail.FUNCTION_FAIL,
			// "FAILED"));
			beans.setCode("500");
			beans.setMassage("Database Error");
			return Response.status(500).entity(new Gson().toJson(beans)).build();
		}

	}
	

//	[{"logedInId":"","co":"","logedInDate":"2013-07-04 00:00:00"}]
//	{"logedInId":"309086","co":"0986","logedInDate":"2013-07-04 00:00:00"}
	@POST
	@Path("/agentLoginDetails")
	@Consumes(MediaType.TEXT_PLAIN)
	@Produces({MediaType.APPLICATION_JSON})
	public Response agentLoginDetails(@Context HttpServletRequest request,
						   		   @Context ServletContext context,
						   		   String jsonString)
	{
		log.log(Level.INFO,"UserAuthRest --> agentLoginDetails");
	    log.log(Level.INFO,"UserAuthRest --> agentLoginDetails --> Data ...  ::::: "+jsonString);
		boolean status=false;
		UserMaintenance userMaintenance = new UserMaintenance();
		MsgBeans beans = new MsgBeans();
		AuditTrailMaintenance auditTrailMaint=new AuditTrailMaintenance();	
		try{
			GsonBuilder builder = new GsonBuilder();
	        builder.registerTypeAdapter(Date.class, new JsonDeserializer<Date>() { 
               @Override  
               public Date deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) throws JsonParseException {
            	   	Date date = null;
        	   		try {
						date = LMSUtil.yyyymmddHHmmssdashed.parse(json.getAsString());
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
        	   		return date;
               }
            });
	        
	        Gson googleJson  = builder.create();
	        LogedInDetails logedInDetails = googleJson.fromJson(jsonString, LogedInDetails.class);
	        userMaintenance.insertUserDetails(logedInDetails.getCo(), logedInDetails.getLogedInId(), logedInDetails.getLogedInDate(),"AG");    
	        
	        status = true;
		    auditTrailMaint.insertAuditTrail(new AuditTrail("Rest", AuditTrail.MODULE_EOP, AuditTrail.FUNCTION_REST, "SUCCESS"));
		}
		catch(Exception e){
			log.log(Level.INFO,"UserAuthRest --> agentLoginDetails --> Exception..... ");
			log.log(Level.SEVERE, e.getMessage());
			e.printStackTrace();
			StringWriter errors = new StringWriter();
			e.printStackTrace(new PrintWriter(errors));
			LogsMaintenance logsMain=new LogsMaintenance();
			logsMain.insertLogs("UserAuthRest",Level.SEVERE+"",errors.toString());
			
			auditTrailMaint.insertAuditTrail(new AuditTrail("Rest", AuditTrail.MODULE_USER, AuditTrail.FUNCTION_FAIL, "FAILED"));
			beans.setCode("500");
			beans.setMassage("Database Error");
			status = false;
		}
		
		return Response.status(200).entity("{\"status\":"+status+"}").build();
	}

}
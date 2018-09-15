package com.cbs.action;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.interceptor.RequestAware;

import org.apache.struts2.interceptor.ServletResponseAware;
import org.apache.struts2.interceptor.SessionAware;

import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.SerializerFeature;
/**通用的Action类*/
public class BaseAction implements ServletResponseAware,RequestAware,SessionAware {
   public HttpServletResponse response;
   public Map<String, Object> request;
   public Map<String, Object> session;
	
public void setServletResponse(HttpServletResponse response) {
		this.response=response;
		
	}


	public void setRequest(Map<String, Object> request) {
		this.request=request;
		
	}

	public void setSession(Map<String, Object> session) {
		this.session=session;
		
	}
 //通用的JSON提交方法
	public void WriteJson(Object obj){
		String Jsonstr=JSONObject.toJSONString(obj);
		System.out.println("Jsonstr:"+Jsonstr);
		this.response.setContentType("text/html;charset=utf-8");
		try {
			this.response.getWriter().write(Jsonstr);
			this.response.getWriter().flush();
			this.response.getWriter().close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**通用的（json,过滤）提交*/
		public void wirteJSON(Object o){
			try {
				String json= JSONObject.toJSONString(o,SerializerFeature.DisableCircularReferenceDetect);
				System.out.println("json:"+json);
				this.response.setContentType("text/html;charset=utf-8");
				this.response.getWriter().write(json);
				this.response.getWriter().flush();
				this.response.getWriter().close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	/**通用的返回结果提示语句*/
	public Map<String,Object> getResultMsg(boolean flag,String smsg,String fmsg ){
		Map<String,Object> mapmsg=new HashMap<String,Object>();
		mapmsg.put("success", flag);
		if(flag){
			mapmsg.put("msg", smsg);
		}else{
			mapmsg.put("msg", fmsg);
		}
		return mapmsg;
		}
}

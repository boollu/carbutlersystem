package com.cbs.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.ServletActionContext;


import com.alibaba.fastjson.JSONObject;
import com.cbs.po.Menu;
import com.cbs.po.PageMenu;
import com.cbs.service.IMenuService;

public class MenuAction {
	private IMenuService ims;

public IMenuService getIms() {
	return ims;
}

public void setIms(IMenuService ims) {
	this.ims = ims;
}
 //加载菜单树的方法
 public void menuTree(){
	 //定义前台所需要的数据集合
	 List<PageMenu> pmlist=new ArrayList<PageMenu>();
	 //得到菜单表中所有的数据
	 List<Menu> mlist=ims.findAllMenu();
	 if(mlist!=null&&mlist.size()>0){
	 //转换为前台所需要的属性值
	 for (Menu menu : mlist) {
		 PageMenu pm=new PageMenu();
		 pm.setId(menu.getId());
		 pm.setPid(menu.getPid());
		 pm.setText(menu.getText());
		 //设置自定义属性，存放url
		 Map<String,Object> urlmap=new HashMap<String,Object>();
		 urlmap.put("url", menu.getUrl());
		 pm.setAttributes(urlmap);
		 pmlist.add(pm);
	}
	 //转换为JSON字符串并写出
	 String Jsonpmlist=JSONObject.toJSONString(pmlist);
		//写出
		HttpServletResponse response=ServletActionContext.getResponse();
		response.setContentType("text/html;charset=utf-8");
		try {
			PrintWriter out=response.getWriter();
			out.print(Jsonpmlist);
			out.flush();
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 }else{//没有树菜单的情况
		//转换为JSON字符串并写出
		 String Jsonerror=JSONObject.toJSONString("系统错误，请联系运维！");
			//写出
			HttpServletResponse response=ServletActionContext.getResponse();
			response.setContentType("text/html;charset=utf-8");
			try {
				PrintWriter out=response.getWriter();
				out.print(Jsonerror);
				out.flush();
				out.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} 
		 
	 }
 }
 
 
}

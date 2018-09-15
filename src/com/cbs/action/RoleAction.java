package com.cbs.action;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cbs.po.Menu;
import com.cbs.po.PageMenu;
import com.cbs.po.PageModel;
import com.cbs.po.Role;
import com.cbs.service.IMenuService;
import com.cbs.service.IRoleService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class RoleAction extends BaseAction implements ModelDriven<Role>{
   private Role role;
   private IRoleService irs;
   private IMenuService ims;//加载菜单树
   
   
   
	public IMenuService getIms() {
	return ims;
}


public void setIms(IMenuService ims) {
	this.ims = ims;
}


	public Role getRole() {
	return role;
}


public void setRole(Role role) {
	this.role = role;
}


public IRoleService getIrs() {
	return irs;
}


public void setIrs(IRoleService irs) {
	this.irs = irs;
}
//展示所有角色的方法
public void showRole(){
	//获取所需要的数据
	PageModel pm=irs.findPageRole(role);
	//转化为JSON并写出到前台
	this.WriteJson(pm);
}
/**添加角色*/
public void addRole(){
	//
	boolean flag=irs.addRole(role);
	Map<String, Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg, PrintInfo.fmsg);
	//转化为Json字符串并写往前台
	this.WriteJson(mapmsg);
	}
/**修改角色*/
public void updRole(){
	System.out.println("修改的角色id为："+role.getId());
	boolean flag=irs.updRole(role);
	Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg, PrintInfo.fmsg);
	//转化为Json字符串并写往前台
		this.WriteJson(mapmsg);
}
/**展示角色tree的方法*/
public void showRoleTree(){
	//获取从前台传入的id
	Integer rid=role.getId();
	Role r=irs.get(rid);
	//获取角色对应的菜单
	Set<Menu> rolemenu=r.getMenus();
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
		 //判断选中的角色有无已授权的菜单
		 for (Menu m : rolemenu) {
			if(m.getId().equals(menu.getId())&&menu.getId().length()==PrintInfo.menulength){
				pm.setChecked(true);
			}
		}
		 pmlist.add(pm);
	}
	 //转换为JSON字符串并写出
	 this.WriteJson(pmlist);
	 }else{//没有树菜单的情况
		//转换为JSON字符串并写出
		this.WriteJson("系统异常，请联系运维！");
	 } 
}
/**
 *角色授权
 * */
public boolean grantRole(){
	boolean flag=irs.grantRole(role);
	if(flag){
		Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg, PrintInfo.fmsg);
		//转化为Json字符串并写往前台
			this.WriteJson(mapmsg);
	}
	return false;
	
}
//模型驱动的方法
	public Role getModel() {
		if(role==null){
			role=new Role();
		}
		return role;
	}
 
}

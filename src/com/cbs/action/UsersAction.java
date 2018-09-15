package com.cbs.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts2.ServletActionContext;

import com.alibaba.fastjson.JSONObject;
import com.cbs.po.Dictionary;
import com.cbs.po.Menu;
import com.cbs.po.PageMenu;
import com.cbs.po.PageModel;
import com.cbs.po.Role;
import com.cbs.po.Users;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IMenuService;
import com.cbs.service.IUsersService;
import com.cbs.util.MD5Util;
import com.cbs.util.PrintInfo;

import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

public class UsersAction extends BaseAction implements ModelDriven<Users>{
  private String url;
  public Users us;
  private String path;
  private IMenuService ims;//加载菜单树
  private IUsersService ius;//登陆
  private IDictionaryService idics;
  
  


public IDictionaryService getIdics() {
	return idics;
}

public void setIdics(IDictionaryService idics) {
	this.idics = idics;
}

public String getUrl() {
	return url;
}

public void setUrl(String url) {
	this.url = url;
}

public IMenuService getIms() {
	return ims;
}

public void setIms(IMenuService ims) {
	this.ims = ims;
}

public Users getUs() {
	return us;
}

public void setUs(Users us) {
	this.us = us;
}

public String getPath() {
	return path;
}

public void setPath(String path) {
	this.path = path;
}

public IUsersService getIus() {
	return ius;
}

public void setIus(IUsersService ius) {
	this.ius = ius;
}
  /**登录方法*/
 public void login(){
	 boolean flag=false;
	String md5lpass=MD5Util.md5Encode(us.getLpass());//转换登录对象的密码，与已存在的对象密码作比较
	Users user=ius.findUsersByLogin(us.getLname(), md5lpass);
	System.out.println(user.getCard());
	if(user!=null){
		this.session.put("user", user);//直接使用通用action中的session，将登陆成功后的用户对象存入session中
		
		flag=true;
	}
	//转换为JSON字符串并写出
	this.WriteJson(flag);
	}
 //登陆成功后跳转的方法
 public String gotoIndex(){
	 System.out.println("gotoIndex*****************");
	 this.path="WEB-INF/index.jsp";
	return "ok";//走struts的跳转路径至index页面
	}
 //安全退出的方法
 public String exit(){
	 //该session和login方法中的session为同一个
	 //HttpSession session=ServletActionContext.getRequest().getSession();
	//清空session
	 //this.session.invalidate();
	 this.session.clear();
	 //清空后跳转至登陆页面
	 this.path="WEB-INF/login.jsp";
	return "ok";
	}
 
 /**加载菜单树的方法*/
 public void menuTree(){
	 System.out.println("menuTree方法执行*************");
	 //获取登陆用户
	 Users u=(Users) this.session.get("user");
	 //判空
	 if(u!=null){
		 //if(u.getLname().equals("admin")){
	//定义前台所需要的数据集合
	 List<PageMenu> pmlist=new ArrayList<PageMenu>();
	 List<Menu> mlist=new ArrayList<Menu>();
	 if(u.getLname().equals("admin")){
	 //得到菜单表中所有的数据
    mlist=ims.findAllMenu();
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
	 } this.WriteJson(pmlist);
	 }else{//没有树菜单的情况
		//转换为JSON字符串并写出
		for (Role r :u.getRoles() ) {
			for (Menu menu : r.getMenus()) {
				mlist.add(menu);
			}
		}
		if(mlist!=null&&mlist.size()>0){
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
			this.WriteJson(pmlist);
		}
		
		
	 } 
	 }
 }
 /**获取对象模型的方法*/
public Users getModel() {
	if(us==null){
	us=new Users();
	}
	return us;
}

 /**跳转至角色管理页面的方法*/
public String gotoRoleManagement(){
	this.path="WEB-INF/pages/"+url;
	return "ok";
	
}
 /**获取对应部门部门的方法*/
public void findDept(){
	List<Dictionary> dlist=idics.findByText("部门");
	//转换为JSON字符串并写出
	this.wirteJSON(dlist);
}
/**获取对应职务的方法*/
public void findPost(){
	List<Dictionary> plist=idics.findByText("职务");
	//转换为JSON字符串并写出
		this.wirteJSON(plist);
}
/**获取用户结果集的方法*/
public void showUsers(){
	PageModel pm=ius.findPageUsers(us);
	//转换为JSON字符串并写出
			this.wirteJSON(pm);
}
/**验证用户是否存在的方法*//*
public void checkUsers(){
	boolean flag=ius.checkUsers(us);
	//转换为JSON字符串并写出
	this.wirteJSON(flag);
}*/
/**添加用户*/
public void addUsers(){
	 String md5lpass=MD5Util.md5Encode(us.getLpass());//添加用户时加密密码
	 us.setLpass(md5lpass);//修改密码为加密之后的密码
	 boolean f=ius.addUsers(us);//保存对象
	// boolean f=ius.addUsers(us);
	Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
	//转换为JSON字符串并写出
		this.wirteJSON(mapmsg);
}
/**修改用户*/
public void updUsers(){
	boolean f=ius.updUsers(us);
	Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
	//转换为JSON字符串并写出
		this.wirteJSON(mapmsg);
}
/**删除用户(该变启用状态为禁用)*/
public void delUsers(){
	boolean f=ius.dUsers(us);
	Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
	//转换为JSON字符串并写出
		this.wirteJSON(mapmsg);
}
/**查询的所有角色*/
public void findAllRole(){
	List<Role> rlist=ius.findAllRole(us);
	//转换为JSON字符串并写出
			this.wirteJSON(rlist);
}
/**给用户指派角色的方法*/
public void grant(){
	boolean f=ius.grantRole(us);
	Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
	//转换为JSON字符串并写出
		this.wirteJSON(mapmsg);
}
//修改密码时先查看原始密码是否正确
	/*public void ckPass(){
		boolean f=false;
		//登陆时的对象
		Users u=(Users) this.session.get("users");
		//原始密码转MD5
		String temp=MD5Util.md5Encode(u.getOpass());//获取修改时用户输入的"原始密码"
		if(temp.equals(u.getLpass())){//对用户输入的原始密码进行加密，比较加密后的一组密码，若相等，返回true
			f=true;
		};
		this.wirteJSON(f);
	}*/
	/**重置密码的方法*/
	public void resetPass(){
		//重置后默认密码123456
		us.setLpass(MD5Util.md5Encode("123456"));
		boolean f=ius.resetPass(us);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
	}
	
public void checkUsers(){
	System.out.println("这是检测用户已经是否存在");
	boolean flag=ius.checkUsers(us);
	this.wirteJSON(flag);
	
	
}
	

    public void ckPass(){
    	System.out.println("11111这是判断方法");
    	Users u=(Users) this.session.get("user");
    	String temp=MD5Util.md5Encode(us.getOpass());
    	System.out.println("122222222"+temp.equals(u.getLpass()));
    	this.wirteJSON(temp.equals(u.getLpass()));
    }
    
    public void updPass(){
    	Users u=(Users) this.session.get("user");
    	u.setLpass(MD5Util.md5Encode(us.getLpass()));
    	boolean flag=ius.resetpass(u);
    	Map<String,Object> mapmsg=this.getResultMsg(flag,PrintInfo.Smsg, PrintInfo.fmsg);
    	this.wirteJSON(mapmsg);
    }
    
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}

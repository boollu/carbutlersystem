package com.cbs.service.impl;

import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cbs.dao.IRoleDao;
import com.cbs.dao.IUsersDao;
import com.cbs.po.PageModel;
import com.cbs.po.Role;
import com.cbs.po.Users;
import com.cbs.service.IUsersService;
import com.cbs.util.PrintInfo;

public class UsersServiceImpl implements IUsersService {
	private IUsersDao iud;//在spring配置文件中通过ByName自动注入
	private IRoleDao ird;
	
	
	public IRoleDao getIrd() {
		return ird;
	}

	public void setIrd(IRoleDao ird) {
		this.ird = ird;
	}

	public IUsersDao getIud() {
		return iud;
	}

	public void setIud(IUsersDao iud) {
		this.iud = iud;
	}

	public Users findUsersByLogin(Users user) {
		Map<String,Object> params=new HashMap<String,Object>();
		String hql="from Users u where u.lname= :lname and u.lpass= :lpass";
		params.put("lname", user.getLname());
		params.put("lpass", user.getLpass());
		return iud.get(hql, params);
	}

	public boolean addUsers(Users user) {
		Integer rows=iud.add(user);
		if(rows>0){
			return true;
		}
		return false;
	}

	public boolean updUsers(Users user) {
		Integer rows=iud.upd(user);
		if(rows>0){
			return true;
		}
		return false;
	}

	public boolean delUsers(Users user) {
		Integer rows=iud.del(user);
		if(rows>0){
			return true;
		}
		return false;
	}

	public PageModel<Users> findPageUsers(Users user) {
		PageModel pm=new PageModel();
		//定义分页所需要的数据
		long total;
		if(user!=null){
			int page=user.getPage();
			int rows=user.getRows();
			String hql="from Users u where u.lname!=:lname";//不显示超级管理员信息
			Map<String,Object> maps=new HashMap<String, Object>();
			maps.put("lname", PrintInfo.admin);
			
			//获取总记录数
			String hql1="select count(u.id) from Users u";
			//定义模糊查询的hql
			Map<String, Object> mapc=new HashMap<String, Object>();
			if(user.getRname()!=null){
				hql+=" and u.rname like:rname";
				maps.put("rname", "%"+user.getRname()+"%");
				hql1+=" where u.rname like:rname";
				mapc.put("rname", "%"+user.getRname()+"%");
			}
			
			total=iud.count(hql1, mapc);
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<Users> ulist=iud.getAllByPage(hql, maps, rows*(page-1), rows);
			if(total==-1){//排除异常情况，避免前台因出现错误
				total=0;
			}
			//设置pm的属性值，为前台准备分页数据
			pm.setRows(ulist);
			pm.setTotal(total);
			return pm;
		}
		return null;
	}

	public boolean checkUsers(Users users) {
		String hql="from Users where lname=:lname ";
		 Map<String,Object> map=new HashMap<String, Object>();
		 map.put("lname", users.getLname());
	Users us=	iud.get(hql, map);
	if(us!=null){
		return true;    //用户存在
	}
		
		return false;
	}

	public boolean dUsers(Users user) {
		Users u=iud.get(user.getId());
		u.setIsdisable(0);//改变该用户的可用状态为禁用
		Integer row=iud.upd(u);//修改指定用户信息，返回影响行数
		if(row>0){
			return true;
		}
		return false;
	}
/**查询用户对应的角色*/
	public List<Role> findAllRole(Users user) {
		String hql="from Role";
		List<Role> rlist=ird.getAll(hql, null);
		
		return rlist;
	}

public boolean grantRole(Users user) {
	//通过id查找到对应的用户
	Users u=iud.get(user.getId());
	//获取该用户的角色属性(已选中的)
	String rids=user.getRids();
	if(rids!=null&&rids.length()>0){
		String[] rrid=rids.split(",");//获取已选中角色id对应的数组
		Set<Role> srole=new HashSet<Role>();//定义集合用于存放角色对象
		for (String rid : rrid) {
			Role r=ird.get(Integer.parseInt(rid));
			srole.add(r);
		}
		u.setRoles(srole);//设置角色集合属性
	}else{
		u.setRoles(null);
	}
	//更新该用户信息
	Integer row=iud.upd(u);
	if(row>0){
		return true;
	}
	return false;
}

public Users findUsersByLogin(String lname, String lpass) {
	Map<String,Object> params=new HashMap<String,Object>();
	String hql="from Users u where u.lname= :lname and u.lpass= :lpass";
	params.put("lname", lname);
	params.put("lpass", lpass);
	return iud.get(hql, params);
}
/**重置密码的方法*/
public boolean resetPass(Users users) {
	boolean res=false;
	Map<String,Object> params = new HashMap<String, Object>();
	
	String hql="update Users u set u.lpass=:lpass where u.id=:id";
	params.put("lpass",users.getLpass() );
	params.put("id", users.getId());
	
	if(iud.execute(hql, params)>0){
		res=true;
	}
	
	return res;
}

 public boolean resetpass(Users users) {
	if(users.getLpass()!=null){
		if(iud.upd(users)>0){
			return true;
		}
		
		
	  }
	return false;
}




}

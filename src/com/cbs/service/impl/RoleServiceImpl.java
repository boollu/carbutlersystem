package com.cbs.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.cbs.dao.IMenuDao;
import com.cbs.dao.IRoleDao;
import com.cbs.po.Menu;
import com.cbs.po.PageModel;
import com.cbs.po.Role;
import com.cbs.service.IMenuService;
import com.cbs.service.IRoleService;

public class RoleServiceImpl implements IRoleService {
  private IRoleDao ird;
  private IMenuDao imd;
  
  
  
	public IMenuDao getImd() {
	return imd;
}

public void setImd(IMenuDao imd) {
	this.imd = imd;
}

	public IRoleDao getIrd() {
	return ird;
}

public void setIrd(IRoleDao ird) {
	this.ird = ird;
}

	public PageModel<Role> findPageRole(Role role) {
		 PageModel pm=new PageModel();
		 //设置默认总记录数
		 long total;
		 if(role!=null){
			 //获取分页数据
			 int page=role.getPage();
			 int rows=role.getRows();
			 String hql="from Role";
			 List<Role> rlist=ird.getAllByPage(hql, null, rows*(page-1), rows);
		  //获取总记录数
			 String hqlcount="select count(r.id) from Role r";
			 //获取分页总记录数
			 total=ird.count(hqlcount, null);
			 if(total==-1){//若查询不到，则返回-1
				 total=0L;
			 }
			 //将封装到pm对象
			 pm.setRows(rlist);
			 pm.setTotal(total);
		 }
		 //返回pm对象
		return pm;
	}
/**添加角色*/
	public boolean addRole(Role role) {
		boolean flag=false;
		Integer row=ird.add(role);
		if(row>0){
			flag=true;
		}
		return flag;
	}
	/**修改角色*/
	public boolean updRole(Role role) {
		boolean flag=false;
		Integer row=ird.upd(role);
		if(row>0){
			flag=true;
		}
		return flag;
	}
	/**删除角色*/
	public boolean delRole(Role role) {
		boolean flag=false;
		Integer row=ird.del(role);
		if(row>0){
			flag=true;
		}
		return flag;
	}
	/**
	 * 通过id查询角色
	 * */
	public Role get(Integer rid) {
		
		return ird.get(rid);
	}
	/**
	 *角色授权
	 * */
	public boolean grantRole(Role role) {
		//通过传递过来的角色id查找角色
		Role r=ird.get(role.getId());
		//得到传递过来的所有菜单id
		String strmids=role.getMids();
		if(strmids!=null&&strmids.length()>0){
			//切割得到的mids
			String[] mids=strmids.split(",");
			//创建set集合用于存放选中的选中的menu对象
			Set<Menu> mset=new HashSet<Menu>(); 
			for (String mid : mids) {
				Menu m=imd.get(mid);//遍历集合，通过id获取对应的menu对象
				mset.add(m);
			}
			r.setMenus(mset);//设置该角色对象的set集合属性值
			//更新该角色信息
			Integer num=ird.upd(r);
			if(num>0){
				return true;
			}
			//若无角色对应的菜单,设置空值
			r.setMenus(null);
			//更新该角色信息
			Integer num1=ird.upd(r);
			if(num1>0){
				return true;
			}
		}
		return false;
	}

}

package com.cbs.service;

import java.util.List;

import com.cbs.po.PageModel;
import com.cbs.po.Role;
import com.cbs.po.Users;

public interface IUsersService {
/**登录方法*/
	public Users findUsersByLogin(Users user);
	public Users findUsersByLogin(String lname,String lpass);
	/**添加用户*/
	public boolean addUsers(Users user);
	/**修改用户*/
	public boolean updUsers(Users user);
	/**删除用户*/
	public boolean delUsers(Users user);
	/**伪删除（改变该用户状态为禁用）*/
	public boolean dUsers(Users user);
	/**添加时判断用户名是否存在的方法*/
	public boolean checkUsers(Users user);
	/**分页查找*/
	public PageModel<Users> findPageUsers(Users user);
	/**查询指定用户对应的所有角色*/
	public List<Role> findAllRole(Users user);
	/**给用户指派角色*/
	public boolean grantRole(Users user);
	/**重置密码的方法*/
	public boolean resetPass(Users users);
	public boolean resetpass(Users users);
}

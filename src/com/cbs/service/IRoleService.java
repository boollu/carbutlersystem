package com.cbs.service;

import com.cbs.po.PageModel;
import com.cbs.po.Role;

public interface IRoleService {
/**
 * 分页的查询所有
 * */
	public PageModel<Role> findPageRole(Role role);
	/**
	 * 添加角色
	 * */
	public boolean addRole(Role role);
	/**
	 * 修改角色
	 * */
	public boolean updRole(Role role);
	/**
	 * 删除角色
	 * */
	public boolean delRole(Role role);
	/**
	 * 通过id查询角色
	 * */
	public Role get(Integer rid);
	/**
	 * 角色授权
	 * */
	public boolean grantRole(Role role);
	
}

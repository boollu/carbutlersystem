package com.cbs.service;

import java.util.List;

import com.cbs.po.Menu;

public interface IMenuService {
 /**
  * 给前台准备菜单树的方法
  * */
	public List<Menu> findAllMenu();
}

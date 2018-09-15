package com.cbs.service.impl;

import java.util.List;

import com.cbs.dao.IMenuDao;
import com.cbs.po.Menu;
import com.cbs.service.IMenuService;

public class MenuServiceImpl implements IMenuService {
   private IMenuDao imd;
   
	public IMenuDao getImd() {
	return imd;
}

public void setImd(IMenuDao imd) {
	this.imd = imd;
}

	public List<Menu> findAllMenu() {
		String hql="from Menu";
		List<Menu> mlist=imd.getAll(hql, null);
		return mlist;
	}

	
}

package com.cbs.service;

import java.util.List;

import com.cbs.po.PageModel;
import com.cbs.po.RefuelRec;

public interface IRefuelRecService {
	/**
	 * 视图
	 * */
	public PageModel<RefuelRec> findrefDG(RefuelRec ref);
	/**
	 * 增加加油记录
	 * */
	public boolean add(RefuelRec ref);
	/**
	 * 编辑加油记录
	 * */
	public boolean upd(RefuelRec ref);
	/**
	 * 删除加油记录
	 * */
	public boolean del(RefuelRec ref);
	/**
	 * 查找加油记录
	 * */
	public RefuelRec findbyid(RefuelRec ref);
	
	/**
	 * 查看所有加油记录
	 * */
	public List<RefuelRec> findAll();

}

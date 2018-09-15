package com.cbs.service;

import com.cbs.po.FeesManager;
import com.cbs.po.PageModel;

public interface IFeesManagerService {
	public boolean add(FeesManager fee);//增加
	public boolean del(FeesManager fee);//删除
	public boolean upd(FeesManager fee);//修改
	public FeesManager findById(Integer id);//根据id查找对象
	public PageModel<FeesManager> findIRDG(FeesManager fee);//获取分页结果集
}

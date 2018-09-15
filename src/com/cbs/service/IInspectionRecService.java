package com.cbs.service;

import com.cbs.dao.IInspectionRecDao;
import com.cbs.po.InspectionRec;
import com.cbs.po.*;

public interface IInspectionRecService {
	public boolean add(InspectionRec ip);//增加
	public boolean del(InspectionRec ip);//删除
	public boolean upd(InspectionRec ip);//修改
	public InspectionRec findById(Integer id);//根据id查找对象
	public PageModel<InspectionRec> findIRDG(InspectionRec ip);//获取分页结果集
	
}

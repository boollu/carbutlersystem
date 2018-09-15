package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IRefuelRecDao;
import com.cbs.po.AccidentRec;
import com.cbs.po.PageModel;
import com.cbs.po.RefuelRec;
import com.cbs.service.IRefuelRecService;

public class RefuelRecServiceimpl implements IRefuelRecService{

	private IRefuelRecDao irefuelrecd;
	public IRefuelRecDao getIrefuelrecd() {
		return irefuelrecd;
	}

	public void setIrefuelrecd(IRefuelRecDao irefuelrecd) {
		this.irefuelrecd = irefuelrecd;
	}

	public PageModel<RefuelRec> findrefDG(RefuelRec ref) {
		System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
		PageModel<RefuelRec> pm=new PageModel<RefuelRec>();
		String hql =" from RefuelRec ref where 1=1 ";
		String counthql ="select count(*) from RefuelRec ref where 1=1 ";
		Long total;
		Map<String,Object> params=new HashMap<String, Object>();
		Map<String,Object> countparms=new HashMap<String, Object>();
		if(ref!=null){
			int page =ref.getPage();
			int rows=ref.getRows();
			if(ref.getCar()!=null){
				hql+=" and ref.car.carNo like:carNo";
				counthql+=" and ref.car.carNo like:carNo";
				params.put("carNo" , "%"+ref.getCar().getCarNo()+"%");
				countparms.put("carNo" ,"%"+ref.getCar().getCarNo()+"%");
			}
			
		total=	irefuelrecd.count(counthql, countparms);
		System.out.println("测试家哟"+total);
        if(total==-1){
			total=0l;
		}
		List<RefuelRec> re=irefuelrecd.getAllByPage(hql, params, (page-1)*rows, rows);
		pm.setRows(re);
		pm.setTotal(total);
		}
		
		return pm;
	}

	public boolean add(RefuelRec ref) {
		boolean flag=false;
		int a=irefuelrecd.add(ref);
		if(a>0){ 
			flag=true;
				}
		return  flag;
	}

	public boolean upd(RefuelRec ref) {
		boolean flag=false;
		int a=irefuelrecd.upd(ref);
		if(a>0){ 
			flag=true;
				}
		return  flag;
	}
	public boolean del(RefuelRec ref) {
		boolean flag=false;
		int a=irefuelrecd.del(ref);
		if(a>0){ 
			flag=true;
				}
		return  flag;
	}

	public RefuelRec findbyid(RefuelRec ref) {
		
		return irefuelrecd.get(ref.getId());
	}

	public List<RefuelRec> findAll() {
		String hql =" from RefuelRec ref where 1=1 ";
		return irefuelrecd.getAll(hql, null);
	}

}

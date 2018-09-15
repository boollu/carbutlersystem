package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IAccidentRecDao;
import com.cbs.po.AccidentRec;
import com.cbs.po.InspectionRec;
import com.cbs.po.PageModel;
import com.cbs.service.IAccidentRecService;

public class AccidentRecServiceImpl implements IAccidentRecService {
    private IAccidentRecDao iaccidentrecd;
    
	public IAccidentRecDao getIaccidentrecd() {
		return iaccidentrecd;
	}

	public void setIaccidentrecd(IAccidentRecDao iaccidentrecd) {
		this.iaccidentrecd = iaccidentrecd;
	}

	public boolean add(AccidentRec acc) {
		boolean f=false;
		if(iaccidentrecd.add(acc)>0){
			f=true;
		}
		return f;
	}

	public boolean updd(AccidentRec acc) {
		boolean f=false;
		if(iaccidentrecd.upd(acc)>0){
			f=true;
		}
		return f;
	}

	public boolean del(AccidentRec acc) {
		boolean f=false;
		if(iaccidentrecd.del(acc)>0){
			f=true;
		}
		return f;
	}

	public AccidentRec findAById(Integer id) {
		String hql="from AccidentRec acc where acc.id =:id";
		Map<String,Object> maps=new HashMap<String,Object>();
		maps.put("id", id);
		return iaccidentrecd.get(hql, maps);
	}

	public PageModel<AccidentRec> findARDG(AccidentRec acc) {
		PageModel<AccidentRec> pm=new PageModel<AccidentRec>();
		String hql="from AccidentRec acc where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(acc.id) from AccidentRec acc";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(acc!=null){
			int page=acc.getPage();
			int rows=acc.getRows();
			if(acc.getCar()!=null&&acc.getCar().getCarNo()!=null){
				hql+=" and acc.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps.put("carNo", "%"+acc.getCar().getCarNo()+"%");
				
				hql1+=" where acc.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+acc.getCar().getCarNo()+"%");
			}
			total=iaccidentrecd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<AccidentRec> acclist=iaccidentrecd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(acclist);
			pm.setTotal(total);
		}
				
		return pm;
	}

}

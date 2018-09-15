package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IInspectionRecDao;
import com.cbs.po.InspectionRec;
import com.cbs.po.InsuranceRec;
import com.cbs.po.PageModel;
import com.cbs.service.IInspectionRecService;

public class InspectionRecServiceImpl implements IInspectionRecService {
    private IInspectionRecDao iinspectionrecd;
    
	public IInspectionRecDao getIinspectionrecd() {
		return iinspectionrecd;
	}

	public void setIinspectionrecd(IInspectionRecDao iinspectionrecd) {
		this.iinspectionrecd = iinspectionrecd;
	}

	public boolean add(InspectionRec ip) {
		boolean f=false;
			if(iinspectionrecd.add(ip)>0){
				f=true;
			}	
		return f;
	}

	public boolean del(InspectionRec ip) {
		boolean f=false;
		if(iinspectionrecd.del(ip)>0){
			f=true;
		}	
	return f;
	}

	public boolean upd(InspectionRec ip) {
		boolean f=false;
		if(iinspectionrecd.upd(ip)>0){
			f=true;
		}	
	return f;
	}

	public InspectionRec findById(Integer id) {
		
		return iinspectionrecd.get(id);
	}

	public PageModel<InspectionRec> findIRDG(InspectionRec ip) {
		PageModel<InspectionRec> pm=new PageModel<InspectionRec>();
		String hql="from InspectionRec ip where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(ip.id) from InspectionRec ip";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(ip!=null){
			int page=ip.getPage();
			int rows=ip.getRows();
			if(ip.getCar()!=null&&ip.getCar().getCarNo()!=null){
				hql+=" and ip.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps.put("carNo", "%"+ip.getCar().getCarNo()+"%");
				
				hql1+=" where ip.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+ip.getCar().getCarNo()+"%");
			}
			total=iinspectionrecd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			hql+=" order by ip.expireDate desc";//按保险到期日期降序排列记录
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<InspectionRec> iplist=iinspectionrecd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(iplist);
			pm.setTotal(total);
		}
				
		return pm;
	}


}

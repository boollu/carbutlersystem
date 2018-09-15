package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IFeesManagerDao;
import com.cbs.po.FeesManager;
import com.cbs.po.InsuranceRec;
import com.cbs.po.PageModel;
import com.cbs.service.IFeesManagerService;

public class FeesManagerServiceImpl implements IFeesManagerService {
    private IFeesManagerDao ifeesmanagerd;
    
	public IFeesManagerDao getIfeesmanagerd() {
		return ifeesmanagerd;
	}

	public void setIfeesmanagerd(IFeesManagerDao ifeesmanagerd) {
		this.ifeesmanagerd = ifeesmanagerd;
	}

	public boolean add(FeesManager fee) {
		if(ifeesmanagerd.add(fee)>0){
			return true;
		}
		return false;
	}

	public boolean del(FeesManager fee) {
		if(ifeesmanagerd.del(fee)>0){
			return true;
		}
		return false;
	}

	public boolean upd(FeesManager fee) {
		if(ifeesmanagerd.upd(fee)>0){
			return true;
		}
		return false;
	}

	public FeesManager findById(Integer id) {
		String hql="from FeesManager fee where fee.id =:id";
		Map<String,Object> maps=new HashMap<String,Object>();
		maps.put("id", id);
		return ifeesmanagerd.get(hql, maps);
	}

	public PageModel<FeesManager> findIRDG(FeesManager fee) {
		PageModel<FeesManager> pm=new PageModel<FeesManager>();
		String hql="from FeesManager fee where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(fee.id) from FeesManager fee";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(fee!=null){
			int page=fee.getPage();
			int rows=fee.getRows();
			if(fee.getCar()!=null&&fee.getCar().getCarNo()!=null){
				hql+=" and fee.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps.put("carNo", "%"+fee.getCar().getCarNo()+"%");
				
				hql1+=" where fee.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+fee.getCar().getCarNo()+"%");
			}
			total=ifeesmanagerd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			//hql+=" order by ir.expireDate desc";//按日期降序排列记录
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<FeesManager> irlist=ifeesmanagerd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(irlist);
			pm.setTotal(total);
		}
				
		return pm;
	}

}

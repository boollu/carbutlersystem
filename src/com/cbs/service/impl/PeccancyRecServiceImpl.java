package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IPeccancyRecDao;
import com.cbs.po.PageModel;
import com.cbs.po.PeccancyRec;
import com.cbs.service.IPeccancyRecService;


public class PeccancyRecServiceImpl implements IPeccancyRecService {
    private IPeccancyRecDao ipeccancyrecd;
    
    
	public IPeccancyRecDao getIpeccancyrecd() {
		return ipeccancyrecd;
	}

	public void setIpeccancyrecd(IPeccancyRecDao ipeccancyrecd) {
		this.ipeccancyrecd = ipeccancyrecd;
	}

	public boolean add(PeccancyRec pecc) {
		boolean f=false;
		if(ipeccancyrecd.add(pecc)>0){
			f=true;
		}
		return f;
	}

	public boolean del(PeccancyRec pecc) {
		boolean f=false;
		if(ipeccancyrecd.del(pecc)>0){
			f=true;
		}
		return f;
	}

	public boolean upd(PeccancyRec pecc) {
		boolean f=false;
		if(ipeccancyrecd.upd(pecc)>0){
			f=true;
		}
		return f;
	}

	public PeccancyRec findById(Integer id) {
		String hql="from PeccancyRec pecc where pecc.id =:id";
		Map<String,Object> maps=new HashMap<String,Object>();
		maps.put("id", id);
		return ipeccancyrecd.get(hql, maps);
	}

	public PageModel<PeccancyRec> findPRDG(PeccancyRec pecc) {
		PageModel<PeccancyRec> pm=new PageModel<PeccancyRec>();
		String hql="from PeccancyRec pecc where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(pecc.id) from PeccancyRec pecc";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(pecc!=null){
			int page=pecc.getPage();
			int rows=pecc.getRows();
			if(pecc.getCar()!=null&&pecc.getCar().getCarNo()!=null){
				hql+=" and pecc.car.carNo like :carNo";//按车牌号码模糊查询保险记
				maps.put("carNo", "%"+pecc.getCar().getCarNo()+"%");
				
				hql1+=" where pecc.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+pecc.getCar().getCarNo()+"%");
			}
			total=ipeccancyrecd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<PeccancyRec> pecclist=ipeccancyrecd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(pecclist);
			pm.setTotal(total);
		}
				
		return pm;
	}

}

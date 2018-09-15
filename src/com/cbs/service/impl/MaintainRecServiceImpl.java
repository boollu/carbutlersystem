package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IMaintainRecDao;
import com.cbs.po.InsuranceRec;
import com.cbs.po.MaintainRec;
import com.cbs.po.PageModel;
import com.cbs.service.IMaintainRecService;

public class MaintainRecServiceImpl implements IMaintainRecService {
    private IMaintainRecDao imaintainrecd;
    
	public IMaintainRecDao getImaintainrecd() {
		return imaintainrecd;
	}

	public void setImaintainrecd(IMaintainRecDao imaintainrecd) {
		this.imaintainrecd = imaintainrecd;
	}

	public boolean add(MaintainRec ma) {
		System.out.println("111111111111111111111");
		boolean f=false;
		if(imaintainrecd.add(ma)>0){
			f=true;
		}
		return f;
	}

	public boolean del(MaintainRec ma) {
		boolean f=false;
		if(imaintainrecd.del(ma)>0){
			f=true;
		}
		return f;
	}

	public boolean upd(MaintainRec ma) {
		boolean f=false;
		if(imaintainrecd.upd(ma)>0){
			f=true;
		}
		return f;
	}

	public MaintainRec findById(Integer id) {
		String hql="from MaintainRec ma where ma.id =:id";
		Map<String,Object> maps=new HashMap<String,Object>();
		maps.put("id",id);
		return imaintainrecd.get(hql, maps);
	}

	public PageModel<MaintainRec> findMRDG(MaintainRec ma) {
		PageModel<MaintainRec> pm=new PageModel<MaintainRec>();
		String hql="from MaintainRec ma where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(ma.id) from MaintainRec ma";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(ma!=null){
			int page=ma.getPage();
			int rows=ma.getRows();
			if(ma.getCar()!=null&&ma.getCar().getCarNo()!=null){
				hql+=" and ma.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps.put("carNo", "%"+ma.getCar().getCarNo()+"%");
				
				hql1+=" where ma.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+ma.getCar().getCarNo()+"%");
			}
			total=imaintainrecd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			hql+=" order by ma.nextDate desc";//按保险到期日期降序排列记录
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<MaintainRec> irlist=imaintainrecd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(irlist);
			pm.setTotal(total);
		}
				
		return pm;
	}

}

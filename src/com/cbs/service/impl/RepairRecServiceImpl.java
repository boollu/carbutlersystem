package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.ICarDao;
import com.cbs.dao.IRepairRecDao;
import com.cbs.po.FeesManager;
import com.cbs.po.PageModel;
import com.cbs.po.RepairRec;
import com.cbs.service.IRepairRecService;

public class RepairRecServiceImpl implements IRepairRecService {
    private IRepairRecDao irepairrecd;
    private ICarDao icard;
    
    
	public ICarDao getIcard() {
		return icard;
	}

	public void setIcard(ICarDao icard) {
		this.icard = icard;
	}

	public IRepairRecDao getIrepairrecd() {
		return irepairrecd;
	}

	public void setIrepairrecd(IRepairRecDao irepairrecd) {
		this.irepairrecd = irepairrecd;
	}

	public boolean add(RepairRec rep) {
		boolean res=false;
		Map<String,Object> params =new HashMap<String,Object>();
		
		if(irepairrecd.add(rep)>0){
			//修改车辆为3维修状态
			String hql="update Car c set c.carState=3 where c.id=:carid";
			params.put("carid", rep.getCar().getId());
			if(irepairrecd.execute(hql, params)>0){
				res=true;
			}
		}
		
		return res;
	}

	public boolean upd(RepairRec rep) {
		if(irepairrecd.upd(rep)>0){
			return true;
		}
		return false;
	}

	public boolean del(RepairRec rep) {
		boolean res=false;
		int i=0;
		
		RepairRec rr=irepairrecd.get(rep.getId());
		
		if(rr !=null){			
			
			if(irepairrecd.del(rr)>0){
				//如果删除的是未取车信息，则修改车辆信息为可用
				if(rr.getGetTime() ==null){
					//条件容器
					Map<String,Object> params =new HashMap<String,Object>();
					//修改车辆为可用状态
					String hql="update Car c set c.carState=1 where c.id=:carid";
					params.put("carid", rr.getCar().getId());
					
					i=icard.execute(hql, params);
					if(i>0){
						return true;
					}
				}				
				res=true;
			}
		}
		
		return res;
	}

	public PageModel<RepairRec> findRRDG(RepairRec rep) {
		PageModel<RepairRec> pm=new PageModel<RepairRec>();
		String hql="from RepairRec rep where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(rep.id) from RepairRec rep";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(rep!=null){
			int page=rep.getPage();
			int rows=rep.getRows();
			if(rep.getCar()!=null&&rep.getCar().getCarNo()!=null){
				hql+=" and rep.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps.put("carNo", "%"+rep.getCar().getCarNo()+"%");
				
				hql1+=" where rep.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+rep.getCar().getCarNo()+"%");
			}
			total=irepairrecd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			//hql+=" order by ir.expireDate desc";//按日期降序排列记录
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<RepairRec> irlist=irepairrecd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(irlist);
			pm.setTotal(total);
		}
				
		return pm;
	}

	public RepairRec findRRById(Integer id) {
		String hql="from RepairRec rep where rep.id =:id";
		Map<String,Object> maps=new HashMap<String,Object>();
		maps.put("id", id);
		return irepairrecd.get(hql, maps);
	}
/**维修后回车方法*/
	public boolean backRepRec(RepairRec rr) {
		boolean res=false;
		Map<String,Object> params1 =new HashMap<String,Object>();
		Map<String,Object> params2 =new HashMap<String,Object>();
		
		String hql1="update RepairRec rr " +
				"set rr.repType.id=:repType, " +
				"rr.getTime=:getTime, " +
				"rr.repCost=:repCost, " +
				"rr.repOption=:repOption, " +
				"rr.useStuff=:useStuff, " +
				"rr.getRemarks=:getRemarks " +
				"where rr.id=:id ";
		
		params1.put("repType", rr.getRepType().getId());
		params1.put("getTime", rr.getGetTime());
		params1.put("repCost", rr.getRepCost());
		params1.put("repOption", rr.getRepOption());
		params1.put("useStuff", rr.getUseStuff());
		params1.put("getRemarks", rr.getGetRemarks());
		params1.put("id", rr.getId());
		
		if(irepairrecd.execute(hql1, params1)>0){
			//修改车辆为可用状态
			String hql2="update Car c set c.carState=1 where c.id=:carid";
			params2.put("carid", rr.getCar().getId());
			if(icard.execute(hql2, params2)>0){
				res=true;
			}
		}
		
		return res;
	}
}

package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.ICarDao;
import com.cbs.dao.IDriverDao;
import com.cbs.dao.IDrivingRecDao;
import com.cbs.po.DrivingRec;
import com.cbs.po.PageModel;
import com.cbs.po.Users;
import com.cbs.service.IDrivingRecService;
import com.cbs.util.PrintInfo;

public class DrivingRecServiceImpl implements IDrivingRecService {
	private IDrivingRecDao idrirecd;
	private ICarDao icard;
	private IDriverDao idrid;
	
	
	
public IDrivingRecDao getIdrirecd() {
		return idrirecd;
	}

	public void setIdrirecd(IDrivingRecDao idrirecd) {
		this.idrirecd = idrirecd;
	}

	public ICarDao getIcard() {
		return icard;
	}

	public void setIcard(ICarDao icard) {
		this.icard = icard;
	}

	public IDriverDao getIdrid() {
		return idrid;
	}

	public void setIdrid(IDriverDao idrid) {
		this.idrid = idrid;
	}

/**查询总记录，参数为具体用户对象和记录实体*/
	public Long findDRCount(DrivingRec dr, Users users) {
		Map<String,Object> params =new HashMap<String,Object>();
		String hql="select count(dr.id) from DrivingRec where 1=1";
		//非管理员仅有权限看自己的记录
		if(!users.getLname().equals(PrintInfo.admin)){
			hql+=" and dr.creater.id=:uid";//限制条件
			params.put("uid",users.getId());
		}
		if(dr.getBacktime()==null){//回车时间为空，说明已出车，则该车不可用
			hql+=" and dr.backtime is null";
		}
		if(dr.getCar()!=null&&dr.getCar().getCarNo()!=null){
			hql+=" and dr.car.carNo=:carNo";
			params.put("carNo", dr.getCar().getCarNo());
		}
		return idrirecd.count(hql, params);
		//return idrirecd.count(hql, null);
	}

	public PageModel<DrivingRec> findDRDG(DrivingRec dr, Users users) {
		PageModel<DrivingRec> pm=new PageModel<DrivingRec>();
		Map<String,Object> params =new HashMap<String,Object>();
		long total=0L;
		String hql="from DrivingRec dr where 1=1";
		String hql1="select count(dr.id) from DrivingRec dr where 1=1";
		Map<String,Object> params1 =new HashMap<String,Object>();
		if(dr!=null){
			int page=dr.getPage();
			int rows=dr.getRows();
			
			//如果是管理员，可以看到所有的出车记录，否则仅有权限看自己的记录
			if(!(users.getLname().equals(PrintInfo.admin))){
				hql+=" and dr.creater.id=:uid";//限制条件
				hql1+=" and dr.creater.id=:uid";//限制条件
				params.put("uid",users.getId());
				params1.put("uid",users.getId());
				
			}
			
			if(dr.getCar()!=null&&dr.getCar().getCarNo()!=null){
				hql+=" and dr.car.carNo like :carNo";
				hql1+=" and dr.car.carNo like :carNo";
				params.put("carNo", "%"+dr.getCar().getCarNo()+"%");
				params1.put("carNo", "%"+dr.getCar().getCarNo()+"%");
			}
			List<DrivingRec> drirec=idrirecd.getAllByPage(hql, params, rows*(page-1), rows);
			total=idrirecd.count(hql1, params1);
		    System.out.println("总记录数为："+total);
		    if(total==-1){
		    	total=0L;
		    }
		    pm.setRows(drirec);
		    pm.setTotal(total);
		}
	
		return pm;
	}
	public DrivingRec findDRById(int id) {
		return idrirecd.get(id);
	}
	/**添加出车记录*/
	public boolean addDR(DrivingRec dr) {
		Map<String,Object> maps1 =new HashMap<String,Object>();
		Map<String,Object> maps2 =new HashMap<String,Object>();
		if(idrirecd.add(dr)>0){//如果添加出车记录成功,需要修改对应的车辆状态和司机状态
			String hql1="update Car c set c.carState=2 where c.id=:carid";//车辆状态：1-可用；2-出车；3-维修；4-其他
		    maps1.put("carid", dr.getCar().getId());//修改对应的车辆信息为-出车
		
		  //修改对应的驾驶员为禁用状态
			String hql2="update Driver d set d.isdisable=0 where d.id=:driverid";
			maps2.put("driverid", dr.getDriver().getId());
			if((icard.execute(hql1, maps1)+idrid.execute(hql2, maps2))>1){//若两个修改都成功
				
				return true;
			}
		}
		return false;
	}
	
/****修改*/
	public boolean updDR(DrivingRec dr) {
		if(idrirecd.upd(dr)>0){
			return true;
		}
		return false;
	}

	public boolean backDR(DrivingRec dr) {
		Map<String,Object> maps1 =new HashMap<String,Object>();
		Map<String,Object> maps2 =new HashMap<String,Object>();
		//if(idrirecd.add(dr)>0){//如果添加出车记录成功,需要修改对应的车辆状态和司机状态
			String hql1="update Car c set c.carState=1 where c.id=:carid";//车辆状态：1-可用；2-出车；3-维修；4-其他
		    maps1.put("carid", dr.getCar().getId());//修改对应的车辆信息为-可用
		
		  //修改对应的驾驶员为可用状态
			String hql2="update Driver d set d.isdisable=1 where d.id=:driverid";
			maps2.put("driverid", dr.getDriver().getId());
			if((icard.execute(hql1, maps1)+idrid.execute(hql2, maps2))>1){//若两个修改都成功
				return true;
			}
		//}
		return false;
	}

	public boolean delDR(int id) {
		boolean res=false;
		Map<String,Object> params1 =new HashMap<String,Object>();
		Map<String,Object> params2 =new HashMap<String,Object>();
		
		DrivingRec dr=idrirecd.get(id);
		
		if(dr !=null){
			//如果删除的是未回车状态的出车信息，需要同时更新车辆信息和驾驶员信息
			if(dr.getBacktime() == null){
				//修改为可用状态
				String hql1="update Car c set c.carState=1 where c.id=:carid";
				params1.put("carid", dr.getCar().getId());
				int i=icard.execute(hql1, params1);
				
				String hql2="update Driver d set d.isdisable=1 where d.id=:did";
				params2.put("did", dr.getDriver().getId());
				int j=icard.execute(hql2, params2);
			}
			
			if(idrirecd.del(dr)>0){
				res=true;
			}
		}
		
		return res;
}


}

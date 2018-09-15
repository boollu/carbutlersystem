package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.ICarDao;
import com.cbs.dao.ICarPicDao;
import com.cbs.po.Car;
import com.cbs.po.CarPic;
import com.cbs.po.Driver;
import com.cbs.po.PageModel;
import com.cbs.service.ICarService;

public class CarServiceImpl implements ICarService {
    private ICarDao icard;
    private ICarPicDao icarpicd;
    
	public ICarDao getIcard() {
		return icard;
	}

	public void setIcard(ICarDao icard) {
		this.icard = icard;
	}

	public ICarPicDao getIcarpicd() {
		return icarpicd;
	}

	public void setIcarpicd(ICarPicDao icarpicd) {
		this.icarpicd = icarpicd;
	}
//具体方法
	/**查询车辆总数*/
	public Long findCarCount(Car car) {
		Map<String,Object> maps=new HashMap<String, Object>();
		String hql="select count(c.id) from Car c where 1=1";
		if(car.getCarNo()!=null){
			hql+=" and c.carNo like :carno";
			maps.put("carno", car.getCarNo());
		}
		return icard.count(hql, maps);
	}
/**获取分页模型*/
	public PageModel<Car> findCarDG(Car car) {
		long total=0L;
		PageModel<Car> pm=new PageModel<Car>();
		if(car!=null){
		int page=car.getPage();
		int rows=car.getRows();
		Map<String,Object> maps=new HashMap<String, Object>();
		String hql="from Car c";
		//获取总记录数
		String hql1="select count(*) from Car c";
		//定义模糊查询的hql
		Map<String, Object> mapc=new HashMap<String, Object>();
		if(car.getCarNo()!=null){
			
			hql+=" where c.carNo like :carno";
			maps.put("carno", "%"+car.getCarNo()+"%");
			hql1+=" where c.carNo like :carno";
			mapc.put("carno", "%"+car.getCarNo()+"%");
		}
		total=icard.count(hql1, mapc);
		//获取hibernate中分页集合，为前台easyui准备属性值
		List<Car> clist=icard.getAllByPage(hql, maps, rows*(page-1), rows);
		if(total==-1){//排除异常情况，避免前台因出现错误
			total=0L;
		}
		//设置pm的属性值，为前台准备分页数据
		pm.setRows(clist);
		pm.setTotal(total);
	}
		return pm;
	}
	/**通过id寻找对应的车辆信息*/
	public Car findCarById(Integer id) {
		return icard.get(id);
		
	}
/**添加车辆信息*/
	public boolean addCar(Car car) {
		boolean f=false;
		if(icard.add(car)>0){
			return true;
		}
		return false;
	}
/**修改车辆信息*/
	public boolean updCar(Car car) {
		boolean f=false;
		Map<String, Object> mapc=new HashMap<String, Object>();
		String hql="update Car c set c.carBrand=:carBrand,"+
		                            "c.Model.id=:carModel,"+
				                    "c.carColor=:carColor,"+
		                            "c.carSeats=:carSeats,"+
				                    "c.oilWear=:oilWeal,"+
		                            "c.initMil=:initMil"+
				                    "c.maintainMil=:maintainMil,"+
		                            "c.maintainPeriod=:maintainPeriod,"+
				                    "c.engineNum=:engineNum,"+
		                            "c.frameNum=:frameNum,"+
				                    "c.sup.id=:sup,"+
				                    "c.purchasePrice=:purchasePrice,"+
		                            "c.purchaseDate=:purchaseDate,"+
				                    "c.dept.id=:dept,"+
		                            "c.carState=:carState,"+
				                    "c.remarks=:remarks,"+
		                            "c.isdisable=:isdisable "+
				                    "where c.id=:id";
		mapc.put("carBrand", car.getCarBrand().getId());
		mapc.put("carModel", car.getCarModel().getId());
		mapc.put("carColor", car.getCarColor());
		mapc.put("carSeats", car.getCarSeats());
		mapc.put("oilWear", car.getOilWear());
		mapc.put("initMil", car.getInitMil());
		mapc.put("maintainMil", car.getMaintainMil());
		mapc.put("maintainPeriod", car.getMaintainPeriod());
		mapc.put("engineNum", car.getEngineNum());
		mapc.put("frameNum", car.getFrameNum());
		mapc.put("sup", car.getSup().getId());
		mapc.put("purchasePrice", car.getPurchasePrice());
		mapc.put("purchaseDate", car.getPurchaseDate());
		mapc.put("dept", car.getDept().getId());
		mapc.put("carState", car.getCarState());
		mapc.put("remarks", car.getRemarks());
		mapc.put("isdisable", car.getIsdisable());
		mapc.put("id", car.getDept().getId());
		mapc.put("dept", car.getId());
		
		if(icard.execute(hql, mapc)>0){
			f=true;
		}
		return f;
	}
/**删除车辆信息*/
	public boolean delCar(Integer id) {
		Car c=icard.get(id);
		c.setIsdisable(0);
		if(icard.upd(c)>0){
			return true;
		}
		return false;
	}
/**删除车辆对应的图片信息（参数为车辆id）*/
	public boolean delCarPic(Integer cid) {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean delCarPicById(int carPicId, String carPicPath) {
		// TODO Auto-generated method stub
		return false;
	}
/**查询所有可用的车辆*/
	public List<Car> findCarList(int state, int isdisable) {
		Map<String, Object> mapc=new HashMap<String, Object>();
		String hql="from Car c where 1=1";
		if(state!=-1){
			hql+=" and c.carState=:carS";
			mapc.put("carS", state);
		}
		if(isdisable!=-1){
			hql+=" and c.isdisable=:isdisable";
			mapc.put("isdisable", isdisable);
		}
		return icard.getAll(hql, mapc);
	}

	public boolean updCarPic(CarPic cp) {
		// TODO Auto-generated method stub
		return false;
	}

	public List<CarPic> findCarPicList(int id) {
		// TODO Auto-generated method stub
		return null;
	}

	public boolean addCarPic(Car car) {
		// TODO Auto-generated method stub
		return false;
	}
/***/
	public int findCarNo(String carNo) {
		Map<String, Object> mapc=new HashMap<String, Object>();
		String hql="select count(c.id) from Car c where c.carNo=:carNo ";
		mapc.put("carNo", carNo);
		return icard.count(hql, mapc).intValue();
	}

}

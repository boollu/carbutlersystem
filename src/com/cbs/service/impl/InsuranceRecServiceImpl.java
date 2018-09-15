package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IInsuranceRecDao;
import com.cbs.po.Car;
import com.cbs.po.InsuranceRec;
import com.cbs.po.PageModel;
import com.cbs.service.IInsuranceRecService;

public class InsuranceRecServiceImpl implements IInsuranceRecService {
	private IInsuranceRecDao  iinsurancerecd;
	
	
	public IInsuranceRecDao getIinsurancerecd() {
		return iinsurancerecd;
	}

	public void setIinsurancerecd(IInsuranceRecDao iinsurancerecd) {
		this.iinsurancerecd = iinsurancerecd;
	}

	public PageModel<InsuranceRec> findIRDG(InsuranceRec ir) {
		PageModel<InsuranceRec> pm=new PageModel<InsuranceRec>();
		String hql="from InsuranceRec ir where 1=1";
		Map<String,Object> maps=new HashMap<String,Object>();
		
		String hql1="select count(ir.id) from InsuranceRec ir";
		Map<String,Object> maps1=new HashMap<String,Object>();
		long total=0L;
		if(ir!=null){
			int page=ir.getPage();
			int rows=ir.getRows();
			if(ir.getCar()!=null&&ir.getCar().getCarNo()!=null){
				hql+=" and ir.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps.put("carNo", "%"+ir.getCar().getCarNo()+"%");
				
				hql1+=" where ir.car.carNo like :carNo";//按车牌号码模糊查询保险记录
				maps1.put("carNo", "%"+ir.getCar().getCarNo()+"%");
			}
			total=iinsurancerecd.count(hql1, maps1);
			if(total==-1){
				total=0L;
			}
			hql+=" order by ir.expireDate desc";//按保险到期日期降序排列记录
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<InsuranceRec> irlist=iinsurancerecd.getAllByPage(hql, maps, rows*(page-1), rows);
		    //设置pm对象的属性值，构造出pm对象
			pm.setRows(irlist);
			pm.setTotal(total);
		}
				
		return pm;
	}

	public Long findIRCount(InsuranceRec ir) {
		return null;
	}

	public InsuranceRec findIRById(int id) {
		
		return iinsurancerecd.get(id);
	}

	public boolean addIR(InsuranceRec ir) {
		boolean f=false;
		if(iinsurancerecd.add(ir)>0){
			f=true;
		}
		return f;
	}

	public boolean updIR(InsuranceRec ir) {
		boolean f=false;
		if(iinsurancerecd.upd(ir)>0){
			f=true;
		}
		return f;
	}

	/*public boolean delIR(int id) {
		Map<String,Object> maps=new HashMap<String,Object>();
		String hql="delete from InsuranceRec ir where ir.id=:id";
		maps.put("id", id);
		if(iinsurancerecd.execute(hql, maps)>0){
			return true;
		}
		return false;
	}*/

	public boolean delIR(InsuranceRec ir) {
		boolean f=false;
		if(iinsurancerecd.del(ir)>0){
			f=true;
		}
		return f;
	}
}

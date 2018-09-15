

package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.*;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IRepairRecService;

import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class RepairRecAction extends BaseAction implements ModelDriven<RepairRec> { 
	private RepairRec rep;
	private IRepairRecService ireps;
	private IDriverService idris;
	private IDictionaryService idics;
	private ICarService icars;
	private ICurrentUnitService icus;
	
	public ICurrentUnitService getIcus() {
		return icus;
	}


	public void setIcus(ICurrentUnitService icus) {
		this.icus = icus;
	}


	public RepairRec getRep() {
		return rep;
	}


	public void setRep(RepairRec rep) {
		this.rep = rep;
	}


	

	public IRepairRecService getIreps() {
		return ireps;
	}


	public void setIreps(IRepairRecService ireps) {
		this.ireps = ireps;
	}


	public IDriverService getIdris() {
		return idris;
	}


	public void setIdris(IDriverService idris) {
		this.idris = idris;
	}


	public IDictionaryService getIdics() {
		return idics;
	}


	public void setIdics(IDictionaryService idics) {
		this.idics = idics;
	}


	public ICarService getIcars() {
		return icars;
	}


	public void setIcars(ICarService icars) {
		this.icars = icars;
	}


	//查询部门下拉列表
		public void findDeptList(){
		List<Dictionary> dlist=idics.findByText("部门");
		this.wirteJSON(dlist);
		}
		
		//查询车辆下拉列表新增时查询所有可用的
		public void findCarListForAdd(){
		List<Car> clist=icars.findCarList(1, 1);
		this.wirteJSON(clist);
		}
	
		public void findDriverListForAdd(){
			List<Driver> lssd=idris.findDriverList(1);
			this.wirteJSON(lssd);
		}
		/**
		*展示4s店
		*/
		public void findRepDepotList(){
			List<CurrentUnit> lscu=icus.findCULByType("4S店");
			this.wirteJSON(lscu);
			
		}
		
		
		public void add(){
			boolean flag=ireps.add(rep);
			Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg,  PrintInfo.fmsg);
			//写入前台
			this.wirteJSON(mapmsg);
			
		}

		public void upd(){
			boolean flag=ireps.upd(rep);
			Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg,  PrintInfo.fmsg);
			//写入前台
			this.wirteJSON(mapmsg);
			
		}
		
		public void del(){
			boolean flag=ireps.del(rep);
			Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg,  PrintInfo.fmsg);
			//写入前台
			this.wirteJSON(mapmsg);
			
		}
		
		
		public void findRRById(){
			RepairRec re=ireps.findRRById(rep.getId());
			this.wirteJSON(re);
		}
		
		
		
		
		public RepairRec getModel() {
			if(rep==null){
				rep=new RepairRec();
			}
			return rep;
		}
	
	
	
	

}

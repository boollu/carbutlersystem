package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.AccidentRec;
import com.cbs.po.Car;
import com.cbs.po.Driver;
import com.cbs.po.InspectionRec;
import com.cbs.po.PageModel;
import com.cbs.service.IAccidentRecService;
import com.cbs.service.ICarService;
import com.cbs.service.IDriverService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class AccidentRecAction  extends BaseAction implements ModelDriven<AccidentRec>{
	private AccidentRec acc;
	private IAccidentRecService iaccs;
	private ICarService icars;
	private IDriverService idris;
	

	public AccidentRec getAcc() {
		return acc;
	}
	public void setAcc(AccidentRec acc) {
		this.acc = acc;
	}
	public IAccidentRecService getIaccs() {
		return iaccs;
	}
	public void setIaccs(IAccidentRecService iaccs) {
		this.iaccs = iaccs;
	}
	public ICarService getIcars() {
		return icars;
	}
	public void setIcars(ICarService icars) {
		this.icars = icars;
	}
	public IDriverService getIdris() {
		return idris;
	}
	public void setIdris(IDriverService idris) {
		this.idris = idris;
	}
	public void findARDG(){
		PageModel<AccidentRec> pm=iaccs.findARDG(acc);
		this.wirteJSON(pm);
	}
	public void findCarList(){
		List<Car> clist=icars.findCarList(-1, 1);
		this.wirteJSON(clist);
	}
	public void findDriverList(){
		List<Driver> dlist=idris.findDriverList(-1);//表示所有的司机(当事人)
		this.wirteJSON(dlist);
	}
	public void findARById(){
		AccidentRec oacc=iaccs.findAById(acc.getId());
		this.wirteJSON(oacc);
	}
	public void add(){
		boolean f=iaccs.add(acc);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	public void upd(){
		boolean f=iaccs.updd(acc);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	public void del(){
		boolean f=iaccs.del(acc);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	public AccidentRec getModel() {
		if(acc==null){
			acc=new AccidentRec();
		}
		return acc;
	}
	
	
	
}

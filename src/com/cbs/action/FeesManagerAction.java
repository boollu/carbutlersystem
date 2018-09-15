package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.FeesManager;
import com.cbs.po.PageModel;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IFeesManagerService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class FeesManagerAction extends BaseAction implements ModelDriven<FeesManager> {
    private FeesManager fee;
    private IDictionaryService idics;
    private ICurrentUnitService icus;
    private ICarService icars;
    private IDriverService idris;
    private IFeesManagerService ifees;
    
    
	public IFeesManagerService getIfees() {
		return ifees;
	}
	public void setIfees(IFeesManagerService ifees) {
		this.ifees = ifees;
	}
	public IDictionaryService getIdics() {
		return idics;
	}
	public void setIdics(IDictionaryService idics) {
		this.idics = idics;
	}
	public ICurrentUnitService getIcus() {
		return icus;
	}
	public void setIcus(ICurrentUnitService icus) {
		this.icus = icus;
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
	public FeesManager getFee() {
		return fee;
	}
	public void setFee(FeesManager fee) {
		this.fee = fee;
	}
	public FeesManager getModel() {
		if(fee==null){
			fee=new FeesManager();
		}
		return fee;
	}//findFeesUnitList
 public void findFeesDG(){
	 PageModel<FeesManager> pm=ifees.findIRDG(fee);
	 this.wirteJSON(pm);
 }
 public void findCarList(){
	 List<Car> clist=icars.findCarList(-1, 1);
		this.wirteJSON(clist);
 }
 public void findFeesUnitList(){
	 List<CurrentUnit> feulist=icus.findCULByType();
		this.wirteJSON(feulist);
 }
 /*public void findFeesUnitList(){
	 List<CurrentUnit> instlist=icus.findCULByType(null);
	 this.wirteJSON(instlist);
 }*/
 public void findDriverList(){
	 List<Driver> dlist=idris.findDriverList(-1);
		this.wirteJSON(dlist);
 }
 public void add(){
	 boolean f=ifees.add(fee);
	 Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
 }
 public void del(){
	 boolean f=ifees.del(fee);
	 Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
	 this.wirteJSON(mapmsg);
 }
 public void upd(){
	 boolean f=ifees.upd(fee);
	 Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
	 this.wirteJSON(mapmsg);
 }
 public void findFeesById(){
	 FeesManager ofee=ifees.findById(fee.getId());
	 this.wirteJSON(ofee);
 }
}

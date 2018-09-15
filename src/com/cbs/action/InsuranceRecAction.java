package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.InsuranceRec;
import com.cbs.po.PageModel;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IInsuranceRecService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class InsuranceRecAction  extends BaseAction implements ModelDriven<InsuranceRec>{
    private InsuranceRec ir;
    private IInsuranceRecService iis;
    private IDictionaryService idics;
    private ICurrentUnitService icus;
    private ICarService icars;
    private IDriverService idris;
    
    
	public InsuranceRec getIr() {
		return ir;
	}


	public void setIr(InsuranceRec ir) {
		this.ir = ir;
	}


	public IInsuranceRecService getIis() {
		return iis;
	}


	public void setIis(IInsuranceRecService iis) {
		this.iis = iis;
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

/**获取模型驱动的方法*/
	public InsuranceRec getModel() {
		if(ir==null){
			ir=new InsuranceRec();
		}
		return ir;
	}
  /**展示数据（分页模型）*/
	public void findIRDG(){
		System.out.println("展示所有保险记录******");
		PageModel<InsuranceRec> pm=iis.findIRDG(ir);
		this.wirteJSON(pm);
	}
	/**查询可用车辆下拉列表*/
	public void findCarList(){
		List<Car> clist=icars.findCarList(-1, 1);
		this.wirteJSON(clist);
		System.out.println("总共有几辆车？"+clist.size());
	}
	/**查询保险种类下拉列表*/
	public void findInsTypeList(){
		List<Dictionary> instlist=idics.findByText("保险种类");
		this.wirteJSON(instlist);
	}
	/**查询保险公司下拉列表*/
	public void findInsUnitList(){
		List<CurrentUnit> ulist=icus.findCULByType("保险");
		this.wirteJSON(ulist);
	}
	/**查询经办人(驾驶员)下拉列表*/
	public void findDriverList(){
		List<Driver> dlist=idris.findDriverList(-1);
		this.wirteJSON(dlist);
	}
	/**根据id查询出保险记录实体对象*/
	public void findIRById(){
		InsuranceRec oir=iis.findIRById(ir.getId());
		this.wirteJSON(oir);
	}
	/**修改保险记录*/
	public void upd(){
		boolean f=iis.updIR(ir);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**增加保险记录*/
	public void add(){
		boolean f=iis.addIR(ir);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**删除保险记录*/
	public void del(){
		boolean f=iis.delIR(ir);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
}

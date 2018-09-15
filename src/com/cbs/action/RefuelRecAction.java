
package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.AccidentRec;
import com.cbs.po.Car;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.PageModel;
import com.cbs.po.RefuelRec;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IRefuelRecService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class RefuelRecAction extends BaseAction implements ModelDriven<RefuelRec> {

	private ICarService icars;
	private ICurrentUnitService icus;
	private IDictionaryService idics;
	private RefuelRec ref;
	private IRefuelRecService irefs;
	private IDriverService idris;
	
	
	
	public IDriverService getIdris() {
		return idris;
	}
	public void setIdris(IDriverService idris) {
		this.idris = idris;
	}
	public IRefuelRecService getIrefs() {
		return irefs;
	}
	public void setIrefs(IRefuelRecService irefs) {
		this.irefs = irefs;
	}
	public RefuelRec getRef() {
		return ref;
	}
	public void setRef(RefuelRec ref) {
		this.ref = ref;
	}
	public ICarService getIcars() {
		return icars;
	}
	public void setIcars(ICarService icars) {
		this.icars = icars;
	}
	public ICurrentUnitService getIcus() {
		return icus;
	}
	public void setIcus(ICurrentUnitService icus) {
		this.icus = icus;
	}
	public IDictionaryService getIdics() {
		return idics;
	}
	public void setIdics(IDictionaryService idics) {
		this.idics = idics;
	}
	public RefuelRec getModel() {
		if(ref==null){
			ref=new RefuelRec();
		}
		return ref;
	}
	 
	public void findRRDG(){
		PageModel<RefuelRec> pm=irefs.findrefDG(ref);
		System.out.println(pm+"111111111");
		  this.wirteJSON(pm);
		
		
	}
	/**车牌展示**/
	public void findCarList(){
		List<Car> lssc=icars.findCarList(-1, 1);
		this.wirteJSON(lssc);
	}
	
	
	public void findOilStaList(){
	//	System.out.println("111111111");
		List<CurrentUnit> lscu=icus.findCULByType("油");
		this.wirteJSON(lscu);
		
	}
	
	public void findOilLabelList(){
		List<Dictionary> lssd=idics.findByText("油料标号");
		this.wirteJSON(lssd);
	}
	
	
	public void findDriverList(){
		List<Driver> lssd=idris.findDriverList(1);
		
		this.wirteJSON(lssd);
	}
	
	
	public void add(){
		
		boolean flag=irefs.add(ref);
		Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
	}
    public void upd(){
		
		boolean flag=irefs.upd(ref);
		Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
	}
	
   public void del(){
	boolean flag=irefs.del(ref);
	Map<String,Object> mapmsg=this.getResultMsg(flag, PrintInfo.Smsg, PrintInfo.fmsg);
	//转换为JSON字符串并写出
		this.wirteJSON(mapmsg);
	
}
	
	public void findRRById(){
		RefuelRec re=irefs.findbyid(ref);
		this.wirteJSON(re);
		
	}
	
	
	
	
	
}

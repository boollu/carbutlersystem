package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Driver;
import com.cbs.po.InspectionRec;
import com.cbs.po.PageModel;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IInspectionRecService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class InspectionRecAction extends BaseAction implements ModelDriven<InspectionRec>{
   private InspectionRec ip;
   private IInspectionRecService iips;
   private IDictionaryService idics;
   private ICurrentUnitService icus;
   private ICarService icars;
   private IDriverService idris;
   
	public InspectionRec getIp() {
	return ip;
}
public void setIp(InspectionRec ip) {
	this.ip = ip;
}
public IInspectionRecService getIips() {
	return iips;
}
public void setIips(IInspectionRecService iips) {
	this.iips = iips;
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
	/**展示分页信息结果集*/
	public void findIRDG(){
		PageModel<InspectionRec> pm=iips.findIRDG(ip);
		this.wirteJSON(pm);
	}
	/**展示车辆信息下拉列表*/
	public void findCarList(){
		List<Car> clist=icars.findCarList(-1,1);
		this.wirteJSON(clist);
	}
	/**展示检车单位信息下拉列表*/
	public void findVAOList(){
		List<CurrentUnit> ulist=icus.findCULByType("车管所");
		this.wirteJSON(ulist);
	}
	/**展示经办人信息下拉列表*/
	public void findDriverList(){
		List<Driver> dlist=idris.findDriverList(-1);//表示所有的司机
		this.wirteJSON(dlist);
	}
	/**根据记录id查询记录实体对象*/
	public void findIRById(){
		InspectionRec oip=iips.findById(ip.getId());
		this.wirteJSON(oip);
	}
	/**添加年检记录*/
	public void add(){
		boolean f=iips.add(ip);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**修改年检记录*/
	public void upd(){
		boolean f=iips.upd(ip);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**删除年检记录*/
	public void del(){
		boolean f=iips.del(ip);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**获取驱动模型*/
	public InspectionRec getModel() {
		if(ip==null){
			ip=new InspectionRec();
		}
		return ip;
	}
}

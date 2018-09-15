package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.DrivingRec;
import com.cbs.po.PageModel;
import com.cbs.po.Users;
import com.cbs.service.ICarService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IDrivingRecService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class DrivingRecAction extends BaseAction implements ModelDriven<DrivingRec> {
  private IDrivingRecService idrirecs;
  private DrivingRec dr;//值栈
  private IDictionaryService idics;
  private IDriverService idris;
  private ICarService icars;
public IDrivingRecService getIdrirecs() {
	return idrirecs;
}
public void setIdrirecs(IDrivingRecService idrirecs) {
	this.idrirecs = idrirecs;
}
public DrivingRec getDr() {
	return dr;
}
public void setDr(DrivingRec dr) {
	this.dr = dr;
}
public IDictionaryService getIdics() {
	return idics;
}
public void setIdics(IDictionaryService idics) {
	this.idics = idics;
}
public IDriverService getIdris() {
	return idris;
}
public void setIdris(IDriverService idris) {
	this.idris = idris;
}
public ICarService getIcars() {
	return icars;
}
public void setIcars(ICarService icars) {
	this.icars = icars;
}
  //具体动作方法
/**展示分页结果集*/
public void findDRDG(){
	Users us=(Users) this.session.get("user");//从session中获取当前登录的用户
	PageModel<DrivingRec> pm=idrirecs.findDRDG(dr, us);
	this.wirteJSON(pm);
	System.out.println("出车记录集合大小为："+pm.getTotal());
}
public DrivingRec getModel() {
	if(dr==null){
		dr=new DrivingRec();
	}
	return dr;
}
//查询部门下拉列表
	public void findDeptList(){
	List<Dictionary> dlist=idics.findByText("部门");
	this.wirteJSON(dlist);
	}
	
	//查询车辆下拉列表新增时查询所有可用的
	public void findCarListForAdd(){
		//this.writeJson(icars.findCarList(1, 1), new String[]{"dic"});		
	List<Car> clist=icars.findCarList(1, 1);
	this.wirteJSON(clist);
	}
	
	//查询车辆下拉列表修改时查询所有的包括已出车的
	public void findCarListForUpd(){
		//this.writeJson(icars.findCarList(-1, 1), new String[]{"dic"});		
		List<Car> culist=icars.findCarList(-1, 1);
		this.wirteJSON(culist);
	}
	
	//查询驾驶员信息新增时查询所有可用的
	public void findDriverListForAdd(){
		//this.writeJson(idris.findDriverList(1),new String[]{"dic"});
	  List<Driver> dlist=idris.findDriverList(1);
	  this.wirteJSON(dlist);
	}
	
	//查询驾驶员信息修改时查询所有的包括已出车的
	public void findDriverListForUpd(){
		this.wirteJSON(idris.findDriverList(-1));
	}
	
	//通过ID查询实体
	public void findDRById(){
		DrivingRec odr=idrirecs.findDRById(dr.getId());
		this.wirteJSON(odr);		
	}
	
	//出车信息登记
	public void add(){
		//添加创建人
		System.out.println("添加方法过来了！！！！！！！！！！！！！！！！");
		Users us=(Users) this.session.get("user");
		dr.setCreater(us);
		boolean f=idrirecs.addDR(dr);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
		
		
	}
	
	//出车信息修改
	public void upd(){
		boolean f=idrirecs.updDR(dr);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
		
	}
	
	//回车信息登记
	public void back(){
		boolean f=idrirecs.backDR(dr);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
		
	}
	
	//删除出车信息
	public void del(){
		boolean f=idrirecs.delDR(dr.getId());
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
		
		
	}
}

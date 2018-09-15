package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.PageModel;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class DriverAction extends BaseAction implements ModelDriven<Driver> {
	private Driver driver;
	private IDriverService idris;
	private IDictionaryService idics;
	
	public Driver getDriver() {
		return driver;
	}
	public void setDriver(Driver driver) {
		this.driver = driver;
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
	public Driver getModel() {
		return driver==null?driver=new Driver():driver;
	}
	
	//查询数据表
	public void findDriDG(){
		PageModel pm=idris.findDriverDG(driver);
		//转换为JSON字符串并写出
			this.wirteJSON(pm);
		//this.writeJson(idris.findDriverDG(driver),new String[]{"dic"});
	}
	
	//通过ID查询实体
	public void findDriById(){
		Driver d=idris.findDriverById(driver.getId());
		this.wirteJSON(d);
		//this.writeJson(idris.findDriverById(driver.getId()),new String[]{"dic"});		
	}
	
	//查询部门下拉列表
	public void findDeptList(){
		//
		List<Dictionary> dlist=idics.findByText("部门");
		//转换为JSON字符串并写出
		this.wirteJSON(dlist);
		//this.writeJson(idics.findDicListByName("部门"), new String[]{"dic"});
	}
	
	//查询驾照类型下拉列表
	public void findDriTypeList(){
		List<Dictionary> dlist=idics.findByText("驾照类型");
		//转换为JSON字符串并写出
		this.wirteJSON(dlist);
		//this.writeJson(idics.findDicListByName("驾照类型"), new String[]{"dic"});
	}
	
	//新增驾驶员
	public void add(){
		boolean f=idris.addDriver(driver);
		
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
	}
	
	//修改驾驶员
	public void upd(){
		boolean f=idris.updDriver(driver);
		
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
	}
	
	//删除驾驶员
	public void del(){
		boolean f=idris.dDriver(driver.getId());
		
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
	}
}

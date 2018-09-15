package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.MaintainRec;
import com.cbs.po.PageModel;
import com.cbs.service.ICarService;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IMaintainRecService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class MaintainRecAction extends BaseAction implements ModelDriven<MaintainRec> {
    private MaintainRec mat;
    private ICarService icars;
   	private IDriverService idris;
   	private IDictionaryService idics;
   	private ICurrentUnitService icus;
   	private IMaintainRecService imas;
 
	public IMaintainRecService getImas() {
		return imas;
	}
	public void setImas(IMaintainRecService imas) {
		this.imas = imas;
	}
	public IMaintainRecService getIma() {
		return imas;
	}
	public void setIma(IMaintainRecService imas) {
		this.imas = imas;
	}
	public ICurrentUnitService getIcus() {
		return icus;
	}
	public void setIcus(ICurrentUnitService icus) {
		this.icus = icus;
	}
	public MaintainRec getMat() {
		return mat;
	}
	public void setMat(MaintainRec mat) {
		this.mat = mat;
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
	public IDictionaryService getIdics() {
		return idics;
	}
	public void setIdics(IDictionaryService idics) {
		this.idics = idics;
	}
	public MaintainRec getModel() {
		if(mat==null){
			mat=new MaintainRec();
		}
		return mat;
	}
	/**获取维修记录的分页结果集*/
	public void findMRDG(){
		PageModel<MaintainRec> pm=imas.findMRDG(mat);
		this.wirteJSON(pm);
	}
	/**获取车辆信息下拉列表*/
	public void findCarList(){
		List<Car> clist=icars.findCarList(-1, 1);
		this.wirteJSON(clist);
	}
	/**获取车辆保养类型下拉列表*/
	public void findMainTypeList(){
		List<Dictionary> dmlist=idics.findByText("保养类别");
		this.wirteJSON(dmlist);
	}
	/**获取车辆保养单位下拉列表*/
	public void findMainUnitList(){
		List<CurrentUnit> culist=icus.findCULByType("4S");
		this.wirteJSON(culist);
	}
	/**获取经办人（司机）下拉列表*/
	public void findDriverList(){
		List<Driver> dlist=idris.findDriverList(-1);//表示所有的司机(当事人)
		this.wirteJSON(dlist);
	}
	/**添加保养信息*/
	public void add(){
		System.out.println("这是保养得增加方法");
		boolean f=imas.add(mat);
		
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**修改保养信息*/
	public void upd(){
		boolean f=imas.upd(mat);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	/**删除保养信息*/
	public void del(){
		boolean f=imas.del(mat);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	

	public void findMRById(){
		MaintainRec mtr=imas.findById(mat.getId());
		this.wirteJSON(mtr);
	}
}

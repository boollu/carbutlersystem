package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Car;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.PageModel;
import com.cbs.po.PeccancyRec;
import com.cbs.service.ICarService;
import com.cbs.service.IDictionaryService;
import com.cbs.service.IDriverService;
import com.cbs.service.IPeccancyRecService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class PeccancyRecAction extends BaseAction implements ModelDriven<PeccancyRec> {
    private PeccancyRec pec;
    private ICarService icars;
	private IDriverService idris;
	private IDictionaryService idics;
	private IPeccancyRecService peccs;
	
	
	public IDictionaryService getIdics() {
		return idics;
	}
	public void setIdics(IDictionaryService idics) {
		this.idics = idics;
	}
	public IPeccancyRecService getPeccs() {
		return peccs;
	}
	public void setPeccs(IPeccancyRecService peccs) {
		this.peccs = peccs;
	}
	public PeccancyRec getPec() {
		return pec;
	}
	public void setPec(PeccancyRec pec) {
		this.pec = pec;
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
	public PeccancyRec getModel() {
		if(pec==null){
			pec=new PeccancyRec();
		}
		return pec;
	}
	/**违章车辆下拉列表*/
	public void findCarList(){
		List<Car> clist=icars.findCarList(-1, 1);
		this.wirteJSON(clist);
	};
	/**违章驾驶员下拉列表*/
	public void findDriverList(){
		List<Driver> dlist=idris.findDriverList(-1);//表示所有的司机(当事人)
		this.wirteJSON(dlist);
	};
	/**违章类型拉列表*/
	public void findOptionList(){
		System.out.println("违章项目下拉列表");
		List<Dictionary> olist=idics.findByText("违章项目");
		this.wirteJSON(olist);
		
		
	};
	/**违章详细信息*/
	public void findPRById(){
		PeccancyRec opec=peccs.findById(pec.getId());
		this.wirteJSON(opec);
	};
	/**添加违章记录*/
	public void add(){
		boolean f=peccs.add(pec);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	};
	/**修改违章记录*/
	public void upd(){
		boolean f=peccs.upd(pec);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	};
	/**删除违章记录*/
	public void del(){
		boolean f=peccs.del(pec);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	};
	/***展示全部**/
	public void findPRDG(){
		PageModel<PeccancyRec> lssp=peccs.findPRDG(pec);
		this.wirteJSON(lssp);
		
	}
	
	
	
}

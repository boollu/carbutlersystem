package com.cbs.action;

import com.cbs.po.ViewCostContrast;
import com.cbs.service.IViewCostContrastService;
import com.opensymphony.xwork2.ModelDriven;

public class ViewCostContrastAction extends BaseAction implements ModelDriven<ViewCostContrast> {
	private ViewCostContrast vcc;
	private IViewCostContrastService iviewccs;	
	
	public ViewCostContrast getVcc() {
		return vcc;
	}
	public void setVcc(ViewCostContrast vcc) {
		this.vcc = vcc;
	}	
	public void setIviewccs(IViewCostContrastService iviewccs) {
		this.iviewccs = iviewccs;
	}

	public ViewCostContrast getModel() {
		return vcc==null?vcc=new ViewCostContrast():vcc;
	}
	
	//查询数据
	public void findColumnList(){
		this.wirteJSON(iviewccs.findVCCList(vcc));
	}
}

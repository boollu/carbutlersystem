package com.cbs.action;

import com.cbs.po.ViewExpiration;
import com.cbs.service.IViewExpirationService;
import com.opensymphony.xwork2.ModelDriven;

public class ViewExpirationAction extends BaseAction implements ModelDriven<ViewExpiration> {
	private ViewExpiration ve;
	private IViewExpirationService iviewexps;

	public ViewExpiration getVe() {
		return ve;
	}
	public void setVe(ViewExpiration ve) {
		this.ve = ve;
	}
	public void setIviewexps(IViewExpirationService iviewexps) {
		this.iviewexps = iviewexps;
	}

	public ViewExpiration getModel() {
		return ve==null?ve=new ViewExpiration():ve;
	}
	
	//查询数据
	/*public void findVEDG(){
		this.writeJson(iviewexps.findVEDG(ve));
	}*/
	
}

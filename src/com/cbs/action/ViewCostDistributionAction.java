package com.cbs.action;

import java.util.List;

import com.cbs.po.Car;
import com.cbs.po.ViewCostDistribution;
import com.cbs.service.ICarService;
import com.cbs.service.IViewCostDistributionService;
import com.opensymphony.xwork2.ModelDriven;

public class ViewCostDistributionAction extends BaseAction implements ModelDriven<ViewCostDistribution> {
	private ViewCostDistribution vcd;
	private IViewCostDistributionService iviewcds;
	 private ICarService icars;
	
	public void setIcars(ICarService icars) {
		this.icars = icars;
	}
	public ViewCostDistribution getVcd() {
		return vcd;
	}
	public void setVcd(ViewCostDistribution vcd) {
		this.vcd = vcd;
	}
	public void setIviewcds(IViewCostDistributionService iviewcds) {
		this.iviewcds = iviewcds;
	}

	public ViewCostDistribution getModel() {
		return vcd==null?vcd=new ViewCostDistribution():vcd;
	}
	
	//查询车辆下拉列表
	public void findCarList(){
		
		List<Car> lssc=icars.findCarList(-1, 1);
		this.wirteJSON(lssc);		
	}
	
	//查询数据
	public void findPieList(){
		System.out.println("oooooooooooooooooo");
		
		this.wirteJSON(iviewcds.findVCDList(vcd));
		System.out.println("111111111");
	}
}

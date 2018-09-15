package com.cbs.action;

import java.util.List;

import com.cbs.po.Car;
import com.cbs.service.ICarService;

public class ViewcdAction extends BaseAction  {
	 private ICarService icars;
	 private Car car;
	 

	public Car getCar() {
		return car;
	}

	public void setCar(Car car) {
		this.car = car;
	}

	public ICarService getIcars() {
		return icars;
	}

	public void setIcars(ICarService icars) {
		this.icars = icars;
	}
	 
	/**违章车辆下拉列表*/
	public void findCarList(){
		List<Car> clist=icars.findCarList(-1, -1);
		this.wirteJSON(clist);
	};
	
	/****/
	
	public void findPieList(){
	
	
	
	}
}

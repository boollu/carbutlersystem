package com.cbs.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IViewCostContrastDao;
import com.cbs.po.ReportColumn;
import com.cbs.po.ViewCostContrast;
import com.cbs.service.IViewCostContrastService;

public class ViewCostContrastServiceImpl implements IViewCostContrastService {
	private IViewCostContrastDao iviewccd;	

	public void setIviewccd(IViewCostContrastDao iviewccd) {
		this.iviewccd = iviewccd;
	}


	public List<ReportColumn<Double>> findVCCList(ViewCostContrast vcc) {
		//总容器
		List<ReportColumn<Double>> rclist=new ArrayList<ReportColumn<Double>>();
		//一组数据容器
		ReportColumn<Double> rc=new ReportColumn<Double>();
		rc.setName("车牌号码");
		//临时变量
		ViewCostContrast temp=null;
		//条件容器
		Map<String,Object> params =new HashMap<String,Object>();
		
		String hql="from ViewCostContrast vcc where 1=1 ";
		
		//原始数据
		List<ViewCostContrast> data=iviewccd.getAll(hql, params);
		
		if(data !=null){
			//X轴数据
			String[] x =new String[data.size()];
			//对应Y轴数据
			Double[] y=new Double[data.size()];
			
			//封装
			for(int i=0;i<data.size();i++){
				temp=data.get(i);
				x[i]=temp.getCarNo();
				y[i]=temp.getCarCost();
			}
			
			rc.setX(x);
			rc.setY(y);
			
			rclist.add(rc);
		}
		
		return rclist;
	}
	
}

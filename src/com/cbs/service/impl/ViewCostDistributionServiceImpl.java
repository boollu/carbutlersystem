package com.cbs.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IViewCostDistributionDao;
import com.cbs.po.ViewCostDistribution;
import com.cbs.service.IViewCostDistributionService;

public class ViewCostDistributionServiceImpl implements IViewCostDistributionService {
	private IViewCostDistributionDao iviewcdd;

	public void setIviewcdd(IViewCostDistributionDao iviewcdd) {
		this.iviewcdd = iviewcdd;
	}	

	
	public List<ViewCostDistribution> findVCDList(ViewCostDistribution vcd) {
		//条件容器
		Map<String,Object> params =new HashMap<String,Object>();
		System.out.println("||||||||||||||||||||||");
		
		String hql="from ViewCostDistribution vcd where 1=1 and vcd.cid=:cid";
		params.put("cid", vcd.getCid());
		System.out.println(vcd.getCid()+"************");
		
		List<ViewCostDistribution> data=iviewcdd.getAll(hql, params);
		System.out.println("5555"+data);
		if(data !=null){
			return data;
		}
		
		return new ArrayList<ViewCostDistribution>();
	}
	
}

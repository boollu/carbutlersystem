package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.action.ViewcdAction;
import com.cbs.dao.IViewExpirationDao;
import com.cbs.po.DataGrid;
import com.cbs.po.ViewExpiration;
import com.cbs.service.IViewExpirationService;
import com.cbs.util.Page;

public class ViewExpirationServiceImpl implements IViewExpirationService {
	private IViewExpirationDao iviewexpd;
	
	public void setIviewexpd(IViewExpirationDao iviewexpd) {
		this.iviewexpd = iviewexpd;
	}
	
	
	/*public Long findVECount(ViewExpiration ve) {
		//条件容器
		Map<String,Object> params =new HashMap<String,Object>();
		
		String hql="select count(ve.id) from ViewExpiration ve where 1=1 ";		
		
		return iviewexpd.count(hql, params);
	}

	public DataGrid<ViewExpiration> findVEDG(ViewExpiration ve) {
		//条件容器
		Map<String,Object> params =new HashMap<String,Object>();
		//页面数据容器
		DataGrid<ViewExpiration> dg =new DataGrid<ViewExpiration>();
		//分页工具
		Page page=new Page(ve.getPage(),ve.getRows());
		
		String hql="from ViewExpiration ve where 1=1 ";
		
		List<ViewExpiration> data=iviewexpd.getAllByPage(hql, params, page.getBegin(), page.getPageSize());
		
		if(data !=null){
			Long c=findVECount(ve);
			dg.setRows(data);
			dg.setTotal(c);
		}
		
		return dg;
	}
*/

	public Long findVECount(ViewcdAction ve) {
Map<String,Object> params =new HashMap<String,Object>();
		
		String hql="select count(ve.id) from ViewExpiration ve where 1=1 ";		
		
		return iviewexpd.count(hql, params);
	}


	public DataGrid<ViewExpiration> findVEDG(ViewcdAction ve) {
		// TODO Auto-generated method stub
		return null;
	}



	/*public DataGrid<ViewExpiration> findVEDG(ViewcdAction ve) {
		Map<String,Object> params =new HashMap<String,Object>();
		//页面数据容器
		DataGrid<ViewExpiration> dg =new DataGrid<ViewExpiration>();
		//分页工具
		//Page page=new Page(ve.g(),ve.getRows());
		
		String hql="from ViewExpiration ve where 1=1 ";
		
	//	List<ViewExpiration> data=iviewexpd.getAllByPage(hql, params, page.getBegin(), page.getPageSize());
		
		if(data !=null){
			Long c=findVECount(ve);
			dg.setRows(data);
			dg.setTotal(c);
		}
		
		return dg;
	}*/
	}

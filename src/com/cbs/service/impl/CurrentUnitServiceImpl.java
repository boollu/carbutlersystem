package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.IdClass;

import com.cbs.dao.ICurrentUnitDao;
import com.cbs.dao.IDictionaryDao;
import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.PageModel;
import com.cbs.service.ICurrentUnitService;


public class CurrentUnitServiceImpl implements ICurrentUnitService {
  private ICurrentUnitDao icud;
  private IDictionaryDao idicd;
  
	public ICurrentUnitDao getIcud() {
	return icud;
}

public void setIcud(ICurrentUnitDao icud) {
	this.icud = icud;
}

/**获取展示数据的分页模型*/
	public PageModel<CurrentUnit> findCurrentUnitDG(CurrentUnit cu) {
		PageModel pm=new PageModel();
		//定义分页所需要的数据
		long total=0L;
		if(cu!=null){
			int page=cu.getPage();
			int rows=cu.getRows();
			String hql="from CurrentUnit cu";
			Map<String,Object> maps=new HashMap<String, Object>();
			//获取总记录数
			String hql1="select count(cu.id) from CurrentUnit cu";
			//定义模糊查询的hql
			Map<String, Object> mapc=new HashMap<String, Object>();
			System.out.println("cu为空？：");
			if(cu.getUnitName()!=null){
			hql+=" where cu.unitName like :untiName";
			maps.put("untiName", "%"+cu.getUnitName()+"%");
			System.out.println("准备执行模糊查询········");
			hql1+=" where cu.unitName like :untiName";
			mapc.put("untiName", "%"+cu.getUnitName()+"%");
			System.out.println("完成模糊查询········");
			}
			System.out.println("cu不为空：");
			total=icud.count(hql1, mapc);
			System.out.println("总记录数为："+total);
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<CurrentUnit> culist=icud.getAllByPage(hql, maps, rows*(page-1), rows);
			System.out.println("集合长度为："+culist.size());
			if(total==-1){//排除异常情况，避免前台因出现错误
				total=0L;
			}
			//设置pm的属性值，为前台准备分页数据
			pm.setRows(culist);
			pm.setTotal(total);
			
		}
		return pm;
	}
  /**详细页面*/
	public CurrentUnit findCUById(int id) {//1
		return icud.get(id);
	}

	public boolean addCurrentUnit(CurrentUnit cu) {
		if(icud.add(cu)>0){
			return true;
		}
		return false;
	}

	public boolean updCurrentUnit(CurrentUnit cu) {
		if(icud.upd(cu)>0){
			return true;
		}
		return false;
	}

	public boolean dCurrentUnit(int id) {
		CurrentUnit cu=icud.get(id);
		cu.setIsdisable(0);//改变可用状态
		if(icud.upd(cu)>0){
			return true;
		}
		return false;
	}
   //单位名称下拉列表
	public List<CurrentUnit> findCULByType(String text) {//2
				Map<String,Object> params =new HashMap<String,Object>();
				
				String hql="from CurrentUnit c where c.unitName like :text";
				
				params.put("text", "%"+text+"%");
			
				List<CurrentUnit> clist=icud.getAll(hql, params);

				return icud.getAll(hql, params);
	}
/**获取模糊查询符合条件的总记录数*/
	public Long findCurrentUnitCount(CurrentUnit cu) {
		String hql="select count(cu.id) from CurrentUnit cu where 1=1";
	     Map<String,Object> maps=new HashMap<String, Object>();
			if(cu.getUnitName()!=null){
				hql+=" and cu.unitName like :name";
				maps.put("name", "%"+cu.getUnitName()+"%");
				
				
	}
			return icud.count(hql, maps);

	}

public List<CurrentUnit> findCULByType() {
	String hql="from CurrentUnit";
	
	return icud.getAll(hql, null);
}	

}

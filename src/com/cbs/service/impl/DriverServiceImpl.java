package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cbs.dao.IDictionaryDao;
import com.cbs.dao.IDriverDao;
import com.cbs.po.Driver;
import com.cbs.po.PageModel;
import com.cbs.po.Users;
import com.cbs.service.IDriverService;
import com.cbs.util.PrintInfo;

public class DriverServiceImpl implements IDriverService {
    private IDriverDao idrid;
    private IDictionaryDao idicd;
    
    
	public IDriverDao getIdrid() {
		return idrid;
	}

	public void setIdrid(IDriverDao idrid) {
		this.idrid = idrid;
	}

	public IDictionaryDao getIdicd() {
		return idicd;
	}

	public void setIdicd(IDictionaryDao idicd) {
		this.idicd = idicd;
	}
/**获取总记录的方法*/
	public Long findDriverCount(Driver dri) {
     Map<String,Object> params =new HashMap<String,Object>();
		
		String hql="select count(d.id) from Driver d where 1=1 ";
		
		if(dri.getName()!=null){
			hql+="and d.name=:name ";
			params.put("name", dri.getName());
		}
		
		if(dri.getDriverNo()!=null){
			hql+="and d.driverNo=:driverNo ";
			params.put("driverNo", dri.getDriverNo());
		}
		
		return idrid.count(hql, params);
	}
/**获取分页模型的方法*/
	public PageModel<Driver> findDriverDG(Driver dri) {
		PageModel pm=new PageModel();
		//定义分页所需要的数据
		long total;
		if(dri!=null){
			int page=dri.getPage();
			int rows=dri.getRows();
			String hql="from Driver d where 1=1";
			Map<String,Object> maps=new HashMap<String, Object>();
			//获取总记录数
			String hql1="select count(d.id) from Driver d";
			//定义模糊查询的hql
			Map<String, Object> mapc=new HashMap<String, Object>();
			if(dri.getName()!=null){
			hql+=" and d.name like:name";
			maps.put("name", "%"+dri.getName()+"%");
			hql1+=" where d.name like:name";
			mapc.put("name", "%"+dri.getName()+"%");
			}
			total=idrid.count(hql1, mapc);
			//获取hibernate中分页集合，为前台easyui准备属性值
			List<Driver> ulist=idrid.getAllByPage(hql, maps, rows*(page-1), rows);
			if(total==-1){//排除异常情况，避免前台因出现错误
				total=0;
			}
			//设置pm的属性值，为前台准备分页数据
			pm.setRows(ulist);
			pm.setTotal(total);
			
		}
		return pm;
	}

	public Driver findDriverById(int id) {
		return idrid.get(id);
	}

	public boolean addDriver(Driver dri) {
		boolean f=false;
		if(idrid.add(dri)>0){
			f=true;
		}
		return f;
	}

	public boolean updDriver(Driver dri) {
		boolean f=false;
		if(idrid.upd(dri)>0){
			f=true;
		}
		return f;
	}
/**真删除*/
	public boolean delDriver(int id) {
		boolean f=false;
		Map<String,Object> maps=new HashMap<String,Object>();
		String hql="delete from Driver d where d.id=:id";
		maps.put("id", id);
		if(idrid.execute(hql, maps)>0){
			f=true;
		}
		return f;
	}
	/**真删除*/
	
	public List<Driver> findDriverList(int isdisable) {
		//条件容器
	Map<String,Object> params =new HashMap<String,Object>();
				
	String hql="from Driver d where 1=1 ";
				 
	if(isdisable !=-1){
	hql+="and d.isdisable=:isdisable ";
	params.put("isdisable", isdisable);
	}
				
	return idrid.getAll(hql, params);
	}
/**伪删除*/
	public boolean dDriver(int id) {
		Driver d=idrid.get(id);
		d.setIsdisable(0);
		if(idrid.upd(d)>0){
			return true;
		}
		return false;
	}

}

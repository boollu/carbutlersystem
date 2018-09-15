package com.cbs.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.IdClass;

import com.cbs.dao.IDictionaryDao;
import com.cbs.po.Dictionary;
import com.cbs.po.PageModel;
import com.cbs.service.IDictionaryService;

public class DictionaryServiceImpl implements IDictionaryService {
   private IDictionaryDao idicd;
   
	public IDictionaryDao getIdicd() {
	return idicd;
}

public void setIdicd(IDictionaryDao idicd) {
	this.idicd = idicd;
}
/**通过类型查找*/
	public List<Dictionary> findByText(String text) {
		String hql="from Dictionary d1 where d1.dic.id=(select d2.id from Dictionary d2 where text like :text)";
		Map<String,Object> maps=new HashMap<String,Object>();
		maps.put("text", "%"+text+"%");
		List<Dictionary> listd=idicd.getAll(hql, maps);
		return listd;
	}
 /**初始化所有下拉列表*/
	public List<Dictionary> initBP(Dictionary dic) {
		String hql="from Dictionary d";
		Map<String,Object> maps=new HashMap<String,Object>();
		if(dic.getDic()==null){//若父级id为空，则为一级菜单
			hql+=" where d.dic is null";
		}else{//
			hql+=" where d.dic.id= :pid";
			maps.put("pid", dic.getDic().getId());
		}
		List<Dictionary> dd=idicd.getAll(hql, maps);
		System.out.println("集合长度为："+dd.size());
		return dd;
	}
/**获取分页模型*/
	public PageModel<Dictionary> findDG(Dictionary dic) {
		PageModel<Dictionary> pm=new PageModel<Dictionary>();
		Map<String,Object> params=new HashMap<String, Object>();
		int page=dic.getPage();
		int rows=dic.getRows();
		String hql="from Dictionary d";
		String hql1="select count(d.id) from Dictionary d";
		if(dic.getDic()==null){
			hql+=" where d.dic is null";
			hql1+=" where d.dic is null";  //where d.dic.id= null
		}else{
			hql+=" where d.dic.id= :pid";
			hql1+=" where d.dic.id= :pid";
			params.put("pid", dic.getDic().getId());
		}
		//根据父级id（pid）查找数据字典表的数据
		List<Dictionary> dlist=idicd.getAllByPage(hql, params, rows*(page-1), rows);
		pm.setRows(dlist);
		//
		Long  count=idicd.count(hql1, params);
		pm.setTotal(count);
		return pm;
	}
/***/
	public List<Dictionary> initByLev(Dictionary dic) {
		String hql="from Dictionary d where d.isdisable=:isdisable and d.lev=:lev ";
		Map<String,Object> params=new HashMap<String, Object>();
		params.put("isdisable", 1);
		params.put("lev", dic.getLev());
		return idicd.getAll(hql, params);
	}


	public boolean add(Dictionary dic) {
		if(dic.getDic().getId()==-1){
			dic.setDic(null);
		}
		if(idicd.add(dic)>0){
			return true;
		}
		return false;
	}

	public boolean upd(Dictionary dic) {
		System.out.println("***********"+dic);
		boolean f=false;
		Map<String,Object> maps=new HashMap<String,Object>();
		int a=idicd.upd(dic);
		
		if(a>0){
			f=true;
		}
		return f;
	}
	public boolean findText(Dictionary dictionary) {
		  String hql="from Dictionary d where d.text=:text";
		  Map<String,Object> params=new HashMap<String, Object>();
		  params.put("text", dictionary.getText());
		  Dictionary d=idicd.get(hql, params);
			return d!=null?false:true;
		}
          /**通过pid获取结果集*/
	public List<Dictionary> findDicByPid(Integer pid){
     Map<String,Object> params =new HashMap<String,Object>();		
		
		String hql="from Dictionary d where 1=1 ";
		
		if(pid ==-1){//若为一级菜单，pid赋空值
			hql+="and d.dic is null";
		}else{
			hql+="and d.dic.id =:id";
			params.put("id", pid);
		}

		return idicd.getAll(hql, params);
		
	}
	
  public Dictionary findById(Dictionary dic){
	  
	  Dictionary d=idicd.get(dic.getId());
	  
	  
	  return d;
  }
	
	
	
}

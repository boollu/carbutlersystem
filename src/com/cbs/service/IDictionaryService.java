package com.cbs.service;

import java.util.List;

import com.cbs.po.Dictionary;
import com.cbs.po.PageModel;

public interface IDictionaryService {
/**
 * 通过传入的类型查找对应的部门，职位*/
	public List<Dictionary> findByText(String text);
	/**初始化下拉联动列表，根据上一级节点信息查询其对应的子节点信息*/
	public  List<Dictionary> initBP(Dictionary dic);
	/**获取分页模型数据*/
	public PageModel<Dictionary> findDG(Dictionary dic);
	/**初始化添加的下拉列表，根据上级节点可用状态,节点等级查询对应子节点信息集合*/
	public List<Dictionary> initByLev(Dictionary dic);
	/**增加字典信息*/
	public boolean add(Dictionary dic);
	/**修改字典信息*/
	public boolean upd(Dictionary dic);
	/**
	 * 验证字典
	 * 
	 * */
	public boolean findText(Dictionary dictionary);
	/**通过父级id获取结果集*/
	public List<Dictionary> findDicByPid(Integer pid);
	/**查找*/
	 public Dictionary findById(Dictionary dic);
	
}

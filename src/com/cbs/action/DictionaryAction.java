package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.Dictionary;
import com.cbs.po.PageModel;
import com.cbs.service.IDictionaryService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class DictionaryAction extends BaseAction implements
		ModelDriven<Dictionary> {
	private Dictionary dic;
	private IDictionaryService idics;

	public Dictionary getDic() {
		return dic;
	}

	public void setDic(Dictionary dic) {
		this.dic = dic;
	}

	public IDictionaryService getIdics() {
		return idics;
	}

	public void setIdics(IDictionaryService idics) {
		this.idics = idics;
	}

	/** 初始化大分类 */
	public void init() {
		List<Dictionary> dlist = idics.initBP(dic);
		this.wirteJSON(dlist);
	}

	/** 展示中分类 */
	public void show() {
		PageModel<Dictionary> pm = idics.findDG(dic);
		this.wirteJSON(pm);
	}

	// 新增编辑
	public void initbylev() {
		List<Dictionary> dlist = idics.initByLev(dic);
		this.wirteJSON(dlist);
	}

	// 添加方法
	public void add() {
		boolean flag = idics.add(dic);
		
		Map<String, Object> mapmsg = this.getResultMsg(flag, PrintInfo.Smsg,
				PrintInfo.fmsg);
		// 写入前台
		this.wirteJSON(mapmsg);
	}

	/** 获取模型对象 */
	public Dictionary getModel() {
		if (dic == null) {
			dic = new Dictionary();
		}
		return dic;
	}

	// 检查字典是否存在
	public void findText() {
		this.wirteJSON(idics.findText(dic));
	}

	public void update() {
		/*Dictionary d= idics.findById(dic);
		System.out.println("111111111111"+d);
		if(d.getId()==null){
			dic.getDic().setId(null);
		}
		System.out.println(dic.toString());*/
		/*if(dic.getDic().getId()==-1){
			dic.getDic().setPid(null);
			
		}*/
		boolean flag = idics.upd(dic);
		Map<String, Object> mapmsg = this.getResultMsg(flag, PrintInfo.Smsg,
				PrintInfo.fmsg);
		this.wirteJSON(mapmsg);
	}
	public void findbyid(){
		Dictionary d= idics.findById(dic);
		this.wirteJSON(d);
	}
	
	
	

}

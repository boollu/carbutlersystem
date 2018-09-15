package com.cbs.action;

import java.util.List;
import java.util.Map;

import com.cbs.po.CurrentUnit;
import com.cbs.po.Dictionary;
import com.cbs.po.Driver;
import com.cbs.po.PageModel;
import com.cbs.service.ICurrentUnitService;
import com.cbs.service.IDictionaryService;
import com.cbs.util.PrintInfo;
import com.opensymphony.xwork2.ModelDriven;

public class CurrentUnitAction extends BaseAction implements ModelDriven<CurrentUnit> {
	private CurrentUnit cu;
  private ICurrentUnitService icus;
  private IDictionaryService idics;
public CurrentUnit getCu() {
	return cu;
}
public void setCu(CurrentUnit cu) {
	this.cu = cu;
}
public ICurrentUnitService getIcus() {
	return icus;
}
public void setIcus(ICurrentUnitService icus) {
	this.icus = icus;
}
public IDictionaryService getIdics() {
	return idics;
}
public void setIdics(IDictionaryService idics) {
	this.idics = idics;
}
  /**分页结果集*/
public void findpageAll(){
	 System.out.println("分页结果集方法执行：111111111111111111111");//没有输出！？
	  PageModel pm=icus.findCurrentUnitDG(cu);
	 //转换为JSON字符串并写出
			this.wirteJSON(pm);
  }
/**获取对象模型*/
public CurrentUnit getModel() {
	if(cu==null){
		cu=new CurrentUnit();
	}
	return cu;
}
//查询往来部门详细信息
	public void findCUById(){
		//
		
		CurrentUnit oldcu=icus.findCUById(cu.getId());
		//转换为JSON字符串并写出
		this.wirteJSON(oldcu);
		
	} 
//添加单位时获取单位类型下拉列表的方法
	public void findUnitTypeList(){
		List<Dictionary> dlist=idics.findByText("单位类型");
		//转换为JSON字符串并写出
				this.wirteJSON(dlist);
	}
	/**添加往来单位*/
	public void add(){
		boolean f=icus.addCurrentUnit(cu);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
	}
	/**修改往来单位*/
	public void upd(){
		boolean f=icus.updCurrentUnit(cu);
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
	}
	/**删除往来单位*/
	public void del(){
		boolean f=icus.dCurrentUnit(cu.getId());
		Map<String,Object> mapmsg=this.getResultMsg(f, PrintInfo.Smsg, PrintInfo.fmsg);
		//转换为JSON字符串并写出
			this.wirteJSON(mapmsg);
	}
	
}

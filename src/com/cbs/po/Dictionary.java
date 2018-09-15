package com.cbs.po;

import java.io.Serializable;

//字典表实�?
public class Dictionary implements Serializable{
	private Integer id=-1;
	private Dictionary dic;
	private String text;
	private Integer lev;
	private Integer isdisable=1;	
	private boolean selected=false;
	
	//传�?专用，不做数据映�?
	private Integer pid=-1;
	
	//分页专用
	private int page;
	private int rows;	
	
	public Integer getLev() {
		return lev;
	}
	public void setLev(Integer lev) {
		this.lev = lev;
	}
	public Integer getPid() {
		return pid;
	}
	public void setPid(Integer pid) {
		this.pid = pid;
	}
	public int getPage() {
		return page;
	}
	public void setPage(int page) {
		this.page = page;
	}
	public int getRows() {
		return rows;
	}
	public void setRows(int rows) {
		this.rows = rows;
	}
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
	}
	public Dictionary getDic() {
		return dic;
	}
	public void setDic(Dictionary dic) {
		this.dic = dic;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public Integer getIsdisable() {
		return isdisable;
	}
	public void setIsdisable(Integer isdisable) {
		this.isdisable = isdisable;
	}
	public boolean isSelected() {
		return selected;
	}
	public void setSelected(boolean selected) {
		this.selected = selected;
	}
	@Override
	public String toString() {
		return "Dictionary [id=" + id + ", dic=" + dic + ", text=" + text
				+ ", lev=" + lev + ", isdisable=" + isdisable + ", selected="
				+ selected + ", pid=" + pid + "]";
	}
	
	
}

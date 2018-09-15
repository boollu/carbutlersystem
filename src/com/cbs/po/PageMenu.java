package com.cbs.po;

import java.util.Map;

public class PageMenu {
	private String pid;
	private String id;
	private String text;
	private boolean checked=false;
	private Map<String,Object>attributes;//鑷畾涔夊睘鎬�
	public String getPid() {
		return pid;
	}
	public void setPid(String pid) {
		this.pid = pid;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public boolean isChecked() {
		return checked;
	}
	public void setChecked(boolean checked) {
		this.checked = checked;
	}
	public Map<String, Object> getAttributes() {
		return attributes;
	}
	public void setAttributes(Map<String, Object> attributes) {
		this.attributes = attributes;
	}
	public PageMenu() {
		super();
		// TODO Auto-generated constructor stub
	}
	public PageMenu(String pid, String id, String text, boolean checked,
			Map<String, Object> attributes) {
		super();
		this.pid = pid;
		this.id = id;
		this.text = text;
		this.checked = checked;
		this.attributes = attributes;
	}
	
	
	
}

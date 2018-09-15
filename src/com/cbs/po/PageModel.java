package com.cbs.po;

import java.util.List;

public class PageModel<T>{
	/**T	Ϊ����list�����е�����
	 * ǰ̨��ҳ��
	 * */
	private Long total;//�ṩ�ܼ�¼��
	private List<T>rows;//�ṩչʾ����
	public Long getTotal() {
		return total;
	}
	public void setTotal(Long total) {
		this.total = total;
	}
	public List<T> getRows() {
		return rows;
	}
	public void setRows(List<T> rows) {
		this.rows = rows;
	}
	public PageModel(Long total, List<T> rows) {
		super();
		this.total = total;
		this.rows = rows;
	}
	public PageModel() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
}

package com.cbs.service;

import com.cbs.po.InsuranceRec;
import com.cbs.po.PageModel;

public interface IInsuranceRecService {
	/***
	 * 查询保险信息(分页模型)
	 */
	public PageModel<InsuranceRec> findIRDG(InsuranceRec ir);
	/***
	 * 查询总数
	 */
	public Long findIRCount(InsuranceRec ir);
	/***
	 * 按照id查询实体对象
	 */
	public InsuranceRec findIRById(int id);
	/***
	 * 新增保险信息
	 */
	public boolean addIR(InsuranceRec ir);
	/***
	 * 修改保险信息
	 */
	public boolean updIR(InsuranceRec ir);
	/***
	 * 删除保险信息
	 */
	//public boolean delIR(int id);
	public boolean delIR(InsuranceRec ir);
}

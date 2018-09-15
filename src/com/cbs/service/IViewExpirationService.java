package com.cbs.service;

import com.cbs.action.ViewcdAction;
import com.cbs.po.DataGrid;
import com.cbs.po.ViewExpiration;

public interface IViewExpirationService {
	/***
	 * 查询总数
	 *
	 */
	public Long findVECount(ViewcdAction ve);
	/***
	 * 查询到期提醒
	 */
	public DataGrid<ViewExpiration> findVEDG(ViewcdAction ve);
}

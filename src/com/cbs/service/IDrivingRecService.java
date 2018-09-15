package com.cbs.service;

import com.cbs.po.DrivingRec;
import com.cbs.po.PageModel;
import com.cbs.po.Users;

public interface IDrivingRecService {
	/***
	 * 查询总数
	 * @param dr 实体
	 * @param selType 查询方式 
	 * @return 总数
	 */
	public Long findDRCount(DrivingRec dr,Users users);
	/***
	 * 查询出车信息
	 * @param dr 实体
	 * @return 数据容器
	 */
	public PageModel<DrivingRec> findDRDG(DrivingRec dr,Users users);
	/***
	 * 按照ID查询出车信息
	 * @param id ID
	 * @return 出车信息实体
	 */
	public DrivingRec findDRById(int id);
	/***
	 * 出车信息登记
	 * @param dr 实体
	 * @return 成功与否
	 */
	public boolean addDR(DrivingRec dr);
	/***
	 * 出车信息修改
	 * @param dr 实体
	 * @return 成功与否
	 */
	public boolean updDR(DrivingRec dr);
	/***
	 * 回车信息登记
	 * @param dr 实体
	 * @return 成功与否
	 */
	public boolean backDR(DrivingRec dr);
	/***
	 * 删除出车信息
	 * @param id 主键ID
	 * @return 成功与否
	 */
	public boolean delDR(int id);
}

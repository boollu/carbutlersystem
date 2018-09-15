package com.cbs.service;

import java.util.List;

import com.cbs.po.Driver;
import com.cbs.po.PageModel;

public interface IDriverService {
	/***
	 * 查询总数
	 * @param dri 实体
	 * @return 总数
	 */
	public Long findDriverCount(Driver dri);
	/***
	 * 查询驾驶员信息
	 * @param dri 实体
	 * @return 数据容器
	 */
	public PageModel<Driver> findDriverDG(Driver dri);
	/***
	 * 按照ID查询驾驶员信息
	 * @param id ID
	 * @return 驾驶员实体
	 */
	public Driver findDriverById(int id);
	/***
	 * 新增驾驶员信息
	 * @param dri 实体
	 * @return 成功与否
	 */
	public boolean addDriver(Driver dri);
	/***
	 * 修改驾驶员信息
	 * @param dri 实体
	 * @return 成功与否
	 */
	public boolean updDriver(Driver dri);
	/***
	 * 删除驾驶员信息
	 * @param id 主键ID
	 * @return 成功与否
	 */
	public boolean delDriver(int id);
	/***
	 * 删除驾驶员信息（改变状态为禁用）
	 * @param id 主键ID
	 * @return 成功与否
	 */
	public boolean dDriver(int id);
	/***
	 * 得到驾驶员信息
	 * @param isdisable 1启用 0禁用 -1所有
	 * @return 集合
	 */
	
	public List<Driver> findDriverList(int isdisable);
}

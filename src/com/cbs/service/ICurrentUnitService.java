package com.cbs.service;

import java.util.List;

import com.cbs.po.CurrentUnit;
import com.cbs.po.PageModel;


public interface ICurrentUnitService {
	/***4.
	 * 查询总数
	 * @param cu 实体
	 * @return 总数
	 */
	public Long findCurrentUnitCount(CurrentUnit cu );
	/***5.
	 * 查询驾驶员信息
	 * @param cu 实体
	 * @return 分页模型
	 */
	public PageModel<CurrentUnit> findCurrentUnitDG(CurrentUnit cu );
	/***1.
	 * 按照ID查询往来单位信息
	 * @param id ID
	 * @return 往来单位实体
	 */
	public CurrentUnit   findCUById(int id);
	/***2.
	 * 新增往来单位信息
	 * @param cu 实体
	 * @return 成功与否
	 */
	public boolean addCurrentUnit(CurrentUnit cu);
	/***6.
	 * 修改往来单位信息
	 * @param cu 实体
	 * @return 成功与否
	*/ 
	public boolean updCurrentUnit(CurrentUnit cu);
	
	/***
	 * 删除往来单位信息
	 * @param id 主键ID
	 * @return 成功与否
	 
	public boolean delCurrentUnit(int id);
	*/
	/***8.
	 * 删除往来单位信息（改变状态为禁用）
	 * @param id 主键ID
	 * @return 成功与否
	 */
	public boolean dCurrentUnit(int id);
	
	/***3.
	 * 得到往来单位信息集合
	 * @param isdisable 1启用 0禁用 -1所有
	 * @return 集合
	 */
	
	public List<CurrentUnit> findCULByType(String text);
	/**测试方法（得到全部往来单位）*/
	public List<CurrentUnit> findCULByType();
}

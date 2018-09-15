package com.cbs.service;

import java.util.List;

import com.cbs.po.Car;
import com.cbs.po.CarPic;
import com.cbs.po.PageModel;

/***/
public interface ICarService {
  /**查询车辆总数*/
	public Long findCarCount(Car car);
	/**查询分页模型*/
	public PageModel<Car> findCarDG(Car car);
	/**根据id查询车辆信息*/
	public Car findCarById(Integer id);
   /**添加车辆*/
	public boolean addCar(Car car);
	/**修改车辆*/
	public boolean updCar(Car car);
	/**删除车辆*/
	public boolean delCar(Integer cid);
	/**删除对应车辆的所有图片信息*/
	public boolean delCarPic(Integer cid);
	/***
	 * 删除对应ID的图片信息
	 * @param carPicId 子表图片信息ID
	 * @param carPicPath 图片路径
	 * @return 成功与否
	 */
	public boolean delCarPicById(int carPicId,String carPicPath);
	/***
	 * 得到车辆信息
	 * @param state 1可用 2出车 3维修 4其他 -1所有
	 * @param isdisable 1启用 0禁用 -1所有
	 * @return 集合
	 */
	public List<Car> findCarList(int state,int isdisable);
	/***
	 * 修改对应的图片
	 * @param cp 图片实体
	 * @return 成功与否
	 */
	public boolean updCarPic(CarPic cp);
	/***
	 * 查询车辆图片信息
	 * @param id 车辆ID
	 * @return 车辆图片信息集合
	 */
	public List<CarPic> findCarPicList(int id);
	/***
	 * 上传图片信息
	 * @param car 车辆信息实体其中有图片信息
	 * @return 成功与否
	 */
	public boolean addCarPic(Car car);
	/**
	 * 检查车牌是否已经新增过了
	 * @param carNo
	 * @return
	 */
	public int findCarNo(String carNo);	
}

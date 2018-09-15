package com.cbs.service;

import com.cbs.po.PageModel;
import com.cbs.po.PeccancyRec;

public interface IPeccancyRecService {
	 /****
	    * 增加事故
	    * 
	    * */
   public boolean add(PeccancyRec pecc);
   /****
    * 删除事故
    * 
    * */
   public boolean del(PeccancyRec pecc);
   /****
    * 修改事故
    * 
    * */
   public boolean upd(PeccancyRec pecc);
   /****
    *详细展示
    * 
    * */
   public PeccancyRec findById(Integer id);

   /****
    * 前台展示 模糊查询
    * 
    * */
   public PageModel<PeccancyRec> findPRDG(PeccancyRec pecc);
}

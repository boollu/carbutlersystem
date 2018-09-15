package com.cbs.service;

import com.cbs.po.MaintainRec;
import com.cbs.po.PageModel;

public interface IMaintainRecService {
   public boolean add(MaintainRec ma);
   public boolean del(MaintainRec ma);
   public boolean upd(MaintainRec ma);
   public MaintainRec findById(Integer id);
   public PageModel<MaintainRec> findMRDG(MaintainRec ma);
}

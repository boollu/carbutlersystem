package com.cbs.service;

import com.cbs.po.AccidentRec;
import com.cbs.po.PageModel;

public interface IAccidentRecService {
   public boolean add(AccidentRec acc);
   public boolean updd(AccidentRec acc);
   public boolean del(AccidentRec acc);
   public AccidentRec findAById(Integer id);
   public PageModel<AccidentRec> findARDG(AccidentRec acc);
}

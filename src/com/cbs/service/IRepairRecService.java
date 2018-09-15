package com.cbs.service;

import com.cbs.po.*;


public interface IRepairRecService {
	public boolean add(RepairRec rep);
    public boolean upd(RepairRec rep);
    public boolean del(RepairRec rep);
    public PageModel<RepairRec> findRRDG(RepairRec rep);
    public RepairRec findRRById(Integer id);
    public boolean backRepRec(RepairRec rr);
}

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<jsp:include page="../../Inc.jsp"></jsp:include>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title></title>
	<script type="text/javascript">
    $(function(){
    	/*数据表初始设置开始*****************************/  
    	$('#rep_dg').datagrid({
            url:'<%=basePath%>reprec_findRRDG.action',
            fitColumns:true,
            pagination:true,
            rownumbers:true,
            toolbar: '#rep_tb',
            columns:[[
				{field:'id',title:'编号',checkbox:true},
                {field:'car',title:'车牌号码',formatter:function(v,r,i){
                	return v.carNo;
                }},
                {field:'repDepot',title:'修理厂',formatter:function(v,r,i){
                	return v.unitName;
                }},
                {field:'sendTime',title:'送修时间',formatter: function(v,r,i){
					return formatTime(v);
				}},
				{field:'estTime',title:'预计取车时间',formatter: function(v,r,i){
					return formatTime(v);
				}},
				{field:'getTime',title:'取车时间',formatter: function(v,r,i){
					return v==null?'未取车':formatTime(v);
				}},
				{field:'operator',title:'经办人',formatter:function(v,r,i){
					return v.name;						
				}},
				{field:'getTime',title:'取车时间',formatter: function(v,r,i){
					return v==null?'未取车':formatTime(v);
				}},
				{field:'repCost',title:'维修金额',formatter:function(v,r,i){
					return r.getTime==null?'未结算':v;
				}},						
				{field:'null',title:'操作',formatter: function(v,r,i){
					var str1='未取车无法查看详细';
					var str2='<a href="javascript:showDetailed('+r.id+');">查看详细</a>';
					return r.getTime==null?str1:str2;
				}}
            ]]
        });
    	/*数据表初始设置结束*****************************/
    	
    	/*新增按钮事件设置,开始*****************************/
		$('#tb_add').on('click',function(){
			//填充车辆下拉列表
			var url='<%=basePath%>reprec_findCarListForAdd.action';
			var carKV={k:'id',v:'carNo'};
			initCombobox($('#rep_sendForm #car'),url,carKV,-1);
			
			//填充修理厂下拉列表
			var url='<%=basePath%>reprec_findRepDepotList.action';
			var rdKV={k:'id',v:'unitName'};
			initCombobox($('#rep_sendForm #repDepot'),url,rdKV,-1);
			
			//送修时间默认当前时间
			$('#rep_sendForm #sendTime').datetimebox('setValue',getNowTime());
			
			
			//填充经办人【驾驶员】下拉列表
			var url='<%=basePath%>reprec_findDriverListForAdd.action';
			var opeKV={k:'id',v:'name'};
			initCombobox($('#rep_sendForm #operator'),url,opeKV,-1);
			
			$('#rep_sendDialog').dialog('open');					
		});			
		/*新增按钮事件设置,结束*****************************/
		
		/*修改按钮事件设置,开始*****************************/
		$('#tb_edit').on('click',function(){
			//未选中提示
   			var rows=$('#rep_dg').datagrid('getChecked');
   			if(rows.length==0){
				$.messager.show({
					title : '提示',
					msg : '请勾选要修改的记录！'
				});
				return;
			}
			//选中多笔提示
			if(rows.length>1){
				$.messager.show({
					title : '提示',
					msg : '修改时只能选择一条记录！'
				});
				return;
			}
			
			//不可修改提示【已取车不许编辑】
			if(rows[0].getTime !=null){
				$.messager.alert('提示','已取车，不允许修改内容','warning');
				$('#reg_dg').datagrid('unselectAll');
				return;
			}
			
			//主键ID
			var id=rows[0].id;
			var params={"id":id};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>reprec_findRRById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定数据
					updDataBindForSend(data);
					
					$('#rep_sendUpdDialog').dialog('open');		
				}
			});
		});		
		/*修改按钮事件设置,结束*****************************/
		
		/*取车按钮事件设置,开始*****************************/
		$('#tb_back').on('click',function(){
			//未选中提示
   			var rows=$('#rep_dg').datagrid('getChecked');
   			if(rows.length==0){
				$.messager.show({
					title : '提示',
					msg : '请勾选要取车的记录！'
				});
				return;
			}
			//选中多笔提示
			if(rows.length>1){
				$.messager.show({
					title : '提示',
					msg : '取车时只能选择一条记录！'
				});
				return;
			}
			
			//不可修改提示【已取车不许再次取车】
			if(rows[0].getTime !=null){
				$.messager.alert('提示','已取车，不允许修改内容','warning');
				$('#reg_dg').datagrid('unselectAll');
				return;
			}
			
			//主键ID
			var id=rows[0].id;
			var params={"id":id};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>reprec_findRRById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定取车数据
					updDataBindForGet(data);
					
					$('#rep_backDialog').dialog('open');		
				}
			});
		});		
		/*修改按钮事件设置,结束*****************************/
		
		/*删除按钮事件设置,开始*****************************/
		$('#tb_remove').on('click',function(){
			//未选中提示
   			var rows=$('#rep_dg').datagrid('getChecked');
   			if(rows.length==0){
				$.messager.show({
					title : '提示',
					msg : '请勾选要删除的记录！'
				});
				return;
			}
			//选中多笔提示
			if(rows.length>1){
				$.messager.show({
					title : '提示',
					msg : '删除时只能选择一条记录！'
				});
				return;
			}
			
			//主键ID
			var id=rows[0].id;
			var params={"id":id};
			
			$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
				if(r){
					//取得数据
					$.ajax({
						url:'<%=basePath%>reprec_delRR.action',
						data:params,
						dataType:'json',
						type:'POST',
						success:function(data){
							if(data.success){
								//去除选择
								$('#rep_dg').datagrid('unselectAll');
								//刷新dg
								$('#rep_dg').datagrid('reload');
							}
							
							$.messager.show({
								title:'提示消息',
								msg:data.msg
							});								
						}
					});
				}else{
					$('#rep_dg').datagrid('unselectAll');
				}
			});
			
		});
		/*删除按钮事件设置,结束*****************************/
		
		
		/*搜索按钮事件设置,开始*****************************/
		$('#sel').searchbox({
			searcher:function(v,n){
				var params={};
				
				params['car.carNo']=v;
				
				$('#rep_dg').datagrid('load',params);
			},
			menu:'#mm',
	  		prompt:'此处输入车牌号码，支持模糊查询' 
		});
		/*搜索按钮事件设置,结束*****************************/
		
    });
    
    /*绑定送修待修改内容开始*****************************/ 
	function updDataBindForSend(data){
		//绑定数据开始
					
		//填充车辆下拉列表
		var url='<%=basePath%>reprec_findCarListForUpd.action';
		var carKV={k:'id',v:'carNo'};
		initCombobox($('#rep_sendUpdForm #car'),url,carKV,data.car.id);
		
		//填充修理厂下拉列表
		var url='<%=basePath%>reprec_findRepDepotList.action';
		var rdKV={k:'id',v:'unitName'};
		initCombobox($('#rep_sendUpdForm #repDepot'),url,rdKV,data.repDepot.id);
				
		//填充经办人【驾驶员】下拉列表
		var url='<%=basePath%>reprec_findDriverListForUpd.action';
		var opeKV={k:'id',v:'name'};
		initCombobox($('#rep_sendUpdForm #operator'),url,opeKV,data.operator.id);
		
				
		$('#rep_sendUpdForm #id').val(data.id);
		$('#rep_sendUpdForm #sendTime').datetimebox('setValue',formatTime(data.sendTime));
		$('#rep_sendUpdForm #estTime').datetimebox('setValue',formatTime(data.estTime));
		$('#rep_sendUpdForm [name=sendReason]').val(data.sendReason);
		$('#rep_sendUpdForm [name=sendRemarks]').val(data.sendRemarks);
		
		//绑定数据结束
	}
	/*绑定待修改内容结束*****************************/
	
	/*绑定取车内容开始*****************************/ 
	function updDataBindForGet(data){
		//绑定数据开始
		
		//绑定ID
		$('#rep_backForm #id').val(data.id);
				
		//填充车辆下拉列表
		var url='<%=basePath%>reprec_findCarListForUpd.action';
		var carKV={k:'id',v:'carNo'};
		initCombobox($('#rep_backForm #car'),url,carKV,data.car.id);
		
		//填充修理厂下拉列表
		var url='<%=basePath%>reprec_findRepDepotList.action';
		var rdKV={k:'id',v:'unitName'};
		initCombobox($('#rep_backForm #repDepot'),url,rdKV,data.repDepot.id);			
		
		//填充维修类别下拉列表
		var url='<%=basePath%>reprec_findRepTypeList.action';
		initCombobox($('#rep_backForm #repType'),url,null,-1);
		
		//送修时间
		$('#rep_backForm #sendTime').datetimebox('setValue',formatTime(data.sendTime));
		
		//绑定数据结束
	}
	/*绑定取车内容结束*****************************/
    
    /*展示详细内容，此方法必须声明在初始方法外,开始*****************************/ 
	function showDetailed(id){
		//参数容器
		var params={};
		params['id']=id;
		
		//取得数据
		$.ajax({
			url:'<%=basePath%>reprec_findRRById.action',
			data:params,
			dataType:'json',
			type:'POST',
			success:function(data){
				//绑定数据开始				
				$('#rep_showDialog #car').html(data.car.carNo);
				$('#rep_showDialog #repDepot').html(data.repDepot.unitName);
				$('#rep_showDialog #sendTime').html(formatTime(data.sendTime));
				$('#rep_showDialog #estTime').html(formatTime(data.estTime));
				$('#rep_showDialog #sendReason').html(data.sendReason);
				$('#rep_showDialog #sendRemarks').html(data.sendRemarks);
				$('#rep_showDialog #operator').html(data.operator.name);
				$('#rep_showDialog #repType').html(data.repType.text);
				$('#rep_showDialog #getTime').html(formatTime(data.getTime));
				$('#rep_showDialog #repCost').html(data.repCost);
				$('#rep_showDialog #repOption').html(data.repOption);
				$('#rep_showDialog #useStuff').html(data.useStuff);
				$('#rep_showDialog #getRemarks').html(data.getRemarks);
				
				//绑定数据结束
				
				$('#rep_showDialog').dialog('open');
			}
		});
		
	}	
	/*展示详细内容，此方法必须声明在初始方法外,结束*****************************/
    
    </script>

  </head>
  
  <body>
  	<!-- 数据展示窗体创建位置 --> 
  	<table id="rep_dg"></table>
  	
  	<!-- 数据工具栏创建位置 -->   
	<div id="rep_tb">
		<a class="easyui-linkbutton" id="tb_add" data-options="iconCls:'icon-add',plain:true" style="float:left;">维修信息登记</a>
		<div class="datagrid-btn-separator"></div>		
		<a class="easyui-linkbutton" id="tb_edit" data-options="iconCls:'icon-edit',plain:true" style="float:left;">维修信息编辑</a>
		<div class="datagrid-btn-separator"></div>
		<a class="easyui-linkbutton" id="tb_back" data-options="iconCls:'icon-add',plain:true" style="float:left;">取车信息登记</a>
		<div class="datagrid-btn-separator"></div>
		<a class="easyui-linkbutton" id="tb_remove" data-options="iconCls:'icon-remove',plain:true" style="float:left;">维修信息删除</a>
		<div class="datagrid-btn-separator"></div>
		
    	<!-- 搜索框div创建位置 --> 
    	&nbsp;
		<input style="width:350px" id="sel"></input> 
		<div id="mm" style="width:120px">
			<div data-options="name:'name'">车牌号码</div>
		</div>
	</div>
	
	<!-- 详细窗体创建位置 -->
	<div id="rep_showDialog" class="easyui-dialog" title="维修信息详细" 
		style="width:400px;height:450px;align:center;top:1px;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#rep_dg').datagrid('unselectAll');
				$('#rep_showDialog').dialog('close');
			}
		}]">
		<table>
			<tr>
				<td style="text-align:rigth;">车牌号码：</td>
				<td>
					<span id="car"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">修&nbsp;理&nbsp;厂：</td>
				<td>
					<span id="repDepot"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">送修时间：</td>
				<td>
					<span id="sendTime"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">预计取车时间：</td>
				<td>
					<span id="estTime"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">送修原因：</td>
				<td>
					<span id="sendReason"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">送修备注：</td>
				<td>
					<span id="sendRemarks"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">经&nbsp;办&nbsp;人：</td>
				<td>
					<span id="operator"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">维修类别：</td>
				<td>
					<span id="repType"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">取车时间：</td>
				<td>
					<span id="getTime"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">花费金额：</td>
				<td>
					<span id="repCost"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">维修项目：</td>
				<td>
					<span id="repOption"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">使用材料：</td>
				<td>
					<span id="useStuff"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">取车备注：</td>
				<td>
					<span id="getRemarks"></span>
				</td>
			</tr>				
		</table>
	</div>
	
	<!-- 送修窗体创建位置 -->
	<div id="rep_sendDialog" class="easyui-dialog" title="送修信息登记" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#rep_sendForm').form('submit',{
					url:'<%=basePath%>reprec_addSendRR.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#rep_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#rep_sendForm').form('clear');
							//关闭表单
							$('#rep_sendDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#rep_sendForm #sendTime').datetimebox('getValue');
						var eTime=$('#rep_sendForm #estTime').datetimebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','预计取车时间必须大于送修时间','warning');
							return false;
						}
						
						
						return true;
					}
				});
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#rep_sendForm').form('clear');
				$('#rep_sendDialog').dialog('close');
			}
		}]">
		<form id="rep_sendForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" id="car" name="car.id" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">修&nbsp;理&nbsp;厂：</td>
					<td>
						<input id="repDepot" name="repDepot.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修时间：</td>
					<td>
						<input type="text" id="sendTime" name="sendTime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">预计取车时间：</td>
					<td>
						<input type="text" id="estTime" name="estTime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修原因：</td>
					<td>
						<input type="text" name="sendReason" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修备注：</td>
					<td>
						<input type="text" name="sendRemarks" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">经&nbsp;办&nbsp;人：</td>
					<td>
						<input id="operator" name="operator.id"/>
					</td>
				</tr>				
			</table>
			
		</form>
	</div> 
	
	<!-- 送修修改窗体创建位置 -->
	<div id="rep_sendUpdDialog" class="easyui-dialog" title="送修信息修改" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#rep_sendUpdForm').form('submit',{
					url:'<%=basePath%>reprec_updSendRR.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#rep_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#rep_sendUpdForm').form('clear');
							//关闭表单
							$('#rep_sendUpdDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#rep_sendUpdForm #sendTime').datetimebox('getValue');
						var eTime=$('#rep_sendUpdForm #estTime').datetimebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','预计取车时间必须大于送修时间','warning');
							return false;
						}
						
						
						return true;
					}
				});
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#rep_sendUpdDialog').dialog('close');
				$('#rep_dg').datagrid('unselectAll');
			}
		}]">
		<form id="rep_sendUpdForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="hidden" id="id" name="id"/>
						<input type="text" id="car" name="car.id" disabled="disabled" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">修&nbsp;理&nbsp;厂：</td>
					<td>
						<input id="repDepot" name="repDepot.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修时间：</td>
					<td>
						<input type="text" id="sendTime" name="sendTime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">预计取车时间：</td>
					<td>
						<input type="text" id="estTime" name="estTime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修原因：</td>
					<td>
						<input type="text" name="sendReason" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修备注：</td>
					<td>
						<input type="text" name="sendRemarks" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">经&nbsp;办&nbsp;人：</td>
					<td>
						<input id="operator" name="operator.id"/>
					</td>
				</tr>				
			</table>
			
		</form>
	</div>  
	
	<!-- 取车信息窗体创建位置 -->
	<div id="rep_backDialog" class="easyui-dialog" title="取车信息登记" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#rep_backForm').form('submit',{
					url:'<%=basePath%>reprec_backRR.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#rep_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#rep_backForm').form('clear');
							//关闭表单
							$('#rep_backDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#rep_backForm #sendTime').datetimebox('getValue');
						var eTime=$('#rep_backForm #getTime').datetimebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','取车时间必须大于送修时间','warning');
							return false;
						}
						
						return true;
					}
				});
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#rep_backForm').form('clear');
				$('#rep_backDialog').dialog('close');
				$('#rep_dg').datagrid('unselectAll');
			}
		}]">
		<form id="rep_backForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="hidden" id="id" name="id"/>
						<input type="text" id="car" name="car.id" disabled="disabled" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">修&nbsp;理&nbsp;厂：</td>
					<td>
						<input type="text" id="repDepot" name="repDepot.id"  disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">维修类别：</td>
					<td>
						<input type="text" id="repType" name="repType.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">送修时间：</td>
					<td>
						<input type="text" id="sendTime" name="sendTime" class="easyui-datetimebox" disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">取车时间：</td>
					<td>
						
						<input type="text" id="getTime" name="getTime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">花费金额：</td>
					<td>
						<input type="text" id="repCost" name="repCost" data-options="min:0,precision:2" required="required" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">维修项目：</td>
					<td>
						<input type="text" name="repOption" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">使用材料：</td>
					<td>
						<input type="text" name="useStuff" maxlength="100"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">取车备注：</td>
					<td>
						<input type="text" name="getRemarks" maxlength="100"/>
					</td>
				</tr>			
			</table>
			
		</form>
	</div>   
  </body>
</html>

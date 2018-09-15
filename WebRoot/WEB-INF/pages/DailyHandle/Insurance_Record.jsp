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
		$('#ir_dg').datagrid({
            url:'<%=basePath%>insurancerec_findIRDG.action',
            pagination:true,
            rownumbers:true,
            toolbar: '#ir_tb',
            columns:[[
				{field:'id',title:'编号',checkbox:true},
                {field:'car',title:'车牌号码',formatter:function(v,r,i){
                	return v.carNo;
                }},
                {field:'insNo',title:'保险编号'}, 
                {field:'insDate',title:'保险开始时间',formatter: function(v,r,i){
					return formatDate(v);
				}},
				{field:'insType',title:'保险种类',formatter:function(v,r,i){
                	return v.text;
                }},
				{field:'insAmount',title:'保险金额'},
				{field:'insUnit',title:'保险公司',formatter:function(v,r,i){
                	return v.unitName;
                }},
                {field:'expireDate',title:'保险到期时间',formatter: function(v,r,i){
					return formatDate(v);
				}},
				{field:'operator',title:'操作人员',formatter:function(v,r,i){
					return v.name;						
				}},
				{field:'remarks',title:'备注'}
                
            ]]
        });
		/*数据表初始设置结束*****************************/
		
		/*新增按钮事件设置,开始*****************************/
		$('#tb_add').on('click',function(){
			//填充车辆下拉列表
			var url='<%=basePath%>insurancerec_findCarList.action';
			var carKV={k:'id',v:'carNo'};
			initCombobox($('#ir_addForm #car'),url,carKV,-1);
			
			//填充保险种类下拉列表
			var url='<%=basePath%>insurancerec_findInsTypeList.action';
			initCombobox($('#ir_addForm #insType'),url,null,-1);
			
			//填充保险公司下拉列表
			var url='<%=basePath%>insurancerec_findInsUnitList.action';
			var rdKV={k:'id',v:'unitName'};
			initCombobox($('#ir_addForm #insUnit'),url,rdKV,-1);
			
			//投保时间默认当前时间
			$('#ir_addForm #insDate').datebox('setValue',getNowDate());			
			
			//投保金额
			$('#ir_addForm #insAmount').numberbox('setValue',0);
			
			//填充经办人【驾驶员】下拉列表
			var url='<%=basePath%>insurancerec_findDriverList.action';
			var opeKV={k:'id',v:'name'};
			initCombobox($('#ir_addForm #operator'),url,opeKV,-1);
			
			$('#ir_addDialog').dialog('open');					
		});			
		/*新增按钮事件设置,结束*****************************/
		
		/*新增界面选择年检时间计算下次年检时间,开始*****************************/
    	$('#ir_addForm #insDate').datebox({
    		onSelect:function(date){
    			//车辆保险间隔自动1年到期，但支持手动更改
    			var nextDate=addYear(date,1);
    			$('#ir_addForm #expireDate').datebox('setValue',nextDate);
    		}
    	});
    	/*新增界面选择年检时间计算下次年检时间,结束*****************************/
    	
    	/*修改按钮事件设置,开始*****************************/
		$('#tb_edit').on('click',function(){
			//未选中提示
   			var rows=$('#ir_dg').datagrid('getChecked');
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
			
			//主键ID
			var id=rows[0].id;
			var params={"id":id};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>insurancerec_findIRById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定数据
					updDataBind(data);
					
					$('#ir_updDialog').dialog('open');		
				}
			});
		});		
		/*修改按钮事件设置,结束*****************************/
		
		/*修改界面选择年检时间计算下次年检时间,开始*****************************/
    	$('#ir_updForm #insDate').datebox({
    		onSelect:function(date){
    			//车辆保险间隔自动1年到期，但支持手动更改
    			var nextDate=addYear(date,1);
    			$('#ir_updForm #expireDate').datebox('setValue',nextDate);
    		}
    	});
    	/*修改界面选择年检时间计算下次年检时间,结束*****************************/
    	
    	/*删除按钮事件设置,开始*****************************/
		$('#tb_remove').on('click',function(){
			//未选中提示
   			var rows=$('#ir_dg').datagrid('getChecked');
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
						url:'<%=basePath%>insurancerec_del.action',
						data:params,
						dataType:'json',
						type:'POST',
						success:function(data){
							if(data.success){
								//去除选择
								$('#ir_dg').datagrid('unselectAll');
								//刷新dg
								$('#ir_dg').datagrid('reload');
							}
							
							$.messager.show({
								title:'提示消息',
								msg:data.msg
							});								
						}
					});
				}else{
					$('#ir_dg').datagrid('unselectAll');
				}
			});
			
		});
		/*删除按钮事件设置,结束*****************************/
    	
		/*搜索按钮事件设置,开始*****************************/
		$('#sel').searchbox({
			searcher:function(v,n){
				var params={};
				
				params['car.carNo']=v;
				
				$('#ir_dg').datagrid('load',params);
			},
			menu:'#mm',
   			prompt:'此处输入车牌号码，支持模糊查询' 
		});
		/*搜索按钮事件设置,结束*****************************/
		
    });
    
    /*绑定待修改内容开始*****************************/ 
	function updDataBind(data){
		//填充车辆下拉列表
		var url='<%=basePath%>insurancerec_findCarList.action';
		var carKV={k:'id',v:'carNo'};
		initCombobox($('#ir_updForm #car'),url,carKV,data.car.id);
		
		//填充保险种类下拉列表
		var url='<%=basePath%>insurancerec_findInsTypeList.action';
		initCombobox($('#ir_updForm #insType'),url,null,data.insType.id);
		
		//填充保险公司下拉列表
		var url='<%=basePath%>insurancerec_findInsUnitList.action';
		var rdKV={k:'id',v:'unitName'};
		initCombobox($('#ir_updForm #insUnit'),url,rdKV,data.insUnit.id);
		
		//填充经办人【驾驶员】下拉列表
		var url='<%=basePath%>insurancerec_findDriverList.action';
		var opeKV={k:'id',v:'name'};
		initCombobox($('#ir_updForm #operator'),url,opeKV,-1);
    	
		//待修改ID
		$('#ir_updForm [name=id]').val(data.id);
		//保险开始时间
		$('#ir_updForm #insDate').datebox('setValue',formatDate(data.insDate));    	
		//保险到期时间
		$('#ir_updForm #expireDate').datebox('setValue',formatDate(data.expireDate));
		//保险编号
		$('#ir_updForm #insNo').val(data.insNo);
		//保险金额
		$('#ir_updForm #insAmount').numberbox('setValue',data.insAmount);
		//备注
		$('#ir_updForm #remarks').val(data.remarks);
		
    }    
	/*绑定待修改内容结束*****************************/
    </script>
	

  </head>
  
  <body>
    <!-- 数据展示窗体创建位置 --> 
  	<table id="ir_dg"></table>
  	
  	<!-- 数据工具栏创建位置 -->   
	<div id="ir_tb">
		<a class="easyui-linkbutton" id="tb_add" data-options="iconCls:'icon-add',plain:true" style="float:left;">保险信息登记</a>
		<div class="datagrid-btn-separator"></div>		
		<a class="easyui-linkbutton" id="tb_edit" data-options="iconCls:'icon-edit',plain:true" style="float:left;">保险信息编辑</a>
		<div class="datagrid-btn-separator"></div>
		<a class="easyui-linkbutton" id="tb_remove" data-options="iconCls:'icon-remove',plain:true" style="float:left;">保险信息删除</a>
		<div class="datagrid-btn-separator"></div>
		
    	<!-- 搜索框div创建位置 --> 
    	&nbsp;
		<input style="width:350px" id="sel"></input> 
		<div id="mm" style="width:120px">
			<div data-options="name:'name'">车牌号码</div>
		</div>
	</div>
	
	<!-- 保险窗体创建位置 -->
	<div id="ir_addDialog" class="easyui-dialog" title="保险信息登记" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#ir_addForm').form('submit',{
					url:'<%=basePath%>insurancerec_add.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#ir_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#ir_addForm').form('clear');
							//关闭表单
							$('#ir_addDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#ir_addForm #insDate').datebox('getValue');
						var eTime=$('#ir_addForm #expireDate').datebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','保险到期时间必须大于保险开始时间','warning');
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
				$('#ir_addForm').form('clear');
				$('#ir_addDialog').dialog('close');
			}
		}]">
		<form id="ir_addForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" id="car" name="car.id" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险编号：</td>
					<td>
						<input type="text" id="insNo" name="insNo" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险开始日期：</td>
					<td>
						<input type="text" id="insDate" name="insDate" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险种类：</td>
					<td>
						<input type="text" name="insType.id" id="insType"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险金额：</td>
					<td>
						<input type="text" id="insAmount" name="insAmount" data-options="min:0,precision:2" required="required" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险公司：</td>
					<td>
						<input type="text" id="insUnit" name="insUnit.id" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险到期时间：</td>
					<td>
						<input type="text" id="expireDate" name="expireDate" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">经&nbsp;办&nbsp;人：</td>
					<td>
						<input id="operator" name="operator.id"/>
					</td>
				</tr>	
				<tr>
					<td style="text-align: rigth;">保险备注：</td>
					<td>
						<input type="text" id="remarks" name="remarks" maxlength="100"/>
					</td>
				</tr>
							
			</table>
			
		</form>
	</div>
  
  	<!-- 保险窗体修改位置 -->
	<div id="ir_updDialog" class="easyui-dialog" title="保险信息修改" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#ir_updForm').form('submit',{
					url:'<%=basePath%>insurancerec_upd.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//成功刷新DG
							$('#ir_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#ir_updForm').form('clear');
							//取消选择
							$('#ir_dg').datagrid('unselectAll');
							//关闭表单
							$('#ir_updDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#ir_updForm #insDate').datebox('getValue');
						var eTime=$('#ir_updForm #expireDate').datebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','保险到期时间必须大于保险开始时间','warning');
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
				$('#ir_updForm').form('clear');
				//取消选择
				$('#ir_dg').datagrid('unselectAll');
				$('#ir_updDialog').dialog('close');
			}
		}]">
		<form id="ir_updForm" method="post">
			<table>
				<tr>
					<td><input type="hidden" name="id"/></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" id="car" name="car.id" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险编号：</td>
					<td>
						<input type="text" id="insNo" name="insNo" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险开始日期：</td>
					<td>
						<input type="text" id="insDate" name="insDate" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险种类：</td>
					<td>
						<input type="text" name="insType.id" id="insType"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险金额：</td>
					<td>
						<input type="text" id="insAmount" name="insAmount" data-options="min:0,precision:2" required="required" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险公司：</td>
					<td>
						<input type="text" id="insUnit" name="insUnit.id" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保险到期时间：</td>
					<td>
						<input type="text" id="expireDate" name="expireDate" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">经&nbsp;办&nbsp;人：</td>
					<td>
						<input id="operator" name="operator.id"/>
					</td>
				</tr>	
				<tr>
					<td style="text-align: rigth;">保险备注：</td>
					<td>
						<input type="text" id="remarks" name="remarks" maxlength="100"/>
					</td>
				</tr>
							
			</table>
			
		</form>
	</div>
  </body>
</html>

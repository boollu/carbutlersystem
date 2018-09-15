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
		$('#drirec_dg').datagrid({
            url:'<%=basePath%>drirec_findDRDG.action',
            fitColumns:true,
            pagination:true,
            rownumbers:true,
            toolbar: '#drirec_tb',
            columns:[[
				{field:'id',title:'编号',checkbox:true},
                {field:'car',title:'车牌号码',formatter:function(v,r,i){
                	return v.carNo;
                }},
                {field:'dept',title:'部门',formatter:function(v,r,i){
                	return v.text;
                }},
                {field:'begin_time',title:'出车时间',formatter: function(v,r,i){
					return formatTime(v);
				}},
				{field:'pre_backtime',title:'预计回车时间',formatter: function(v,r,i){
					return formatTime(v);
				}},
				{field:'backtime',title:'回车时间',formatter: function(v,r,i){
					return v==null?'未回车':formatTime(v);
				}},
				{field:'personnel',title:'随行人员'},
				{field:'driver',title:'驾驶员',formatter:function(v,r,i){
					return v.name;						
				}},
				{field:'destination',title:'目的地'},
				{field:'this_mil',title:'本次行程',formatter:function(v,r,i){
					return v==null?'未回车':v;
				}},
				{field:'creater',title:'创建人员',formatter:function(v,r,i){
					return v.rname;						
				}},				
				{field:'null',title:'操作',formatter: function(v,r,i){
					var str='';
					
					if(r.backtime==null){
						str='未回车无法查看详细';						
					}else{
						str='<a href="javascript:showDetailed('+r.id+');">查看详细</a>';	
					}
					
					return str; 					
				}}
            ]]
        });
		/*数据表初始设置结束*****************************/
		
		/*搜索按钮事件设置,开始*****************************/
		$('#sel').searchbox({
			searcher:function(v,n){
				var params={};
				
				params['car.carNo']=v;
				
				$('#drirec_dg').datagrid('load',params);
			},
			menu:'#mm',
   			prompt:'此处输入车牌号码，支持模糊查询' 
		});
		/*搜索按钮事件设置,结束*****************************/
		
		
			$("#1").blur(function(){ 
				var lname=$.trim($("#1").val());
				//alert("11111111111")
				//将值传送到后台
			if(lname.length==0){
			$.messager.alert("警告","请添加目的地","warning"); 
			
			}
			});
		/*******************验证出车原因************/
				$("#2").blur(function(){ 
				var lname=$.trim($("#2").val());
		    //将值传送到后台
			if(lname.length==0){
			$.messager.alert("警告","请规范填写出车原因","warning"); 
			
			}
			});
		
		
		
		
		
		
		
		
		
		
		
		
		/*新增按钮事件设置,开始*****************************/
		$('#tb_add').on('click',function(){
			//填充车辆下拉列表
			var url='<%=basePath%>drirec_findCarListForAdd.action';
			var carKV={k:'id',v:'carNo'};
			initCombobox($('#drirec_addForm #car'),url,carKV,-1);
			
			//填充部门下拉列表
			var url='<%=basePath%>drirec_findDeptList.action';
			initCombobox($('#drirec_addForm #dept'),url,null,-1);
			
			//出车时间默认当前时间
			$('#drirec_addForm #begin_time').datetimebox('setValue',getNowTime());
			
			//填充驾驶员下拉列表
			var url='<%=basePath%>drirec_findDriverListForAdd.action';
			var driverKV={k:'id',v:'name'};
			initCombobox($('#drirec_addForm #driver'),url,driverKV,-1);
			
			$('#drirec_addDialog').dialog('open');					
		});			
		/*新增按钮事件设置,结束*****************************/
		
		/*修改按钮事件设置,开始*****************************/
		$('#tb_edit').on('click',function(){
			//未选中提示
   			var rows=$('#drirec_dg').datagrid('getChecked');
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
			
			//不可修改提示【已回车不许编辑】
			if(rows[0].backtime !=null){
				$.messager.alert('提示','已回车，不允许修改内容','warning');
				$('#drirec_dg').datagrid('unselectAll');
				return;
			}
			
			//主键ID
			var id=rows[0].id;
			var params={"id":id};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>drirec_findDRById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定数据
					updDataBind(data);
					
					$('#drirec_updDialog').dialog('open');		
				}
			});
		});		
		/*修改按钮事件设置,结束*****************************/
		
		/*回车信息按钮事件设置,开始*****************************/
		$('#tb_back').on('click',function(){
			//未选中提示
   			var rows=$('#drirec_dg').datagrid('getChecked');
   			if(rows.length==0){
				$.messager.show({
					title : '提示',
					msg : '请勾选要回车的出车记录！'
				});
				return;
			}
			//选中多笔提示
			if(rows.length>1){
				$.messager.show({
					title : '提示',
					msg : '回车时只能选择一条出车记录！'
				});
				return;
			}
			//不可回车提示【已回车不许再次回车】
			if(rows[0].backtime !=null){
				$.messager.alert('提示','该记录已回车','warning');
				$('#drirec_dg').datagrid('unselectAll');
				return;
			}			
			
			//主键ID
			var id=rows[0].id;
			var params={"id":id};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>drirec_findDRById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定待回车数据
					backDataBind(data);
					
					$('#drirec_backDialog').dialog('open');		
				}
			});
		});		
		/*回车信息按钮事件设置,结束*****************************/
		
		/*删除按钮事件设置,开始*****************************/
		$('#tb_remove').on('click',function(){
			//未选中提示
   			var rows=$('#drirec_dg').datagrid('getChecked');
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
						url:'<%=basePath%>drirec_del.action',
						data:params,
						dataType:'json',
						type:'POST',
						success:function(data){
							if(data.success){
								//去除选择
								$('#drirec_dg').datagrid('unselectAll');
								//刷新dg
								$('#drirec_dg').datagrid('reload');
							}
							
							$.messager.show({
								title:'提示消息',
								msg:data.msg
							});								
						}
					});
				}else{
					$('#drirec_dg').datagrid('unselectAll');
				}
			});
			
		});
		/*删除按钮事件设置,结束*****************************/
	});
	
	
	
	/*绑定待修改内容开始*****************************/ 
	function updDataBind(data){
		//绑定数据开始
					
		//填充车辆下拉列表
		var url='<%=basePath%>drirec_findCarListForUpd.action';
		var carKV={k:'id',v:'carNo'};
		initCombobox($('#drirec_updForm #car'),url,carKV,data.car.id);
		
		//填充部门下拉列表
		var url='<%=basePath%>drirec_findDeptList.action';
		initCombobox($('#drirec_updForm #dept'),url,null,data.dept.id);
		
		//出车时间
		$('#drirec_updForm #begin_time').datetimebox('setValue',formatTime(data.begin_time));
		
		//填充驾驶员下拉列表
		var url='<%=basePath%>drirec_findDriverListForUpd.action';
		var driverKV={k:'id',v:'name'};
		initCombobox($('#drirec_updForm #driver'),url,driverKV,data.driver.id);
				
		$('#drirec_updForm [name=id]').val(data.id);
		$('#drirec_updForm #begin_time').datebox('setValue',formatTime(data.begin_time));
		$('#drirec_updForm #pre_backtime').datebox('setValue',formatTime(data.pre_backtime));
		$('#drirec_updForm [name=personnel]').val(data.personnel);
		$('#drirec_updForm [name=destination]').val(data.destination);
		$('#drirec_updForm [name=reason]').val(data.reason);
		$('#drirec_updForm #start_mil').numberbox('setValue',data.start_mil);
		
		//绑定数据结束
	}
	/*绑定待修改内容结束*****************************/
	
	/*绑定待回车内容开始*****************************/ 
	function backDataBind(data){
		//绑定数据开始 drirec_backDialog drirec_backForm
					
		//填充车辆下拉列表
		var url='<%=basePath%>drirec_findCarListForUpd.action';
		var carKV={k:'id',v:'carNo'};
		initCombobox($('#drirec_backForm #car'),url,carKV,data.car.id);
		
		//填充驾驶员下拉列表
		var url='<%=basePath%>drirec_findDriverListForUpd.action';
		var driverKV={k:'id',v:'name'};
		initCombobox($('#drirec_backForm #driver'),url,driverKV,data.driver.id);
				
		$('#drirec_backForm [name=id]').val(data.id);
		$('#drirec_backForm #begin_time').datebox('setValue',formatTime(data.begin_time));
		$('#drirec_backForm #backtime').datetimebox('setValue',getNowTime());
		$('#drirec_backForm #start_mil').numberbox('setValue',data.start_mil);
		
		//绑定数据结束
	}
	/*绑定待回车内容结束*****************************/
	
	/*展示详细内容，此方法必须声明在初始方法外,开始*****************************/ 
	function showDetailed(id){
		//参数容器
		var params={};
		params['id']=id;
		
		//取得数据
		$.ajax({
			url:'<%=basePath%>drirec_findDRById.action',
			data:params,
			dataType:'json',
			type:'POST',
			success:function(data){
				//绑定数据开始				
				$('#drirec_showDialog #car').html(data.car.carNo);
				$('#drirec_showDialog #dept').html(data.dept.text);
				$('#drirec_showDialog #begin_time').html(formatTime(data.begin_time));
				$('#drirec_showDialog #pre_backtime').html(formatTime(data.pre_backtime));
				$('#drirec_showDialog #backtime').html(formatTime(data.backtime));
				$('#drirec_showDialog #driver').html(data.driver.name);
				$('#drirec_showDialog #personnel').html(data.personnel);
				$('#drirec_showDialog #destination').html(data.destination);
				$('#drirec_showDialog #reason').html(data.reason);
				$('#drirec_showDialog #start_mil').html(data.start_mil);
				$('#drirec_showDialog #return_mil').html(data.return_mil);
				$('#drirec_showDialog #this_mil').html(data.this_mil);
				$('#drirec_showDialog #park_place').html(data.park_place);
				$('#drirec_showDialog #remarks').html(data.remarks);
				$('#drirec_showDialog #creater').html(data.creater.rname);
				
				//绑定数据结束
				
				$('#drirec_showDialog').dialog('open');
			}
		});
		
	}	
	/*展示详细内容，此方法必须声明在初始方法外,结束*****************************/
	
	
	</script>

  </head>
  
  <body>
    <!-- 数据展示窗体创建位置 --> 
  	<table id="drirec_dg"></table>
  	
  	<!-- 数据工具栏创建位置 -->   
	<div id="drirec_tb">
		<a class="easyui-linkbutton" id="tb_add" data-options="iconCls:'icon-add',plain:true" style="float:left;">出车信息登记</a>
		<div class="datagrid-btn-separator"></div>		
		<a class="easyui-linkbutton" id="tb_edit" data-options="iconCls:'icon-edit',plain:true" style="float:left;">出车信息编辑</a>
		<div class="datagrid-btn-separator"></div>
		<a class="easyui-linkbutton" id="tb_back" data-options="iconCls:'icon-add',plain:true" style="float:left;">回车信息登记</a>
		<div class="datagrid-btn-separator"></div>	
		<a class="easyui-linkbutton" id="tb_remove" data-options="iconCls:'icon-remove',plain:true" style="float:left;">出车信息删除</a>
		<div class="datagrid-btn-separator"></div>
		
    	<!-- 搜索框div创建位置 --> 
    	&nbsp;
		<input style="width:350px" id="sel"></input> 
		<div id="mm" style="width:120px">
			<div data-options="name:'name'">车牌号码</div>
		</div>
	</div>
	
	<!-- 详细窗体创建位置 -->
	<div id="drirec_showDialog" class="easyui-dialog" title="出车详细信息" 
		style="width:400px;height:500px;align:center;top:1px;"   
        data-options="iconCls:'icon-tip',resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#drirec_dg').datagrid('unselectAll');
				$('#drirec_showDialog').dialog('close');
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
				<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
				<td>
					<span id="dept"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">出车时间：</td>
				<td>
					<span id="begin_time"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">预计回车时间：</td>
				<td>
					<span id="pre_backtime"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">回车时间：</td>
				<td>
					<span id="backtime"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">驾&nbsp;驶&nbsp;员：</td>
				<td>
					<span id="driver"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">随行人员：</td>
				<td>
					<span id="personnel"></span>
				</td>
			</tr>			
			<tr>
				<td style="text-align: rigth;">目&nbsp;的&nbsp;地：</td>
				<td>
					<span id="destination"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">出车原因：</td>
				<td>
					<span id="reason"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">开始里程（公里）：</td>
				<td>
					<span id="start_mil"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">回车里程（公里）：</td>
				<td>
					<span id="return_mil"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">本次里程（公里）：</td>
				<td>
					<span id="this_mil"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">停放位置：</td>
				<td>
					<span id="park_place"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">备&nbsp;&nbsp;注：</td>
				<td>
					<span id="remarks"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">创建人员：</td>
				<td>
					<span id="creater"></span>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- 新增窗体创建位置 -->
	<div id="drirec_addDialog" class="easyui-dialog" title="出车信息登记" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#drirec_addForm').form('submit',{
					url:'<%=basePath%>drirec_add.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#drirec_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#drirec_addForm').form('clear');
							//关闭表单
							$('#drirec_addDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#drirec_addForm #begin_time').datetimebox('getValue');
						var eTime=$('#drirec_addForm #pre_backtime').datetimebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','预计回车时间必须大于出车时间','warning');
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
				$('#drirec_addDialog').dialog('close');
			}
		}]">
		<form id="drirec_addForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" id="car" name="car.id" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
					<td>
						<input id="dept" name="dept.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">出车时间：</td>
					<td>
						<input type="text" id="begin_time" name="begin_time" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">预计回车时间：</td>
					<td>
						<input type="text" id="pre_backtime" name="pre_backtime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">随行人员：</td>
					<td>
						<input type="text" name="personnel" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾&nbsp;驶&nbsp;员：</td>
					<td>
						<input id="driver" name="driver.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">目&nbsp;的&nbsp;地：</td>
					<td>
						<input type="text" name="destination" id="1" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">出车原因：</td>
					<td>
						<input type="text" name="reason" id="2"  maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">开始里程（公里）：</td>
					<td>
						<input type="text" name="start_mil" data-options="min:0,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
			</table>
			
		</form>
	</div>
	
	<!-- 修改窗体创建位置 -->
	<div id="drirec_updDialog" class="easyui-dialog" title="出车信息修改" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-edit',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#drirec_updForm').form('submit',{
					url:'<%=basePath%>drirec_upd.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//去除选择
							$('#drirec_dg').datagrid('unselectAll');
							//成功后清空表单数据
							$('#drirec_updForm').form('clear');
							//刷新dg
							$('#drirec_dg').datagrid('reload');
							//关闭表单
							$('#drirec_updDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#drirec_updForm #begin_time').datetimebox('getValue');
						var eTime=$('#drirec_updForm #pre_backtime').datetimebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','预计回车时间必须大于出车时间','warning');
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
				//去除选择
				$('#drirec_dg').datagrid('unselectAll');
				$('#drirec_updDialog').dialog('close');
			}
		}]">
		<form id="drirec_updForm" method="post">
			<table>
				<tr>
					<td><input type="hidden" name="id"/></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" id="car" name="car.id" disabled="disabled"/>						
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
					<td>
						<input id="dept" name="dept.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">出车时间：</td>
					<td>
						<input type="text" id="begin_time" name="begin_time" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">预计回车时间：</td>
					<td>
						<input type="text" id="pre_backtime" name="pre_backtime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">随行人员：</td>
					<td>
						<input type="text" name="personnel" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾&nbsp;驶&nbsp;员：</td>
					<td>
						<input id="driver" name="driver.id" disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">目&nbsp;的&nbsp;地：</td>
					<td>
						<input type="text" name="destination" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">出车原因：</td>
					<td>
						<input type="text" name="reason" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">开始里程（公里）：</td>
					<td>
						<input type="text" id="start_mil" name="start_mil" data-options="min:0,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
			</table>
			
		</form>
	</div>
	
	<!-- 回车登记窗体创建位置 -->
	<div id="drirec_backDialog" class="easyui-dialog" title="回车信息登记" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-edit',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#drirec_backForm').form('submit',{
					url:'<%=basePath%>drirec_back.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//去除选择
							$('#drirec_dg').datagrid('unselectAll');
							//成功后清空表单数据
							$('#drirec_backForm').form('clear');
							//刷新dg
							$('#drirec_dg').datagrid('reload');
							//关闭表单
							$('#drirec_backDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					},
					onSubmit:function(){
						var bTime=$('#drirec_backForm #begin_time').datetimebox('getValue');
						var eTime=$('#drirec_backForm #backtime').datetimebox('getValue');
						
						if(!compareTime(bTime,eTime)){
							$.messager.alert('提示','回车时间必须大于出车时间','warning');
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
				//去除选择
				$('#drirec_dg').datagrid('unselectAll');
				$('#drirec_backDialog').dialog('close');
			}
		}]">
		<form id="drirec_backForm" method="post">
			<table>
				<tr>
					<td><input type="hidden" name="id"/></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" id="car" name="car.id" disabled="disabled"/>						
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾&nbsp;驶&nbsp;员：</td>
					<td>
						<input type="text" id="driver" name="driver.id" disabled="disabled"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">出车时间：</td>
					<td>
						<input type="text" id="begin_time" name="begin_time" class="easyui-datetimebox" disabled="disabled" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">回车时间：</td>
					<td>
						<input type="text" id="backtime" name="backtime" class="easyui-datetimebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">开始里程（公里）：</td>
					<td>
						<input type="text" id="start_mil" name="start_mil" data-options="min:0,precision:2" disabled="disabled" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">回车里程（公里）：</td>
					<td>
						<input type="text" id="return_mil" name="return_mil" data-options="min:0,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">停放位置：</td>
					<td>
						<input type="text" name="park_place" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">备&nbsp;&nbsp;注：</td>
					<td>
						<input type="text" name="remarks" maxlength="50"/>
					</td>
				</tr>
				
			</table>
			
		</form>
	</div>
  </body>
</html>

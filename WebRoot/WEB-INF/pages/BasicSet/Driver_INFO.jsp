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
			$('#dri_dg').datagrid({
	            url:'<%=basePath%>driver_findDriDG.action',
	            fitColumns:true,
	            pagination:true,
	            rownumbers:true,
	            toolbar: '#dri_tb',
	            columns:[[
					{field:'id',title:'编号',checkbox:true},
	                {field:'name',title:'姓名'},
	                {field:'dept',title:'部门',formatter:function(v,r,i){
	                	return v.text;
	                }},
	                {field:'gender',title:'性别',formatter: function(v,r,i){
						return v=='M'?'男':'女';
					}},
					{field:'phone',title:'电话'},
					{field:'entrytime',title:'入职时间',formatter:function(v,r,i){
						return formatDate(v);						
					}},
					{field:'driverNo',title:'驾照号码'},
					{field:'driverType',title:'驾照类型',formatter: function(v,r,i){
						return v.text;
					}},
					{field:'isdisable',title:'是否启用',formatter: function(v,r,i){
						return v==1?'启用':'禁用';
					}},
					{field:'null',title:'操作',formatter: function(v,r,i){
						return '<a href="javascript:showDetailed('+r.id+');">查看详细</a>';						
					}}
	            ]]
	        });
			/*数据表初始设置结束*****************************/  
			
			/*新增按钮事件设置,开始*****************************/
			$('#tb_add').on('click',function(){
				
				//填充部门下拉列表
				var url='<%=basePath%>driver_findDeptList.action';
				initCombobox($('#dri_addForm #dept'),url,null,-1);
				
				//入职时间默认当前时间
				$('#dri_addForm #entrytime').datebox('setValue',getNowDate());
				
				//填充驾照类型下拉列表
				var url='<%=basePath%>driver_findDriTypeList.action';
				initCombobox($('#dri_addForm #driType'),url,null,-1);
				
				$('#dri_addDialog').dialog('open');					
			});			
			/*新增按钮事件设置,结束*****************************/
			
			
			
			/*修改按钮事件设置,开始*****************************/
			$('#tb_edit').on('click',function(){
				//未选中提示
    			var rows=$('#dri_dg').datagrid('getChecked');
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
					url:'<%=basePath%>driver_findDriById.action',
					data:params,
					dataType:'json',
					type:'POST',
					success:function(data){
						//绑定数据
						updDataBind(data);
						
						$('#dri_updDialog').dialog('open');		
					}
				});
							
			});
			/*修改按钮事件设置,结束*****************************/	
			
			/*删除按钮事件设置,开始*****************************/
			$('#tb_remove').on('click',function(){
				//未选中提示
    			var rows=$('#dri_dg').datagrid('getChecked');
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
				
				//删除数据
				$.messager.confirm('确认','您确认想要删除记录吗？',function(r){
					if(r){
						$.ajax({
							url:'<%=basePath%>driver_del.action',
							data:params,
							dataType:'json',
							type:'POST',
							success:function(data){
								if(data.success){
									//去除选择
									$('#dri_dg').datagrid('unselectAll');
									//刷新dg
									$('#dri_dg').datagrid('reload');
								}
								
								$.messager.show({
									title:'提示消息',
									msg:data.msg
								});	
									
							}
						});
					}else{
						//去除选择
						$('#dri_dg').datagrid('unselectAll');
					}
				});		
				
				
			});
			/*删除按钮事件设置,结束*****************************/
			
			/*搜索按钮事件设置,开始*****************************/
			$('#sel').searchbox({
				searcher:function(v,n){
					var params={};
					
					if(n=='驾驶员姓名'){
						params['name']=v;
					}else if(n=='驾驶证号码'){
						params['driverNo']=v;
					}
					
					$('#dri_dg').datagrid('load',params);
				},
				menu:'#mm',
    			prompt:'此处输入姓名或驾照号码，支持模糊查询' 
			});
			/*搜索按钮事件设置,结束*****************************/				
			
		});	
				
		/*展示详细内容，此方法必须声明在初始方法外,开始*****************************/ 
		function showDetailed(id){
			//参数容器
			var params={};
			params['id']=id;
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>driver_findDriById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定数据开始
					$('#dri_showDialog #name').html(data.name);
					$('#dri_showDialog #dept').html(data.dept.text);
					$('#dri_showDialog #gender').html(data.gender==1?'男':'女');
					$('#dri_showDialog #card').html(data.card);					
					$('#dri_showDialog #phone').html(data.phone);
					$('#dri_showDialog #entrytime').html(formatDate(data.entrytime));
					$('#dri_showDialog #address').html(data.address);
					$('#dri_showDialog #driver_no').html(data.driverNo);
					$('#dri_showDialog #driver_type').html(data.driverType.text);
					$('#dri_showDialog #remarks').html(data.remarks);
					$('#dri_showDialog #isdisable').html(data.isdisable==1?'启用':'禁用');
					//绑定数据结束
					
					$('#dri_showDialog').dialog('open');
				}
			});
			
		}
		
		/*展示详细内容，此方法必须声明在初始方法外,结束*****************************/
		
		/*绑定待修改内容开始*****************************/ 
		function updDataBind(data){
			//绑定数据开始
						
			//填充部门下拉列表
			var url='<%=basePath%>driver_findDeptList.action';
			initCombobox($('#dri_updForm #dept'),url,null,data.dept.id);
			
			//填充驾照类型下拉列表
			var url='<%=basePath%>driver_findDriTypeList.action';
			initCombobox($('#dri_updForm #driType'),url,null,data.driverType.id);	
					
			$('#dri_updForm [name=id]').val(data.id);
			$('#dri_updForm [name=name]').val(data.name);
			$('#dri_updForm [name=gender][value='+data.gender+']').prop('checked',true);
			$('#dri_updForm #birthday').datebox('setValue',formatDate(data.birthday));
			$('#dri_updForm [name=card]').val(data.card);					
			$('#dri_updForm [name=phone]').val(data.phone);
			$('#dri_updForm #entrytime').datebox('setValue',formatDate(data.entrytime));
			$('#dri_updForm [name=address]').val(data.address);
			$('#dri_updForm [name=driverNo]').val(data.driverNo);
			$('#dri_updForm [name=remarks]').val(data.remarks);
			$('#dri_updForm [name=isdisable][value='+data.isdisable+']').prop('checked',true);
						
			//绑定数据结束
		}
		/*绑定待修改内容结束*****************************/
		
	</script>
  </head>
  
  <body>
    <!-- 数据展示窗体创建位置 --> 
  	<table id="dri_dg"></table>
  	
  	<!-- 数据工具栏创建位置 -->   
	<div id="dri_tb">
		<a class="easyui-linkbutton" id="tb_add" data-options="iconCls:'icon-add',plain:true" style="float:left;">新增</a>
		<div class="datagrid-btn-separator"></div>		
		<a class="easyui-linkbutton" id="tb_edit" data-options="iconCls:'icon-edit',plain:true" style="float:left;">编辑</a>
		<div class="datagrid-btn-separator"></div>
		<a class="easyui-linkbutton" id="tb_remove" data-options="iconCls:'icon-remove',plain:true" style="float:left;">删除</a>
		<div class="datagrid-btn-separator"></div>
		
    	<!-- 搜索框div创建位置 --> 
    	&nbsp;
		<input style="width:350px" id="sel"></input> 
		<div id="mm" style="width:120px">
			<div data-options="name:'name'">驾驶员姓名</div>
			<div data-options="name:'driverNo'">驾驶证号码</div>
		</div>
	</div>
	
	<!-- 详细窗体创建位置 -->
	<div id="dri_showDialog" class="easyui-dialog" title="驾驶员详细信息" 
		style="width:400px;height:350px;align:center;"   
        data-options="iconCls:'icon-tip',resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#dri_dg').datagrid('unselectAll');
				$('#dri_showDialog').dialog('close');
			}
		}]">
		<table>
			<tr>
				<td style="text-align:rigth;">姓&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
				<td>
					<span id="name"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
				<td>
					<span id="dept"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">性&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
				<td>
					<span id="gender"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">生&nbsp;&nbsp;&nbsp;&nbsp;日：</td>
				<td>
					<span id="birthday"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">身&nbsp;份&nbsp;证：</td>
				<td>
					<span id="card"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
				<td>
					<span id="phone"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">入职时间：</td>
				<td>
					<span id="entrytime"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">地&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
				<td>
					<span id="address"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">驾照号码：</td>
				<td>
					<span id="driver_no"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">驾照类型：</td>
				<td>
					<span id="driver_type"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">备&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
				<td>
					<span id="remarks"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">状&nbsp;&nbsp;&nbsp;&nbsp;态：</td>
				<td>
					<span id="isdisable"></span>
				</td>
			</tr>
		</table>
	</div>
	
	<!-- 新增窗体创建位置 -->
	<div id="dri_addDialog" class="easyui-dialog" title="新增驾驶员信息" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#dri_addForm').form('submit',{
					url:'<%=basePath%>driver_add.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#dri_dg').datagrid('reload');
						
							//成功后清空表单数据
							$('#dri_addForm').form('clear');
							//关闭表单
							$('#dri_addDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					}
				});
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				$('#dri_addDialog').dialog('close');
			}
		}]">
		<form id="dri_addForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">姓&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
					<td>
						<input type="text" name="name" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
					<td>
						<input id="dept" name="dept.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">性&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
					<td>
						<input type="radio" name="gender" value="M" checked="checked" />男
						<input type="radio" name="gender" value="F" />女
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">生&nbsp;&nbsp;&nbsp;&nbsp;日：</td>
					<td>
						<input type="text" name="birthday" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">身&nbsp;份&nbsp;证：</td>
					<td>
						<input type="text" name="card" maxlength="18"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
					<td>
						<input type="text" name="phone" maxlength="11"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">入职时间：</td>
					<td>
						<input type="text" id="entrytime" name="entrytime" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">地&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
					<td>
						<input type="text" name="address" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾照号码：</td>
					<td>
						<input type="text" name="driverNo" maxlength="18"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾照类型：</td>
					<td>
						<input id="driType" name="driverType.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">备&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
					<td>
						<input type="text" name="remarks" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">状&nbsp;&nbsp;&nbsp;&nbsp;态：</td>
					<td>
						<input type="radio" name="isdisable" value="1" checked="checked" />启用
						<input type="radio" name="isdisable" value="0" />禁用
					</td>
				</tr>
			</table>
			
		</form>
	</div> 
	
	<!-- 修改窗体创建位置 -->
	<div id="dri_updDialog" class="easyui-dialog" title="修改驾驶员信息" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-edit',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#dri_updForm').form('submit',{
					url:'<%=basePath%>driver_upd.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//去除选择
							$('#dri_dg').datagrid('unselectAll');
							//成功后清空表单数据
							$('#dri_updForm').form('clear');
							//刷新dg
							$('#dri_dg').datagrid('reload');
							//关闭表单
							$('#dri_updDialog').dialog('close');
						}
						$.messager.show({
							title:'提示',
							msg:obj.msg
						});
					}
				});
			}
		},{
			text:'取消',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#dri_dg').datagrid('unselectAll');
				$('#dri_updDialog').dialog('close');
			}
		}]">
		<form id="dri_updForm" method="post">
			<table>
				<tr>
					<td><input type="hidden" name="id"/></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">姓&nbsp;&nbsp;&nbsp;&nbsp;名：</td>
					<td>
						<input type="text" name="name" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
					<td>
						<input name="dept.id" id="dept"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">性&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
					<td>
						<input type="radio" name="gender" value="M" checked="checked" />男
						<input type="radio" name="gender" value="F" />女
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">生&nbsp;&nbsp;&nbsp;&nbsp;日：</td>
					<td>
						<input type="text" id="birthday" name="birthday" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">身&nbsp;份&nbsp;证：</td>
					<td>
						<input type="text" name="card" maxlength="18"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
					<td>
						<input type="text" name="phone" maxlength="11"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">入职时间：</td>
					<td>
						<input type="text" id="entrytime" name="entrytime" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">地&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
					<td>
						<input type="text" name="address" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾照号码：</td>
					<td>
						<input type="text" name="driverNo" maxlength="18"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">驾照类型：</td>
					<td>
						<input id="driType" name="driverType.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">备&nbsp;&nbsp;&nbsp;&nbsp;注：</td>
					<td>
						<input type="text" name="remarks" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">状&nbsp;&nbsp;&nbsp;&nbsp;态：</td>
					<td>
						<input type="radio" name="isdisable" value="1" checked="checked" />启用
						<input type="radio" name="isdisable" value="0" />禁用
					</td>
				</tr>
			</table>
			
		</form>
	</div> 	
  </body>
</html>

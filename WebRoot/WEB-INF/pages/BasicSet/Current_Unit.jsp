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
		$('#unit_dg').datagrid({
            url:'<%=basePath%>cu_findpageAll.action',
            
            fitColumns:true,
            pagination:true,
            rownumbers:true,
            toolbar: '#unit_tb',
            columns:[[
				{field:'id',title:'编号',checkbox:true},
                {field:'unitName',title:'单位名称'},
                {field:'unitType',title:'单位类型',formatter: function(v,r,i){
					return v.text;
				}},
				{field:'tel',title:'单位电话'},
				{field:'contacts',title:'联系人'},
				{field:'isdisable',title:'是否启用',formatter: function(v,r,i){
					return v==1?'启用':'禁用';
				}},
				{field:'null',title:'操作',formatter: function(v,r,i){
					return '<a href="javascript:showDetailed('+r.id+');">查看详细</a>';						
				}}
            ]]
        });
		alert("表格赋值完毕！");
		/*数据表初始设置结束*****************************/
		
		/*修改按钮事件设置,开始*****************************/
		$('#tb_edit').on('click',function(){
			//未选中提示
   			var rows=$('#unit_dg').datagrid('getChecked');
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
				url:'<%=basePath%>cu_findCUById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//绑定数据
					updDataBind(data);
					
					$('#unit_updDialog').dialog('open');		
				}
			});
						
		});
		/*修改按钮事件设置,结束*****************************/	
		
		/*新增按钮事件设置,开始*****************************/
		$('#tb_add').on('click',function(){
			
			//填充部门下拉列表
			var url='<%=basePath%>cu_findUnitTypeList.action';
			initCombobox($('#unit_addForm #unitType'),url,null,-1);			
			
			$('#unit_addDialog').dialog('open');					
		});			
		/*新增按钮事件设置,结束*****************************/
		
		/*删除按钮事件设置,开始*****************************/
		$('#tb_remove').on('click',function(){
			//未选中提示
   			var rows=$('#unit_dg').datagrid('getChecked');
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
						//删除数据
						$.ajax({
							url:'<%=basePath%>cu_del.action',
							data:params,
							dataType:'json',
							type:'POST',
							success:function(data){
								if(data.success){
									//去除选择
									$('#unit_dg').datagrid('unselectAll');						
									//刷新dg
									$('#unit_dg').datagrid('reload');
								}
								$.messager.show({
									title:'提示',
									msg:obj.msg
								});
								
							}
						});
					}else{
						//去除选择
						$('#unit_dg').datagrid('unselectAll');
					}
			});
			
			
		});		
		/*删除按钮事件设置,结束*****************************/
		
		
		/*搜索按钮事件设置,开始*****************************/
		$('#sel').searchbox({
			searcher:function(v,n){
				var params={};
				
				params['unitName']=v;
				
				$('#unit_dg').datagrid('load',params);
			},
			menu:'#mm',
   			prompt:'此处输入单位名称，支持模糊查询' 
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
			url:'<%=basePath%>cu_findCUById.action',
			data:params,
			dataType:'json',
			type:'POST',
			success:function(data){
				//绑定数据开始
				$('#unit_showDialog #unitName').html(data.unitName);
				$('#unit_showDialog #unitType').html(data.unitType.text);
				$('#unit_showDialog #address').html(data.address);
				$('#unit_showDialog #tel').html(data.tel);
				$('#unit_showDialog #contacts').html(data.contacts);
				$('#unit_showDialog #remarks').html(data.remarks);
				$('#unit_showDialog #isdisable').html(data.isdisable==1?'启用':'禁用');
				//绑定数据结束
				
				$('#unit_showDialog').dialog('open');
			}
		});
	}
	/*展示详细内容，此方法必须声明在初始方法外,结束*****************************/
	
	/*绑定待修改内容开始*****************************/ 
	function updDataBind(data){
		//绑定数据开始
					
		//填充单位类型下拉列表
		var url='<%=basePath%>cu_findUnitTypeList.action';
		initCombobox($('#unit_updForm #unitType'),url,null,data.unitType.id);
						
		$('#unit_updForm [name=id]').val(data.id);
		$('#unit_updForm [name=unitName]').val(data.unitName);
		$('#unit_updForm [name=address]').val(data.address);
		$('#unit_updForm [name=tel]').val(data.tel);
		$('#unit_updForm [name=contacts]').val(data.contacts);
		$('#unit_updForm [name=remarks]').val(data.remarks);
		$('#unit_updForm [name=isdisable][value='+data.isdisable+']').prop('checked',true);
					
		//绑定数据结束
	}
	/*绑定待修改内容结束*****************************/
	</script>

  </head>
  
  <body>
    <!-- 数据展示窗体创建位置 --> 
  	<table id="unit_dg"></table>
  	
  	<div id="unit_tb">
		<a class="easyui-linkbutton" id="tb_add" data-options="iconCls:'icon-add',plain:true" style="float:left;">新增</a>
		<div class="datagrid-btn-separator"></div>		
		<a class="easyui-linkbutton" id="tb_edit" data-options="iconCls:'icon-edit',plain:true" style="float:left;">编辑</a>
		<div class="datagrid-btn-separator"></div>
		<a class="easyui-linkbutton" id="tb_remove" data-options="iconCls:'icon-remove',plain:true" style="float:left;">删除</a>
		<div class="datagrid-btn-separator"></div>
		
    	<!-- 搜索框div创建位置 --> 
    	&nbsp;
		<input style="width:300px" id="sel"></input> 
		<div id="mm" style="width:120px">
			<div data-options="name:'name'">单位名称</div>
		</div>
	</div>
	
	
	<!-- 详细窗体创建位置 -->
	<div id="unit_showDialog" class="easyui-dialog" title="往来单位详细信息" 
		style="width:400px;height:350px;align:center;"   
        data-options="iconCls:'icon-tip',resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#unit_dg').datagrid('unselectAll');
				$('#unit_showDialog').dialog('close');
			}
		}]">
		<table>
			<tr>
				<td style="text-align:rigth;">单位名称：</td>
				<td>
					<span id="unitName"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">单位类型：</td>
				<td>
					<span id="unitType"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">单位地址：</td>
				<td>
					<span id="address"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">联系电话：</td>
				<td>
					<span id="tel"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">联&nbsp;系&nbsp;人：</td>
				<td>
					<span id="contacts"></span>
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
	<div id="unit_addDialog" class="easyui-dialog" title="添加往来单位信息" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#unit_addForm').form('submit',{
					url:'<%=basePath%>cu_add.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//去除选择
							$('#unit_dg').datagrid('unselectAll');
							//成功后清空表单数据
							$('#unit_addForm').form('clear');
							//刷新dg
							$('#unit_dg').datagrid('reload');
							//关闭表单
							$('#unit_addDialog').dialog('close');
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
				$('#unit_dg').datagrid('unselectAll');
				$('#unit_addDialog').dialog('close');
			}
		}]">
		
		<form id="unit_addForm" method="post">
			<table>
				<tr>
					<td><input type="hidden" name="id"/></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">单位名称：</td>
					<td>
						<input type="text" name="unitName" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">单位类型：</td>
					<td>
						<input name="unitType.id" id="unitType"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">地&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
					<td>
						<input type="text" name="address"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
					<td>
						<input type="text" name="tel" maxlength="12"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">联&nbsp;系&nbsp;人：</td>
					<td>
						<input type="text" name="contacts"/>
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
	<div id="unit_updDialog" class="easyui-dialog" title="修改往来单位信息" 
		style="width:400px;height:450px;align:center;"   
        data-options="iconCls:'icon-edit',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#unit_updForm').form('submit',{
					url:'<%=basePath%>cu_upd.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//去除选择
							$('#unit_dg').datagrid('unselectAll');
							//成功后清空表单数据
							$('#unit_updForm').form('clear');
							//刷新dg
							$('#unit_dg').datagrid('reload');
							//关闭表单
							$('#unit_updDialog').dialog('close');
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
				$('#unit_dg').datagrid('unselectAll');
				$('#unit_updDialog').dialog('close');
			}
		}]">
		<form id="unit_updForm" method="post">
			<table>
				<tr>
					<td><input type="hidden" name="id"/></td>
					<td></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">单位名称：</td>
					<td>
						<input type="text" name="unitName" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">单位类型：</td>
					<td>
						<input name="unitType.id" id="unitType"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">地&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
					<td>
						<input type="text" name="address"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
					<td>
						<input type="text" name="tel" maxlength="12"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">联&nbsp;系&nbsp;人：</td>
					<td>
						<input type="text" name="contacts"/>
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


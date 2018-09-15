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
	<script type="text/javascript">
		$(function(){
			/************************联动下拉列表数据begin**************************/
			//数据表格开始
			$("#dic_dg").datagrid({
				url:"",
				toolbar:"#dic_tb",
				pagination:true,
				fitColumns:true,
				columns:[[ 
					{field : "id",title : "编号",checkbox: true},
					{field : "dic",title : "父类名称",
						formatter: function(value,row,index){
							if(value!=null){
								return value.text;
							}else{
								return value;
							}
						}
					},
					{field : "text",title : "文本"},
					{field : "isdisable",title : "是否启用",
						formatter: function(value,row,index){
								return row.isdisable==1?"启用":"禁用";
						}
					}
				]]
			});
			//初始化大分类
			initCombobox($("#dic_tb #max"),"dic_init.action",{"k":"id","v":"text"},true,-1);
			//给大分类添加选中事件（当大分类选中时初始化中分类）
			$("#dic_tb #max").combobox({
				onSelect:function(rec){
					//alert(rec.id+"一级目录"+rec.text);
					//初始化中分类										  pid=1;
					initCombobox($("#dic_tb #middle"),"dic_init.action?dic.id="+rec.id,{"k":"id","v":"text"},null,-1);
					//加载表格数据
					$("#dic_dg").datagrid({url:"dic_show.action?dic.id="+rec.id});
					//清空小分类的数据
					$("#dic_tb #min").combobox("clear");
					$("#dic_tb #min").combobox("loadData",[]);
				}
			});
			//给中分类添加选中事件，（当中分类选中时初始化小分类），并在中分类选中时在数据表格显示小分类并显示父类
			$("#dic_tb #middle").combobox({
				onSelect:function(rec){
					//alert(rec.id+"一级目录"+rec.text);
					//初始化小分类
					initCombobox($("#dic_tb #min"),"dic_init.action?dic.id="+rec.id,{"k":"id","v":"text"},null,-1);
					//加载表格数据
					$("#dic_dg").datagrid({url:"dic_show.action?dic.id="+rec.id});
				}
			});
			/************************联动下拉列表数据end***********************************/
			/************************添加数据字典begin***********************************/
			//给添加按钮添加单击事件
			$("#dic_add").on("click",function(){
				//打开添加窗口
				$("#dicadddialog").dialog("open");
				
			});
			
			//给添加窗口中的选择级别添加事件(给单选框添加单击事件)
			$("#dicaddform [type='radio'][name='lev']").on("click",function(){
				if($(this).val()==1){
					//清空下拉的数据
					$("#dicaddform #dic_add_select").combobox("clear");
					$("#dicaddform #dic_add_select").combobox("loadData",[{"id":-1,"text":"无"}]);
					$("#dicaddform #dic_add_select").combobox("select",-1);
				}else{
					initCombobox($("#dicaddform #dic_add_select"),"dic_initbylev.action?lev="+($(this).val()-1),{"k":"id","v":"text"},true,-1);
				}
			});
			
			//给添加dialog上面的ok添加事件
			$("#dicaddok").on("click",function(){
				//添加数据
				$("#dicaddform").form("submit", {    
				    url:"dic_add.action",
				    success:function(data){
					//将返回结果转换成JSON数据	
					var mes=$.parseJSON(data);
					//alert(mes.success);
					if(mes.success){
						//关闭添加dialog
						$("#dicadddialog").dialog("close");
						//刷新表格数据
						$("#dic_dg").datagrid("reload"); 
						//初始化大分类
						initCombobox($("#dic_tb #max"),"dic_init.action",{"k":"id","v":"text"},true,-1);
						//重置表单数据
						$("#dicaddform").form("reset");
						$("#dicaddform #dic_add_select").combobox("clear");
						$("#dicaddform #dic_add_select").combobox("loadData",[{"id":-1,"text":"无"}]);     
						$("#dicaddform #dic_add_select").combobox("select",-1);
					}
					//提示消息
					$.messager.show({
							title:"提示信息",
							msg:mes.msg
						});
				    }    
				});  
			});
			//给添加dialog上面的cancel添加事件
			$("#dicaddcancel").on("click",function(){
				//关闭添加dialog
				$("#dicadddialog").dialog("close");
			});
			
		//添加字典时判断当前数据库是否已存在该字典
		$("#dicaddform #text").on("blur",function(){
			$.post("dic_findText.action",{"text":$(this).val()},
				function(data){
					if(!data){
						$.messager.alert("警告","字典信息已存在，请重新输入","info");
					}
				},"json");
		});
		/************************添加数据字典end***********************************/
		
		/************************编辑数据字典begin*********************************/
		//给修改按钮添加单击事件
		$("#dic_edit").on("click",function(){
			//判断当前选中了多少条数据
			var rows=$("#dic_dg").datagrid("getChecked");
			if(rows.length!=1){
				if(rows.length<1){
					$.messager.show({
						title:"提示信息",
						msg:"请选择需要修改的数据"
					});
				}else{
					$.messager.show({
						title:"提示信息",
						msg:"修改的时候只能选择一条数据"
					});
				}  
			}else{
				$("#dicupdatedialog").dialog("open");
				alert(rows[0].id+"选中的ID")
				$.post("dic_findbyid.action",{"id":rows[0].id},function(data){
					//设置选中级别
					$("#dicupdateform [type='radio'][name='lev'][value='"+data.lev+"']").prop("checked",true);
					//初始化下拉菜单
					initCombobox($("#dicupdateform #dic_update_select"),"dic_initbylev.action?lev="+(data.lev-1),{"k":"id","v":"text"},true,data.dic.id);
					//初始化是否禁用
					$("#dicupdateform [type='radio'][name='isdisable'][value='"+data.isdisable+"']").prop("checked",true);
					//初始化文本数据
					$("#dicupdateform #text").val(data.text);
					//设置隐藏域ID
					$("#dicupdateform #id").val(data.id);
				},"json");
			
			}
	
		});
		//给修改dialog上面的ok添加事件
		$("#dicupdateok").on("click",function(){
			//修改数据
			$("#dicupdateform").form("submit", {    
			    url:"dic_update.action",
			    success:function(data){
					//将返回结果转换成JSON数据	
					var mes=$.parseJSON(data);
					if(mes.flag){
						//关闭添加dialog
						$("#dicupdatedialog").dialog("close");
						//刷新表格数据
						$("#dic_dg").datagrid("reload");  
						//重置表单数据
						$("#dicupdateform").form("reset");
						$("#dicupdateform #dic_update_select").combobox("clear");
						$("#dicupdateform #dic_update_select").combobox("loadData",[{"id":-1,"text":"无"}]);  
						$("#dicupdateform #dic_update_select").combobox("select",-1);
					}
					//提示消息
					$.messager.show({
							title:"提示信息",
							msg:mes.msg
					});
			    }    
			});  
		});
		//给修改dialog上面的cancel添加事件
		$("#dicupdatecancel").on("click",function(){
			//关闭修改dialog
			$("#dicupdatedialog").dialog("close");
		});

		//给修改窗口中的选择级别添加事件
		$("#dicupdateform [type='radio'][name='lev']").on("click",function(){
			if($(this).val()==1){
				
				//清空下拉的数据
				$("#dicupdateform #dic_update_select").combobox("clear");
				$("#dicupdateform #dic_update_select").combobox("loadData",[{"id":-1,"text":"无"}]);
				$("#dicupdateform #dic_update_select").combobox("select",-1);
			}else{
				initCombobox($("#dicupdateform #dic_update_select"),"dic_initbylev.action?lev="+($(this).val()-1),{"k":"id","v":"text"},true,-1);
			}
		});
		
		/************************编辑数据字典end*********************************/
		
	 });	
	</script>
  </head>
  
  <body>
    <!-- 数据展示窗体创建位置 --> 
  	<table id="dic_dg"></table>
  	
  	<!-- 数据工具栏创建位置 -->   
	<div id="dic_tb">
		<a class="easyui-linkbutton" id="dic_add" data-options="iconCls:'icon-add',plain:true" style="float:left;">新增</a>
		<div class="datagrid-btn-separator"></div>		
		<a class="easyui-linkbutton" id="dic_edit" data-options="iconCls:'icon-edit',plain:true" style="float:left;">编辑</a>
		<div class="datagrid-btn-separator"></div>
		
		<!-- 下拉框1,初始显示大分类 -->
		&nbsp;&nbsp;&nbsp;大分类：<input id="max" 
			class="easyui-combobox"
			name="max"   
    		data-options="valueField:'id',textField:'text'"/>
    	
    	<!-- 下拉框2,初始显示中分类 -->
    	&nbsp;&nbsp;&nbsp;中分类：<input id="middle" class="easyui-combobox" name="middle"/>
    	
    	<!-- 下拉框3,初始显示小分类 -->
    	&nbsp;&nbsp;&nbsp;小分类：<input id="min" class="easyui-combobox" name="min"/>
    	
	</div>
	
	<!-- 添加 -->
   	<div id="dicadddialog" class="easyui-dialog" title="新增字典信息" style="width:300px;height:220px;"   
	        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#dicadddialogtb'">   
	   <form id="dicaddform" method="post">
	    	<table>
				<tr>
					<td style="text-align: right;">选择级别：</td>
					<td>
						<input type="radio" name="lev" value="1" checked="checked"/>1级
						<input type="radio" name="lev" value="2"/>2级
						<input type="radio" name="lev" value="3"/>3级
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">上级菜单：</td>
					<td>
						<select id="dic_add_select" name="dic.id" class="easyui-combobox" style="width:143px;">
							<option value="-1">无</option> 
						</select>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">是否启用：</td>
					<td>
						<input type="radio" name="isdisable" value="1" checked="checked"/>启用
						<input type="radio" name="isdisable" value="0"/>禁用
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">字典文本：</td>
					<td>
						<input type="text" id="text" name="text" maxlength="10"/>
					</td>
				</tr>
			</table>
	    	
	   </form>  
	</div>   
   	 <div id="dicadddialogtb">
		<a id="dicaddok" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">保存</a>
		<a id="dicaddcancel" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">关闭</a>
	</div> 
	
	<!-- 编辑 -->
   	<div id="dicupdatedialog" class="easyui-dialog" title="修改字典信息" style="width:300px;height:220px;"   
	        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#dicupdatedialogtb'">   
	   <form id="dicupdateform" method="post">
	    	<table>
	    		<tr>
		   				<td colspan="2">
		   					<input type="hidden" name="id" id="id">
		   				</td>
		   		</tr>
				<tr>
					<td style="text-align: right;">选择级别：</td>
					<td>
						<input type="radio" name="lev" value="1" checked="checked"/>1级
						<input type="radio" name="lev" value="2"/>2级
						<input type="radio" name="lev" value="3"/>3级
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">上级菜单：</td>
					<td>
						<select id="dic_update_select" name="dic.id" class="easyui-combobox" style="width:143px;">
							<option value="-1">无</option> 
						</select>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">是否启用：</td>
					<td>
						<input type="radio" name="isdisable" value="1" checked="checked"/>启用
						<input type="radio" name="isdisable" value="0"/>禁用
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">字典文本：</td>
					<td>
						<input type="text" name="text" id="text" maxlength="10"/>
					</td>
				</tr>
			</table>
	    	
	   </form>  
	</div>   
   	 <div id="dicupdatedialogtb">
		<a id="dicupdateok" class="easyui-linkbutton" data-options="iconCls:'icon-ok'">保存</a>
		<a id="dicupdatecancel" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'">关闭</a>
	</div> 
 	
  </body>
</html>

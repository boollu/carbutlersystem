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
				$("#datagridRole").datagrid({    
				    url:"role_showRole.action",  //datagrid_data1.json
				    pagination:true,  
				    columns:[[   
				        {field:'id',title:'',width:100,checkbox:true},    
				        {field:'name',title:'角色名称',width:100},    
				    ]] ,
					toolbar: "#roletb"      
				});  
			//给添加角色图标添加点击事件	
			$("#addrole").click(
				//点击的时候让dialog弹出
				function(){
					$("#adddialog").dialog("open");					
				}
			);
			
			//给编辑角色图标添加点击事件	
			$("#editrole").click(
				//点击的时候让dialog弹出
				function(){
					//判断是否选中角色
					//获得所有选中的行对象
					var rowsObject= $("#datagridRole").datagrid("getChecked");
					if(1!=rowsObject.length){
						//没有选择角色的时候
						if(rowsObject.length<1){
								//提示框提示
					    		$.messager.show({
					    			title:"提示消息",
									msg:"请选择一个角色",
									timeout:2000,
									showType:'slide'
								});	
						}
						
						//选择多个角色的时候
						if(rowsObject.length>1){
								//提示框提示
					    		$.messager.show({
					    			title:"提示消息",
									msg:"只能选择一个角色",
									timeout:2000,
									showType:'slide'
								});	
						}
						
					}else{
						//alert(rowsObject[0].name);
						$("#editdialog").dialog("open");
						$("#id").val(rowsObject[0].id);//修改时需要传入id
						$("#editrolename").val(rowsObject[0].name);
							
					}
				
									
				}
			);
		/***********************************************/	
			//给授权角色图标添加点击事件	
			$("#grantrole").click(
				//点击的时候让dialog弹出
				function(){
					//判断是否选中角色
					//获得所有选中的行对象
					var rowsObject= $("#datagridRole").datagrid("getChecked");
					if(1!=rowsObject.length){
						//没有选择角色的时候
						if(rowsObject.length<1){
								//提示框提示
					    		$.messager.show({
					    			title:"提示消息",
									msg:"请选择一个角色",
									timeout:2000,
									showType:'slide'
								});	
						}
						
						//选择多个角色的时候
						if(rowsObject.length>1){
								//提示框提示
					    		$.messager.show({
					    			title:"提示消息",
									msg:"只能选择一个角色",
									timeout:2000,
									showType:'slide'
								});	
						}
						
					}else{
						$("#grantdialog").dialog("open");
						//加载树结构
						 $("#grantTree").tree({    
							    url:"role_showRoleTree.action?id="+rowsObject[0].id,
							    idFiled:"id",
							    textFiled:"text",
							    parentField:"pid",
							    checkbox:true
						 })	    
						
						//alert(rowsObject[0].name);
					
					}
				
									
				}
			);
			/**************************添加角色begin*******************************/
			//点击添加弹出框的提交按钮
			$("#addokrole").click(
				function(){
					$("#roleaddform").form("submit", {    
					    url:"role_addRole.action",    
					    success:function(data){ 
					    	var datas=$.parseJSON(data);
					    	//拿到返回的结果并转化格式
					    	var success=datas.success;
					    	if(success){
					    		//显示成功提示框
					    		$.messager.show({
					    			title:"提示消息",
									msg:datas.msg,
									timeout:2000,
									showType:'slide'
								});	
								//清空添加角色inpput框
								$("#addrolename").val("");
								//关闭添加对话框
								$("#adddialog").dialog("close");	
								//刷新数据重新加载
								$("#datagridRole").datagrid("reload");
								
					    	}else{
					    		//显示失败提示框
					    		$.messager.show({
					    			title:"提示消息",
									msg:datas.msg,
									timeout:2000,
									showType:'slide'
								});	
								//清空添加角色inpput框
								$("#addrolename").val("");
								//关闭添加对话框
								$("#adddialog").dialog("close");
					    	}
					    
					    }    
					});  	
				}
			);
			/**************************添加角色end*******************************/
			
			/**************************编辑角色begin*******************************/
			//点击添加弹出框的提交按钮
			$("#editokrole").click(
				function(){
					$("#roleeditform").form("submit", {    
					    url:"role_updRole.action",    
					    success:function(data){ 
					    	var datas=$.parseJSON(data);
					    	//拿到返回的结果
					    	var success=datas.success;
					    	if(success){
					    		//显示成功提示框
					    		$.messager.show({
					    			title:"提示消息",
									msg:datas.msg,
									timeout:2000,
									showType:'slide'
								});	
								//清空添加角色inpput框
								$("#editrolename").val("");
								//关闭添加对话框
								$("#editdialog").dialog("close");	
								//刷新数据重新加载
								$("#datagridRole").datagrid("reload");
								
					    	}else{
					    		//显示失败提示框
					    		$.messager.show({
					    			title:"提示消息",
									msg:datas.msg,
									timeout:2000,
									showType:'slide'
								});	
								//清空添加角色inpput框
								$("#editrolename").val("");
								//关闭添加对话框
								$("#editdialog").dialog("close");
					    	}
					    
					    }    
					});  	
				}
			);
			/**************************编辑角色end*******************************/
			
			/**************************授权角色begin*******************************/
			//点击授权弹出框的提交按钮
			$("#grantokrole").click(
				//角色授权 需要传两个东西(角色id,选中的菜单的id)
				function(){
					//获得所有选中的行对象
					var rowsObject= $("#datagridRole").datagrid("getChecked");
					//拿到role的id
					var roleid=rowsObject[0].id;
					//alert("roleid"+roleid);
					
					//拿到菜单id
					//拿到所有的选中的菜单对象及其级联目录
					var nodes = $("#grantTree").tree("getChecked", ["checked","indeterminate"]);//1 2 3 4
					//var n=$.parseJSON(nodes);
					//alert(n);
					//定义一个数组来放所有选中菜单的id
					var ids=[];
					
					//遍历获取到的菜单对象(i代表遍历的下标，v下标对应的对象)
					$.each(nodes, function(i, v){
						  ids.push(v.id);
					});
					
					//把数组中放的所有选中菜单的id转换成字符串
					ids=ids.join(",");//  ids="1,2,3,4";
					//alert(ids);
					//通过异步将参数发送到后台
					$.post("role_grantRole.action", 
						  { "id":roleid,"mids":ids },
						   function(data){
								//关闭添加对话框
								$("#grantdialog").dialog("close");	
						    	if(data.success){
									//刷新数据重新加载
									$("#datagridRole").datagrid("reload");	
						    	}
						    	//显示提示框
					    		$.messager.show({
					    			title:"提示消息",
									msg:data.msg,
									timeout:2000,
									showType:'slide'
								});	
						   }, 
						   "json");					
					}
			);
			/**************************授权角色end*******************************/
			
			
			
			
			
			/*********************************点击取消按钮关闭弹窗框******************/	
			//关闭添加的取消按钮
			$("#addcancelrole").click(function(){
				$("#adddialog").dialog("close");	
			});
			
			//关闭编辑的取消按钮
			$("#editcancelrole").click(function(){
				$("#editdialog").dialog("close");	
			});
			
			//关闭授权的取消按钮
			$("#grantcancelrole").click(function(){
				$("#grantdialog").dialog("close");	
			});
			
			/*********************************点击取消按钮关闭弹窗框******************/	
			
			
			
		});	
		
		
			

	</script>

  </head>
  
  <body>
	
      <table id="datagridRole" class="easyui-datagrid">
	</table>
	<div id="roletb">
		<a id="addrole" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-add',plain:true"><b>添加</b></a>		
		<div class="dialog-tool-separator"></div>
		<a id="editrole" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-edit',plain:true"><b>编辑</b></a>
		<div class="dialog-tool-separator" ></div>
		<a id="grantrole" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-edit',plain:true"><b>授权</b></a>
		<div class="dialog-tool-separator"></div>
	</div>
	<!-- 添加的弹出框 -->
	<div id="adddialog" class="easyui-dialog" title="新增角色" style="width:300px;height:120px;"   
        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#addrolebutton'">   
    	<form id="roleaddform" method="post">
  			<b>角色名称:</b><input id="addrolename" name="name" type="text"/><br/>
	  </form>
	</div>  
	<!-- 添加的按钮 -->
	<div id="addrolebutton">
		<a id="addokrole" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"><b>保存</b></a>	
		<a id="addcancelrole" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"><b>取消</b></a>
	</div>

	<!-- 编辑的弹出框 -->
	<div id="editdialog" class="easyui-dialog" title="编辑角色" style="width:300px;height:120px;"   
        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#editrolebutton'">   
    	<form id="roleeditform" method="post">
    		<table>
    			<tr>
    				<td colspan="2">
    					<input id="id" name="id" type="hidden"/>
    				</td>
    			</tr>
    			<tr>
    				<td><b>角色名称:</b></td>
    				<td><input id="editrolename" name="name" type="text"/></td>
    			</tr>
    		</table>
  			
	  </form>
	</div>  
	<!-- 编辑的按钮 -->
	<div id="editrolebutton">
		<a id="editokrole" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"><b>保存</b></a>	
		<a id="editcancelrole" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"><b>取消</b></a>
	</div>
		<!-- 授权的弹出框 -->
	<div id="grantdialog" class="easyui-dialog" title="授权角色" style="width:400px;height:400px;"   
	data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#grantrolebutton'">   
		<ul id="grantTree"></ul>
	</div>  
	<!-- 授权的按钮 -->
	<div id="grantrolebutton">
		<a id="grantokrole" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"><b>保存</b></a>	
		<a id="grantcancelrole" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"><b>取消</b></a>
	</div>	
  </body>
</html>

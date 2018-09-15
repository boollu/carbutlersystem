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
    		$("#datagridUsers").datagrid({    
				    url:"users_showUsers",  //datagrid_data1.json
				    pagination:true,  
				    columns:[[   
						{field:"id",title:"编号",checkbox:true},
						{field:"lname",title:"登录名称"},
						{field:"rname",title:"真实名称"},                
						{field:"age",title:"年龄"},
						{field:"gender",title:"性别",
							formatter: function(v,r,i){
										return v=="M"?"男":"女";
									}
						},
						{field:"address",title:"地址"},
						{field:"phone",title:"电话"},                
						{field:"dept",title:"部门",formatter: function(v,r,i){
								return v.text;
								}},
						{field:"post",title:"职务",formatter: function(v,r,i){
								return v.text;
								}},
						{field:"birthday",title:"生日",formatter: function(v,r,i){
									return formatDate(v);
								}},
								{field:"card",title:"身份证号码"},   
								{field:"entrytime",title:"入职时间",formatter: function(v,r,i){
									return formatDate(v);
								}},
						{field:"isdisable",title:"是否启用",formatter: function(v,r,i){
								return v==1?"启用":"禁用";
								}},
						{field:"null",title:"操作",formatter: function(v,r,i){
							var str='';
							
							str='<a href="javascript:resetPass('+r.id+');">重置密码</a>';
							
							return str; 					
						}}  
				    ]] ,
					toolbar: "#userstb"

				       
				}); 
			/*****************************************添加用户begin*****************************/	
			
			//给添用户色图标添加点击事件	
			$("#addusers").click(
				//点击的时候让dialog弹出
				function(){
					//添加下拉框，并从后台获取部门数据
					$("#dept").combobox({    
					    url:"users_findDept",    
					    valueField:"id",    
					    textField:"text"   
					});  
					//添加下拉框，并从后台获取职务数据
					$("#post").combobox({    
					    url:"users_findPost",    
					    valueField:"id",    
					    textField:"text"   
					});  
					
					//设置入职日期为当前日期
					$("#entrytime").datebox("setValue",today());
				    //打开
					$("#adddialog").dialog("open");					
				}
			);
			
			//判断用户名是否存在
			$("#lname").blur(function(){ 
				var lname=$.trim($("#lname").val());
				//将值传送到后台
				$.post(
					"users_checkUsers",
					{lname:lname},
					function(data){
						if(data){
							//显示提示框
							$.messager.alert("警告","用户已存在","warning"); 
						}
					},
					"json"
				);
				
			});
			
			
			
			//点击添加弹出框的提交按钮
			$("#addokusers").click(
				function(){
					$("#usersaddform").form("submit", {    
					    url:"users_addUsers.action",    
					    success:function(data){ 
					 //   alert("11111111111111111111111");
					    	var datas=$.parseJSON(data);//将json转换字符串
					    	//拿到返回的结果
					    	var success=datas.success;
					    	//清空添加用户inpput框
							$("#usersaddform").form("clear");
							//关闭添加对话框
							$("#adddialog").dialog("close");	
					    	if(success){
								//刷新数据重新加载
								$("#datagridUsers").datagrid("reload");	
					    	}
					    	//显示提示框
				    		$.messager.show({
				    			title:"提示消息",
								msg:datas.msg,
								timeout:2000,
								showType:'slide'
							});	
					    
					    }    
					});  	
				}
			);
			
			//关闭添加的取消按钮
			$("#addcancelusers").click(function(){
				$("#adddialog").dialog("close");	
			});
		 /*****************************************添加用户end*****************************/
		 
		 /*****************************************编辑用户begin*****************************/
		 //给编辑角色图标添加点击事件	
			$("#editusers").click(
				//点击的时候让dialog弹出
				function(){
					//判断是否选中角色
					//获得所有选中的行对象
					var rowsObject= $("#datagridUsers").datagrid("getChecked");
					if(1!=rowsObject.length){
						//没有选择角色的时候
						if(rowsObject.length<1){
								//提示框提示
					    		$.messager.show({
					    			title:"提示消息",
									msg:"请选择一个用户",
									timeout:2000,
									showType:'slide'
								});	
						}
						
						//选择多个角色的时候
						if(rowsObject.length>1){
								//提示框提示
					    		$.messager.show({
					    			title:"提示消息",
									msg:"只能选择一个用户",
									timeout:2000,
									showType:'slide'
								});	
						}
						
					}else{
						alert(rowsObject[0].name);
						alert(rowsObject[0].id);
						$("#userseditform #id").val(rowsObject[0].id);
						$("#userseditform #lname").val(rowsObject[0].lname);
						$("#userseditform #lpass").val(rowsObject[0].lpass);
						$("#userseditform #rname").val(rowsObject[0].rname);
						$("#userseditform #age").val(rowsObject[0].age);
						$("#userseditform #phone").val(rowsObject[0].phone);
						$("#userseditform #dept").val(rowsObject[0].dept.id);
						$("#userseditform #post").val(rowsObject[0].post.id);
		$("#userseditform #birthday").datebox('setValue',formatDate(rowsObject[0].birthday));
						$("#userseditform #card").val(rowsObject[0].card);
		$("#userseditform #entrytime").datebox('setValue',formatDate(rowsObject[0].entrytime));
						$("#userseditform #address").val(rowsObject[0].address);
						//添加下拉框，并从后台获取部门数据
						$("#userseditform #dept").combobox({    
						    url:"users_findDept",    
						    valueField:"id",    
						    textField:"text"   
						});  
						//添加下拉框，并从后台获取职务数据
						$("#userseditform #post").combobox({    
						    url:"users_findPost",    
						    valueField:"id",    
						    textField:"text"   
						});  
						$("#editdialog").dialog("open");
						//给角色名称设置值
						//$("#editrolename").val(rowsObject[0].name);
						//给隐藏域id设置值
						//$("#roleeditform #id").val(rowsObject[0].id);
							
					}
				
									
				}
			);	
			
			
			//点击编辑弹出框的提交ok按钮
			$("#editokusers").click(
				function(){
					$("#userseditform").form("submit", {    
					    url:"users_updUsers.action",    
					    success:function(data){ 
					    	var datas=$.parseJSON(data);
					    	//拿到返回的结果
					    	var success=datas.success;
					    	//清空添加角色inpput框
							//$("#editrolename").val("");
							//关闭添加对话框
							$("#editdialog").dialog("close");	
					    	if(success){
								//刷新数据重新加载
								$("#datagridUsers").datagrid("reload");	
					    	}
					    	//显示提示框
				    		$.messager.show({
				    			title:"提示消息",
								msg:datas.msg,
								timeout:2000,
								showType:'slide'
							});	
					    
					    }    
					});  	
				}
			);
			
			//关闭编辑用户的取消按钮
			$("#editcancelusers").click(function(){
				$("#editdialog").dialog("close");	
			});
			
/***************************************************编辑用户end*****************************/
			/*****************************************删除用户*****************************/
			$("#delusers").click(function(){
				//判断是否选中角色
				//获得所有选中的行对象
				var rowsObject= $("#datagridUsers").datagrid("getChecked");
				if(1!=rowsObject.length){
					//没有选择角色的时候
					if(rowsObject.length<1){
							//提示框提示
				    		$.messager.show({
				    			title:"提示消息",
								msg:"请选择一个用户",
								timeout:2000,
								showType:'slide'
							});	
					}
					
					//选择多个角色的时候
					if(rowsObject.length>1){
							//提示框提示
				    		$.messager.show({
				    			title:"提示消息",
								msg:"只能选择一个用户",
								timeout:2000,
								showType:'slide'
							});	
					}
				}else{
					//删除用户
					var id=rowsObject[0].id;
					alert(id);
					$.messager.confirm("确认","您确认要删除此用户吗？",function(r){    
					    if(r){    
					    	$.post("users_delUsers",
									{"id":id},
									function(data){
								    	//拿到返回的结果
								    	var success=data.success;
								    	if(success){
											//刷新数据重新加载
											$("#datagridUsers").datagrid("reload");	
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
					});  
					
				}
			});
			/*****************************************删除用户end*****************************/
			
			/*****************************************指派角色begin*****************************/
			$("#grantusers").click(function(){
				//判断是否选中角色
				//获得所有选中的行对象	
				var rowsObject= $("#datagridUsers").datagrid("getChecked");
				if(1!=rowsObject.length){
					//没有选择角色的时候
					if(rowsObject.length<1){
							//提示框提示
				    		$.messager.show({
				    			title:"提示消息",
								msg:"请选择一个用户",
								timeout:2000,
								showType:'slide'
							});	
					}
					
					//选择多个角色的时候
					if(rowsObject.length>1){
							//提示框提示
				    		$.messager.show({
				    			title:"提示消息",
								msg:"只能选择一个用户",
								timeout:2000,
								showType:'slide'
							});	
					}
				}else{
					//获取选中用户的所有的角色
					var uroles=rowsObject[0].roles;	
					$("#grantdialog").dialog("open");
					$.post("users_findAllRole",
						function(data){
						var dom="<div>";
						var datas=$.parseJSON(data);
						
							$.each(datas, 
								function(i,v){
									var checked=false;
									//alert(v.name);
								  //alert( "Name: " + i + ", Value: " + role.name );
								  //判断用户用那些角色，有的这些角色就要在所有角色复选框选中
								  $.each(uroles,function(i,role){
									  if(role.id==v.id){
										  alert(111111111111);
										  checked=true;
									  }
								  });
								  
								  if(checked){
									  dom+="<input type='checkbox' name='role' checked='checked' value='"+v.id+"'/>"+v.name;
								  }else{
									  dom+="<input type='checkbox' name='role' value='"+v.id+"'/>"+v.name;  
								  }

							});
							dom+="</div>";	
							alert(dom);
							//不要写到回调函数外边
							$("#grantdialog #grantdiv").html(dom);
					});
					
					//alert(dom);
				}
			});
			
			//判断用户是否存在
			
			
			//给指派角色ok按钮添加事件
			$("#grantokusers").click(function(){
				//获得所有选中的行对象	
				var rowsObject= $("#datagridUsers").datagrid("getChecked");
				//取到到用户的id
				var id=rowsObject[0].id;
				//取到用户选中的角色id
				var rids=[];
				var checkedboxdom=$("#grantdiv input[type='checkbox']:checked");
				$.each(checkedboxdom, 
						function(i,v){
							rids.push(v.value);
						}
				)
				//将数组转化为字符串用,号拼接
				rids=rids.join(",");
				//通过异步将参数发送到后台
				$.post("users_grant.action", 
					  { "id":id,"rids":rids },
					   function(data){
							//关闭添加对话框
							$("#grantdialog").dialog("close");	
					    	if(data.success){
								//刷新数据重新加载
								$("#datagridUsers").datagrid("reload");	
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
	
					
			});
			
			//关闭指派角色的取消按钮
			$("#grantcancelusers").click(function(){
				$("#grantdialog").dialog("close");	
			});
			/*****************************************指派角色end*****************************/
    	});
    	
    	//模糊查询
    	function search(value,name){ 
    		//alert(value+":"+name);
    		//将输入的数据传入到后台，从新加载
    		$("#datagridUsers").datagrid("reload",{rname:value});
		} 

    	//获得当前日期函数
    	function today(){
    		var date=new Date();
    		return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
    	}
    	/*重置密码,开始*****************************/ 
    	function resetPass(id){
    		var params={"id":id};
    		$.ajax({
    			url:'<%=basePath%>users_resetPass.action',
    			data:params,
    			dataType:'json',
    			type:'POST',
    			success:function(data){					
    				$.messager.show({
    					title:'提示消息',
    					msg:data.msg
    				});								
    			}
    		});
    	}
    	/*重置密码,结束*****************************/	
    	/****  用户名验证    **/
    	$('#lname').form('validate')
$.extend($.fn.validatebox.defaults.rules,{
            NotEmpty : { // 非空字符串验证。 easyui 原装required 不能验证空格
                validator : function(value, param) {
                    return $.trim(value).length>0;
                }, 
                message : '请输入用户名'
            }
            });
    	/*****手机号码验证*****/
    	$('#phone').form('validate')
   $.extend($.fn.validatebox.defaults.rules, {
    mobile: {
        validator: function (value) {
            return /^1[0-9]{10}$/i.test($.trim(value));
        },
        message: '请输入正确的手机号码'
    }
});
             /*****身份证验证****/
             $('#card').form('validate')
$.extend($.fn.validatebox.defaults.rules, {
    Idnum : {// 验证身份证
                validator : function(value) {
                    return /^\d{15}(\d{2}[A-Za-z0-9])?$/i.test(value);
                },
                message : '身份证号码格式不正确'
            },
});

            /****  年龄格式判断     ***/  	
  
  $("#age").blur(function(){ 
				var lname=$.trim($("#age").val());
		    //将值传送到后台
			if(isNaN(lname)){
			$.messager.alert("警告","请输入合法年龄","warning"); 
			
			}
			});
		/*********真实姓名*******/	
			$('#rname').form('validate')
$.extend($.fn.validatebox.defaults.rules,
  {   
   // 验证中文
   CHS : {
    validator : function(value) {
    return /^[\u0391-\uFFE5]+$/.test(value);},
    message : "请输入正确姓名"
   }
   });
 	
    </script>
  </head>  
  <body>
     <!-- 展示数据的部分 -->
  	 <table id="datagridUsers" class="easyui-datagrid">
	 </table>
	 <!-- 数据表格的表头 -->
	 <div id="userstb">
		<a id="addusers" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-add',plain:true"><b>新增</b></a>		
		<div class="dialog-tool-separator"></div>
		<a id="editusers" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-edit',plain:true"><b>编辑</b></a>
		<div class="dialog-tool-separator" ></div>
		<a id="delusers" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-remove',plain:true"><b>删除</b></a>
		<div class="dialog-tool-separator"></div>
		<a id="grantusers" class="easyui-linkbutton" style="float:left" data-options="iconCls:'icon-edit',plain:true"><b>指派角色</b></a>
		<div class="dialog-tool-separator"></div>
		<!-- 添加搜索框 -->
		<input id="ss" class="easyui-searchbox" style="width:300px" 
		data-options="searcher:search,prompt:'此处输入用户真实姓名',menu:'#mm'"></input> 
		
		<div id="mm" style="width:120px"> 
			<div data-options="name:'all',iconCls:'icon-ok'">用户真实姓名</div> 
		</div> 
	</div>
	
	<!-- 添加的弹出框 -->
	<div id="adddialog" class="easyui-dialog" title="新增用户信息" style="width:360px;height:450px;"   
        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#addusersbutton'">   
    	<form id="usersaddform" method="post">
					<table>
	    		<tr>
	    			<td align="right">用&nbsp;户&nbsp;名：</td>
	    			<td>
	    				<input type="text" style="width:200px;" id="lname" name="lname"  class="easyui-validatebox" data-options="required:true" />
					</td>
	    		</tr>
	    		<tr>
	    			<td align="right">密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
	    			<td>
	    				<input type="password" style="width:200px;" value="123456" id="passwd" name="lpass"/>
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">真实姓名：</td>
	    			<td>
	    				<input type="text" style="width:200px;" name="rname" id="rname" class="easyui-validatebox" data-options="required:true" validType="CHS"  />
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="right">年&nbsp;&nbsp;&nbsp;&nbsp;龄：</td>
	    			<td>
	    				<input type="text" style="width:200px;" name="age" id="age" class="easyui-numberbox" data-options="min:0,max:150"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="right">性&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
	    			<td>
	    				<input type="radio" value="M" name="gender" checked="checked"/>男
	    				<input type="radio" value="F" name="gender"/>女
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
	    			<td>
	    				<input type="text" style="width:200px;" name="phone" id="phone" class="easyui-numberbox"  required="required" validtype="mobile"  />
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
	    			<td>
	    				<input id="dept" name="dept.id" style="width:200px;"/>
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">职&nbsp;&nbsp;&nbsp;&nbsp;位：</td>
	    			<td>
	    				<input id="post" name="post.id" style="width:200px;"/>
	    			</td>
	    		</tr>	    		
					<tr>
					<td align="right">生&nbsp;&nbsp;&nbsp;&nbsp;日：</td>
					<td>
						<input type="text" name="birthday" id="birthday" style="width:200px;" class="easyui-datebox" />
					</td>
				</tr>				
				<tr>
					<td align="right">身&nbsp;份&nbsp;证：</td>
					<td>
						<input type="text" name="card"  maxlength="18" id="card" style="width:200px;"/>
					</td>
				</tr>
				<tr>
					<td align="right">入职时间：</td>
					<td>
						<input type="text" id="entrytime"  name="entrytime" style="width:200px;" class="easyui-datebox" />
					</td>
				</tr>
	    		<tr>
	    			<td align="right">住&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
	    			<td>
	    				<input type="text" style="width:200px;" name="address" style="width:200px;"/>
	    			</td>
	    		</tr>
	    		<tr>
					<td style="text-align: rigth;">是否启用：</td>
					<td>
						<input type="radio" name="isdisable" value="1" checked="checked"/>启用
						<input type="radio" name="isdisable" value="0"/>禁用
					</td>
				</tr>
			</table>	
	  </form>
	</div>  
	<!-- 添加的按钮 -->
	<div id="addusersbutton">
		<a id="addokusers" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"><b>保存</b></a>	
		<a id="addcancelusers" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"><b>取消</b></a>
	</div>
	
	<!-- 编辑的弹出框 -->
	<div id="editdialog" class="easyui-dialog" title="修改用户信息" style="width:360px;height:450px;"   
        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#editusersbutton'">   
    	<form id="userseditform" method="post">
				<table>
					<input type="hidden" id="id" name="id"/>
					<input type="hidden" id="lpass" name="lpass"/>
	    		<tr>
	    			<td align="right">用&nbsp;户&nbsp;名：</td>
	    			<td>
	    				<input type="text" style="width:200px;background-color:#F8F8F8" id="lname" name="lname" readonly="readonly"  class="easyui-validatebox"/>
					</td>
	    		</tr>
	    		<!--
	    		<tr>
	    			<td align="right">密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
	    			<td>
	    				<input type="password" id="lpass" style="width:200px;" value="123456" name="lpass"/>
	    			</td>
	    		</tr>  -->	    		
	    		<tr>
	    			<td align="right">真实姓名：</td>
	    			<td>
	    				<input id="rname" type="text" style="width:200px;" name="rname"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="right">年&nbsp;&nbsp;&nbsp;&nbsp;龄：</td>
	    			<td>
	    				<input type="text" id="age" style="width:200px;" name="age" class="easyui-numberbox" data-options="min:0,max:150"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td align="right">性&nbsp;&nbsp;&nbsp;&nbsp;别：</td>
	    			<td>
	    				<input type="radio" value="M" name="gender" checked="checked"/>男
	    				<input type="radio" value="F" name="gender"/>女
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">电&nbsp;&nbsp;&nbsp;&nbsp;话：</td>
	    			<td>
	    				<input type="text" id="phone" style="width:200px;" name="phone"/>
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
	    			<td>
	    				<input id="dept" name="dept.id" style="width:200px;"/>
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td align="right">职&nbsp;&nbsp;&nbsp;&nbsp;位：</td>
	    			<td>
	    				<input id="post" name="post.id" style="width:200px;"/>
	    			</td>
	    		</tr>	    		
					<tr>
					<td align="right">生&nbsp;&nbsp;&nbsp;&nbsp;日：</td>
					<td>
						<input type="text" name="birthday" id="birthday" style="width:200px;" class="easyui-datebox" required="required" />
					</td>
				</tr>				
				<tr>
					<td align="right">身&nbsp;份&nbsp;证：</td>
					<td>
						<input type="text" id="card" name="card"  maxlength="18" style="width:200px;"/>
					</td>
				</tr>
				<tr>
					<td align="right">入职时间：</td>
					<td>
						<input type="text" id="entrytime"  name="entrytime" style="width:200px;" class="easyui-datebox" />
					</td>
				</tr>
	    		<tr>
	    			<td align="right">住&nbsp;&nbsp;&nbsp;&nbsp;址：</td>
	    			<td>
	    				<input type="text" id="address" style="width:200px;" name="address" style="width:200px;"/>
	    			</td>
	    		</tr>
	    		<tr>
					<td style="text-align: rigth;">是否启用：</td>
					<td>
						<input type="radio" name="isdisable" value="1" checked="checked"/>启用
						<input type="radio" name="isdisable" value="0"/>禁用
					</td>
				</tr>
			</table>	
	  </form>
	</div>  
	<!-- 编辑的按钮 -->
	<div id="editusersbutton">
		<a id="editokusers" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"><b>保存</b></a>	
		<a id="editcancelusers" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"><b>取消</b></a>
	</div>
  	<!-- 指派角色的弹出框 -->
	<div id="grantdialog" class="easyui-dialog" title="指派角色" style="width:360px;height:150px;"   
        data-options="iconCls:'icon-save',resizable:true,modal:true,closed:true,buttons:'#grantusersbutton'">   
		<div id="grantdiv"></div>
	</div>
	<!-- 指派角色的按钮 -->
	<div id="grantusersbutton">
		<a id="grantokusers" class="easyui-linkbutton" data-options="iconCls:'icon-ok'"><b>保存</b></a>	
		<a id="grantcancelusers" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'"><b>取消</b></a>
	</div>  
  </body>
</html>
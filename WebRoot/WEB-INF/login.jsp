<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="Inc.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<style type="text/css">
		body{
			background-image: url("Inc/img/login_backimg.jpg");
		}
		#logindiv{
			position: absolute; left:890px;top:340px;
		}
		.myinput{
	    	background-color:transparent;
	    	border:0px;
	    	width:335px;
	    	font-size:30px;
	    	height:61px;
	    	padding-left: 60px;
	    }
	</style>
	<script type="text/javascript">
			$(function(){
			
			//判断用户名是否存在
			$("#lname").blur(function(){ 
				var lname=$.trim($("#lname").val());
				//将值传送到后台
				$.post(
					"users_checkUsers",
					{lname:lname},
					function(data){
						if(!data){
							//显示提示框
							$.messager.alert("警告","存在非法登陆,请重新输入用户名","warning"); 
						}
					},
					"json"
				);
				
			});
			

				$("#subimage").on("click",function(){
					return submitLogin();
				});
				$("#lpass").keydown(function(event){
					if(event.keyCode==13){
						submitLogin();
					}
				});
			});
			
			//公用的登录提交方法
			function submitLogin(){
				$("#loginform").form("submit", {    
				    url:"users_login.action",    
				    onSubmit: function(){    
				      var lname= $.trim($("#lname").val());
				      var lpass= $.trim($("#lpass").val());
				      if(lname==""){
				      	$.messager.alert('警告:','用户名不能为空',"warning");
				      	return false;
				      }
				      
				      if(lpass==""){
				      	$.messager.alert('警告:','密码不能为空',"warning");
						return false;	
				      }
				      return true;
				    },    
				    success:function(data){
				    	//alert("登陆方法后台返回值："+data);
				    	//转化成对应的类型
				    	var flag=$.parseJSON(data);
				    	if(flag){
				    		//登录成功应跳转到主页面
				    		window.location.href="users_gotoIndex.action";
				    		
				    	}else{
				    		//登录失败应提示
				    		$.messager.alert('警告:','用户名或密码不正确',"warning");
				    	}    
				            
				    }    
				});  	
				return false;
			}
		
	</script>
	
  </head>
  
  <body>
    	<div id="logindiv">
    	  <form id="loginform">	
    		<table>
    			<tr>
    				<td><input id="lname" class="myinput" type="text" name="lname"  style="background-image:url('Inc/img/login_lname.png')"/></td>
    			</tr>
    			<tr>
    				<td></td>
    			</tr>
    			<tr>
    				<td><input id="lpass" class="myinput" type="password" name="lpass"  style="background-image:url('Inc/img/login_lpass.png')"/></td>
    			</tr>
    			<tr>
    				<td></td>
    			</tr>
    			<tr>
    				<td><input id="subimage" type="image" src="Inc/img/login_denglu.png"/></td>
    			</tr>
    		</table>
    	  </form>
    	</div>
  </body>
</html>

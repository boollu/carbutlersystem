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
    <style type="text/css">
    	td{border: 1px solid #818181;}
    </style>
	<script type="text/javascript">
	$(function(){
		$('#opass').blur(function(){			
			var b=$('#opass').validatebox('isValid');			
			if(!b){return;}
			
			var opass=$(this).val();
						
			var params={"opass":opass};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>users_ckPass.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					if(!data){						
						$.messager.alert('提示','原始密码不正确','warning');
						$('#opass').focus();
						$('#opass').val('');
					}																		
				}
			});	
		});
	
		$.extend($.fn.validatebox.defaults.rules, {    
		    equals: {    
		        validator: function(value,param){    
		            return value == $(param[0]).val();    
		        },    
		        message: '新密码和确认新密码不相同'   
		    }    
		});
		
		//确认修改
		$('#qbutton').on('click',function(){
			$('#f1').form('submit',{
				url:'<%=basePath%>users_updPass.action',
				success:function(data){
					var obj=$.parseJSON(data);
					if(obj.success){
						$.messager.confirm('确认对话框', '修改成功,请重新登录^_^', function(r){
	if (r){
	 window.parent.location.href='<%=basePath%>users_exit.action';
	}
});          	}else{
						$.messager.alert('提示','修改失败','warning');
					}
				}
			});
		});
		
	});	
	
	</script>

  </head>
  
  <body>
  	<form id="f1" method="post"> 	
       <table cellpadding="0" cellspacing="1">
    	<tr>
 			<td align="right">原始密码:</td>
 			<td>
 				<input id="opass" type="password" class="easyui-validatebox" required="required" />
 			</td>
 		</tr>
 		<tr>
 			<td align="right">新&nbsp;密&nbsp;码:</td>	   				
 			<td>
 				<input id="pwd" name="lpass" type="password" class="easyui-validatebox" required="required"/>
 			</td>
 		</tr>
 		<tr>
 			<td align="right">确认新密码:</td>	   				
 			<td>
 				<input id="rpwd" validType="equals['#pwd']"  type="password" class="easyui-validatebox" required="required"/>
 			</td>
 		</tr>
 		<tr>
 			<td colspan="2" align="center">
 				<input type="button" id="qbutton" value="确认"/>
 				<input type="reset" value="清空"/>
 			</td>
 		</tr>
   	</table>
   </form>
  </body>
</html>

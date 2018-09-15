<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@ include file="Inc.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <script type="text/javascript">
    	$(function(){
			 $("#maintree").tree({    
			    url:"users_menuTree.action",
			    idFiled:"id",
			    textFiled:"text",
			    parentField:"pid",
			    onClick: function(node){
			    	//判断打开状态(针对文件夹)
			    	if(node.state=="open"){//若文件夹打开
			    		$("#maintree").tree("collapse",node.target);//单击后折叠		    		
			    	}else if(node.state=="closed"){//若文件夹关闭
			    		$("#maintree").tree("expand",node.target);//单击后打开
			    	}else{
			    		//是文件的操作
			    		//判断是否存在选项卡，若有，选中已打开的选项卡
			    		if($("#layout_center_tabs").tabs("exists",node.text)){//
			    			$("#layout_center_tabs").tabs("select",node.text);
			    		}else{//若无，打开一个新的选项卡
			    		      var url=node.attributes.url;
			    		     // alert(url);
			    		      //<iframe src='pages/"+url+"' style='border:0;width:100%;heigth:99.4%'></iframe>"
							$("#layout_center_tabs").tabs("add",{    
							    title:node.text,    
							    content:"<iframe src='users_gotoRoleManagement?url="+url+"' style='border:0;width:100%;height:99.4%'></iframe>",    
							    closable:true,    
							    tools:[{    
							        iconCls:"icon-mini-refresh",    
							        handler:function(){    
							            alert('refresh');    
							        }    
							    }]    
							});  
			    	  	}	
			    	}
			    
					//alert(node.url);  // 在用户点击的时候提示
			    }
			       
			});  
    		
    	
    	});
    	
    </script>
  </head>
  
  <body class="easyui-layout">  		
	<div region="north" split="true" border="false" style="overflow: hidden; height: 90px;
	        background: url('Inc/img/main_top.jpg') #7f99be repeat-x center 50%;
	        line-height: 20px;color: #fff; font-family: Verdana, 微软雅黑,黑体">
	        
	        <span style="float:right;
	        	padding-top:60px; 
	        	padding-right:10px;
	        	font-size: 16px;" 
	        	class="head">
	        	欢迎
	        	<sapn style="color:red;"> 【${user.rname}】</sapn>
	        	 登录本系统
	        	<a href="users_exit.action" id="loginOut" style="color:yellow;text-decoration: none;">
	        		【安全退出】
	        	</a>
		        <select id="em_sel" class="easyui-combobox" style="width:100px;"> 
				    <option value="default" selected="selected">默认皮肤</option>   
				    <option value="black">古天乐黑</option> 
				    <option value="dark-hive">包青天黑</option>  
				    <option value="bootstrap">浅灰色</option>
				    <option value="gray">深灰色</option>
				    <option value="cupertino">青蓝色</option>
				    <option value="sunny">阳光色</option>   
				</select>		        	
	        </span>
	        
    </div>
    <div region="south" split="true" style="height: 30px; background: #D2E0F2; ">
        <div class="footer"></div>
    </div>   
    <div data-options="region:'west',title:'菜单栏',split:true" style="width:180px;">
    	<!-- 树菜单 -->
    	<ul id="maintree"></ul> 
    </div>   
    <div data-options="region:'center',title:'主界面'" style="padding:5px;background:#eee;">
    	<div id="layout_center_tabs" class="easyui-tabs" data-options="fit:true,border:false" style="overflow: hidden;">
			<div title="首页">
			</div>						
		</div>
    </div>   
</body> 

</html>

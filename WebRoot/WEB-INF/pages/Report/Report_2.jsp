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
    		//填充车辆下拉列表
			var url='<%=basePath%>viewcd_findCarList.action';
			var carKV={k:'id',v:'carNo'};
			initCombobox($('#car'),url,carKV,-1);
    	
    		$('#car').combobox({
	    		onSelect:function(record){
	    			var params={};
		    		params['cid']=record.id;
		    		
		    		$.ajax({
		    			url:'<%=basePath%>viewcd_findPieList.action',
		    			data:params, 
		    			dataType:'json',
						type:'POST',
						success:function(data){
							var t=[];
							
							
							$.each(data,function(k,v){
								t.push([v.text,v.carCost]);
							});
							
							createReport(t,'pie');
						}
		    		});
	    		}
	    	});
    	
    		
    	});
    	
    	
	    //生成饼图
	   	var chart1;
	   	function createReport(data,cType){
	   		chart1=new Highcharts.Chart({
			 	chart:{
			 		renderTo:'container1',
			 	},
			 	credits:{enabled:false},
               	tooltip:{  
                   formatter: function () {  
                       //当鼠标悬置数据点时的格式化提示  
                       return '<b>'+this.point.name+'</b>'+
                       	   ':'+
                       	   Highcharts.numberFormat(this.y,2)+
                       	   '元';  
                   }  
               	},
               	plotOptions:{
               		pie:{
	               		allowPointSelect:true,
	                	cursor:'pointer',
	                	dataLabels:{
	                		enabled:true,
	                		color:'#000000',
	                		formatter:function(){
	                			return '<b>'+this.point.name+'</b>'+
	                        	   ':'+
	                        	   Highcharts.numberFormat(this.percentage,2)+
	                        	   '%'; 
	                		}
	                	}
               	}
               },
               title: { text: '车辆费用分布' }, //图表主标题  
               subtitle: { text: '单个车辆' }, //图表副标题  
               series:[{
               	type:cType,
               	data:data
               }]
			 }); 
	   	}
    </script>
	
  </head>
  
  <body>
  	<input type="text" id="car" />
    <form id="form1">  
		<div>  
			<div id="container1" style="width: 1000px; height: 680px;  margin: 0 auto">  
	        </div>  
		</div>  
    </form>
  </body>
</html>

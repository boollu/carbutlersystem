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
    	/* 图片展示样式 */
    	#car_picShowTab{width: 99%;}
		#car_picShowTab div{width:150px;text-align:center;}
		#car_picShowTab div img{width:150px;height:150px;cursor: pointer;}
		#car_picShowTab div img:hover{opacity:0.7;filter(alpha=80);}
		
		/* 上传按钮布局展示样式 */
		#upTab td{border: 1px solid black;}
    </style>
    
	<script type="text/javascript">
	//上传布局代码
	var strFileHtml='';
	$(function(){
		/*数据表初始设置开始*****************************/  
		$('#car_dg').datagrid({
            url:'<%=basePath%>car_findCarDG.action',
            fitColumns:true,
            pagination:true,
            rownumbers:true,
            toolbar: '#car_tb',
            columns:[[
				{field:'id',title:'编号',checkbox:true},
                {field:'carNo',title:'车牌号码'},
                {field:'carBrand',title:'车辆品牌',formatter:function(v,r,i){
                	return v.text;
                }},
                {field:'carModel',title:'车辆型号',formatter: function(v,r,i){
					return v.text;
				}},
				{field:'carColor',title:'车辆颜色',formatter:function(v,r,i){
					return findLocDicText('color',v);
				}},
				{field:'carSeats',title:'座位数'},
			 	{field:'dept',title:'部门',formatter:function(v,r,i){
                	return v.text;
                }},
                {field:'carState',title:'车辆状态',formatter:function(v,r,i){
                	return findLocDicText('state',v);
                }},
				{field:'isdisable',title:'是否启用',formatter: function(v,r,i){
					return v==1?'启用':'禁用';
				}},
				{field:'null',title:'操作',formatter: function(v,r,i){
					var strUrl='<a href="javascript:showDetailed('+r.id+');">查看详细</a>&nbsp;';
					strUrl +='<a href="javascript:carPicManager('+r.id+');">图片管理</a>&nbsp;';
					return strUrl;						
				}}
            ]]
	    });
		/*数据表初始设置结束*****************************/ 
		
		//新增界面选择车辆品牌联动车辆型号
		$('#car_addForm #carBrand').combobox({
			onSelect:function(record){
				var url='<%=basePath%>car_findCarModelList.action?carBrand.id='+record.id;
				initCombobox($('#car_addForm #carModel'),url,null,-1);
			}
		});
		
		/*新增按钮事件设置,开始*****************************/		
		$('#tb_add').on('click',function(){
			//填充车辆品牌下拉列表
			var url='<%=basePath%>car_findCarBrandList.action';
			initCombobox($('#car_addForm #carBrand'),url,null,-1);			
			
			//填充车辆颜色
			initComboboxLocal($('#car_addForm #carColor'),initLocDic('color'),-1);
			
			//购买日期默认当前时间
			$('#car_addForm #purchaseDate').datebox('setValue',getNowDate());
			
			//填充供应商
			var url='<%=basePath%>car_findSupList.action';
			var kv={k:'id',v:'unitName'};
			initCombobox($('#car_addForm #sup'),url,kv,-1);
					
			//填充部门下拉列表
			var url='<%=basePath%>car_findDeptList.action';
			initCombobox($('#car_addForm #dept'),url,null,-1);
			
			//填充车辆状态
			initComboboxLocal($('#car_addForm #carState'),initLocDic('state'),-1);
			
			$('#car_addDialog').dialog('open');					
		});			
		/*新增按钮事件设置,结束*****************************/
		
		/*新增时车牌已登记检查设置,开始*****************************/
		$('#car_addForm [name=carNo]').blur(function(){
			var carNo=$('#car_addForm [name=carNo]').val().toUpperCase();
			var params={'carNo':carNo};
			
			//取得数据
			$.ajax({
				url:'<%=basePath%>car_findCarNo.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					if(data>0){
						$.messager.alert('提示','该车牌已登记','warning');
						$('#car_addForm [name=carNo]').val('');
					}																			
				}
			});		
		});
		/*新增时车牌已登记检查设置,结束*****************************/
				
		/*修改按钮事件设置,开始*****************************/
		$('#tb_edit').on('click',function(){
			//未选中提示
   			var rows=$('#car_dg').datagrid('getChecked');
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
				url:'<%=basePath%>car_findCarById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){					
					//绑定数据
					updDataBind(data);					
					
					$('#car_updDialog').dialog('open');		
				}
			});
						
		});
		/*修改按钮事件设置,结束*****************************/
		
		/*删除按钮事件设置,开始*****************************/
		$('#tb_remove').on('click',function(){
			//未选中提示
   			var rows=$('#car_dg').datagrid('getChecked');
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
						url:'<%=basePath%>car_delCar.action',
						data:params,
						dataType:'json',
						type:'POST',
						success:function(data){
							if(data.success){
								//去除选择
								$('#car_dg').datagrid('unselectAll');
								//刷新dg
								$('#car_dg').datagrid('reload');
							}
							
							$.messager.show({
								title:'提示消息',
								msg:data.msg
							});								
						}
					});
				}else{
					//去除选择
					$('#car_dg').datagrid('unselectAll');
				}
			});
			
			
		});
		/*删除按钮事件设置,结束*****************************/
		
		/*搜索按钮事件设置,开始*****************************/
		$('#sel').searchbox({
			searcher:function(v,n){
				var params={};
				
				$('#car_dg').datagrid('load',params);
			},
			menu:'#mm',
   			prompt:'此处输入车牌号码，支持模糊查询' 
		});
		/*搜索按钮事件设置,结束*****************************/
		
		/*上传界面操作开始*********************************************/		
		//上传按钮布局
		strFileHtml='<tr><td>'+
			'<input type="file" name="carPic"/>'+
			'描述：<input type="text" name="desc" maxlength="18"/>'+
			'<input type="image" src="<%=basePath%>Inc/img/del_16.png"/>'+
			'</td></tr>';
		//初始添加到表格中
		$('#car_picForm #upTab').append(strFileHtml);
		//点击添加新的上传按钮
		$('#car_picForm #addRow').on('click',function(){			
			
			if($('#upTab tr').size()>0){
	  			$('#upTab tr:last').after(strFileHtml);
	  		}else{
	  			$('#upTab').append(strFileHtml);
	  		}
		});
		//上传旁边的删除按钮
		$('#upTab').on('click',':image',function(){
  			$(this).parent().parent().remove();
  		});
  		//点击缩略图放大图片
  		$('#car_picShowTab').on('click','[name=cpimg]',function(){
  			var carPicPath=$(this).parent().find('#carPicPath').val();
  			
  			var imgpath='<%=basePath%>upload/'+carPicPath;
  			
  			$('#car_showpicDialog #maximg').prop("src",imgpath);
  			
  			$('#car_showpicDialog').dialog('open');
  		});
		//图片删除按钮开始
		$('#car_picShowTab').on('click',':image',function(){
			
			//得到车辆ID
			//var carId=$('#car_picForm #id').val();
			
			//得到图片对应ID以及图片名称
			var o=$(this);//记录被点击删除对象
			var carPicId=o.parent().find('#carPicId').val();
			var carPicPath=o.parent().find('#carPicPath').val();
			
			//条件容器
			var params={};
			params['carPicId']=carPicId;
			params['carPicPath']=carPicPath;			
			
			//开进度条
			$.messager.progress();
			
			$.ajax({
				url:'<%=basePath%>car_delCarPicById.action',
				data:params,
				dataType:'json',
				type:'POST',
				success:function(data){
					//关闭进度条
					$.messager.progress('close');
					
					if(data.success){						
						//成功移除，不弹提示
						o.parent().remove();
					}else{
						//失败提示
						$.messager.show({
							title:'提示消息',
							msg:data.msg
						});	
					}					
				}
			});
						
		});
		//上传实现
		$('#car_picForm #upl').on('click',function(){
			//验证是否选择和是否为空
			var oFiles=$('#car_picForm :file');
			var bFlag=false;
			var strMsg='图片未选择';
			var strFV='';
			
			
			if(oFiles.size()>0){
				oFiles.each(function(){
					strFV=$(this).val();					
					if(strFV==''){
						bFlag=true;
						return false;
					}
					//验证图片格式
					if(!ckImgType(strFV)){
						bFlag=true;
						strMsg='图片类型只允许是【gif,jpeg,jpg,png】';
						return false;
					}
					
				});
			}else{
				bFlag=true;
			}
			
			if(bFlag){
				$.messager.show({
					title:'提示',
					msg:strMsg
				});
				
				return;
			}
			
			//开进度条
			$.messager.progress();
			//检查完开始上传
			$('#car_picForm').form('submit',{
				url:'<%=basePath%>car_addCarPic.action',
				success:function(data){					
					var obj=$.parseJSON(data);
					if(obj.success){
						//取得隐藏的主表ID
						var cid=$('#car_picForm #id').val();
						//生成主表对应的图片表格展示
						carPicShow(cid);
						//还原上传控件
						$('#upTab').html(strFileHtml);
						
						//关闭进度条
						$.messager.progress('close');
					}
					$.messager.show({
						title:'提示',
						msg:obj.msg
					});
				}
			});
		});	
		
		/*上传界面操作结束*****************************/
		
		/*搜索按钮事件设置,开始*****************************/
		$('#sel').searchbox({
			searcher:function(v,n){
				var params={};
				
				params['carNo']=v;
				
				$('#car_dg').datagrid('load',params);
			},
			menu:'#mm',
   			prompt:'此处输入车牌号码，支持模糊查询' 
		});
		/*搜索按钮事件设置,结束*****************************/
		
	});
	
	/*还原上传按钮部分开始*****************************/ 
	function reloadFileHtml(){
		$('#car_picShowTab').html('');
		$('#upTab').html(strFileHtml);
		$('#car_picForm').form('clear');
	}
	/*还原上传按钮部分结束*****************************/
	
	/*展示详细内容，此方法必须声明在初始方法外,开始*****************************/ 
	function showDetailed(id){
		//参数容器
		var params={};
		params['id']=id;
		
		//取得数据
		$.ajax({
			url:'<%=basePath%>car_findCarById.action',
			data:params,
			dataType:'json',
			type:'POST',
			success:function(data){
				//绑定数据开始
				$('#car_showDialog #carNo').html(data.carNo);
				$('#car_showDialog #carBrand').html(data.carBrand.text);
				$('#car_showDialog #carModel').html(data.carModel.text);
				$('#car_showDialog #carColor').html(findLocDicText('color',data.carColor));
				$('#car_showDialog #carLoad').html(data.carLoad+'(吨)');
				$('#car_showDialog #carSeats').html(data.carSeats+'(个)');
				$('#car_showDialog #oilWear').html(data.oilWear+'(/百公里)');
				$('#car_showDialog #initMil').html(data.initMil+'(公里)');
				$('#car_showDialog #maintainMil').html(data.maintainMil+'(公里)');
				$('#car_showDialog #maintainPeriod').html(data.maintainPeriod+'(月)');				
				$('#car_showDialog #engineNum').html(data.engineNum);				
				$('#car_showDialog #frameNum').html(data.frameNum);				
				$('#car_showDialog #sup').html(data.sup.unitName);				
				$('#car_showDialog #purchasePrice').html(data.purchasePrice);
				$('#car_showDialog #purchaseDate').html(formatDate(data.purchaseDate));
				$('#car_showDialog #dept').html(data.dept.text);
				$('#car_showDialog #carState').html(findLocDicText('state',data.carState));
				$('#car_showDialog #remarks').html(data.remarks);
				$('#car_showDialog #isdisable').html(data.isdisable==1?'启用':'禁用');
				//绑定数据结束
				
				$('#car_showDialog').dialog('open');
			}
		});
		
	}
	
	/*展示详细内容，此方法必须声明在初始方法外,结束*****************************/
	
	/*绑定待修改内容开始*****************************/
	var cmId=-1; 
	function updDataBind(data){	
		//绑定数据开始
		cmId=data.carModel.id;
		$('#car_updForm #carBrand').combobox({
			onSelect:function(record){
				var url='<%=basePath%>car_findCarModelList.action?carBrand.id='+record.id;				
				initCombobox($('#car_updForm #carModel'),url,null,cmId);
				//绑定结束马上恢复默认值
				cmId=-1;
			}
		});
		
		//填充车辆品牌下拉列表		
		var url='<%=basePath%>car_findCarBrandList.action';
		initCombobox($('#car_updForm #carBrand'),url,null,data.carBrand.id);		
		
		//填充车辆颜色
		initComboboxLocal($('#car_updForm #carColor'),initLocDic('color'),data.carColor);
		
		//填充供应商
		var url='<%=basePath%>car_findSupList.action';
		var kv={k:'id',v:'unitName'};
		initCombobox($('#car_updForm #sup'),url,kv,data.sup.id);
		
		//填充部门下拉列表
		var url='<%=basePath%>car_findDeptList.action';
		initCombobox($('#car_updForm #dept'),url,null,data.dept.id);
		
		//填充车辆状态
		initComboboxLocal($('#car_updForm #carState'),initLocDic('state'),data.carState);
		
		$('#car_updForm [name=id]').val(data.id);
		$('#car_updForm [name=carNo]').val(data.carNo);
		$('#car_updForm #carLoad').numberbox('setValue',data.carLoad);
		$('#car_updForm #carSeats').numberbox('setValue',data.carSeats);
		$('#car_updForm #oilWear').numberbox('setValue',data.oilWear);
		$('#car_updForm #initMil').numberbox('setValue',data.initMil);
		$('#car_updForm #maintainMil').numberbox('setValue',data.maintainMil);
		$('#car_updForm #maintainPeriod').numberbox('setValue',data.maintainPeriod);
		$('#car_updForm [name=engineNum]').val(data.engineNum);
		$('#car_updForm [name=frameNum]').val(data.frameNum);		
		$('#car_updForm #purchasePrice').numberbox('setValue',data.purchasePrice);		
		$('#car_updForm #purchaseDate').datebox('setValue',formatDate(data.purchaseDate));		
		$('#car_updForm [name=remarks]').val(data.remarks);
		$('#car_updForm [name=isdisable][value='+data.isdisable+']').prop('checked',true);					
		//绑定数据结束
	}
	/*绑定待修改内容结束*****************************/
	
	/*图片管理界面操作开始*****************************/
	function carPicManager(id){
		//还原车辆图片信息界面
		//reloadFileHtml();		
		
		//车辆id放入隐藏域
		$('#car_picForm #id').val(id);
		
		//展示图片界面
		carPicShow(id);
		
		$('#car_picDialog').dialog('open');
	}	
	/*图片管理界面操作结束*****************************/
	
	/*图片展示界面操作开始*****************************/
	function carPicShow(id){
		//条件容器
		var params={};
		params['id']=id;
		
		//取得数据
		$.ajax({
			url:'<%=basePath%>car_findCarPic.action',
			data:params,
			dataType:'json',
			type:'POST',
			success:function(data){				
				//产生图片表格
				createPicTab(data);		
			}
		});
	}
	//生成 总行数*3的表格
	function createPicTab(data){
		var strPics='';	
		var cell=3;//列数
		var count=0;
		var oCarPic;
		
		if(data !=null){			
			var picLen=data.length;//总图片数量			
			var lastLen=picLen%cell;//最后一行的图片数量			
			var rowLen=parseInt(lastLen==0?picLen/cell:picLen/cell+1);//总行数
				
			//循环行		
			for(var i=0;i<rowLen;i++){
				strPics+='<tr>';
				//循环列
				for(var j=0;j<cell;j++){
					strPics+='<td>';
					
					//根据图片的数量决定是否继续拼接					
					if(count <=picLen-1){
						oCarPic=data[count];
						strPics+='<div>';
							//隐藏的图片信息ID
							strPics+='<input type="hidden" id="carPicId" value="'+oCarPic.id+'"/>';
							//隐藏的图片路径
							strPics+='<input type="hidden" id="carPicPath" value="'+oCarPic.imgPath+'"/>';
							strPics+='<img name="cpimg" src="<%=basePath%>upload/'+oCarPic.imgPath+'" />';
							strPics+='<span>'+exp(oCarPic.des)+'</span><br/>';
							strPics+='<input type="image" src="<%=basePath%>Inc/img/del_24.png"/>';						
						strPics+='</div>';
						count++;
					}
					
					strPics+='</td>';
				}				
				strPics+='</tr>';
			}
			
			$('#car_picShowTab').html(strPics);
		}
	}
	/*图片展示界面操作结束*****************************/	
	</script>

  </head>
  
  <body>
    <!-- 数据展示窗体创建位置 --> 
  	<table id="car_dg"></table>
  	
  	<!-- 数据工具栏创建位置 -->   
	<div id="car_tb">
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
			<div data-options="name:'name'">车牌号码</div>
		</div>
	</div>
	
	<!-- 详细窗体创建位置 -->
	<div id="car_showDialog" class="easyui-dialog" title="车辆详细信息" 
		style="width:500px;height:650px;align:center;top:1px;"   
        data-options="iconCls:'icon-tip',resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#car_dg').datagrid('unselectAll');
				$('#car_showDialog').dialog('close');
			}
		}]">
		<table>
			<tr>
				<td style="text-align:rigth;">车牌号码：</td>
				<td>
					<span id="carNo"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">车辆品牌：</td>
				<td>
					<span id="carBrand"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">车辆型号：</td>
				<td>
					<span id="carModel"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">车辆颜色：</td>
				<td>
					<span id="carColor"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">载&nbsp;重&nbsp;量：</td>
				<td>
					<span id="carLoad"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">座&nbsp;位&nbsp;数：</td>
				<td>
					<span id="carSeats"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">油&nbsp;&nbsp;&nbsp;&nbsp;耗：</td>
				<td>
					<span id="oilWear"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">初始里程：</td>
				<td>
					<span id="initMil"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">保养里程：</td>
				<td>
					<span id="maintainMil"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">保养周期：</td>
				<td>
					<span id="maintainPeriod"></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">发动机号：</td>
				<td>
					<span id=engineNum></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">车&nbsp;架&nbsp;号：</td>
				<td>
					<span id=frameNum></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">供&nbsp;应&nbsp;商：</td>
				<td>
					<span id=sup></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">购买价格：</td>
				<td>
					<span id=purchasePrice></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">购买日期：</td>
				<td>
					<span id=purchaseDate></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
				<td>
					<span id=dept></span>
				</td>
			</tr>
			<tr>
				<td style="text-align: rigth;">车辆状态：</td>
				<td>
					<span id=carState></span>
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
	<div id="car_addDialog" class="easyui-dialog" title="新增车辆信息" 
		style="width:500px;height:650px;align:center;top:1px;"   
        data-options="iconCls:'icon-add',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#car_addForm').form('submit',{
					url:'<%=basePath%>car_addCar.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//新增成功刷新DG
							$('#car_dg').datagrid('load');
						
							//成功后清空表单数据
							$('#car_addForm').form('clear');
							//关闭表单
							$('#car_addDialog').dialog('close');
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
				$('#car_addDialog').dialog('close');
			}
		}]">
		<form id="car_addForm" method="post">
			<table>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" name="carNo" maxlength="7" class="easyui-validatebox" data-options="required:true"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">品&nbsp;&nbsp;&nbsp;&nbsp;牌：</td>
					<td>
						<input id="carBrand" name="carBrand.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">型&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
					<td>
						<input id="carModel" name="carModel.id" class="easyui-combobox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">颜&nbsp;&nbsp;&nbsp;&nbsp;色：</td>
					<td>
						<input id="carColor" name="carColor" class="easyui-combobox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">载&nbsp;&nbsp;&nbsp;&nbsp;重（吨）：</td>
					<td>
						<input type="text" name="carLoad"  data-options="min:0,max:99,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">座&nbsp;位&nbsp;数：</td>
					<td>
						<input type="text" name="carSeats"  data-options="min:0,max:99" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">油&nbsp;&nbsp;&nbsp;&nbsp;耗（百公里）：</td>
					<td>
						<input type="text" name="oilWear"  data-options="min:0,max:99,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">初始里程（公里）：</td>
					<td>
						<input type="text" name="initMil" data-options="min:0" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保养里程（公里）：</td>
					<td>
						<input type="text" name="maintainMil" data-options="min:0" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保养周期（月）：</td>
					<td>
						<input type="text" name="maintainPeriod" data-options="min:0,max:24" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">发动机号码：</td>
					<td>
						<input type="text" name="engineNum" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">车&nbsp;架&nbsp;号：</td>
					<td>
						<input type="text" name="frameNum" maxlength="20"/>
					</td>
				</tr>				
				<tr>
					<td style="text-align: rigth;">供&nbsp;应&nbsp;商：</td>
					<td>
						<input id="sup" name="sup.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">购买价格：</td>
					<td>
						<input type="text" name="purchasePrice" data-options="min:0,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">购买日期：</td>
					<td>
						<input type="text" id="purchaseDate" name="purchaseDate" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
					<td>
						<input id="dept" name="dept.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">车辆状态：</td>
					<td>
						<input id="carState" name="carState"/>
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
	<div id="car_updDialog" class="easyui-dialog" title="修改车辆信息" 
		style="width:500px;height:650px;align:center;top:1px;"   
        data-options="iconCls:'icon-edit',resizable:false,modal:true,closed:true,
        buttons:[{
        	text:'保存',
			iconCls: 'icon-ok',
			handler: function(){
				$('#car_updForm').form('submit',{
					url:'<%=basePath%>car_updCar.action',
					success:function(data){
						var obj=$.parseJSON(data);
						if(obj.success){
							//去除选择
							$('#car_dg').datagrid('unselectAll');
							//成功后清空表单数据
							$('#car_updForm').form('clear');
							//刷新dg
							$('#car_dg').datagrid('reload');
							//关闭表单
							$('#car_updDialog').dialog('close');
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
				$('#car_updForm').form('clear');
				//去除选择
				$('#car_dg').datagrid('unselectAll');
				$('#car_updDialog').dialog('close');
				
				
			}
		}]">
		<form id="car_updForm" method="post">
			<table>
				<tr>
					<td></td>
					<td><input type="hidden" name="id"/></td>
				</tr>
				<tr>
					<td style="text-align:rigth;">车牌号码：</td>
					<td>
						<input type="text" name="carNo" maxlength="7" disabled="disabled" />
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">品&nbsp;&nbsp;&nbsp;&nbsp;牌：</td>
					<td>
						<input id="carBrand" name="carBrand.id" class="easyui-combobox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">型&nbsp;&nbsp;&nbsp;&nbsp;号：</td>
					<td>
						<input id="carModel" name="carModel.id" class="easyui-combobox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">颜&nbsp;&nbsp;&nbsp;&nbsp;色：</td>
					<td>
						<input id="carColor" name="carColor" class="easyui-combobox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">载&nbsp;&nbsp;&nbsp;&nbsp;重（吨）：</td>
					<td>
						<input type="text" id="carLoad" name="carLoad"  data-options="min:0,max:99,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">座&nbsp;位&nbsp;数：</td>
					<td>
						<input type="text" id="carSeats" name="carSeats"  data-options="min:0,max:99" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">油&nbsp;&nbsp;&nbsp;&nbsp;耗（百公里）：</td>
					<td>
						<input type="text" id="oilWear" name="oilWear"  data-options="min:0,max:99,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">初始里程（公里）：</td>
					<td>
						<input type="text" id="initMil" name="initMil" data-options="min:0" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保养里程（公里）：</td>
					<td>
						<input type="text" id="maintainMil" name="maintainMil" data-options="min:0" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">保养周期（月）：</td>
					<td>
						<input type="text" id="maintainPeriod" name="maintainPeriod" data-options="min:0,max:24" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">发动机号码：</td>
					<td>
						<input type="text" name="engineNum" maxlength="20"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">车&nbsp;架&nbsp;号：</td>
					<td>
						<input type="text" name="frameNum" maxlength="20"/>
					</td>
				</tr>				
				<tr>
					<td style="text-align: rigth;">供&nbsp;应&nbsp;商：</td>
					<td>
						<input id="sup" name="sup.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">购买价格：</td>
					<td>
						<input type="text" id="purchasePrice" name="purchasePrice" data-options="min:0,precision:2" class="easyui-numberbox"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">购买日期：</td>
					<td>
						<input type="text" id="purchaseDate" name="purchaseDate" class="easyui-datebox" required="required"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">部&nbsp;&nbsp;&nbsp;&nbsp;门：</td>
					<td>
						<input id="dept" name="dept.id"/>
					</td>
				</tr>
				<tr>
					<td style="text-align: rigth;">车辆状态：</td>
					<td>
						<input id="carState" name="carState"/>
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
  	  	
  	<!-- 车辆图片管理窗体创建位置 -->
	<div id="car_picDialog" class="easyui-dialog" title="车辆图片信息" 
		style="width:600px;height:650px;align:center;top:5px;"   
        data-options="iconCls:'icon-edit',closable:false,resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){
				//去除选择
				$('#car_dg').datagrid('unselectAll');
				$('#car_picDialog').dialog('close');
				
				//还原车辆图片信息界面
				reloadFileHtml();
			}
		}]">		
		<table id="car_picShowTab"></table>
		<hr/>
		<form id="car_picForm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="id" id="id"/>
			<a id="addRow" class="easyui-linkbutton" data-options="iconCls:'icon-add'">添加上传按钮</a>
			<a id="upl" class="easyui-linkbutton" data-options="iconCls:'icon-save'">上传所选文件</a>
			<table id="upTab" cellpadding="3" cellspacing="3"></table>			
		</form>
	</div>  	
  	<!-- 车辆图片大图窗体创建位置 -->
  	<div id="car_showpicDialog" class="easyui-dialog" title="车辆图片原图" 
		style="width:550px;height:650px;align:center;top:5px;"   
        data-options="iconCls:'icon-edit',closable:true,resizable:false,modal:true,closed:true,
        buttons:[{
			text:'关闭',
			iconCls: 'icon-cancel',
			handler: function(){				
				$('#car_showpicDialog').dialog('close');
				$('#car_showpicDialog #maximg').prop('src','');
			}
		}]">
		<img id="maximg"/>
	</div>
  </body>
</html>

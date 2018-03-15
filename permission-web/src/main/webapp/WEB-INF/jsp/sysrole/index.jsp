<%@ page language="java" pageEncoding="UTF-8"%>  
<%  
String path = request.getContextPath();  
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";  
%>  
<!DOCTYPE html>  
<html>  
<head>  
<base href="<%=basePath%>">  
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
</head>  
<%@include file="/common.jsp" %>
<body> 
  <table id="userTable"  title="角色列表"
        data-options="url:'role/all',fitColumns:true,striped:true,rownumbers:true,iconCls:'icon-search'">
    <thead>
        <tr>
        	<th data-options="field:'tyu',checkbox:true"></th>
        	<th data-options="field:'id',width:30,sortable:true,order:'desc'">Id</th>
            <th data-options="field:'name',width:100,sortable:true">姓名</th>
            <th data-options="field:'available',width:200,formatter:avaliableFormatter">是否可用</th>
            <th data-options="field:'world',width:50,formatter:opFormatter">权限管理</th>
        </tr>
    </thead>
</table>
<div id="tb">
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_user();" data-options="iconCls:'icon-add',plain:true">添加</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit_user();" data-options="iconCls:'icon-edit',plain:true">修改</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="delete_user();" data-options="iconCls:'icon-remove',plain:true">删除</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">导出</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">批量导入</a>
</div>
</body>  
<script type="text/javascript">  
	$(function(){
		$("#userTable").datagrid({
			pagination : true,
			toolbar : "#tb",
			idField : "id",
			onLoadSuccess:function(){
				$("a.op").tooltip({
					position:'right'
				});
			}
		});
	})
	function avaliableFormatter(value,row,index){
		if(value == 0){
			return "否";
		}
		return "是";
	}
	function opFormatter(value,row,index){
		return "<a href='#' title='分配权限' class='op'><img src='easyui/themes/icons/large_chart.png' width='16'/></a>"
	}
	//删除选中的用户
	function delete_user(){
		//1. 获取选中的数据，如果没有选中，则提示必须选中数据
		var selRows = $("#userTable").datagrid("getSelections");
		if(selRows.length == 0){
			$.messager.alert("提示","请选择要删除的数据行！","warning");
			return;
		}
		//2. 提示是否删除？是
		$.messager.confirm("提示","确定要删除选中的数据吗？",function(r){
			if(r){
				//3. 发送异步请求，带选中行的编号
				//拼接删除条件
				var postData = "";
				$.each(selRows,function(i){
					postData += "ids="+this.id;
					if(i < selRows.length - 1){
						postData += "&";
					}
				});
				$.post("role/batchDelete",postData,function(data){
					if(data.result == true){
						//4. 删除成功后，刷新表格 reload
						$("#userTable").datagrid("reload");
					}
				});
			}
		});
	}
	function add_user(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加角色",
			iconCls : "icon-add",
			width:300,
			height:200,
			modal:true,
			href : "role/form",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#roleForm").form("submit",{
						url : "role/add",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}

	function edit_user(){
		var row = $("#userTable").datagrid("getSelected");
		if(row == null){
			return;
		}

		//如果选中了多个，只保留row这个
		$("#userTable").datagrid("clearSelections");
		$("#userTable").datagrid("selectRecord",row.id);
		
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "编辑用户",
			iconCls : "icon-edit",
			width:500,
			height:300,
			modal:true,
			href : "role/form",
			onClose:function(){$(this).dialog("destroy"); },
			onLoad:function(){
				//发送异步请求，查询数据
				$.post("role/view",{id:row.id},function(data){
					$("#roleForm").form("load",data);
				});
			},
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#roleForm").form("submit",{
						url : "role/edit",
						success : function(data){
							d.dialog("close");
							$("#userTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:"icon-cancel",
				text:"取消",
				handler:function(){
					d.dialog("close");
				}
			}]
		});
	}
</script>  
</html> 
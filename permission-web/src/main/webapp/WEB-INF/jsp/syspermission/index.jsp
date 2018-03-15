<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<base href="<%=basePath%>">
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<%@include file="/common.jsp" %>
<script type="text/javascript">
	$(function(){
		$("#permissionTable").treegrid({
			toolbar:"#tb",
			idField:"id",
			treeField:"text",
			animate:true,
			onLoadSuccess : function(){
				//$(this).treegrid("collapseAll");
			},
			loadFilter : function(data){
				$.each(data,function(){
					this.state = "open";
				});
				return data;
			}
		});
	});
	function add_permissionc(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加子级节点",
			iconCls : "icon-add",
			width:300,
			height:200,
			modal:true,
			href : "permission/addc",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#PermissionFormc").form("submit",{
						url : "permission/addc",
						success : function(data){
							d.dialog("close");
							$("#permissionTable").treegrid("reload");
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
	function add_permissionp(){
		var d = $("<div></div>").appendTo("body");
		d.dialog({
			title : "添加父级节点",
			iconCls : "icon-add",
			width:300,
			height:200,
			modal:true,
			href : "permission/showaddp",
			onClose:function(){$(this).dialog("destroy"); },
			buttons:[{
				iconCls:"icon-ok",
				text:"确定",
				handler:function(){
					$("#PermissionFormp").form("submit",{
						url : "permission/addp",
						success : function(data){
							d.dialog("close");
							$("#permissionTable").treegrid("reload");
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
</head>
<body>

<table id="permissionTable"  title="Permission List"
        data-options="url:'permission/list',fitColumns:true,striped:true,iconCls:'icon-search'">
    <thead>
        <tr>
            <th data-options="field:'text',width:100,sortable:true">Text</th>
            <th data-options="field:'available',width:100,sortable:true">Available</th>
            <th data-options="field:'url',width:50">Url</th>
        </tr>
    </thead>
</table>
<div id="tb">
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_permissionp();" data-options="iconCls:'icon-add',plain:true">添加父级</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="add_permissionc();" data-options="iconCls:'icon-add',plain:true">添加子级</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="edit_role();" data-options="iconCls:'icon-edit',plain:true">修改</a>
<a href="javascript:void(0)" class="easyui-linkbutton" onclick="delete_role();" data-options="iconCls:'icon-remove',plain:true">删除</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true">导出</a>
<a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">批量导入</a>
</div>
</body>
</html>





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
<link rel="stylesheet" type="text/css" href="css/bootstrap.min.css">    
</head>  
<body>  
  <form action="" id="PermissionFormc" method="post">
		<input type="hidden" name="id" />
		<p>
			父级节点 : <input type="text" name="name" class="easyui-validatebox" data-options="required:true,missingMessage:'必须填写'" />
		</p>
		<p>
			子节点名称 : <input type="text" name="cname" class="easyui-validatebox" data-options="required:true,missingMessage:'必须填写'" />
		</p>
		<p>
			URl : <input type="text" name="url" class="easyui-validatebox" data-options="required:true,missingMessage:'必须填写'" />
		</p>
	</form>
</body>  
<script type="text/javascript" src="js/jquery.min.js"></script>  
<script type="text/javascript">
</script>  
</html> 
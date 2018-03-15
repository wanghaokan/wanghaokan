package org.aptech.shiro.permission.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.apache.log4j.chainsaw.Main;
import org.apache.shiro.authc.LogoutAware;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.aptech.shiro.permission.dao.SysPermissionDao;
import org.aptech.shiro.permission.dao.SysUserDao;
import org.aptech.shiro.permission.pojo.SysPermission;
import org.aptech.shiro.permission.pojo.SysUser;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/user")
public class SysUserController {
	@Resource
	private SysUserDao sysUserDao;
	@Resource
	private SysPermissionDao sysPermissionDao;

	public void setSysPermissionDao(SysPermissionDao sysPermissionDao) {
		this.sysPermissionDao = sysPermissionDao;
	}

	public void setSysUserDao(SysUserDao sysUserDao) {
		this.sysUserDao = sysUserDao;
	}
	
	@RequestMapping(value="/login",method=RequestMethod.GET)
	public String login() throws Exception {
		return "login";
	}
	
	@RequestMapping("/main")
	public String main() throws Exception {
		return "main";
	}
	
	@RequestMapping(value="/login",method=RequestMethod.POST)
	public String login(String username, String password, ModelMap modelMap, HttpSession session) throws Exception {
		SysUser sysUser = sysUserDao.getByUsername(username);
		if (sysUser == null) {
			modelMap.put("error", "用户名或者密码错误！");
			return "login";
		}else {
			Md5Hash md5Hash = new Md5Hash(password,sysUser.getSalt());
			if (!md5Hash.toString().equals(sysUser.getPassword())) {
				modelMap.put("error", "用户名或者密码错误！");
				return "login";
			}else {
				//查询登录用户拥有的所有权限菜单
				List<SysPermission> permissionList = sysPermissionDao.getPermissionsByUserId(sysUser.getId(), "menu");
				//查询用户所拥有的所有的功能编码
				List<String> percodes = sysPermissionDao.getPermissionCodeByUserId(sysUser.getId());
				session.setAttribute("percodes", percodes.toString());
				session.setAttribute("permissions", permissionList);
				session.setAttribute("login_user", sysUser);
				return "redirect:/user/main";
			}
		}
	}
	
	@RequestMapping("/logout")
	public String Logout(HttpSession session) throws Exception {
		session.removeAttribute("login_user");
		session.removeAttribute("permissions");
		return "redirect:/user/login";
	}
	
	@RequestMapping(value="/index",method=RequestMethod.GET)
	public String index() throws Exception {
		return "sysuser/index";
	}
	
	@RequestMapping(value="/form",method=RequestMethod.GET)
	public String form() throws Exception {
		return "sysuser/sysuser_form";
	}
	
	@RequestMapping("/list")
	@ResponseBody
	public Map<String, Object> list(Integer page, Integer rows,@RequestParam(defaultValue="id") String sort,@RequestParam(defaultValue="asc") String order,SysUser condition) throws Exception {
		Map<String, Object> map = new HashMap<>();
		
		int start = (page - 1) * rows;
		List<SysUser> list = sysUserDao.getListByCondition(start, rows, condition, sort, order);
		int total = sysUserDao.getCountByCondition(condition);
		
		map.put("rows", list);
		map.put("total", total);
		
		return map;
	}
	
	@RequestMapping(value="/add",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> add(SysUser user,Integer[] roleIds){
		Map<String, Object> map = new HashMap<>();
		//对密码进行加密存储
		Md5Hash md5Hash = new Md5Hash(user.getPassword(), user.getSalt());
		user.setPassword(md5Hash.toString());
		sysUserDao.add(user);
		sysUserDao.addUserRole(user.getId(), roleIds);
		
		map.put("result", true);
		return map;
	}
	
	@RequestMapping(value="/edit",method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> edit(SysUser user,Integer[] roleIds){
		Map<String, Object> map = new HashMap<>();
		//对密码进行加密存储
		Md5Hash md5Hash = new Md5Hash(user.getPassword(), user.getSalt());
		user.setPassword(md5Hash.toString());
		sysUserDao.update(user);
		sysUserDao.addUserRole(user.getId(), roleIds);
		
		map.put("result", true);
		return map;
	}
	
	@RequestMapping("/batchDelete")
	@ResponseBody
	public Map<String, Object> batchDelete(Integer[] ids) throws Exception {
		Map<String, Object> map = new HashMap<>();
		sysUserDao.deleteByIds(ids);
		map.put("result", true);
		return map;
	}
	@RequestMapping("/view")
	@ResponseBody
	public SysUser view(Integer id) throws Exception {
		return sysUserDao.getById(id);
	}
	
}







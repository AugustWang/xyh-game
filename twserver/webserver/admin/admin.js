/**
 * datepicker相关功能
 */
function customRange(input) {  
    return {
        minDate: (input.id == 'kwDateEnd' ? $('#kwDateBegin').datepicker('getDate') : null),  
        maxDate: (input.id == 'kwDateBegin' ? $('#kwDateEnd').datepicker('getDate') : null)};  
}
function Q(url, item){
	var svalue = url.match(new RegExp('[\?\&]' + item + '=([^\&]*)(\&?)','i'));
	svalue=svalue ? svalue[1] : svalue;
	return decodeURIComponent(svalue);
} 
$(document).ready(function(){
    //主菜单折叠
    $('.js_menu_child').menu();

    //自动应用GridView插件
    if($('#gridview').size()){
        GridView.init('#gridview');
    }
	GridView.init('.grid');

    //自动应用datepicker插件
    $('.datefield').css('width', '80px').datepicker();
    $('.js_starttime').datepicker({dateFormat:'yy-mm-dd 00:00:00'});
    $('.js_endtime').datepicker({dateFormat:'yy-mm-dd 23:59:59'});
    
    //范围日期选择必须使用'kwDateBegin'和'kwDateEnd'这两个ID
    if($('#kwDateBegin').size() && $('#kwDateEnd').size()){
        $('#kwDateBegin, #kwDateEnd').datepicker({
            beforeShow: customRange
        }); 
    }
});

/**
 * 生成折叠菜单
 * @param bool hl 是否高亮当前菜单
 */
$.fn.menu = function(){
    return this.each(function(){
        var id = parseInt(this.id.replace(/child/g,''));
        if(iMenu.isShow(id))
        	$(this).show();
        else
        	$(this).hide();
    });
};

function getCookie(name){
	if (!name) 
		return false;
	name += "=";
	var value = document.cookie + ";";
	var start = value.lastIndexOf(name);
	if (start != -1) {
		var end = value.indexOf(";", start);
		return unescape(unescape(value.substring(start + name.length, end)));
	}
	return "";
}

function setCookie(key, value, ttl, path, domain, secure){
	//cookie = [key + '=' + escape(value), 'path=' + ((!path || path == '') ? '/' : path), 'domain=' + ((!domain || domain == '') ? window.location.hostname : domain)];
	cookie = [key + '=' + escape(value)];
	if (ttl) {
		now = new Date();
		now.setTime(now.getTime() + (parseInt(ttl) * 60 * 60 * 1000));
		cookie.push(now.toGMTString());
	}
	
	if (secure) 
		cookie.push('secure');
	return document.cookie = cookie.join('; ');
}

var iMenu = {
	cache : null,
	cookie2list : function(){
		if(iMenu.cache)return iMenu.cache;
		var ck = getCookie('menuck');
		if(!ck)return {4:1,1:1};
		var sp = ck.split(',');
		var ls = [],tmp;
		for(var i in sp)
		{
			tmp = sp[i].split(':');
			ls[parseInt(tmp[0])]=parseInt(tmp[1]);
		}
		iMenu.cache = ls;
		return ls;
	},
	set : function(id, display){
		var ls = iMenu.cookie2list();
		ls[id] = display;
		var ck = [];
		for(var id in ls)
		{
			ck.push(id+':'+ls[id]);
		}
		setCookie('menuck', ck.join(','), 30*24*3600);
		iMenu.cache = null;
		var test=document.cookie;
		test=null;
	},
	isShow : function(id){
		var ls = iMenu.cookie2list();
		if(ls[id])
			return true;
		return false;
	}
};

/**
 * 
 * 菜单管理
 *
 */
function expand(el)
{
	childObj = document.getElementById("child" + el);
	var display=childObj.style.display;
	//$('.js_menu_child').hide();
    $('.js_menu_child').each(
        function(){
            iMenu.set(this.id.replace(/child/ig, ''), 0);
            $(this).hide();
        }
    );
	if (display == 'none')
	{
		childObj.style.display = '';
		iMenu.set(el, 1);
	}
	else
	{
		childObj.style.display = 'none';
		iMenu.set(el, 0);
	}
	return;
}


/**
 * 弹出居中窗口
 * @param string src 窗口内容地址
 * @param int w 宽度
 * @param int h 高度
 * @param bool resizable 是否允许改变大小和出现滚动条
 * @param string name 窗口名称
 * @return null
 */
var winOpen = function(src, w, h, name, r){
    var l = (screen.width - w) / 2;
    var t = (screen.height - h) / 2;
    var r = r ? 'resizable=yes,scrollbars=yes' : 'resizable=no,scrollbars=no';
    name = name ? name : '_blank';
    var win = window.open(src, name, 'width=' + w + ',height=' + h + ',top=' + t + ',left=' + l + ',' + r);
    win.focus()
    return win;
}

var rand = function(){
	return (new Date).getTime();
};

var divDialog;

function getDivDialog(){
    if(divDialog != null){
        divDialog.remove();
        $(divDialog).dialog( "close" );
    }
    divDialog = document.createElement("div");
    $("body").append(divDialog);
    return divDialog;
}


function getUrlParam(name)
{
    var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
    var r = window.location.search.substr(1).match(reg);  //匹配目标参数
    if (r!=null) return unescape(r[2]); return null; //返回参数值
} 

function gm_action_do(url, params, width ){
    $("button[id='gm_action_button']").attr("disabled", "disabled");
    $.get(url, params, function(data){
        var divDialog = getDivDialog();
        var dialog = $(divDialog).dialog({ 
            autoOpen: false, 
            width: width ,
            buttons: [
        {
            text: "Ok",
            click: function() {
                $( this ).dialog( "close" );
            }
        }
        ],
            title: "NOTICE",
        });
        $(divDialog).html( data );
        dialog.dialog( "open" );
    });
}

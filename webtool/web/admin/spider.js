var SortTimeout = null;
/**
 * Author: 249828165@qq.com 
 */
function toArray(arr)
{
  var rt = [];
  for(var i=0; i<arr.length; i++)
  {
    rt[i] = arr[i];
  }
  return rt;
}

function intval(v)
{
  v = parseInt(v);
  if(isNaN(v))
    return 0;
  return v;
}

function rand()
{
  return (new Date).getTime();
}

var Spider = {
  servers : [],
  timeout : [],
  conn_timeout : 15000,
  url : '',  //附加URL height=90&width=90, 由set_url控制
  append_url : '',
  callfunc : '', //请求远程服务器调用的函数
  admin_key : '', //远程握手钥匙
  username : '', //管理员名称
  query_file : '', //请求文件名
  cache : [],
  delayTime : 700, //各个服务器延迟请求时间
  delayTimeVal : 0,
  ts : 0,
  group_id : 0, //只某个代理商
  order_row : 0, //默认降序的列，从0开始
  srv_id : '', //平台组ID|服务器ID 或数字，即服务器id
  stat_date:[],   //统计所有服返回的日期，各个日期唯一。
  stat_data:[],   //缓存各个服返回的数据
  fetch_local : false, //是否跨域获取，调用 url_callback() 控制地址
  use_flash : false, //是否使用flash来跨域
  ajax_type : 'GET', //请求方式 
  url_callback : function(gid, id, srvinfo){
    return '';
  },
  callback : function(data, gid, id, srvinfo){}, //ajax 回调函数
	
  set_srv : function(s){
    this.servers = s;
  },
	
  set_date : function(d){
    return this.stat_date[d] = null;
  },
	
  get_date : function(){
    var rt = [];
    for(var i in this.stat_date)
    {
      rt.push(i);
    }
    return this.sort(rt);
  },
	
  get_date_key : function(d){
    d = d.replace(/[\/~\s\-]/g, '');
    return 'js_'+d;
  },
	
  set_data : function(key, data){
    this.stat_data[key]=data;
    return this.stat_data;
  },
	
  get_data : function(){
    return this.stat_data;
  },
	
  //set and self increase
  //varname, key1, key2, value
  si : function(){
    //var args = toArray(arguments);
    var args = typeof(arguments[0])==="string" ? arguments : arguments[0];
    var len = args.length;
    var value = parseFloat(args[len-1]);
    args[len-1] = 0;
    var v = this.g(args);
    v = v ? parseFloat(v) : 0;
    args[len-1] = value+v;
    this.s(args);
    return args[len-1];
  },
	
  //只保存最大值
  max : function(){
    var args = toArray(arguments);
    var len = args.length;
    var value = parseFloat(args[len-1]);
    if(isNaN(value))
      value=0;
    args[len-1] = 0;
    var v = this.g(args);
    v = v ? parseFloat(v) : 0;
    if(value > v)
    {
      args[len-1] = value;
      this.s(args);
      return value;
    }
    return v;
  },
	
  get_time_name : function(sec){
    if(sec < 60)
      return sec + '秒';
    if(sec < 3600)
      return Math.round(sec/60)+'分钟';
		
    return Math.round(sec/3600)+'小时';
  },
	
  //设置平均值
  set_avg : function(){
    var args = toArray(arguments);
    var len = args.length;
    var value = parseFloat(args[len-1]);
    if(isNaN(value))
      value=0;
    //设置值的累和
    args[len-1] = 'value';
    args[len] = value;
    var sum = this.si(args);
    //设置数量
    args[len-1] = 'num';
    args[len] = 1;
    var num = this.si(args);
    if(!num)return 0;
    return Math.round(sum/num);
  },
	
  get_avg : function(){
    var args = toArray(arguments);
    var a = this.g(args);
    if(a && a['value'] && a['num'])
      return Math.round(a['value']/a['num']);
		
    return 0;
  },
	
  //设置， 方便地处理数组 
  //varname, key1, key2, value
  s : function(){
    var args = typeof(arguments[0])==="string" ? arguments : arguments[0];
    var alen = args.length;
    var value = args[alen-1];
    var js = '';
    for(var i=0; i<alen-1; i++)
    {
      var keyname = args[i];
      js += '["'+keyname+'"]';
      if(i != alen-2)
        eval('if(!Spider.cache'+js+'){Spider.cache'+js+'=[];}');
    }
    var rt = 0;
    js = 'rt = Spider.cache'+js+'=value;';
    eval(js);
    return rt;
  },
	
  //varname, key1, key2, default_val
  g : function(){
    var args = typeof(arguments[0])==="string" ? arguments : arguments[0];
    var alen = args.length;
    var default_val = args[alen-1];
    var js = '';
    var undef;
    for(var i=0; i<alen-1; i++)
    {
      var keyname = args[i];
      js += '["'+keyname+'"]';
      eval('undef = typeof(Spider.cache'+js+')==="undefined";');
      if(undef === true)return default_val;
    }
    var rt = 0;
    js = 'rt = Spider.cache'+js+';';
    eval(js);
    return rt;
  },
	
  //varname, key1, key2 e.g  (total, '*', '*', 'gold')
  sum : function(){
    var args = toArray(arguments);
    return this.sum_loop(this.cache, args);
  },
	
  sum_loop : function(cache, args){
    if(typeof(cache) == 'number' || typeof(cache) == 'string')
    {
      var num = parseFloat(cache);
      if(isNaN(num))
        return 0;
      return num;
    }
		
    if(typeof(cache) != 'object' || !args || args.length == 0)
      return 0;
		
    var keyname = args.shift();
		
    if(keyname != '*')
    {
      return this.sum_loop(cache[keyname], args);
    }
		
    var rt = 0;
		
    for(var k in cache)
    {
      //利用toArray断掉引用
      rt += this.sum_loop(cache[k], toArray(args));
    }
    return rt;
  },
	
  /**
	 * @param object | array $o
	 */
  set_url : function(o){
    this.url = $.param(o);
		
  },
	
  ksort : function(data){
    var date=[];
    for(var k in data)
    {
      date.push(k);
    }
    date = this.sort(date);
    var rt = [],v;
    for(var k in date)
    {
      v=date[k];
      rt[v] = data[v];
    }
    return rt;
  },
    
  sort : function(data){
    return data.sort(function(a, b){
      var aa = a.replace(/[\/~\s\-]/g, '');
      var bb = b.replace(/[\/~\s\-]/g, '');
      aa = parseInt(aa);
      if(isNaN(aa))aa=0;
      bb = parseInt(bb);
      if(isNaN(bb))bb=0;
      return aa - bb;
    });
  },
	
  init : function(){
    //Spider.delayTimeVal=0;
    if(this.group_id)
    {
      var i = this.group_id;
      for(var ii in this.servers[i]['hosts'])
      {
        Spider.delayTimeVal+=Spider.delayTime;
        setTimeout('Spider.fetch('+i+', '+ii+')', Spider.delayTimeVal);
      }
      return true;
    }
    if(this.srv_id && typeof(this.srv_id) == 'string')
    {
      var s = this.srv_id.split('|');
      var group_id = parseInt(s[0]);
      var host_id = parseInt(s[1]);
      this.fetch(group_id, host_id);
      return true;
    }
        
    for(var i in this.servers)
    {
      for(var ii in this.servers[i]['hosts'])
      {
        if(this.srv_id && typeof(this.srv_id) == 'number')
        {
          if(this.srv_id != ii)
            continue;
        }
        Spider.delayTimeVal+=Spider.delayTime;
        setTimeout('Spider.fetch('+i+', '+ii+')', Spider.delayTimeVal);
      }
    }
  },
	
  init_table : function(){
    clearTimeout(window.SortTimeout);
    window.SortTimeout = setTimeout(function(){
      try{
        Spider.sort_table(".tabsort", Spider.order_row);
      }catch(e){}
    }, 5000);
  },
    
  sort_table : function(selector, row, desc){
    var table = $(selector);
    if(table.length < 1)return;
    try{
      table.tablesorter(); 
      // let the plugin know that we made a update 
      table.trigger("update"); 
      // set sorting column and direction, this will sort on the first and third column 
      var sorting = [[row, typeof(desc)=='undefined' || desc ? 1 : 0]];
      // sort on the first column 
      table.trigger("sorton",[sorting]);
    }catch(e){}
  },
	
  error : function(gid, id){
    var gsrv = Spider.servers[gid];
    var srvinfo = gsrv['hosts'][id];
    $('#js_r_'+gid+'_'+id).remove();
    $('#js_status').append('<span id="js_r_'+gid+'_'+id+'" style="color:red" class="js_ajax_req_now">'+srvinfo['name']+' 连接失败！<a href="#@" style="color:blue;font-weight:bold;" onclick="$(this).parent().remove();Spider.fetch(\''+gid+'\',\''+id+'\');">点击重试</a></span>');
  },
    
  get_srvinfo : function(gid, id){
    return this.servers[gid]['hosts'][id];
  },
	
  fetch : function(gid, id){
    var srvinfo = this.servers[gid]['hosts'][id];
    if(!srvinfo)return false;
    $('#js_status').append('<span id="js_r_'+gid+'_'+id+'" class="js_ajax_req_now" style="color:green;">正在请求'+srvinfo['name']+'...</span>');

    if(Spider.fetch_local)
    {
      $.ajax({
        url: Spider.url_callback(gid, id, srvinfo),
        timeout: this.conn_timeout,
        type: Spider.ajax_type,
        dataType : "json",
        error : function(){
          Spider.error(gid, id );
        },
        success: function(j){
          if(!j || typeof(j.data) == 'undefined')
            return Spider.error(gid, id );

          clearTimeout(Spider.timeout[gid+'_'+id]);
          $('#js_r_'+gid+'_'+id).remove();

          var srvinfo = Spider.servers[gid]['hosts'][id];
          Spider.callback(j.data, gid, id, srvinfo);
          Spider.init_table();
        }
      });
    }else if(Spider.use_flash){
      this.timeout[gid+'_'+id] = setTimeout(function(){
        $('#js_r_'+gid+'_'+id).remove();
        Spider.error(gid, id);
      }, Spider.conn_timeout+3500);
      
      $.flXHRproxy.registerOptions(srvinfo['url'],{
        xmlResponseText:false,
        loadPolicyURL:srvinfo['url']+"crossdomain.xml"
      });
      
      //<script type="text/javascript" src="flensed/flXHR.js"></script>
      //<script type="text/javascript" src="flensed/jquery.xhr.js"></script>
      //<script type="text/javascript" src="flensed/jquery.flXHRproxy.js"></script>

      $.ajaxSetup({
        transport:'flXHRproxy',
        timeout: this.conn_timeout,
        error:function(XHRobj,errtype,errObj) {
//          	alert("Error: "+errObj.number
//          		+"\nType: "+errObj.name
//          		+"\nDescription: "+errObj.description
//          		+"\nSource Object Id: "+errObj.srcElement.instanceId
//          	);
          Spider.error(gid, id );
        }
      });
      $.post(
        srvinfo['url']+"xge_api/"+this.query_file+"?func="+this.callfunc+"&admin_key="+this.admin_key+"&ts="+Spider.ts+"&username="+this.username,
        this.url,
        function(j){
          if(!j || !j.data)
            return Spider.error(gid, id );

          clearTimeout(Spider.timeout[gid+'_'+id]);
          $('#js_r_'+gid+'_'+id).remove();

          var srvinfo = Spider.servers[gid]['hosts'][id];
          Spider.callback(j.data, gid, id, srvinfo);
          Spider.init_table();
        },
        "json"
        );
    }else{
      this.timeout[gid+'_'+id] = setTimeout(function(){
        $('#js_r_'+gid+'_'+id).remove();
        Spider.error(gid, id);
      }, Spider.conn_timeout+3500);
      $.ajax({
        url: srvinfo['url']+"xge_api/"+this.query_file+"?func="+this.callfunc+"&admin_key="+this.admin_key+"&ts="+Spider.ts+"&username="+this.username+"&"+this.url,
        timeout: this.conn_timeout,
        dataType : "jsonp",
        jsonp: 'jsonp',
        success: function(j){
          if(!j || !j.data)
            return Spider.error(gid, id );

          clearTimeout(Spider.timeout[gid+'_'+id]);
          $('#js_r_'+gid+'_'+id).remove();

          var srvinfo = Spider.servers[gid]['hosts'][id];
          Spider.callback(j.data, gid, id, srvinfo);
          Spider.init_table();
        }
      });
    }
  }
};

/**
 * 处理带Checkbox的table事件
 * @author yeahoo2000@163.com
 */

/**
 *	通过类名取得节点(参考自prototype.js代码)
 *	@param string className 类名
 *	@param string|element 父节点
 */
function getElementsByClassName(className, pElement) {
	var child = (pElement || document.body).getElementsByTagName('*');
	var elms = new Array();
	for (var i = 0; i < child.length; i++)
		if(child[i].className.match(new RegExp("(^|\\s)" + className + "(\\s|$)")))
			elms.push(child[i]);
	return elms;
}

var GridView = {
	hl:'#f0f0cc',
	init:function(tid){
		var colors = ['#EFEFEF','#ffffff'];
		$(tid).each(
			function(index)
			{
				var nohover = $(this).hasClass('nohover') ;//鼠标移上去背景不变
				var tabclass = 'js_GRIDVIEW_TABLE_'+index;
				$(this).addClass(tabclass);

				$(this).find('tbody tr').each(
					function(){
						if(!$(this).parent().parent().hasClass(tabclass))
							return;
						this.bgColor = this.oBg = this.oldBg = GridView.cycle(colors);
						if(!nohover)
						{
							this.onmouseover = GridView.highlight;
							this.onmouseout = GridView.revert;
						}
						if(tid == '.grid')return true;
						this.onclick = GridView.checkbox;
						var cbs = $(this).find('input')[0];
						if(cbs){
							if(cbs.checked){
								this.bgColor = this.oBg = GridView.hl;
							}
						cbs.onclick = GridView.cbEvent;
						}
					}
				);
			}
			
		);
		return;
	},
	checkAll:function(){
		for(i=0; i<this.cbs.length; i++){
			GridView.setCheckbox(this.cbs[i]);
		}
	},
	uncheckAll:function(){
		for(i=0; i<this.cbs.length; i++){
			GridView.setCheckbox(this.cbs[i], 0);
		}
	},
	setCheckbox:function(o, val){
		row = o.parentNode.parentNode;
		v = null == val? o.checked : !val;
		if(v){
			row.bgColor = row.oBg = row.oldBg;
			//o.checked = false;
			row.onmouseover = GridView.highlight;
			row.onmouseout = GridView.revert;
		}else{
			row.bgColor = row.oBg = GridView.hl;
			//o.checked = true;
			row.onmouseover = null;
			row.onmouseout = null;
		}
	},
	checkbox : function(){
		var a = $(this).find(':checkbox');
		if(!a)return;
		var c =a.attr('checked');
		if(!a[0])return;
		var row = a[0].parentNode.parentNode;
		if (!c) {
			a.attr('checked', 'checked');
			row.onmouseover = null;
			row.onmouseout = null;
			row.bgColor = row.oBg = GridView.hl;
		}
		else {
			a.attr('checked', '');
			row.bgColor = row.oBg = row.oldBg;
			row.onmouseover = GridView.highlight;
			row.onmouseout = GridView.revert;
		}
	},
	cbEvent:function(event){
		if(window.event)
		{
			window.event.cancelBubble = true;
		}else{
			event.stopPropagation();
		}
		
		if(this.checked){
			GridView.setCheckbox(this, true);
		}else{
			GridView.setCheckbox(this, false);
		}
	},
	highlight:function(){
		this.bgColor = '#ddddff';
	},
	revert:function(){
		this.bgColor = this.oBg;
	},
	cycle:function(values){
		if(GridView.vIndex == null){
			GridView.vIndex = 0;
		}
		var v = values[GridView.vIndex++];
		if(GridView.vIndex >= values.length){
			GridView.vIndex = 0;
		}
		return v;
	}
}

/*!
 * jQuery UI 1.8.18
 *
 * Copyright 2011, AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT or GPL Version 2 licenses.
 * http://jquery.org/license
 *
 * http://docs.jquery.com/UI
 */
(function(f,e){function g(a){return !f(a).parents().andSelf().filter(function(){return f.curCSS(this,"visibility")==="hidden"||f.expr.filters.hidden(this)}).length}function h(a,l){var k=a.nodeName.toLowerCase();if("area"===k){var j=a.parentNode,i=j.name,d;if(!a.href||!i||j.nodeName.toLowerCase()!=="map"){return !1}d=f("img[usemap=#"+i+"]")[0];return !!d&&g(d)}return(/input|select|textarea|button|object/.test(k)?!a.disabled:"a"==k?a.href||l:l)&&g(a)}f.ui=f.ui||{};f.ui.version||(f.extend(f.ui,{version:"1.8.18",keyCode:{ALT:18,BACKSPACE:8,CAPS_LOCK:20,COMMA:188,COMMAND:91,COMMAND_LEFT:91,COMMAND_RIGHT:93,CONTROL:17,DELETE:46,DOWN:40,END:35,ENTER:13,ESCAPE:27,HOME:36,INSERT:45,LEFT:37,MENU:93,NUMPAD_ADD:107,NUMPAD_DECIMAL:110,NUMPAD_DIVIDE:111,NUMPAD_ENTER:108,NUMPAD_MULTIPLY:106,NUMPAD_SUBTRACT:109,PAGE_DOWN:34,PAGE_UP:33,PERIOD:190,RIGHT:39,SHIFT:16,SPACE:32,TAB:9,UP:38,WINDOWS:91}}),f.fn.extend({propAttr:f.fn.prop||f.fn.attr,_focus:f.fn.focus,focus:function(a,d){return typeof a=="number"?this.each(function(){var b=this;setTimeout(function(){f(b).focus(),d&&d.call(b)},a)}):this._focus.apply(this,arguments)},scrollParent:function(){var a;f.browser.msie&&/(static|relative)/.test(this.css("position"))||/absolute/.test(this.css("position"))?a=this.parents().filter(function(){return/(relative|absolute|fixed)/.test(f.curCSS(this,"position",1))&&/(auto|scroll)/.test(f.curCSS(this,"overflow",1)+f.curCSS(this,"overflow-y",1)+f.curCSS(this,"overflow-x",1))}).eq(0):a=this.parents().filter(function(){return/(auto|scroll)/.test(f.curCSS(this,"overflow",1)+f.curCSS(this,"overflow-y",1)+f.curCSS(this,"overflow-x",1))}).eq(0);return/fixed/.test(this.css("position"))||!a.length?f(document):a},zIndex:function(j){if(j!==e){return this.css("zIndex",j)}if(this.length){var i=f(this[0]),b,a;while(i.length&&i[0]!==document){b=i.css("position");if(b==="absolute"||b==="relative"||b==="fixed"){a=parseInt(i.css("zIndex"),10);if(!isNaN(a)&&a!==0){return a}}i=i.parent()}}return 0},disableSelection:function(){return this.bind((f.support.selectstart?"selectstart":"mousedown")+".ui-disableSelection",function(b){b.preventDefault()})},enableSelection:function(){return this.unbind(".ui-disableSelection")}}),f.each(["Width","Height"],function(l,k){function a(m,p,o,n){f.each(j,function(){p-=parseFloat(f.curCSS(m,"padding"+this,!0))||0,o&&(p-=parseFloat(f.curCSS(m,"border"+this+"Width",!0))||0),n&&(p-=parseFloat(f.curCSS(m,"margin"+this,!0))||0)});return p}var j=k==="Width"?["Left","Right"]:["Top","Bottom"],i=k.toLowerCase(),b={innerWidth:f.fn.innerWidth,innerHeight:f.fn.innerHeight,outerWidth:f.fn.outerWidth,outerHeight:f.fn.outerHeight};f.fn["inner"+k]=function(d){if(d===e){return b["inner"+k].call(this)}return this.each(function(){f(this).css(i,a(this,d)+"px")})},f.fn["outer"+k]=function(d,m){if(typeof d!="number"){return b["outer"+k].call(this,d)}return this.each(function(){f(this).css(i,a(this,d,!0,m)+"px")})}}),f.extend(f.expr[":"],{data:function(a,j,i){return !!f.data(a,i[3])},focusable:function(a){return h(a,!isNaN(f.attr(a,"tabindex")))},tabbable:function(a){var i=f.attr(a,"tabindex"),c=isNaN(i);return(c||i>=0)&&h(a,!c)}}),f(function(){var a=document.body,d=a.appendChild(d=document.createElement("div"));d.offsetHeight,f.extend(d.style,{minHeight:"100px",height:"auto",padding:0,borderWidth:0}),f.support.minHeight=d.offsetHeight===100,f.support.selectstart="onselectstart" in d,a.removeChild(d).style.display="none"}),f.extend(f.ui,{plugin:{add:function(a,l,k){var j=f.ui[a].prototype;for(var i in k){j.plugins[i]=j.plugins[i]||[],j.plugins[i].push([l,k[i]])}},call:function(j,i,m){var l=j.plugins[i];if(!!l&&!!j.element[0].parentNode){for(var k=0;k<l.length;k++){j.options[l[k][0]]&&l[k][1].apply(j.element,m)}}}},contains:function(d,c){return document.compareDocumentPosition?d.compareDocumentPosition(c)&16:d!==c&&d.contains(c)},hasScroll:function(a,k){if(f(a).css("overflow")==="hidden"){return !1}var j=k&&k==="left"?"scrollLeft":"scrollTop",i=!1;if(a[j]>0){return !0}a[j]=1,i=a[j]>0,a[j]=0;return i},isOverAxis:function(i,d,j){return i>d&&i<d+j},isOver:function(a,m,l,k,j,i){return f.ui.isOverAxis(a,l,j)&&f.ui.isOverAxis(m,k,i)}}))})(jQuery);jQuery.effects||function(x,w){function m(a){if(!a||typeof a=="number"||x.fx.speeds[a]){return !0}if(typeof a=="string"&&!x.effects[a]){return !0}return !1}function n(a,h,g,f){typeof a=="object"&&(f=h,g=null,h=a,a=h.effect),x.isFunction(h)&&(f=h,g=null,h={});if(typeof h=="number"||x.fx.speeds[h]){f=g,g=h,h={}}x.isFunction(g)&&(f=g,g=null),h=h||{},g=g||h.duration,g=x.fx.off?0:typeof g=="number"?g:g in x.fx.speeds?x.fx.speeds[g]:x.fx.speeds._default,f=f||h.complete;return[a,h,g,f]}function o(f,e){var h={_:0},g;for(g in e){f[g]!=e[g]&&(h[g]=e[g])}return h}function p(a){var f,e;for(f in a){e=a[f],(e==null||x.isFunction(e)||f in r||/scrollbar/.test(f)||!/color/i.test(f)&&isNaN(parseFloat(e)))&&delete a[f]}return a}function q(){var g=document.defaultView?document.defaultView.getComputedStyle(this,null):this.currentStyle,f={},j,i;if(g&&g.length&&g[0]&&g[g[0]]){var h=g.length;while(h--){j=g[h],typeof g[j]=="string"&&(i=j.replace(/\-(\w)/g,function(d,c){return c.toUpperCase()}),f[i]=g[j])}}else{for(j in g){typeof g[j]=="string"&&(f[j]=g[j])}}return f}function u(a,f){var c;do{c=x.curCSS(a,f);if(c!=""&&c!="transparent"||x.nodeName(a,"body")){break}f="backgroundColor"}while(a=a.parentNode);return v(c)}function v(a){var d;if(a&&a.constructor==Array&&a.length==3){return a}if(d=/rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(a)){return[parseInt(d[1],10),parseInt(d[2],10),parseInt(d[3],10)]}if(d=/rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(a)){return[parseFloat(d[1])*2.55,parseFloat(d[2])*2.55,parseFloat(d[3])*2.55]}if(d=/#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(a)){return[parseInt(d[1],16),parseInt(d[2],16),parseInt(d[3],16)]}if(d=/#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(a)){return[parseInt(d[1]+d[1],16),parseInt(d[2]+d[2],16),parseInt(d[3]+d[3],16)]}if(d=/rgba\(0, 0, 0, 0\)/.exec(a)){return t.transparent}return t[x.trim(a).toLowerCase()]}x.effects={},x.each(["backgroundColor","borderBottomColor","borderLeftColor","borderRightColor","borderTopColor","borderColor","color","outlineColor"],function(a,c){x.fx.step[c]=function(b){b.colorInit||(b.start=u(b.elem,c),b.end=v(b.end),b.colorInit=!0),b.elem.style[c]="rgb("+Math.max(Math.min(parseInt(b.pos*(b.end[0]-b.start[0])+b.start[0],10),255),0)+","+Math.max(Math.min(parseInt(b.pos*(b.end[1]-b.start[1])+b.start[1],10),255),0)+","+Math.max(Math.min(parseInt(b.pos*(b.end[2]-b.start[2])+b.start[2],10),255),0)+")"}});var t={aqua:[0,255,255],azure:[240,255,255],beige:[245,245,220],black:[0,0,0],blue:[0,0,255],brown:[165,42,42],cyan:[0,255,255],darkblue:[0,0,139],darkcyan:[0,139,139],darkgrey:[169,169,169],darkgreen:[0,100,0],darkkhaki:[189,183,107],darkmagenta:[139,0,139],darkolivegreen:[85,107,47],darkorange:[255,140,0],darkorchid:[153,50,204],darkred:[139,0,0],darksalmon:[233,150,122],darkviolet:[148,0,211],fuchsia:[255,0,255],gold:[255,215,0],green:[0,128,0],indigo:[75,0,130],khaki:[240,230,140],lightblue:[173,216,230],lightcyan:[224,255,255],lightgreen:[144,238,144],lightgrey:[211,211,211],lightpink:[255,182,193],lightyellow:[255,255,224],lime:[0,255,0],magenta:[255,0,255],maroon:[128,0,0],navy:[0,0,128],olive:[128,128,0],orange:[255,165,0],pink:[255,192,203],purple:[128,0,128],violet:[128,0,128],red:[255,0,0],silver:[192,192,192],white:[255,255,255],yellow:[255,255,0],transparent:[255,255,255]},s=["add","remove","toggle"],r={border:1,borderBottom:1,borderColor:1,borderLeft:1,borderRight:1,borderTop:1,borderWidth:1,margin:1,padding:1};x.effects.animateClass=function(a,h,g,f){x.isFunction(g)&&(f=g,g=null);return this.queue(function(){var e=x(this),d=e.attr("style")||" ",c=p(q.call(this)),b,i=e.attr("class");x.each(s,function(j,k){a[k]&&e[k+"Class"](a[k])}),b=p(q.call(this)),e.attr("class",i),e.animate(o(c,b),{queue:!1,duration:h,easing:g,complete:function(){x.each(s,function(j,k){a[k]&&e[k+"Class"](a[k])}),typeof e.attr("style")=="object"?(e.attr("style").cssText="",e.attr("style").cssText=d):e.attr("style",d),f&&f.apply(this,arguments),x.dequeue(this)}})})},x.fn.extend({_addClass:x.fn.addClass,addClass:function(a,h,g,f){return h?x.effects.animateClass.apply(this,[{add:a},h,g,f]):this._addClass(a)},_removeClass:x.fn.removeClass,removeClass:function(a,h,g,f){return h?x.effects.animateClass.apply(this,[{remove:a},h,g,f]):this._removeClass(a)},_toggleClass:x.fn.toggleClass,toggleClass:function(j,i,h,b,a){return typeof i=="boolean"||i===w?h?x.effects.animateClass.apply(this,[i?{add:j}:{remove:j},h,b,a]):this._toggleClass(j,i):x.effects.animateClass.apply(this,[{toggle:j},i,h,b])},switchClass:function(a,j,i,h,g){return x.effects.animateClass.apply(this,[{add:j,remove:a},i,h,g])}}),x.extend(x.effects,{version:"1.8.18",save:function(e,d){for(var f=0;f<d.length;f++){d[f]!==null&&e.data("ec.storage."+d[f],e[0].style[d[f]])}},restore:function(e,d){for(var f=0;f<d.length;f++){d[f]!==null&&e.css(d[f],e.data("ec.storage."+d[f]))}},setMode:function(d,c){c=="toggle"&&(c=d.is(":hidden")?"show":"hide");return c},getBaseline:function(f,e){var h,g;switch(f[0]){case"top":h=0;break;case"middle":h=0.5;break;case"bottom":h=1;break;default:h=f[0]/e.height}switch(f[1]){case"left":g=0;break;case"center":g=0.5;break;case"right":g=1;break;default:g=f[1]/e.width}return{x:g,y:h}},createWrapper:function(a){if(a.parent().is(".ui-effects-wrapper")){return a.parent()}var h={width:a.outerWidth(!0),height:a.outerHeight(!0),"float":a.css("float")},g=x("<div></div>").addClass("ui-effects-wrapper").css({fontSize:"100%",background:"transparent",border:"none",margin:0,padding:0}),f=document.activeElement;a.wrap(g),(a[0]===f||x.contains(a[0],f))&&x(f).focus(),g=a.parent(),a.css("position")=="static"?(g.css({position:"relative"}),a.css({position:"relative"})):(x.extend(h,{position:a.css("position"),zIndex:a.css("z-index")}),x.each(["top","left","bottom","right"],function(b,c){h[c]=a.css(c),isNaN(parseInt(h[c],10))&&(h[c]="auto")}),a.css({position:"relative",top:0,left:0,right:"auto",bottom:"auto"}));return g.css(h).show()},removeWrapper:function(a){var f,e=document.activeElement;if(a.parent().is(".ui-effects-wrapper")){f=a.parent().replaceWith(a),(a[0]===e||x.contains(a[0],e))&&x(e).focus();return f}return a},setTransition:function(a,h,g,f){f=f||{},x.each(h,function(b,d){unit=a.cssUnit(d),unit[0]>0&&(f[d]=unit[0]*g+unit[1])});return f}}),x.fn.extend({effect:function(a,B,A,z){var y=n.apply(this,arguments),l={options:y[1],duration:y[2],callback:y[3]},k=l.options.mode,j=x.effects[a];if(x.fx.off||!j){return k?this[k](l.duration,l.callback):this.each(function(){l.callback&&l.callback.call(this)})}return j.call(this,l)},_show:x.fn.show,show:function(d){if(m(d)){return this._show.apply(this,arguments)}var c=n.apply(this,arguments);c[1].mode="show";return this.effect.apply(this,c)},_hide:x.fn.hide,hide:function(d){if(m(d)){return this._hide.apply(this,arguments)}var c=n.apply(this,arguments);c[1].mode="hide";return this.effect.apply(this,c)},__toggle:x.fn.toggle,toggle:function(a){if(m(a)||typeof a=="boolean"||x.isFunction(a)){return this.__toggle.apply(this,arguments)}var d=n.apply(this,arguments);d[1].mode="toggle";return this.effect.apply(this,d)},cssUnit:function(a){var f=this.css(a),e=[];x.each(["em","px","%","pt"],function(d,c){f.indexOf(c)>0&&(e=[parseFloat(f),c])});return e}}),x.easing.jswing=x.easing.swing,x.extend(x.easing,{def:"easeOutQuad",swing:function(a,j,i,h,g){return x.easing[x.easing.def](a,j,i,h,g)},easeInQuad:function(g,f,j,i,h){return i*(f/=h)*f+j},easeOutQuad:function(g,f,j,i,h){return -i*(f/=h)*(f-2)+j},easeInOutQuad:function(g,f,j,i,h){if((f/=h/2)<1){return i/2*f*f+j}return -i/2*(--f*(f-2)-1)+j},easeInCubic:function(g,f,j,i,h){return i*(f/=h)*f*f+j},easeOutCubic:function(g,f,j,i,h){return i*((f=f/h-1)*f*f+1)+j},easeInOutCubic:function(g,f,j,i,h){if((f/=h/2)<1){return i/2*f*f*f+j}return i/2*((f-=2)*f*f+2)+j},easeInQuart:function(g,f,j,i,h){return i*(f/=h)*f*f*f+j},easeOutQuart:function(g,f,j,i,h){return -i*((f=f/h-1)*f*f*f-1)+j},easeInOutQuart:function(g,f,j,i,h){if((f/=h/2)<1){return i/2*f*f*f*f+j}return -i/2*((f-=2)*f*f*f-2)+j},easeInQuint:function(g,f,j,i,h){return i*(f/=h)*f*f*f*f+j},easeOutQuint:function(g,f,j,i,h){return i*((f=f/h-1)*f*f*f*f+1)+j},easeInOutQuint:function(g,f,j,i,h){if((f/=h/2)<1){return i/2*f*f*f*f*f+j}return i/2*((f-=2)*f*f*f*f+2)+j},easeInSine:function(g,f,j,i,h){return -i*Math.cos(f/h*(Math.PI/2))+i+j},easeOutSine:function(g,f,j,i,h){return i*Math.sin(f/h*(Math.PI/2))+j},easeInOutSine:function(g,f,j,i,h){return -i/2*(Math.cos(Math.PI*f/h)-1)+j},easeInExpo:function(g,f,j,i,h){return f==0?j:i*Math.pow(2,10*(f/h-1))+j},easeOutExpo:function(g,f,j,i,h){return f==h?j+i:i*(-Math.pow(2,-10*f/h)+1)+j},easeInOutExpo:function(g,f,j,i,h){if(f==0){return j}if(f==h){return j+i}if((f/=h/2)<1){return i/2*Math.pow(2,10*(f-1))+j}return i/2*(-Math.pow(2,-10*--f)+2)+j},easeInCirc:function(g,f,j,i,h){return -i*(Math.sqrt(1-(f/=h)*f)-1)+j},easeOutCirc:function(g,f,j,i,h){return i*Math.sqrt(1-(f=f/h-1)*f)+j},easeInOutCirc:function(g,f,j,i,h){if((f/=h/2)<1){return -i/2*(Math.sqrt(1-f*f)-1)+j}return i/2*(Math.sqrt(1-(f-=2)*f)+1)+j},easeInElastic:function(j,i,B,A,z){var y=1.70158,l=0,k=A;if(i==0){return B}if((i/=z)==1){return B+A}l||(l=z*0.3);if(k<Math.abs(A)){k=A;var y=l/4}else{var y=l/(2*Math.PI)*Math.asin(A/k)}return -(k*Math.pow(2,10*(i-=1))*Math.sin((i*z-y)*2*Math.PI/l))+B},easeOutElastic:function(j,i,B,A,z){var y=1.70158,l=0,k=A;if(i==0){return B}if((i/=z)==1){return B+A}l||(l=z*0.3);if(k<Math.abs(A)){k=A;var y=l/4}else{var y=l/(2*Math.PI)*Math.asin(A/k)}return k*Math.pow(2,-10*i)*Math.sin((i*z-y)*2*Math.PI/l)+A+B},easeInOutElastic:function(j,i,B,A,z){var y=1.70158,l=0,k=A;if(i==0){return B}if((i/=z/2)==2){return B+A}l||(l=z*0.3*1.5);if(k<Math.abs(A)){k=A;var y=l/4}else{var y=l/(2*Math.PI)*Math.asin(A/k)}if(i<1){return -0.5*k*Math.pow(2,10*(i-=1))*Math.sin((i*z-y)*2*Math.PI/l)+B}return k*Math.pow(2,-10*(i-=1))*Math.sin((i*z-y)*2*Math.PI/l)*0.5+A+B},easeInBack:function(b,l,k,j,i,h){h==w&&(h=1.70158);return j*(l/=i)*l*((h+1)*l-h)+k},easeOutBack:function(b,l,k,j,i,h){h==w&&(h=1.70158);return j*((l=l/i-1)*l*((h+1)*l+h)+1)+k},easeInOutBack:function(b,l,k,j,i,h){h==w&&(h=1.70158);if((l/=i/2)<1){return j/2*l*l*(((h*=1.525)+1)*l-h)+k}return j/2*((l-=2)*l*(((h*=1.525)+1)*l+h)+2)+k},easeInBounce:function(a,j,i,h,g){return h-x.easing.easeOutBounce(a,g-j,0,h,g)+i},easeOutBounce:function(g,f,j,i,h){return(f/=h)<1/2.75?i*7.5625*f*f+j:f<2/2.75?i*(7.5625*(f-=1.5/2.75)*f+0.75)+j:f<2.5/2.75?i*(7.5625*(f-=2.25/2.75)*f+0.9375)+j:i*(7.5625*(f-=2.625/2.75)*f+0.984375)+j},easeInOutBounce:function(a,j,i,h,g){if(j<g/2){return x.easing.easeInBounce(a,j*2,0,h,g)*0.5+i}return x.easing.easeOutBounce(a,j*2-g,0,h,g)*0.5+h*0.5+i}})}(jQuery);(function($){function int_prop(fx){fx.elem.style[fx.prop]=parseInt(fx.now,10)+fx.unit}var throwError=function(message){throw ({name:"jquery.flip.js plugin error",message:message})};var isIE6orOlder=function(){return(
/*@cc_on!@*/
false&&(typeof document.body.style.maxHeight==="undefined"))};var colors={aqua:[0,255,255],azure:[240,255,255],beige:[245,245,220],black:[0,0,0],blue:[0,0,255],brown:[165,42,42],cyan:[0,255,255],darkblue:[0,0,139],darkcyan:[0,139,139],darkgrey:[169,169,169],darkgreen:[0,100,0],darkkhaki:[189,183,107],darkmagenta:[139,0,139],darkolivegreen:[85,107,47],darkorange:[255,140,0],darkorchid:[153,50,204],darkred:[139,0,0],darksalmon:[233,150,122],darkviolet:[148,0,211],fuchsia:[255,0,255],gold:[255,215,0],green:[0,128,0],indigo:[75,0,130],khaki:[240,230,140],lightblue:[173,216,230],lightcyan:[224,255,255],lightgreen:[144,238,144],lightgrey:[211,211,211],lightpink:[255,182,193],lightyellow:[255,255,224],lime:[0,255,0],magenta:[255,0,255],maroon:[128,0,0],navy:[0,0,128],olive:[128,128,0],orange:[255,165,0],pink:[255,192,203],purple:[128,0,128],violet:[128,0,128],red:[255,0,0],silver:[192,192,192],white:[255,255,255],yellow:[255,255,0],transparent:[255,255,255]};var acceptHexColor=function(color){if(color&&color.indexOf("#")==-1&&color.indexOf("(")==-1){return"rgb("+colors[color].toString()+")"}else{return color}};$.extend($.fx.step,{borderTopWidth:int_prop,borderBottomWidth:int_prop,borderLeftWidth:int_prop,borderRightWidth:int_prop});$.fn.revertFlip=function(){return this.each(function(){var $this=$(this);$this.flip($this.data("flipRevertedSettings"))})};$.fn.flip=function(settings){return this.each(function(){var $this=$(this),flipObj,$clone,dirOption,dirOptions,newContent,ie6=isIE6orOlder();if($this.data("flipLock")){return false}var revertedSettings={direction:(function(direction){switch(direction){case"tb":return"bt";case"bt":return"tb";case"lr":return"rl";case"rl":return"lr";default:return"bt"}})(settings.direction),bgColor:acceptHexColor(settings.color)||"#999",color:acceptHexColor(settings.bgColor)||$this.css("background-color"),content:$this.html(),speed:settings.speed||500,onBefore:settings.onBefore||function(){},onEnd:settings.onEnd||function(){},onAnimation:settings.onAnimation||function(){}};$this.data("flipRevertedSettings",revertedSettings).data("flipLock",1).data("flipSettings",revertedSettings);flipObj={width:$this.width(),height:$this.height(),bgColor:acceptHexColor(settings.bgColor)||$this.css("background-color"),fontSize:$this.css("font-size")||"12px",direction:settings.direction||"tb",toColor:acceptHexColor(settings.color)||"#999",speed:settings.speed||500,top:$this.offset().top,left:$this.offset().left,target:settings.content||null,transparent:"transparent",dontChangeColor:settings.dontChangeColor||false,onBefore:settings.onBefore||function(){},onEnd:settings.onEnd||function(){},onAnimation:settings.onAnimation||function(){}};ie6&&(flipObj.transparent="#123456");$clone=$this.css("visibility","hidden").clone(true).data("flipLock",1).appendTo("body").html("").css({visibility:"visible",position:"absolute",left:flipObj.left,top:flipObj.top,margin:0,zIndex:9999,"-webkit-box-shadow":"0px 0px 0px #000","-moz-box-shadow":"0px 0px 0px #000"});var defaultStart=function(){return{backgroundColor:flipObj.transparent,fontSize:0,lineHeight:0,borderTopWidth:0,borderLeftWidth:0,borderRightWidth:0,borderBottomWidth:0,borderTopColor:flipObj.transparent,borderBottomColor:flipObj.transparent,borderLeftColor:flipObj.transparent,borderRightColor:flipObj.transparent,background:"none",borderStyle:"solid",height:0,width:0}};var defaultHorizontal=function(){var waist=(flipObj.height/100)*25;var start=defaultStart();start.width=flipObj.width;return{start:start,first:{borderTopWidth:0,borderLeftWidth:waist,borderRightWidth:waist,borderBottomWidth:0,borderTopColor:"#999",borderBottomColor:"#999",top:(flipObj.top+(flipObj.height/2)),left:(flipObj.left-waist)},second:{borderBottomWidth:0,borderTopWidth:0,borderLeftWidth:0,borderRightWidth:0,borderTopColor:flipObj.transparent,borderBottomColor:flipObj.transparent,top:flipObj.top,left:flipObj.left}}};var defaultVertical=function(){var waist=(flipObj.height/100)*25;var start=defaultStart();start.height=flipObj.height;return{start:start,first:{borderTopWidth:waist,borderLeftWidth:0,borderRightWidth:0,borderBottomWidth:waist,borderLeftColor:"#999",borderRightColor:"#999",top:flipObj.top-waist,left:flipObj.left+(flipObj.width/2)},second:{borderTopWidth:0,borderLeftWidth:0,borderRightWidth:0,borderBottomWidth:0,borderLeftColor:flipObj.transparent,borderRightColor:flipObj.transparent,top:flipObj.top,left:flipObj.left}}};dirOptions={tb:function(){var d=defaultHorizontal();d.start.borderTopWidth=flipObj.height;d.start.borderTopColor=flipObj.bgColor;d.second.borderBottomWidth=flipObj.height;d.second.borderBottomColor=flipObj.toColor;return d},bt:function(){var d=defaultHorizontal();d.start.borderBottomWidth=flipObj.height;d.start.borderBottomColor=flipObj.bgColor;d.second.borderTopWidth=flipObj.height;d.second.borderTopColor=flipObj.toColor;return d},lr:function(){var d=defaultVertical();d.start.borderLeftWidth=flipObj.width;d.start.borderLeftColor=flipObj.bgColor;d.second.borderRightWidth=flipObj.width;d.second.borderRightColor=flipObj.toColor;return d},rl:function(){var d=defaultVertical();d.start.borderRightWidth=flipObj.width;d.start.borderRightColor=flipObj.bgColor;d.second.borderLeftWidth=flipObj.width;d.second.borderLeftColor=flipObj.toColor;return d}};dirOption=dirOptions[flipObj.direction]();ie6&&(dirOption.start.filter="chroma(color="+flipObj.transparent+")");newContent=function(){var target=flipObj.target;return target&&target.jquery?target.html():target};$clone.queue(function(){flipObj.onBefore($clone,$this);$clone.html("").css(dirOption.start);$clone.dequeue()});$clone.animate(dirOption.first,flipObj.speed);$clone.queue(function(){flipObj.onAnimation($clone,$this);$clone.dequeue()});$clone.animate(dirOption.second,flipObj.speed);$clone.queue(function(){if(!flipObj.dontChangeColor){$this.css({backgroundColor:flipObj.toColor})}$this.css({visibility:"visible"});var nC=newContent();if(nC){$this.html(nC)}$clone.remove();flipObj.onEnd($clone,$this);$this.removeData("flipLock");$clone.dequeue()})})}})(jQuery);
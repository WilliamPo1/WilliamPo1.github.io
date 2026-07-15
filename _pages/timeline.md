---
title: "Academic Timeline Planner"
permalink: /timeline/
author_profile: false
layout: single
---

<style>
.tl-app{font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;max-width:100%;margin:0 auto}
.tl-intro{font-size:14px;color:#555;margin-bottom:20px;line-height:1.5}
.tl-header{display:flex;flex-wrap:wrap;gap:16px;align-items:center;justify-content:space-between;margin-bottom:20px;padding:12px 16px;background:#f8f9fa;border-radius:8px;border:1px solid #dee2e6}
.tl-header label{font-size:14px;font-weight:600;color:#333}
.tl-header input[type="date"]{padding:4px 8px;border:1px solid #ccc;border-radius:4px;font-size:14px}
.tl-mode-wrap{display:flex;align-items:center;gap:8px}
.tl-mode-toggle{display:flex;border-radius:6px;overflow:hidden;border:2px solid #56018D}
.tl-mode-btn{padding:6px 16px;font-size:13px;font-weight:600;cursor:pointer;border:none;background:#fff;color:#56018D;transition:all .2s}
.tl-mode-btn.active{background:#56018D;color:#fff}
.tl-steps{display:flex;flex-direction:column;gap:6px;margin-bottom:16px}
.tl-step{display:flex;flex-wrap:wrap;align-items:center;gap:6px;padding:8px 10px;background:#fff;border:1px solid #e0e0e0;border-radius:6px;font-size:13px;transition:background .15s,opacity .15s,margin .15s;position:relative}
.tl-step.hidden-mode{opacity:.35;border-style:dashed}
.tl-step.tl-dragging{opacity:.25;background:#f4edf8;border-color:#56018D;border-style:dashed}
.tl-drag-indicator{height:4px;background:#56018D;border-radius:2px;margin:2px 0;position:relative}
.tl-drag-indicator::after{content:"Drop here";position:absolute;left:8px;top:-8px;font-size:10px;color:#56018D;font-weight:700}
.tl-drag{cursor:grab;font-size:18px;color:#999;user-select:none;line-height:1;padding:0 4px;transition:color .15s}
.tl-drag:hover{color:#56018D}
.tl-drag:active{cursor:grabbing}
.tl-ghost{position:fixed;pointer-events:none;z-index:2000;opacity:.85;border:2px solid #56018D;border-radius:6px;background:#fff;padding:8px 12px;font-size:13px;font-weight:600;color:#56018D;box-shadow:0 4px 16px rgba(0,0,0,.2);white-space:nowrap;max-width:300px;overflow:hidden;text-overflow:ellipsis}
.tl-step-name{flex:1;min-width:140px;border:1px solid transparent;background:transparent;font-size:13px;font-weight:500;padding:2px 6px;border-radius:3px;color:#333}
.tl-step-name:focus{border-color:#56018D;outline:none;background:#fff}
.tl-step input[type="range"]{width:120px;accent-color:#56018D}
.tl-step-val{width:52px;text-align:right;font-weight:700;font-size:12px;color:#56018D;border:1px solid transparent;background:transparent;padding:2px 4px;border-radius:3px;font-family:inherit}
.tl-step-val:focus{border-color:#56018D;outline:none;background:#fff}
.tl-step select{font-size:11px;padding:2px 4px;border:1px solid #ccc;border-radius:3px;background:#fff}
.tl-step label{font-size:11px;color:#666;display:flex;align-items:center;gap:3px;cursor:pointer;white-space:nowrap}
.tl-step label input[type="checkbox"]{accent-color:#56018D}
.tl-del{background:none;border:none;cursor:pointer;font-size:16px;color:#ccc;padding:0 4px;line-height:1}
.tl-del:hover{color:#d33}
.tl-add{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;font-size:13px;font-weight:600;color:#56018D;background:#f4edf8;border:1px dashed #56018D;border-radius:6px;cursor:pointer;margin-bottom:20px}
.tl-add:hover{background:#e8d9f0}
.tl-summary{text-align:center;margin:12px 0}
.tl-total{font-size:18px;font-weight:700;color:#56018D}
.tl-dates{font-size:14px;color:#555;margin-top:4px}
.tl-chart{width:100%;overflow-x:auto;margin:16px 0}
.tl-export{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;font-size:13px;font-weight:600;color:#fff;background:#56018D;border:none;border-radius:6px;cursor:pointer;margin-top:8px}
.tl-export:hover{background:#430168}
.tl-export-opts{display:inline-flex;align-items:center;gap:8px;margin-top:8px}
.tl-export-opts select{font-size:13px;padding:4px 8px;border:1px solid #ccc;border-radius:4px;background:#fff}
.tl-export-opts label{font-size:13px;font-weight:600;color:#333}
.tl-harmonize{display:inline-flex;align-items:center;gap:6px;padding:8px 16px;font-size:13px;font-weight:600;color:#56018D;background:#f4edf8;border:1px solid #56018D;border-radius:6px;cursor:pointer;margin-top:8px}
.tl-harmonize:hover{background:#e8d9f0}
.tl-tip{position:absolute;background:rgba(0,0,0,.85);color:#fff;padding:6px 10px;border-radius:4px;font-size:12px;pointer-events:none;z-index:1000;display:none;white-space:nowrap}
.tl-swatch{width:14px;height:14px;border-radius:3px;display:inline-block;flex-shrink:0;border:1px solid rgba(0,0,0,.15)}
.tl-info{display:inline-flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:50%;background:#56018D;color:#fff;font-size:11px;font-weight:700;cursor:help;position:relative;font-style:italic;font-family:Georgia,serif;flex-shrink:0;user-select:none}
.tl-info .tl-tt{display:none;position:absolute;bottom:calc(100% + 10px);left:50%;transform:translateX(-50%);background:rgba(0,0,0,.92);color:#fff;padding:10px 14px;border-radius:6px;font-size:12px;font-style:normal;font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif;font-weight:400;white-space:normal;width:260px;z-index:1001;line-height:1.5;box-shadow:0 4px 12px rgba(0,0,0,.25);text-align:left}
.tl-info:hover .tl-tt,.tl-info:focus .tl-tt{display:block}
.tl-info .tl-tt::after{content:'';position:absolute;top:100%;left:50%;transform:translateX(-50%);border:6px solid transparent;border-top-color:rgba(0,0,0,.92)}
.tl-info-right .tl-tt{left:auto;right:-8px;transform:none}
.tl-info-right .tl-tt::after{left:auto;right:14px;transform:none}
.tl-info-left .tl-tt{left:-8px;right:auto;transform:none}
.tl-info-left .tl-tt::after{left:14px;right:auto;transform:none}
</style>

<div class="tl-app">

<p class="tl-intro">
  Plan your academic publication timeline. Drag steps to reorder, adjust durations with the sliders, and toggle between Registered Report and Classical Submission modes.
</p>

<div class="tl-header">
  <div style="display:flex;align-items:center;gap:8px">
    <label for="tlStart">Start date:</label>
    <input type="date" id="tlStart">
    <span class="tl-info tl-info-left" tabindex="0">i<span class="tl-tt">Set the date your project begins. The entire timeline is calculated forward from this date.</span></span>
  </div>
  <div class="tl-mode-wrap">
    <div class="tl-mode-toggle">
      <button class="tl-mode-btn active" data-mode="rr" onclick="setMode('rr')">Registered Report</button>
      <button class="tl-mode-btn" data-mode="classical" onclick="setMode('classical')">Classical Submission</button>
    </div>
    <span class="tl-info tl-info-right" tabindex="0">i<span class="tl-tt"><strong>Registered Report:</strong> Two review rounds. Stage 1 review happens before data collection, giving in-principle acceptance. <br><br><strong>Classical Submission:</strong> Pre-register on OSF, collect data, then submit the complete paper. One review round, no publication guarantee.</span></span>
  </div>
</div>

<div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;padding:0 4px">
  <span style="font-size:12px;color:#888;font-style:italic">Drag the handle to reorder steps. Adjust duration, visibility per mode, and parallelism for each step.</span>
  <span class="tl-info" tabindex="0">i<span class="tl-tt"><strong>Controls per step:</strong><br>
  <strong>&#x2847; Handle</strong> &mdash; drag to reorder<br>
  <strong>Slider</strong> &mdash; set duration in weeks<br>
  <strong>Both / RR / Classical</strong> &mdash; which mode(s) this step appears in<br>
  <strong>Parallel</strong> &mdash; when checked, this step starts at the same time as the previous step. The next non-parallel step waits for all parallel steps to finish.<br>
  <strong>&times;</strong> &mdash; remove the step</span></span>
</div>

<div class="tl-steps" id="tlSteps"></div>
<button class="tl-add" onclick="addStep()" title="Add a new step to the timeline">+ Add Step</button>

<div class="tl-summary">
  <div class="tl-total" id="tlTotal"></div>
  <div class="tl-dates" id="tlDates"></div>
</div>

<div class="tl-chart" id="tlChart"><svg id="tlSvg" xmlns="http://www.w3.org/2000/svg"></svg></div>

<div style="display:flex;flex-wrap:wrap;justify-content:center;gap:12px;align-items:center">
  <div class="tl-export-opts">
    <label for="tlRatio">Format:</label>
    <select id="tlRatio">
      <option value="auto" selected>Auto (fit content)</option>
      <option value="2:1">2:1 (wide)</option>
      <option value="16:9">16:9 (presentation)</option>
      <option value="4:3">4:3</option>
      <option value="1:1">1:1 (square)</option>
    </select>
    <label for="tlScale">Resolution:</label>
    <select id="tlScale">
      <option value="2">2x (standard)</option>
      <option value="3">3x (high)</option>
      <option value="4" selected>4x (very high)</option>
      <option value="6">6x (print quality)</option>
    </select>
  </div>
  <button class="tl-export" onclick="exportPng()" title="Download the chart as a PNG image"><i class="fa fa-download"></i> Export PNG</button>
  <button class="tl-harmonize" onclick="harmonizeColors()" title="Reassign colors to match step order"><i class="fa fa-paint-brush"></i> Harmonize Colors</button>
</div>

<div class="tl-tip" id="tlTip"></div>
</div>

<script>
(function(){
var PALETTE=["#912338","#b84a5e","#c97a1e","#d4a843","#5a8a6a","#4a7a9b","#6a5a8a","#8a6a5a","#5a7a7a","#7a5a6a","#4a6a5a","#8a7a4a","#5a5a8a","#8a5a5a","#6a8a5a"];
var MN=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
var ML=200,MT=30,MR=20,MB=30,BH=26,BG=8;
var nextId=100;
var mode="rr";
var dragIdx=null;

var steps=[
  {id:1,name:"Manuscript preparation",min:2,max:16,value:7,color:"#912338",mode:"both",parallel:false},
  {id:2,name:"Ethics approval",min:2,max:16,value:8,color:"#b84a5e",mode:"both",parallel:false},
  {id:3,name:"Analysis code & simulation",min:1,max:10,value:4,color:"#c97a1e",mode:"both",parallel:true},
  {id:4,name:"Pilot study",min:1,max:8,value:3,color:"#d4a843",mode:"both",parallel:false},
  {id:5,name:"Pre-registration & submission",min:1,max:6,value:2,color:"#5a8a6a",mode:"both",parallel:false},
  {id:6,name:"Stage 1 review",min:4,max:32,value:18,color:"#4a7a9b",mode:"rr",parallel:false},
  {id:7,name:"Data collection",min:2,max:16,value:6,color:"#6a5a8a",mode:"both",parallel:false},
  {id:8,name:"Complete manuscript",min:2,max:16,value:10,color:"#8a6a5a",mode:"both",parallel:false},
  {id:9,name:"Review & publication",min:2,max:24,value:12,color:"#5a7a7a",mode:"both",parallel:false}
];

function getStart(){var v=document.getElementById("tlStart").value;if(!v)return new Date();var p=v.split("-");return new Date(+p[0],+p[1]-1,+p[2]);}
function aw(d,w){var r=new Date(d);r.setDate(r.getDate()+w*7);return r;}
function fd(d){return MN[d.getMonth()]+" "+d.getDate()+", "+d.getFullYear();}
function wb(a,b){return Math.round((b-a)/(7*864e5));}

function visible(){return steps.filter(function(s){return s.mode==="both"||s.mode===mode;});}

function schedule(vis){
  var S0=getStart(),sc=[],gs=new Date(S0),ge=new Date(S0);
  for(var i=0;i<vis.length;i++){
    var st=vis[i],s,e;
    if(i===0||!st.parallel){if(i>0)gs=new Date(ge);s=new Date(gs);e=aw(s,st.value);ge=new Date(e);}
    else{s=new Date(gs);e=aw(s,st.value);if(e>ge)ge=new Date(e);}
    sc.push({s:s,e:e,w:st.value});
  }
  return sc;
}

function renderControls(){
  var el=document.getElementById("tlSteps"),h="";
  for(var i=0;i<steps.length;i++){
    var s=steps[i],hidden=(s.mode!=="both"&&s.mode!==mode);
    h+='<div class="tl-step'+(hidden?" hidden-mode":"")+'" data-idx="'+i+'">';
    h+='<span class="tl-drag" title="Drag to reorder" onmousedown="startDrag(event,'+i+')">&#x2847;</span>';
    h+='<span class="tl-swatch" style="background:'+s.color+'"></span>';
    h+='<input class="tl-step-name" type="text" value="'+s.name.replace(/"/g,"&quot;")+'" onchange="updName('+i+',this.value)">';
    h+='<input type="range" min="'+s.min+'" max="'+s.max+'" value="'+s.value+'" step="1" oninput="updVal('+i+',+this.value)">';
    h+='<input class="tl-step-val" type="text" value="'+s.value+' wk" onfocus="this.value='+s.value+'" onblur="updValDirect('+i+',this)" onkeydown="if(event.key===\'Enter\'){this.blur();}">';
    h+='<select onchange="updMode('+i+',this.value)" title="Which mode(s) this step appears in">';
    h+='<option value="both"'+(s.mode==="both"?" selected":"")+'>Both</option>';
    h+='<option value="rr"'+(s.mode==="rr"?" selected":"")+'>RR only</option>';
    h+='<option value="classical"'+(s.mode==="classical"?" selected":"")+'>Classical only</option>';
    h+='</select>';
    h+='<label title="Run this step at the same time as the previous step"><input type="checkbox"'+(s.parallel?" checked":"")+' onchange="updPar('+i+',this.checked)"> Parallel</label>';
    h+='<button class="tl-del" onclick="delStep('+i+')" title="Remove this step">&times;</button>';
    h+='</div>';
  }
  el.innerHTML=h;
}

var ghost=null,indicator=null;

window.startDrag=function(e,idx){
  e.preventDefault();
  dragIdx=idx;
  var step=document.querySelector('.tl-step[data-idx="'+idx+'"]');
  step.classList.add("tl-dragging");

  ghost=document.createElement("div");
  ghost.className="tl-ghost";
  ghost.textContent=steps[idx].name;
  document.body.appendChild(ghost);
  ghost.style.left=(e.clientX+12)+"px";
  ghost.style.top=(e.clientY-16)+"px";

  indicator=document.createElement("div");
  indicator.className="tl-drag-indicator";

  document.addEventListener("mousemove",onDragMove);
  document.addEventListener("mouseup",onDragEnd);
};

function getDropTarget(y){
  var items=document.querySelectorAll(".tl-step");
  for(var i=0;i<items.length;i++){
    var rect=items[i].getBoundingClientRect();
    if(y<rect.top+rect.height/2) return {idx:+items[i].getAttribute("data-idx"),pos:"before",el:items[i]};
  }
  if(items.length) return {idx:+items[items.length-1].getAttribute("data-idx"),pos:"after",el:items[items.length-1]};
  return null;
}

function onDragMove(e){
  if(dragIdx===null)return;
  ghost.style.left=(e.clientX+12)+"px";
  ghost.style.top=(e.clientY-16)+"px";

  if(indicator.parentNode)indicator.parentNode.removeChild(indicator);
  var target=getDropTarget(e.clientY);
  if(!target)return;
  var container=document.getElementById("tlSteps");
  if(target.pos==="before") container.insertBefore(indicator,target.el);
  else{var next=target.el.nextSibling;if(next)container.insertBefore(indicator,next);else container.appendChild(indicator);}
}

function onDragEnd(e){
  document.removeEventListener("mousemove",onDragMove);
  document.removeEventListener("mouseup",onDragEnd);
  if(ghost){ghost.parentNode.removeChild(ghost);ghost=null;}
  if(indicator&&indicator.parentNode)indicator.parentNode.removeChild(indicator);

  if(dragIdx===null)return;
  var target=getDropTarget(e.clientY);
  var srcStep=document.querySelector('.tl-step[data-idx="'+dragIdx+'"]');
  if(srcStep)srcStep.classList.remove("tl-dragging");

  if(target){
    var insertIdx=target.pos==="before"?target.idx:target.idx+1;
    if(dragIdx<insertIdx)insertIdx--;
    if(insertIdx!==dragIdx){
      var moved=steps.splice(dragIdx,1)[0];
      steps.splice(insertIdx,0,moved);
    }
  }
  dragIdx=null;
  renderControls();drawChart();
}

function drawChart(){
  var vis=visible(),sc=schedule(vis);
  if(!sc.length){document.getElementById("tlSvg").innerHTML="";document.getElementById("tlTotal").textContent="";document.getElementById("tlDates").textContent="";return;}
  var S0=getStart(),endDate=sc[sc.length-1].e,tw=wb(S0,endDate),tm=Math.round(tw/4.33);
  document.getElementById("tlTotal").textContent="Total: ~"+tw+" weeks (~"+tm+" months)";
  document.getElementById("tlDates").textContent=fd(S0)+"  \u2192  "+fd(endDate);

  var ch=MT+MB+vis.length*(BH+BG);
  var cw=Math.max(document.getElementById("tlChart").clientWidth,600),pw=cw-ML-MR;
  var svg=document.getElementById("tlSvg");svg.setAttribute("width",cw);svg.setAttribute("height",ch);
  var xEnd=aw(endDate,2),tms=xEnd.getTime()-S0.getTime();
  function xs(d){return ML+((d.getTime()-S0.getTime())/tms)*pw;}

  var h='<rect width="'+cw+'" height="'+ch+'" fill="white"/>';
  var cur=new Date(S0.getFullYear(),S0.getMonth(),1);
  while(cur<=xEnd){
    var x=xs(cur);
    if(x>=ML&&x<=ML+pw){
      h+='<line x1="'+x+'" y1="'+MT+'" x2="'+x+'" y2="'+(ch-MB)+'" stroke="#e0e0e0" stroke-width="0.5"/>';
      if(cur.getMonth()%2===0||pw>800)h+='<text x="'+x+'" y="'+(ch-MB+16)+'" text-anchor="middle" font-size="11" fill="#555" font-family="sans-serif">'+MN[cur.getMonth()]+" '"+(cur.getFullYear()%100)+'</text>';
    }
    cur.setMonth(cur.getMonth()+1);
  }
  var td=new Date();
  if(td>=S0&&td<=xEnd){
    var tx=xs(td);
    h+='<line x1="'+tx+'" y1="'+(MT-5)+'" x2="'+tx+'" y2="'+(ch-MB)+'" stroke="#56018D" stroke-width="1.5" stroke-dasharray="4 3"/>';
    h+='<text x="'+tx+'" y="'+(MT-8)+'" text-anchor="middle" fill="#56018D" font-weight="600" font-size="10" font-family="sans-serif">Today</text>';
  }
  for(var i=0;i<vis.length;i++){
    var si=sc[i],y=MT+i*(BH+BG),x1=xs(si.s),x2=xs(si.e),w=Math.max(x2-x1,2);
    h+='<text x="'+(ML-8)+'" y="'+(y+BH/2+4)+'" text-anchor="end" font-size="11" fill="#333" font-weight="500" font-family="sans-serif">'+vis[i].name+'</text>';
    h+='<rect x="'+x1+'" y="'+y+'" width="'+w+'" height="'+BH+'" fill="'+vis[i].color+'" rx="3" ry="3" class="tl-bar" data-p="'+vis[i].name.replace(/"/g,"&quot;")+'" data-ds="'+fd(si.s)+'" data-de="'+fd(si.e)+'" data-w="'+si.w+'"/>';
    if(w>40)h+='<text x="'+(x1+w/2)+'" y="'+(y+BH/2+4)+'" text-anchor="middle" font-size="10" fill="white" font-weight="600" style="pointer-events:none" font-family="sans-serif">'+si.w+'wk</text>';
  }
  svg.innerHTML=h;

  var tip=document.getElementById("tlTip");
  svg.querySelectorAll(".tl-bar").forEach(function(b){
    b.style.cursor="default";
    b.addEventListener("mouseenter",function(){tip.innerHTML="<strong>"+b.getAttribute("data-p")+"</strong><br>"+b.getAttribute("data-ds")+" \u2192 "+b.getAttribute("data-de")+" ("+b.getAttribute("data-w")+" weeks)";tip.style.display="block";});
    b.addEventListener("mousemove",function(e){tip.style.left=(e.pageX+12)+"px";tip.style.top=(e.pageY-30)+"px";});
    b.addEventListener("mouseleave",function(){tip.style.display="none";});
  });
}

window.setMode=function(m){
  mode=m;
  document.querySelectorAll(".tl-mode-btn").forEach(function(b){b.classList.toggle("active",b.getAttribute("data-mode")===m);});
  renderControls();drawChart();
};
window.updName=function(i,v){steps[i].name=v;drawChart();};
window.updVal=function(i,v){steps[i].value=v;if(v>=steps[i].max)steps[i].max=v+4;var el=document.querySelector('.tl-step[data-idx="'+i+'"] .tl-step-val');if(el)el.value=v+' wk';drawChart();};
window.updValDirect=function(i,el){var v=parseInt(el.value,10);if(isNaN(v)||v<steps[i].min)v=steps[i].value;if(v>steps[i].max)steps[i].max=v+4;steps[i].value=v;el.value=v+' wk';renderControls();drawChart();};
window.updMode=function(i,v){steps[i].mode=v;renderControls();drawChart();};
window.updPar=function(i,v){steps[i].parallel=v;drawChart();};
window.moveStep=function(i,d){
  var j=i+d;if(j<0||j>=steps.length)return;
  var tmp=steps[i];steps[i]=steps[j];steps[j]=tmp;
  renderControls();drawChart();
};
window.delStep=function(i){if(steps.length<=1)return;steps.splice(i,1);renderControls();drawChart();};
window.addStep=function(){
  var c=PALETTE[steps.length%PALETTE.length];
  steps.push({id:nextId++,name:"New step",min:1,max:20,value:4,color:c,mode:"both",parallel:false});
  renderControls();drawChart();
};

window.harmonizeColors=function(){
  for(var i=0;i<steps.length;i++){
    steps[i].color=PALETTE[i%PALETTE.length];
  }
  renderControls();drawChart();
};

window.exportPng=function(){
  var svg=document.getElementById("tlSvg");
  var scale=+(document.getElementById("tlScale").value)||4;
  var ratioVal=document.getElementById("tlRatio").value;
  var w=+svg.getAttribute("width"),ht=+svg.getAttribute("height");
  var cw=w,ch=ht;
  if(ratioVal!=="auto"){var parts=ratioVal.split(":");var rw=+parts[0],rh=+parts[1];ch=cw*(rh/rw);}
  var clone=svg.cloneNode(true);
  clone.setAttribute("viewBox","0 0 "+w+" "+ht);
  clone.setAttribute("width",cw);
  clone.setAttribute("height",ch);
  clone.setAttribute("preserveAspectRatio","none");
  var svgData=new XMLSerializer().serializeToString(clone);
  var blob=new Blob([svgData],{type:"image/svg+xml;charset=utf-8"});
  var url=URL.createObjectURL(blob);
  var img=new Image();
  img.onload=function(){
    var c=document.createElement("canvas");c.width=cw*scale;c.height=ch*scale;
    var ctx=c.getContext("2d");ctx.scale(scale,scale);ctx.fillStyle="#fff";ctx.fillRect(0,0,cw,ch);
    ctx.drawImage(img,0,0,cw,ch);
    c.toBlob(function(b){var a=document.createElement("a");a.href=URL.createObjectURL(b);a.download="timeline.png";a.click();URL.revokeObjectURL(a.href);});
    URL.revokeObjectURL(url);
  };
  img.src=url;
};

var today=new Date();
document.getElementById("tlStart").value=today.getFullYear()+"-"+String(today.getMonth()+1).padStart(2,"0")+"-"+String(today.getDate()).padStart(2,"0");
renderControls();drawChart();
window.addEventListener("resize",drawChart);
})();
</script>

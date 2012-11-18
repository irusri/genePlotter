
import com.adobe.images.PNGEncoder;
import com.adobe.serialization.json.JSON;

import components.popupcontrols;

import events.RemoveFromListTextEvent;
import events.SendToListTextEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.text.StyleSheet;
import flash.text.TextFormat;
import flash.utils.ByteArray;

import flashx.textLayout.events.UpdateCompleteEvent;

import mx.collections.ArrayCollection;
import mx.containers.Canvas;
import mx.containers.HBox;
import mx.containers.Panel;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Label;
import mx.controls.Text;
import mx.controls.ToolTip;
import mx.controls.sliderClasses.Slider;
import mx.core.FlexGlobals;
import mx.core.IVisualElement;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.events.FlexEvent;
import mx.events.SliderEvent;
import mx.events.ToolTipEvent;
import mx.graphics.ImageSnapshot;
import mx.graphics.codec.JPEGEncoder;
import mx.graphics.codec.PNGEncoder;
import mx.managers.ToolTipManager;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.styles.StyleManager;

import org.alivepdf.colors.RGBColor;
import org.alivepdf.display.Display;
import org.alivepdf.encoding.PNGEncoder;
import org.alivepdf.fonts.FontFamily;
import org.alivepdf.fonts.Style;
import org.alivepdf.images.ColorSpace;
import org.alivepdf.images.PNGImage;
import org.alivepdf.layout.Orientation;
import org.alivepdf.layout.Resize;
import org.alivepdf.layout.Size;
import org.alivepdf.layout.Unit;
import org.alivepdf.pdf.PDF;
import org.alivepdf.saving.Method;

import spark.components.Label;
import spark.components.ResizeMode;
import spark.primitives.Graphic;

import utils.DataGridUtilsold;

private var myPDF:PDF;
private var clicked:Boolean=false;
private var config:Object;
private var modelConfig:Object;
private var exprDatachartfinal:Object= new Object();

[Bindable]
private var startArray:ArrayCollection=new ArrayCollection();

[Bindable]
private var dgArrayCol:ArrayCollection=new ArrayCollection();


private var file:FileReference = new FileReference();
[Bindable]
private var p2:Canvas;

private var  c1:UIComponent = new UIComponent();
private var  c2:UIComponent = new UIComponent();
private var  c3:UIComponent = new UIComponent();
private var  cx:UIComponent = new UIComponent();
[Bindable]
private var searchText:String="";


[Bindable]
public var exportpopupStr:String="";

/**
 * creationCompete HTTP service call
 */
private function geneplotter_init() : void {
	searchText = FlexGlobals.topLevelApplication.parameters.id;
	FlexGlobals.topLevelApplication.parameters.id="";
	serve_getConfigData.send();
	this.addEventListener(SendToListTextEvent.sendtoMainTextInput,sendtobtTriggered);
	this.addEventListener(RemoveFromListTextEvent.removeTextInput,remvefrombtTriggered);
	//exportlistcomp.csvbtn.addEventListener(MouseEvent.CLICK,prepareExport);
	exportlistcomp.csvbtn.addEventListener(MouseEvent.CLICK,csvbtnExport);
	exportlistcomp.tsvbtn.addEventListener(MouseEvent.CLICK,tsvbtnExport);
	
	exportlistcomp.phytozomebtn.addEventListener(MouseEvent.CLICK,phytozomebtnExport);
	exportlistcomp.agrigobtn.addEventListener(MouseEvent.CLICK,agrigobtnExport);
	exportlistcomp.galaxybtn.addEventListener(MouseEvent.CLICK,galaxybtnExport);
	exportlistcomp.popTxt.addEventListener(FlexEvent.VALUE_COMMIT,prepareExport);
}

private function sendtobtTriggered(evt:SendToListTextEvent) : void {
	exportlistcomp.popTxt.visible=false;
	if(exportlistcomp.visible==false){
		exportlistcomp.y=this.mouseY-exportlistcomp.height/3;
		exportlistcomp.x=this.mouseX-exportlistcomp.width/2;
	exportlistcomp.visible=true;
	fastacustomMove.end();
	fastacustomMove.play();
	}
	
	exportlistcomp.popTxt.visible=true;
	
	exportpopupStr+=evt.sendString+',';

	exportlistcomp.popTxt.htmlText=exportpopupStr;
	//Alert.show(evt.sendtobulktoolString);
}

private function remvefrombtTriggered(evt:RemoveFromListTextEvent) : void {
	//exportlistcomp.visible=true;
	exportlistcomp.popTxt.visible=false;
	var replacePattern:RegExp=new RegExp(evt.removeString+',' ,"g");
	//var pattern:RegExp=//(evt.removeString)//g;
	exportpopupStr=exportpopupStr.replace(replacePattern,"");
	//exportpopupStr+=evt.removeString;
	exportlistcomp.popTxt.htmlText=exportpopupStr;
	if(exportpopupStr==""){
		exportlistcomp.visible=false;	
	}
	exportlistcomp.popTxt.visible=true;	
}



/**
 * creationCompete HTTP service Result
 */
private function handle_config_files(event:ResultEvent):void {
	modelConfig = (JSON.decode(String(event.result)));
	loadPolFile(modelConfig.settings.policy_file);
	if(searchText!="" && searchText !=null){
		inputTranscripttxt.text=searchText;
		submitTranscript_clickHandler();
	//	Alert.show("triggered");
	}
}
/**
 * Draw chromosome length
 */
private  function drawChromosomeChart():void{
	for(var k:int=0;k<modelConfig.settings.value;k++){
		var i:int=k+1;
		var tmpValue:int;
		tmpValue=Math.round(parseInt(modelConfig.chromosomes[k].value)/80000);
		
		var s:Sprite = new Sprite(); 
		var txtspritex:Sprite = new Sprite();
		if(i!=20){
			s.graphics.beginFill(chromosomepick.selectedColor, 1);
///			s.addEventListener(MouseEvent.CLICK,selcteme);			
			s.graphics.drawRoundRect(0, 20, 15, tmpValue,10,16);
		}else{
			
			s.graphics.beginFill(0x000000, 1.0);
			txtspritex.graphics.beginFill(0xcccccc, 1.0);
			
			
//			s.addEventListener(MouseEvent.CLICK,selcteme);
			s.graphics.drawRoundRect(30, 20, 1, 100,10,0);
			/*s.graphics.drawRoundRect(30, 120, 1, 100,10,0);			
			s.graphics.drawRoundRect(30, 220, 1, 100,10,0);	
			s.graphics.drawRoundRect(30, 320, 1, 100,10,0);	
			s.graphics.drawRoundRect(30, 420, 1, 100,10,0);	
			s.graphics.drawRoundRect(30, 520, 1, 100,10,0);	*/
			
			
			s.graphics.drawRect(31,20,11,1);
			s.graphics.drawRect(30,120,10,1);
			/*s.graphics.drawRect(20,220,10,1);
			s.graphics.drawRect(20,320,10,1);
			s.graphics.drawRect(20,420,10,1);
			s.graphics.drawRect(20,520,10,1);
			s.graphics.drawRect(18,619,12,1);	*/
			
			
			for(var a:int=0;a<2;a++){
				
				var txtscale:TextField = new TextField(  );
				txtscale.text=a.toString()+' Mb';
				txtscale.y=a*100+11;
				txtscale.x=45;
				var txtscaleFormat:TextFormat = new TextFormat(); 
				txtscaleFormat.font = "gpFontFamily";
				//txtscale.embedFonts = true;
			//	txtscaleFormat.size=8;
				txtscale.defaultTextFormat = txtscaleFormat;
				
				//txtspritex.graphics.drawRoundRect(30, a*100+20, 5, 100,10,00);	
				txtspritex.addChild(txtscale);
				
			}
			//
			
			//var txtscaleFormat:TextFormat = new TextFormat(); 
			//txtscaleFormat.font = "gpFontFamily";
			//txtscale.embedFonts = true;
			//txtscale.defaultTextFormat = txtscaleFormat;
			
		//	txtsprite.addChild(txtscale);
			
			
			
		}
		trace(tmpValue)
		s.graphics.endFill();
		txtspritex.graphics.endFill();

		var s2:Sprite = new Sprite();
		var field:TextField = new TextField(  );
		var myFormat:TextFormat = new TextFormat();  
		myFormat.font = "gpFontFamily";
		field.embedFonts = true;
		field.defaultTextFormat = myFormat;
		if(i!=20){
			field.text=i.toString();
		}else{
			//field.text="SCALE 1:1 Mb "	
		}
		s2.addChild(field);

		s.x=i*25;
		s2.x=i*25;
		txtspritex.x=i*25;
		
		c1.addChild(txtspritex);
		c1.addChild(s);
		c2.addChild(s2);
		
	}	
	alphaChromosome.value=1;
	changechromosomeAlpha();
}

private function selcteme(event:MouseEvent):void{
	//event.target.toString()
	//Alert.show((event.target.mouseY+59025).toString());
}
/**
 * submitted data results and draw gene start lines
 */

private function transcriptDataResult(event:ResultEvent):Boolean {
	var exprData:Object = JSON.decode(String(event.result));
	exprDatachartfinal = exprData;
	var i:int;
	var str:String = exprDatachartfinal.chromosome;
	var pattern:RegExp = /scaffold_/gi;
	trace(str.replace(pattern, ""));
	i=parseInt(str.replace(pattern, ""));
	
	var ttext:popupcontrols=new popupcontrols();
	
	var s3:Sprite = new Sprite();
	s3.graphics.beginFill(genecolorpick.selectedColor,alphaGene.value);
	s3.graphics.drawRect(0, Math.round(parseInt(exprDatachartfinal.transcriptstart)/80000)+20, 15, 1);
	

	
	
//	UIComponent(s3).depth=-1;
/*	var element:IVisualElement;
	element = s3 as IVisualElement;
	element.depth = 0;*/
	
	
	
	s3.buttonMode=true;
	s3.name=exprDatachartfinal.transcriptstart;
	s3.addEventListener(MouseEvent.CLICK, reportClick);
//	s3.addEventListener(MouseEvent.MOUSE_OUT, reportClick2);
	s3.addEventListener(MouseEvent.MOUSE_OVER, reportOver);
	
	
	var field:TextField = new TextField(  );
	field.text=exprDatachartfinal.transcriptstart;
	field.y=Math.round(parseInt(exprDatachartfinal.transcriptstart)/80000)+20;
	field.x=25*i;
	s3.x=25*i;
	s3.graphics.endFill();
	/*var ttext:spark.components.TextArea=new spark.components.TextArea();	
	ttext.text="xxxx";
	ttext.width=100;
	ttext.setStyle("backgroundColor", "#6C9270");
	ttext.height=20;
	ttext.y=Math.round(parseInt(exprDatachartfinal.transcriptstart)/80000)+20;
	ttext.x=25*i;
	ttext.visible=false;*/
	ttext.chromosomestr=exprDatachartfinal.chromosome;	

	ttext.poptrstr=exprDatachartfinal.id;
	ttext.startstr=exprDatachartfinal.transcriptstart;
	ttext.stopstr=exprDatachartfinal.transcriptstop;
	
	ttext.y=Math.round(parseInt(exprDatachartfinal.transcriptstart)/80000)+15;
	ttext.x=25*i+24;
	ttext.visible=false;
	ttext.closebtn.addEventListener(MouseEvent.CLICK, reportClick2);
	
	ttext.depth=900000000;
	
	
	var tmpstr:String=exprDatachartfinal.id;
		function reportClick(event:MouseEvent):void	{
if(panzoom.scale>1){
	
//	ttext.y=Math.round(parseInt(ttext.startstr)/80000)+15;
	//ttext.x=25*i+24;
			ttext.visible=true;
			//var URL:String = "http://popgenie.org/transcript/"+tmpstr;
			//Alert.show(URL);
}else{
	Alert.show("Please zoom in!","Zoom in please!")
}
			//navigateToURL(new URLRequest(URL), "_blank");
		}

		function reportClick2(event:MouseEvent):void	{
			/*ttext.scaledown.duration=0;
			ttext.scaledown.play()
			ttext.scaledown.stop()*/
				
			ttext.visible=false;
		}
		
		var s4:Sprite = new Sprite();
		s4.graphics.beginFill(0x0000FF,1);
		//s4.graphics.drawRect(0, Math.round(parseInt(exprDatachartfinal.transcriptstop)/80000)+20, 15, 1);
		//s4.graphics.drawEllipse(0, Math.round(parseInt(exprDatachartfinal.transcriptstop)/80000)+15,15,7);
		s4.graphics.drawRoundRect(0, Math.round(parseInt(exprDatachartfinal.transcriptstop)/80000)+19, 15, 3,2);
		s4.buttonMode=true;
		s4.x=25*i;
		s4.graphics.endFill();
		s4.visible=false;
		s4.addEventListener(MouseEvent.MOUSE_OUT, reportOut);
		s4.addEventListener(MouseEvent.CLICK, reportClick);
		
		var tip:ToolTip;
		function reportOver(event:MouseEvent):void{
			s4.visible=true;
/*			tip = ToolTipManager.createToolTip(tmpstr,event.stageX+10,event.stageY,null,null) as ToolTip;	
			ToolTipManager.enabled = true;
			ToolTipManager.showDelay = 0;
			ToolTipManager.hideDelay = 200;
			tip.setStyle("borderColor", "white");
			tip.setStyle("backgroundColor", "#6C9270");
			tip.setStyle("cornerRadius", "3");
			tip.setStyle("fontSize", "11");
			tip.setStyle("fontWeight", "bold");
			tip.setStyle("color", "white");
			tip.setStyle("borderShadow", "0");*/
		}
		function reportOut(event:MouseEvent):void{
			s4.visible=false;
			//ToolTipManager.destroyToolTip(tip);		
		}
	


	
	
	
	if(modelConfig.chromosomes.length>i-1){
		c2.addChild(ttext);
		c3.addChild(s3);
		cx.addChild(s4);
	//	c2.depth=1000;
	//	c3.depth=1;
			cx.depth=1;
		
	}
	return true;
}

/**
 * submitted data results and populate grid data
 */
private function transcriptgridDataResult(event:ResultEvent):Boolean {
	var exprData:Object = JSON.decode(String(event.result));
	exprDatachartfinal = exprData;
	var i:int;
	var str:String = exprDatachartfinal.chromosome;
	var pattern:RegExp = /scaffold_/gi;
	i=parseInt(str.replace(pattern,""));
	
	var tmpstr:String=exprDatachartfinal.id;
	var geneLength:String;
	if(modelConfig.chromosomes.length>i-1){
		
		geneLength=modelConfig.chromosomes[i-1].value;
	}else{
		geneLength="Un-placed scaffold";
	}
	startArray.addItem({chromosome: exprDatachartfinal.chromosome,genelength:geneLength,tempvalue:tmpstr,transcriptstart:Math.round(parseInt(exprDatachartfinal.transcriptstart))});
	dg.dataProvider=startArray;
	return true;
}

/**
 * export grid data as CSV
 */
private function handleExportClick():void
{
	DataGridUtilsold.loadDataGridInExcel(dg);
	
}


/**
 * Create tool tip for genes
 */
private function createCustomTip(title:String, body:String, event:ToolTipEvent):void {
	var ptt:PanelTollTip = new PanelTollTip();
	ptt.title = title;
	ptt.bodyText = body;
	event.toolTip = ptt;
}

/**
 * Handle failed HTTPService component requests.
 */
private function transcriptDataResultFault(event:FaultEvent):Boolean {
	Alert.show(event.toString());
	return true;
}

/**
 * Change gene color.
 */
private function changegeneColor():void{
/*	for(var i:int=0;i<c3.numChildren;i++){
		var exprDataz:Object =new Object();
	if(c3.getChildAt(i).toString()=="s3"){
		exprDataz=c3.getChildAt(i)[id];
	}else{
		exprDataz=c3.getChildAt(i);
	}
	}*/
	var colorTransform:ColorTransform = c3.transform.colorTransform;
	colorTransform.color = genecolorpick.selectedColor;
	c3.transform.colorTransform = colorTransform;
}

/**
 * Change numberColor color.
 */
private function changenumberColor():void{
	var colorTransform:ColorTransform = c2.transform.colorTransform;
	colorTransform.color = numberpick.selectedColor;
	c2.transform.colorTransform = colorTransform;
}

/**
 * Change Chromosome color.
 */
private function changechromosomeColor():void{
	var colorTransform:ColorTransform = c1.transform.colorTransform;
	colorTransform.color = chromosomepick.selectedColor;
	c1.transform.colorTransform = colorTransform;
}

/**
 * Change Chromosome color.
 */
private function changechromosomeAlpha():void{

	c1.alpha= alphaChromosome.value;
}

/**
 * Remove already created eliments and children
 */
private function removeeliments():void{
	if(p2!=null){
		p2.removeAllElements();
		p2.removeAllChildren();
		p2=null;}
}

/**
 * Submit button click event
 */
private function submitTranscript_clickHandler():void{
	//drawChromosomeChartPDF();
	//exportpopupStr=new String();
	//exportlistcomp.popTxt.text="";
	if(p2==null){
		geneplotter_init();
		c1=new UIComponent();
		c2=new UIComponent();
		c3=new UIComponent();
		cx=new UIComponent();
		p2=new Canvas();
		p2.percentWidth=100;
		p2.percentHeight=100;
		dd.addElement(p2);
		drawChromosomeChart();
	}
	var str:String =inputTranscripttxt.text;
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	for(var h:int=0;h<a.length;h++){
		serve_getTranscriptData.url =modelConfig.settings.url+"?id="+a[h];
		serve_getTranscriptData.send();
	}
	p2.addChild(c1);
	p2.addChild(c2);
	p2.addChild(c3);
	p2.addChild(cx);
	

}

/**
 * send grid  HTTP service call
 */
private function gridbtnClick():void{
	if(gridBox.visible==false){
		var str:String =inputTranscripttxt.text;
		var pattern:RegExp = /,/gi;
		var a:Array = str.replace(pattern, " ").split(/\s+/);
		for(var h:int=0;h<a.length;h++){
			serve_getGridTranscriptData.url =modelConfig.settings.url+"?id="+a[h];
			serve_getGridTranscriptData.send();
		}
		gridBox.visible=true;
		tableButton.label="Hide Table"
	}else{
		gridBox.visible=false;
		startArray.refresh();
		startArray=new ArrayCollection();
		dg.dataProvider=null;
		tableButton.label="Show Table"
	}
	
}


[Embed(source="utils/pop1.png")] 
[Bindable]
public var iconSymbol:Class;

// Define variable to hold the Alert object. 
public var myAlert:Alert;

private function generatePDF():void {
	myAlert = Alert.show("Your pdf is ready for download!", "PDF Rendering completed", 
		Alert.OK | Alert.CANCEL, this, alertListener, iconSymbol,  Alert.OK );
	// Set the height and width of the Alert control.
	myAlert.height=150;
	myAlert.width=350;
}

private function alertListener(eventObj:CloseEvent):void {
	// Check to see if the OK button was pressed.
	if (eventObj.detail==Alert.OK) {
		generatePDFOK();
	}
}

/**
 * Draw chromosome length for pdf
 */
private  function drawChromosomeChartPDF():void{
	generatePDF();
	var str:String =inputTranscripttxt.text;
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	for(var h:int=0;h<a.length;h++){
		 serve_getTranscriptDataPDf.url =modelConfig.settings.url+"?id="+a[h];
		serve_getTranscriptDataPDf.send();
	}
		
	myPDF = new PDF(  Orientation.LANDSCAPE, Unit.MM, Size.A4 );
	myPDF.setDisplayMode ( Display.DEFAULT ); 
	myPDF.addPage();
	for(var kk:int=0;kk<modelConfig.settings.value;kk++){
		var ii:int=kk+1;
		var tmpValue:int;
		tmpValue=Math.round(parseInt(modelConfig.chromosomes[kk].value)/250000);
		if(ii!=20){
		//var s:Sprite = new Sprite();
		var ben:Number=new Number();
		ben=ii*10;
		myPDF.beginFill(new RGBColor(chromosomepick.selectedColor),1000);
		myPDF.lineStyle(new RGBColor(chromosomepick.selectedColor),1,0,alphaChromosome.value);
		myPDF.drawRoundRect(new Rectangle(ben,6,5,tmpValue),2.5);
		trace(tmpValue)
		}else{
			//myPDF.beginFill(new RGBColor(0x000000), 1);

		//	myPDF.lineStyle(new RGBColor(0x000000),0,0,1);
			
		//	myPDF.drawRoundRect(new Rectangle(220, 8,  0.2, 280),0);
			/*myPDF.drawRoundRect(new Rectangle(30, 120, 10, 100),0);			
			myPDF.drawRoundRect(new Rectangle(30, 220, 10, 100),0);	
			myPDF.drawRoundRect(new Rectangle(30, 320, 10, 100),0);	
			myPDF.drawRoundRect(new Rectangle(30, 420, 10, 100),0);	
			myPDF.drawRoundRect(new Rectangle(30, 520, 10, 100),0);	*/
			
			
			/*myPDF.drawRect(new Rectangle(130,20,12,1));
			myPDF.drawRect(new Rectangle(80,120,10,1));
			myPDF.drawRect(new Rectangle(30,220,10,1));
			myPDF.drawRect(new Rectangle(30,320,10,1));
			myPDF.drawRect(new Rectangle(30,420,10,1));
			myPDF.drawRect(new Rectangle(30,520,10,1));
			myPDF.drawRect(new Rectangle(30,619,12,1));	*/

		}
		myPDF.endFill();
		
		var s2:Sprite = new Sprite();
		var field:TextField = new TextField(  );
		var myFormat:TextFormat = new TextFormat();  
		myFormat.font = "gpFontFamily";
		field.embedFonts = true;
		field.defaultTextFormat = myFormat;
		field.text=ii.toString();
	//	myPDF.addText(i.toString());
		myPDF.textStyle(new RGBColor(numberpick.selectedColor));
		if(ii<20){
		if(ii<10){
		myPDF.addText((ii.toString()),ben+1.3,5);
		}else{
		myPDF.addText((ii.toString()),ben+0.5,5);
		}
		}
		trace('testv'+ii)
		
		//myPDF.lineStyle(new RGBColor(0x990000),1,1,1);
		//myPDF.drawCircle(20,20,20);
	}	
	
}

private function genelinesforPdf(event:ResultEvent):void{
var exprData:Object = JSON.decode(String(event.result));
	//exprDatachartfinal = exprData;
	var i:int;
	var str:String = exprData.chromosome;
	var pattern:RegExp = /scaffold_/gi;
	trace(str.replace(pattern, ""));
	i=parseInt(str.replace(pattern, ""));
	if(i<20){
	myPDF.beginFill(new RGBColor(genecolorpick.selectedColor),0);
	myPDF.lineStyle(new RGBColor(genecolorpick.selectedColor),0,0);
	myPDF.drawRect( new Rectangle(i*10, Math.round(parseInt(exprData.transcriptstart)/250000)+6, 5));
	myPDF.endFill();
	}
	
}




/**
 * Generate High quality pdf
 */
private function generatePDFOK ():void
{
	//myPDF = new PDF(  Orientation.PORTRAIT, Unit.MM, Size.A4 );
	
	//myPDF.addPage();
	
	//var mc:MovieClip= new MovieClip();
	//mc.addChild(p2);
//	var bitmapData:BitmapData = new BitmapData(p2.width*4, p2.height*4);
//	var matrix : Matrix = new Matrix ();
	//matrix.scale (4,4);
	//bitmapData.draw(p2,matrix);
	
	
	//var images:ImageSnapshot = ImageSnapshot.captureImage(p2, 300, new JPEGEncoder());
	
	//var bitmap : Bitmap = new Bitmap(bitmapData);
	//var encoder:JPEGEncoder=new JPEGEncoder(10);
	//var stream:ByteArray = encoder.encode(bitmapData);
	//myPDF.addImageStream(stream, ColorSpace.DEVICE_RGB, null,0, 0, p2.width/4, p2.height/4, 0,1, "Normal", null);
	myPDF.save( Method.REMOTE, "http://v22.popgenie.org/gp/createpdf.php", "geneplot.pdf" );
	

}



/**
 * Generate High quality pdf
 */
/*private function generatePDFOK (event:MouseEvent):void
{
	//myPDF = new PDF(  Orientation.PORTRAIT, Unit.MM, Size.A4 );
	myPDF.setDisplayMode ( Display.FULL_PAGE ); 
	//myPDF.addPage();
	
	var mc:MovieClip= new MovieClip();
	//mc.addChild(p2);
	var bitmapData:BitmapData = new BitmapData(p2.width*4, p2.height*4);
	var matrix : Matrix = new Matrix ();
	matrix.scale (4,4);
	bitmapData.draw(p2,matrix);
	
	
	//var images:ImageSnapshot = ImageSnapshot.captureImage(p2, 300, new JPEGEncoder());
	
	var bitmap : Bitmap = new Bitmap(bitmapData);
	var encoder:JPEGEncoder=new JPEGEncoder(10);
	var stream:ByteArray = encoder.encode(bitmapData);
	myPDF.addImageStream(stream, ColorSpace.DEVICE_RGB, null,0, 0, p2.width/4, p2.height/4, 0,1, "Normal", null);
	myPDF.save( Method.REMOTE, "http://130.239.72.85/createpdf.php", "geneplot.pdf" );
	
	
}*/



/**
 * take snapshot
 */
private function takeSnapshot():void {
	var bitmapData:BitmapData = new BitmapData(p2.width, p2.height);
	bitmapData.draw(p2,new Matrix());
	var bitmap : Bitmap = new Bitmap(bitmapData);
	var jpg:JPEGEncoder = new JPEGEncoder(100);
	var ba:ByteArray = jpg.encode(bitmapData);
	file.save(ba,"screen_capture " + '.png');
}

/**
 * Retrieves the crossdomain file for the web-service policy file.
 */
private function loadPolFile(url:String):void {
	Security.loadPolicyFile(url);
}

/**
 * populate demo data
 */
private function demoData_clickHandler(event:MouseEvent):void
{
	removeeliments();
	inputTranscripttxt.text="POPTR_0021s00230.1  POPTR_1358s00200.1 	POPTR_0001s41170.1 	POPTR_0001s35960.1 	POPTR_0010s17080.1 	POPTR_0003s21720.1,	POPTR_0009s01810.1"+
		", POPTR_0004s18660.1, POPTR_0005s16190.1, POPTR_0011s00230.1, POPTR_0001s14200.1, POPTR_0017s04500.1, POPTR_0019s00480.1, POPTR_0001s36560.1, POPTR_0015s03650.1";
	submitTranscript_clickHandler();
}

private function scaleBoxes():void {
	
	for (var i:Number=0;i<p2.getChildren().length;i++) {
	//	p2.getChildAt(i).scaleX = valuaxisMax.value;
	//	p2.getChildAt(i).scaleY = valuaxisMax.value;
	}
}

import spark.components.BorderContainer;
import spark.components.Button;
import utils.GbrowseDataGridUtils;
import utils.DataGridUtils2;


public static const MAX_ZOOM:Number = 10;
public static const MIN_ZOOM:Number = 0.1;

protected function _onCreationComplete():void
{
	
}

// When our slider changes, we want the zoom level to update.  There's a public zoom method
// within the PanZoomComponent that accepts a scale value (1 = actual size or 100%, 0.5 = half the size or 50%, etc.)
protected function _onSliderChanged():void
{
	this.panzoom.zoom(this.slider.value/100);
}

// The PanZoomComponent provides and event "zoom" for which you can set a callback
// whenever a zoom in or out happens.  Here, we're detecting a zoom from the component
// and setting the slider value accordingly
protected function _onZoom():void
{
	if(this.slider.value/100 != this.panzoom.scale)
	{
		this.slider.value = this.panzoom.scale * 100;
	}
}


private function prepareExport(evt:Event):void{
	dgArrayCol=new ArrayCollection();
	var str:String =exportpopupStr;
	var pattern:RegExp = /,/gi;
	var a:Array = str.replace(pattern, " ").split(/\s+/);
	if(a.length>0){
	for(var i:int=0;i<a.length-1;i++){
		dgArrayCol.addItem({id:a[i].toString()});
	}
	}else{
		Alert.show("Please add some genes by selecting popup chekbox");
		//return;
	}
	
}

private function csvbtnExport(evt:MouseEvent):void{
	GbrowseDataGridUtils.loadDataGridInExcelGFF3(exportDG);	//working
}
private function tsvbtnExport(evt:MouseEvent):void{
	DataGridUtils2.loadDataGridInTSV(exportDG);//working
}
private function phytozomebtnExport(evt:MouseEvent):void{
	GbrowseDataGridUtils.loadDataGridInpyExcel(exportDG);	
}
private function agrigobtnExport(evt:MouseEvent):void{
	if(dgArrayCol.length>10){
	GbrowseDataGridUtils.loadDataGridInAgrigo(exportDG);	
	}else{
		Alert.show("Less than 10 entries can't be mapped with GO.Please enter few more gene.","Low number of input");
	}
}
private function galaxybtnExport(evt:MouseEvent):void{
	DataGridUtils2.loadDataGridInExcel(exportDG);
}


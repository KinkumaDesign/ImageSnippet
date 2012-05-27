/*
Copyright (c) 2012 Tasuku Maeda (KinkumaDesign - kuma-de.com)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package
{
	import adobe.utils.MMExecute;
	
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	import flash.system.System;
	import flash.text.TextFormat;
	
	import kinkuma.FormatTabView;
	
	[SWF(width="200",height="200",frameRate="24",backgroundColor="#f2f2f2")]
	public class ImageSnippet extends Sprite
	{
		[Embed(source="asset/buttonIcon.png")]
		private var _ButtonIconPNG:Class;
		
		private var _baseAsset:SnippetAsset;
		private var _tabView:FormatTabView;
		private var _formatTextView:TextArea;
		private var _snippetTextView:TextArea;
		private var _insertButton:Sprite;
		private var _clipboardButton:Sprite;
		private var _clearButton:Sprite;
		private var _buttonContainer:Sprite;
		
		private var _so:SharedObject;
		
		public function ImageSnippet()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onStageResize);
			visible = false;
			_baseAsset = new SnippetAsset();
			addChild(_baseAsset);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "_typewriter";
			textFormat.size = 13;			
			
			_formatTextView = _baseAsset.formatLabel;
			_formatTextView.setStyle("textFormat", textFormat);
			_formatTextView.addEventListener(Event.CHANGE, onFormatLabelTextChange);
			_snippetTextView = _baseAsset.snippetTextView;
			_snippetTextView.setStyle("textFormat", textFormat);
			
			_tabView = new FormatTabView();
			addChild(_tabView);
			_tabView.x = 5;
			_tabView.y = 19;
			_tabView.addEventListener(Event.CHANGE, onTabViewChange);
			
			_buttonContainer = new Sprite();
			initButtons();
			addChild(_buttonContainer);
			
			onStageResize(null);
			
			_so = SharedObject.getLocal('ImageSnippetCommandPannel');
			//_so.clear();
			updateFormatLabel();
			visible = true;
		}
		
		protected function onFormatLabelTextChange(event:Event):void
		{
			_so.data['tab'+_tabView.selctedTabIndex] = _formatTextView.text;
			_so.flush();
		}
		
		protected function onTabViewChange(event:Event):void
		{
			updateFormatLabel();
		}
		
		private function updateFormatLabel():void
		{
			var tabStr:String = _so.data['tab'+_tabView.selctedTabIndex];
			if(tabStr == null){
				switch(_tabView.selctedTabIndex)
				{
					case 0:
						tabStr = '<img width="%w" height="%h" src="images/%p" alt="">';
						break;
					case 1:
						tabStr = 'width:%wpx;\nheight:%hpx;\nleft:%xpx;\ntop:%ypx;';
						break;
					default:
						tabStr = "";
						break;
				}
			}
			_formatTextView.text = tabStr;
		}
		
		private function initButtons():void
		{
			var assetBmd:BitmapData = Bitmap(new _ButtonIconPNG()).bitmapData;
			var buttonBmd:BitmapData;
			var drawMtx:Matrix;
			//inset
			_insertButton = new Sprite();
			buttonBmd = new BitmapData(32,20,false);
			drawMtx = new Matrix();
			drawMtx.translate(0,0);
			buttonBmd.draw(assetBmd,drawMtx);
			_insertButton.addChild(new Bitmap(buttonBmd));
			_buttonContainer.addChild(_insertButton);
			_insertButton.x = 5;
			registerButtonEvent(_insertButton);
			
			//clipboard
			_clipboardButton = new Sprite();
			buttonBmd = new BitmapData(32,20,false);
			drawMtx = new Matrix();
			drawMtx.translate(-32,0);
			buttonBmd.draw(assetBmd,drawMtx);
			_clipboardButton.addChild(new Bitmap(buttonBmd));
			_buttonContainer.addChild(_clipboardButton);
			_clipboardButton.x = 43;
			registerButtonEvent(_clipboardButton);
			
			//trash
			_clearButton = new Sprite();
			buttonBmd = new BitmapData(32,20,false);
			drawMtx = new Matrix();
			drawMtx.translate(-32*2,0);
			buttonBmd.draw(assetBmd,drawMtx);
			_clearButton.addChild(new Bitmap(buttonBmd));
			_buttonContainer.addChild(_clearButton);
			_clearButton.x = 81;
			registerButtonEvent(_clearButton);
			
			assetBmd.dispose();
			assetBmd = null;
		}
		
		protected function onStageResize(event:Event = null):void
		{
			var padding:int = 10;
			var sw:int = stage.stageWidth;
			var labelW:int = sw - padding;
			_formatTextView.width = labelW;
			_snippetTextView.width = labelW;
			_snippetTextView.height = stage.stageHeight - 135;
			_buttonContainer.y = _snippetTextView.y + _snippetTextView.height + 5;
			_clearButton.x = _snippetTextView.x + _snippetTextView.width - _clearButton.width;
		}
		
		private function registerButtonEvent(button:Sprite):void
		{
			button.addEventListener(MouseEvent.ROLL_OVER, onButtonRollOver);
			button.addEventListener(MouseEvent.ROLL_OUT, onButtonRollOut);
			button.addEventListener(MouseEvent.CLICK, onButtonClick);
			button.buttonMode= true;
		}
		
		protected function onButtonRollOut(event:MouseEvent):void
		{
			var button:Sprite = event.target as Sprite;
			button.alpha = 1;
		}
		
		protected function onButtonClick(event:MouseEvent):void
		{
			var button:Sprite = event.target as Sprite;
			if(button === _clearButton){
				onClearButtonClicked();
			}else if(button === _clipboardButton){
				onClipboardButtonClicked();
			}else if(button === _insertButton){
				onInsertButtonClicked();
			}
		}
		
		private function onInsertButtonClicked():void
		{
			var sliceInfo:String = MMExecute("fw.runScript(fw.appSwfCommandsDir+'/KinkumaUtility/jsf/ImageSnippet.jsf')");
			var sliceInfoArr:Array = sliceInfo.split(",");
			var appendStr:String = _formatTextView.text;
			var pathReg:RegExp = /%p/g;
			var widthReg:RegExp = /%w/g;
			var heightReg:RegExp = /%h/g;
			var xReg:RegExp = /%x/g;
			var yReg:RegExp = /%y/g;
			appendStr = appendStr
						.replace(pathReg, sliceInfoArr[0])
						.replace(widthReg, sliceInfoArr[1])
						.replace(heightReg, sliceInfoArr[2])
						.replace(xReg, sliceInfoArr[3])
						.replace(yReg, sliceInfoArr[4]);
			_snippetTextView.text += appendStr;
		}
		
		private function onClipboardButtonClicked():void
		{
			System.setClipboard(_snippetTextView.text);
		}
		
		private function onClearButtonClicked():void
		{
			_snippetTextView.text = "";
		}
		
		protected function onButtonRollOver(event:MouseEvent):void
		{
			var button:Sprite = event.target as Sprite;
			button.alpha = 0.7;
		}
	}
}
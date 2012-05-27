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

package kinkuma
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class FormatTabView extends Sprite
	{
		[Embed(source="asset/snippetTab.png")]
		private var _SnippetTabPNG:Class;
		
		private var _tabs:Array;
		public static const BUTTON_STATE_BASE:String = "butonStateBase";
		public static const BUTTON_STATE_ACTIVE:String = "butonStateActive";
		private var _selctedTabIndex:int = 0;
			
		public function FormatTabView()
		{
			var tabPngBm:Bitmap = new _SnippetTabPNG();
			var tabPngBmd:BitmapData = tabPngBm.bitmapData;
			_tabs = [];
			
			for(var i:int = 0; i < 6; i++){
				var baseImg:BitmapData = new BitmapData(29,18,false);
				var activeImg:BitmapData = new BitmapData(29, 18, false);
				var baseMtx:Matrix = new Matrix();
				var activeMtx:Matrix = new Matrix();
				var offsetX:int;
				var tabSprite:Sprite = new Sprite();
				baseMtx.translate(0,-18);
				switch(i){
					case 0:
						offsetX = 0;
						break;
					case 1:
						offsetX = -29;
						baseMtx.translate(-29,0);
						activeMtx.translate(-29,0);
						break;
					case 2:
						offsetX = -58;
						baseMtx.translate(-58,0);
						activeMtx.translate(-58,0);
						break;
					case 3:
						offsetX = -87;
						baseMtx.translate(-87,0);
						activeMtx.translate(-87,0);
						break;
					case 4:
						offsetX = -116;
						baseMtx.translate(-116,0);
						activeMtx.translate(-116,0);
						break;
					case 5:
						offsetX = -145;
						baseMtx.translate(-145,0);
						activeMtx.translate(-145,0);
						break;
					default:{
						break;
					}
				}
				baseImg.draw(tabPngBmd, baseMtx);
				activeImg.draw(tabPngBmd, activeMtx);
				var baseBm:Bitmap = new Bitmap(baseImg);
				baseBm.name = BUTTON_STATE_BASE;
				var activeBm:Bitmap = new Bitmap(activeImg);
				activeBm.name = BUTTON_STATE_ACTIVE;
				tabSprite.name = i.toString();
				tabSprite.addChild(baseBm);
				tabSprite.addChild(activeBm);
				if(i == 0){
					baseBm.visible = false;
					tabSprite.buttonMode = false;
				}else{
					activeBm.visible = false;
					tabSprite.buttonMode = true;
				}
				this.addChild(tabSprite);
				tabSprite.x = -offsetX;
				_tabs.push(tabSprite);				
				
				tabSprite.addEventListener(MouseEvent.CLICK, onTabSpriteClick);
			}
			
			tabPngBmd.dispose();
			tabPngBmd = null;
		}
		
		protected function onTabSpriteClick(event:MouseEvent):void
		{
			var tab:Sprite = event.target as Sprite;
			var index:int = parseInt(tab.name);
			if(_selctedTabIndex != index){
				selctedTabIndex = index;
			}
		}

		public function get selctedTabIndex():int
		{
			return _selctedTabIndex;
		}

		public function set selctedTabIndex(value:int):void
		{
			if(_selctedTabIndex != value){
				setTabStateBase(_selctedTabIndex);
			}
			_selctedTabIndex = value;
			setTabStateActive(_selctedTabIndex);
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function setTabStateBase(index:int):void
		{
			var tab:Sprite = _tabs[index];
			var active:Bitmap = tab.getChildByName(BUTTON_STATE_ACTIVE) as Bitmap;
			var base:Bitmap = tab.getChildByName(BUTTON_STATE_BASE) as Bitmap;
			active.visible = false;
			base.visible = true;
			tab.buttonMode = true;
		}
		
		private function setTabStateActive(index:int):void
		{
			var tab:Sprite = _tabs[index];
			var active:Bitmap = tab.getChildByName(BUTTON_STATE_ACTIVE) as Bitmap;
			var base:Bitmap = tab.getChildByName(BUTTON_STATE_BASE) as Bitmap;
			active.visible = true;
			base.visible = false;
			tab.buttonMode = false;
		}
	}
}
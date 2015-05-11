package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Erivan Franklin
	 */
	public class Main extends MovieClip
	{
		//private  var use_chk:CheckBox;
		//public var clrpkr:ColorPicker;
		//public var sldr:Slider;
		private var mc_Desenho1			:MovieClip = new MovieClip();	
		private var mc_Copia			: MovieClip = new MovieClip();
		private var myColor				:ColorTransform = new ColorTransform();
		private var currentPoint		:Point;
		
		public function Main() 
		{
			
			adicionado()
			
			
		}
		
		private function adicionado():void 
		{
			
			
			mc_Desenho1 = new mc_Sonic();
			mc_Copia = new MovieClip();
			addChild(mc_Desenho1);
			mc_Desenho1.x = 50;
			mc_Desenho1.y = 50;
			mc_Copia.x = mc_Desenho1.x + mc_Desenho1.width + 50;
			mc_Copia.y = 50;
			addChild(mc_Copia);
			
			mc_Desenho1.blendMode = BlendMode.MULTIPLY;
			mc_Desenho1.addEventListener(MouseEvent.MOUSE_OVER, evtObj);			
			this.borracha.addEventListener(MouseEvent.MOUSE_DOWN, evtObj);
			this.borracha.addEventListener(MouseEvent.MOUSE_UP, evtObj);
			
		}
		
		private function evtObj(e:MouseEvent):void 
		{
			switch (e.type) 
			{
				case MouseEvent.MOUSE_DOWN:
					
					this.borracha.startDrag();
					addEventListener(Event.ENTER_FRAME, evtApaga)
					
				break;
				
			case MouseEvent.CLICK:
				trace("====")
					var point:Point = new Point( mc_Desenho1.mouseX, mc_Desenho1.mouseY);
					myColor.color = Math.random() * 0xFFFFFF;										
					fill(point, myColor.color, 4);
				break;
				
				case MouseEvent.MOUSE_UP:
					this.borracha.stopDrag();
					removeEventListener(Event.ENTER_FRAME, evtApaga);
				break;
				
				
				case MouseEvent.MOUSE_OVER:
					
					e.currentTarget.addEventListener(MouseEvent.CLICK,evtObj)
				
				break;
			}
			
		}
		
		private function evtApaga(e:Event):void 
		{
			
			currentPoint = new Point(mc_Desenho1.mouseX, mc_Desenho1.mouseY);
			trace(currentPoint)
			mc_Copia.graphics.lineStyle(20, 4294967295, 1);
			mc_Copia.graphics.lineTo(currentPoint.x, currentPoint.y); 
			
			
		}
		
		public function fill(point:Point, color:uint, smoothStrength:int = 8):void {	
			
			
			// if a color is passed with no alpha component, then add it.
			if((color>>24) == 0) {
				
				// add alpha value to color value.
				color = 0xFF << 24 | color;
			
			}
			
			var snapshot1:BitmapData =  new BitmapData(mc_Desenho1.width, mc_Desenho1.height, false, 0xFFFFFFFF);
			snapshot1.draw(mc_Desenho1);
			var snapshot2:BitmapData =  BitmapData(snapshot1.clone());
			
			// fill on point
			snapshot1.floodFill(point.x, point.y, color);
			// compare snapshots
			var compareResult:Object = snapshot1.compare(snapshot2);
			
			// check to make sure compare result exists (snapshots are not the same).
			if (compareResult) {
				
				
				var comp:BitmapData = BitmapData(compareResult);
				var compAlpha:BitmapData = comp.clone();
					
				// get alpha value from color
				var alphaValue:uint = color >> 24 & 0x000000FF;
				
				// apply glow to smoothout and expand the fill a little
				comp.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, alphaValue], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL, true));
				
				// we do not want to apply any alpha settings to this copy that will be used as an alpha mask with copy pixels
				compAlpha.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, 0], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL));
							
				// copy fill back into bitmap
				var bmp:BitmapData = new BitmapData(mc_Desenho1.width, mc_Desenho1.height);
				bmp.copyPixels(comp, comp.rect, new Point(0, 0));
				var b:Bitmap = new Bitmap(bmp);
				b.x = 0;
				b.y = 0;
				trace(mc_Desenho1.width, mc_Desenho1.height);
				//mc_Desenho1.graphics.clear();
				//mc_Desenho1.graphics.lineStyle(10, );
				mc_Copia.graphics.beginBitmapFill(bmp);
				mc_Copia.graphics.drawRect(0, 0, mc_Desenho1.width, mc_Desenho1.height);
				mc_Copia.graphics.endFill();
				//mc_Copia.graphics.beginFill(0x000000);
				//mc_Copia.graphics.drawRect(0, 0, mc_Desenho1.width, mc_Desenho1.height);
				//mc_Copia.graphics.endFill();
				
				//mc_Desenho1.addChild(b);
			
			}
			
			// kill snapshot bitmapdata objects
			snapshot1.dispose();
			snapshot2.dispose();
			
		}
		
		
	}

}
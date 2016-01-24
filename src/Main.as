package 
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Александра
	 */
	public class Main extends Sprite 
	{
		//добавляем фоновое изображение
		[Embed(source = "../lib/arena_2.jpg")]
		public var ArenaFon:Class;
		
		//добавляем изображения правого гладиатора
		[Embed(source = "../lib/goracius-mini.gif")]
		public var GladiatorRight:Class;
		[Embed(source = "../lib/goracius-mini-died.gif")]
		public var GladiatorRightDied:Class;
		[Embed(source = "../lib/goracius-mini-go.gif")]
		public var GladiatorRightGo:Class;
		[Embed(source = "../lib/goracius-mini-kick.gif")]
		public var GladiatorRightKick:Class;
		[Embed(source = "../lib/goracius-mini-serve.gif")]
		public var GladiatorRightServe:Class;
		
		//изображения левого гладиатора
		[Embed(source = "../lib/avrelius-mini.gif")]
		public var GladiatorLeft:Class;
		[Embed(source = "../lib/avrelius-mini-died.gif")]
		public var GladiatorLeftDied:Class;
		[Embed(source = "../lib/avrelius-mini-go.gif")]
		public var GladiatorLeftGo:Class;
		[Embed(source = "../lib/avrelius-mini-serve.gif")]
		public var GladiatorLeftServe:Class;
		
		private var btnPlayImg:Sprite;
		private var btnPlayImgOver:Sprite;
		private var btnStart:Sprite;
		private var btnPause:Sprite;
		private var btnStop:Sprite;
		private var btnPlay:SimpleButton;
		private var goRules:Boolean;
		private var die:Boolean;
		private var goraciusDied:Bitmap;
		private var goracius:Bitmap;
		private var goraciusGo:Bitmap;
		private var goraciusKick:Bitmap;
		private var goraciusServe:Bitmap;
		private var avrelius:Bitmap;
		private var avreliusGo:Bitmap;
		private var avreliusDied:Bitmap;
		private var avreliusServe:Bitmap;
		private var direct:String;
		private var cntPx:uint;
		private var delay:uint;
        private var repeat:uint;
        private var myTimer:Timer;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.frameRate = 10;
			
			var fon:Bitmap = new ArenaFon();
			addChild(fon);
			
			btnPlayImg = new Sprite();
			btnPlayImg.graphics.beginFill(0x7F7F7F, 0.5);
			btnPlayImg.graphics.drawCircle(300, 200, 70);
			btnPlayImg.graphics.endFill();
			btnPlayImg.graphics.beginFill(0xD3D3D3, 0.5);
			btnPlayImg.graphics.moveTo(280, 165);
			btnPlayImg.graphics.lineTo(340, 200);
			btnPlayImg.graphics.lineTo(280, 235);
			btnPlayImg.graphics.endFill();
			btnPlayImgOver = new Sprite();
			btnPlayImgOver.graphics.beginFill(0x7F7F7F, 1);
			btnPlayImgOver.graphics.drawCircle(300, 200, 70);
			btnPlayImgOver.graphics.endFill();
			btnPlayImgOver.graphics.beginFill(0xFFD700);
			btnPlayImgOver.graphics.lineStyle(1, 0xFFFFFF, 1);
			btnPlayImgOver.graphics.moveTo(280, 165);
			btnPlayImgOver.graphics.lineTo(340, 200);
			btnPlayImgOver.graphics.lineTo(280, 235);
			btnPlayImgOver.graphics.endFill();
			btnPlay = new SimpleButton(btnPlayImg, btnPlayImgOver, btnPlayImgOver, btnPlayImg);
			btnPlay.addEventListener(MouseEvent.CLICK, playVideo);
			addChild(btnPlay);
			
			btnStart = new Sprite();
			btnStart.graphics.beginFill(0x7F7F7F);
			btnStart.graphics.moveTo(50, 467);
			btnStart.graphics.lineTo(70, 480);
			btnStart.graphics.lineTo(50, 493);
			btnStart.graphics.endFill();
			addChild(btnStart);
			
			btnPause = new Sprite();
			btnPause.graphics.beginFill(0x000000, 0);
			btnPause.graphics.drawRect(48, 468, 17, 25);
			btnPause.graphics.endFill();
			btnPause.graphics.lineStyle(6, 0x7F7F7F, 1);
			btnPause.graphics.moveTo(50, 470);
			btnPause.graphics.lineTo(50, 491);
			btnPause.graphics.moveTo(61, 470);
			btnPause.graphics.lineTo(61, 491);
			btnPause.graphics.endFill();
			
			btnStop = new Sprite();
			btnStop.graphics.beginFill(0x7F7F7F);
			btnStop.graphics.drawRect(85, 469, 25, 25);
			btnStop.graphics.endFill();
			addChild(btnStop);
			
			goracius = new GladiatorRight();
			goracius.x = 351;
			goracius.y = 200;
			addChild(goracius);
			
			goraciusGo = new GladiatorRightGo();
			goraciusGo.y = 209;
			
			goraciusKick = new GladiatorRightKick();
			goraciusKick.y = 200;
			
			avrelius = new GladiatorLeft();
			avrelius.x = 100;
			avrelius.y = 205;
			addChild(avrelius);
			
			avreliusGo = new GladiatorLeftGo();
			avreliusGo.y = 205;
			
			avreliusDied = new GladiatorLeftDied();
			avreliusDied.y = 330;
			
			avreliusServe = new GladiatorLeftServe();
			avreliusServe.y = 200;
			
			delay = 200;
            repeat = 1;
            myTimer = new Timer(delay, repeat);		
		}
		
		//
		//Клик на кнопку Play, начало действия, и возвращения персонажей в начальные позиции после gameOver
		//
		private function playVideo(event:MouseEvent):void {
			goRules = false;
			die = false;
			cntPx = 0;
			
			btnStop.addEventListener(MouseEvent.CLICK, stopVideo);
			removeChild(btnPlay);
			removeChild(btnStart);
			btnPause.addEventListener(MouseEvent.CLICK, pauseVideo);
			addChild(btnPause);
			direct = 'center';
			if (contains(goraciusGo))
			{
				removeChild(goraciusGo);
				addChild(goracius);
				
			} else if (contains(goraciusKick))
			{
				removeChild(goraciusKick);
				addChild(goracius);
				
			} 
			
			goracius.x = 351;
			goracius.y = 200;
			
			if (contains(avreliusGo))
			{
				removeChild(avreliusGo);
				addChild(avrelius);
				
			} else if (contains(avreliusDied))
			{
				removeChild(avreliusDied);
				addChild(avrelius);
				
			} else if (contains(avreliusServe))
			{
				removeChild(avreliusServe);
				addChild(avrelius);
			}
			
			avrelius.x = 100;
			avrelius.y = 205;
			
			addEventListener(Event.ENTER_FRAME, doEveryFrame);
		}
		//
		//основные действия, которые происходят в каждом фрэйме
		//
		private function doEveryFrame(event:Event):void
		{
			if (die)
			{
				die = false;
				gameOver();
			} else 
			{			
				
				if (goracius.x < 280 && direct == 'center')
				{
					goracius.x += 2;
					avrelius.x += 2;
					direct = 'right';
				
				} else if (goracius.x > 330 && direct == 'right')
				{
					goracius.x -= 2;
					avrelius.x -= 2;
					direct = 'left';
				
				} else if (direct == 'left')
				{
					avrelius.x -= 2;
					goracius.x -= 2;
					
				} else if (direct == 'right')
				{
					avrelius.x += 2;
					goracius.x += 2;					
						
				} else
				{
					goracius.x -= 2;
					avrelius.x += 2;
				}
					
				cntPx += 2;
				
				if (cntPx == 2)
				{
					if (((goracius.x <= 300 && goracius.x > 290) || (goracius.x <= 260 && goracius.x > 250)) && direct == 'left')
					{
						removeChild(avrelius);
						avreliusServe.x = avrelius.x - 5;
						addChild(avreliusServe);
						kick();
						
					} else if ((goracius.x <= 220 && goracius.x > 210) && direct == 'left')
					{
						die = true;
						kick();
						
					} else
					{
						goraciusGo.x = goracius.x - 3;
						removeChild(goracius);
						addChild(goraciusGo);
						
						avreliusGo.x = avrelius.x;
						removeChild(avrelius);
						addChild(avreliusGo);
					}
					
				} else if (cntPx == 4)
				{
					if (goRules)
					{	
						removeChild(goraciusKick);
						addChild(goracius);
						
						removeChild(avreliusServe);
						addChild(avrelius);
						
						goRules = false;
						
					} else 
					{
						removeChild(goraciusGo);
						addChild(goracius);
						
						removeChild(avreliusGo);
						addChild(avrelius);
					}
				}
				
				if (cntPx == 10)
				{
					cntPx = 0;
				}
			}
		}
		//
		//функция заменяет правого гладиатора на изображение с выпадом и устанавливает задержку на 200 млс
		//
		private function kick():void
		{
			removeEventListener(Event.ENTER_FRAME, doEveryFrame);
			removeChild(goracius);
			goraciusKick.x = goracius.x - 30;
			addChild(goraciusKick);
					
			goRules = true;
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, timerHandler);
		}
		//
		//снова запускает действия после задержки на кадре с ударом и защитой
		//
		private function timerHandler(event:Event):void
		{
			addEventListener(Event.ENTER_FRAME, doEveryFrame);
		}
		//
		//пауза
		//
		private function pauseVideo(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, doEveryFrame);
			btnStop.removeEventListener(MouseEvent.CLICK, stopVideo);
			btnPause.removeEventListener(MouseEvent.CLICK, pauseVideo);
			btnStart.addEventListener(MouseEvent.CLICK, playVideoAfterPause);
			removeChild(btnPause);
			addChild(btnStart);
		}
		//
		//продолжение действий после паузы
		//
		private function playVideoAfterPause(event:MouseEvent):void {
			removeChild(btnStart);
			addChild(btnPause);
			btnStart.removeEventListener(MouseEvent.CLICK, playVideoAfterPause);
			btnPause.addEventListener(MouseEvent.CLICK, pauseVideo);
			addEventListener(Event.ENTER_FRAME, doEveryFrame);
			btnStop.addEventListener(MouseEvent.CLICK, stopVideo);
		}
		//
		//остановка видео
		//
		private function stopVideo(event:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, doEveryFrame);
			addChild(btnPlay);
			removeChild(btnPause);
			addChild(btnStart);
		}
		//
		//конец видео, естественная остановка
		//
		private function gameOver():void
		{
			removeChild(avrelius);
			avreliusDied.x = avrelius.x;
			addChild(avreliusDied);
			removeChild(goraciusKick);
			addChild(goracius);
			
			removeEventListener(Event.ENTER_FRAME, doEveryFrame);
			addChild(btnPlay);
			removeChild(btnPause);
			addChild(btnStart);
		}
	}
	
}
package screens
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import objects.BulletPlasma;
	import objects.GameBackground;
	import objects.Hero;
	import objects.Item;
	import objects.PowerBar;
	import objects.PowerUps;
	import objects.RedBirdsArmy;
	import objects.RobotArmy;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.*;
	import starling.display.BlendMode;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	import starling.utils.deg2rad;
	
	public class InGame extends Sprite
	{
		private var hero:Hero;
		private var gameBackground:GameBackground;
		private var startButton:Button;
		
		private var plasmaBullet:BulletPlasma;
		private var bulletVec:Vector.<BulletPlasma>;
		private var bulletsRatio:int;
		private var timerBullets:Timer;
		private const speedBullet:int = 15;
		private var bulletCount:uint;
		private var checkBulletsNow:Boolean;
		private var timerItems:Timer;
		
		private var gameArea:Rectangle;
		private var gameState:String;
		private var scoreText:TextField;
		private var plasmaText:TextField;
		private var distanceText:TextField;
		private var livesText:TextField;
		
		private var textContainer:Sprite;
		
		private var playerSpeed:Number;
		private var obstacleGapCount:int;
		private var scoreDistance:int;
		private var scoreItem:int;
		private var lives:int;
		private var enemyKO:int;
		
		private var timePrevious:Number;
		private var timeCurrent:Number;
		private var elapsed:Number;
		private var hitObstacle:Number;
		private const MIN_SPEED:Number = 650;
		private var robotHit:int;
		private var counterTimer:int;
		private var bulletEnemyRatio:int;
		private var obstacle:RedBirdsArmy;
		private var obstaclesToAnimate:Vector.<RedBirdsArmy>;
		private var itemsToAnimate:Vector.<Item>;
		private var changeNow:Number;
		private var thisDeg:Number;
		
		private var powerBar:PowerBar;
		private var powerBarArt:Image;
		private var fireNow:Boolean;
		private var robotArmy:RobotArmy;
		private var changeDirection:Boolean;
		private var robotShot:Boolean;
		
		private var powerUp:PowerUps;
		private var magnetPower:Boolean;
		private var deflectPower:Boolean;
		private var powerUpTimer:Timer;
		private var powerUpLasting:Number = 0;
		
		private var touch:Touch;
		private var touchX:Number;
		private var touchY:Number;
		private var pool:SpritePool;
		private var robotPool:RobotArmyPool;
		private var currentY:Number = 0;
		private var invertOrder:Boolean;
		private var gameOver:GameOver;
		
		private var robotCounter:int;
		
		public var STAGEWIDTH:uint;
		public var STAGEHEIGHT:uint;
		
		public static var INGAME:Sprite;
		

		public function InGame()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			INGAME = this;
			
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			gameBackground = new GameBackground();
			this.addChild(gameBackground);
			
			drawGame();
			
			textContainer = new Sprite();
			addChild(textContainer);
			
			textContainer.y = -100;
			
			plasmaText = new TextField(200, 100, "PLASMABOMB", Assets.getFont().name, 24, 0xffffff);
			plasmaText.hAlign = HAlign.LEFT;
			plasmaText.vAlign = VAlign.TOP;
			plasmaText.x = 20;
			plasmaText.y = 20;
			textContainer.addChild(plasmaText);
			
			scoreText = new TextField(300, 100, "Score: 0", Assets.getFont().name, 24, 0xffffff);
			scoreText.hAlign = HAlign.LEFT;
			scoreText.vAlign = VAlign.TOP;
			scoreText.x = 550;
			scoreText.y = 20;
			scoreText.height = 40;
			textContainer.addChild(scoreText);
			
			livesText = new TextField(200, 100, "Lives: 3", Assets.getFont().name, 24, 0xffffff);
			livesText.hAlign = HAlign.LEFT;
			livesText.vAlign = VAlign.TOP;
			livesText.x = 300;
			livesText.y = 20;
			livesText.height = 40;
			textContainer.addChild(livesText);
			
			distanceText = new TextField(200, 100, "Distance: 0", Assets.getFont().name, 24, 0xffffff);
			distanceText.hAlign = HAlign.LEFT;
			distanceText.vAlign = VAlign.TOP;
			distanceText.x = 750;
			distanceText.y = 20;
			textContainer.addChild(distanceText);
			
			powerBar = new PowerBar();
			textContainer.addChild(powerBar);
			powerBar.x = 160;
			powerBar.y = 15;
			
			powerBarArt = new Image(Assets.getBackgroundAtlas().getTexture("powerbar"));
			powerBarArt.x = 155
			powerBarArt.y = 10;
			textContainer.addChild(powerBarArt);
		}
		
		public function drawGame():void
		{
			STAGEWIDTH = stage.stageWidth;
			STAGEHEIGHT = stage.stageHeight;
			
			hero = new Hero();
			hero.x = 0;
			hero.y = 0;
			
			this.addChild(hero);
			
			startButton = new Button(Assets.getBackgroundAtlas().getTexture("start_btn"));
			startButton.x = STAGEWIDTH * 0.5 - startButton.width * 0.5;
			startButton.y = -100;
			this.addChild(startButton);
			
			gameArea = new Rectangle(0, 100, STAGEWIDTH, STAGEHEIGHT - 100);
			
			// TIMERS
			bulletsRatio = 600;
			timerBullets = new Timer(bulletsRatio);
			timerBullets.addEventListener(TimerEvent.TIMER, makeBullets, false, 0, true);
			
			timerItems = new Timer(150);
			timerItems.addEventListener(TimerEvent.TIMER, createFoodItems, false, 0, true);
			
			powerUpTimer = new Timer(1000);
			powerUpTimer.addEventListener(TimerEvent.TIMER, fn_powerUp, false, 0, true);
		}
		
		
		public function disposeTemporarily():void
		{
			this.visible = false;
		}
		
		public function initialize():void
		{
			this.visible = true;
			
			var t:Tween = new Tween(startButton, 3, Transitions.EASE_OUT_ELASTIC);
			t.moveTo(startButton.x, STAGEHEIGHT * 0.5 - startButton.height * 0.5);
			t.delay = 1;
			Starling.juggler.add(t);
			
			this.addEventListener(Event.ENTER_FRAME, checkElapsed);
			this.addEventListener("LIVES", livesDown);
			this.addEventListener("ROBOT", removeRobot);
			
			hero.visible = true;
			hero.x = -STAGEWIDTH;
			hero.y = STAGEHEIGHT * 0.5;
			
			hitObstacle = 0;
			playerSpeed = 0;
			robotCounter = 0;
			
			scoreDistance = 0;
			scoreItem = 0;
			obstacleGapCount = 0;
			lives = 3;
			enemyKO = 0;
			counterTimer = 0;
			bulletEnemyRatio = 100;
			thisDeg = 45;
			
			gameState = "idle";
			
			obstaclesToAnimate = new Vector.<RedBirdsArmy>();
			itemsToAnimate = new Vector.<Item>();
			bulletVec = new Vector.<BulletPlasma>();
			
			startButton.addEventListener(Event.TRIGGERED, onStartButtonClick);
			
			pool = new SpritePool(Item, 30);
			robotPool = new RobotArmyPool(RobotArmy, 2);
			
		}
		
		private function onStartButtonClick(event:Event):void
		{	
			startButton.removeEventListener(Event.TRIGGERED, onStartButtonClick);
			CaptainVeggie.MAIN.SM.playSound("../sounds/Blip_Select.mp3");
			
			var t1:Tween = new Tween(startButton, 2, Transitions.EASE_OUT_ELASTIC);
			t1.moveTo(startButton.x,-150);
			Starling.juggler.add(t1);
		
			var t:Tween = new Tween(textContainer, 2, Transitions.EASE_OUT_ELASTIC);
			t.delay = 1;
			t.moveTo(0,0);
			Starling.juggler.add(t);
			
			launchHero();
			
		}
		
		private function launchHero():void
		{
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, onGameTick);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			touch = event.getTouch(stage);
			
			touchX = touch.globalX;
			touchY = touch.globalY;
		}
		
		private function checkElapsed(event:Event):void
		{
			timePrevious = timeCurrent;
			timeCurrent = getTimer();
			elapsed = (timeCurrent - timePrevious) * 0.001;
		}
		
		private function cameraShake():void
		{
			if (hitObstacle > 0)
			{
				this.x = -int(Math.random() * hitObstacle);
				this.y = -int(Math.random() * hitObstacle);
			}
			else if (x != 0)
			{
				this.x = 0;
				this.y = 0;
			}
		}
		
//////////////////////////////////////// RESET AFTER ROBOT ////////////////////////////////////////////				
		private function removeRobot(evt:Event):void
		{
			var t:Tween = new Tween(robotArmy, 2);
			t.moveTo(STAGEWIDTH , robotArmy.y);
			t.onComplete = resetBack;
			Starling.juggler.add(t);
			robotShot = false;
		}
		
		private function resetBack():void
		{
			GameBackground.GAMEBG.dispatchEvent( new Event("RESETY"));
			robotArmy.deleteMe = true;
			robotArmy.reseteMe = true;
			removeChild(robotArmy);
			robotPool.returnSprite(robotArmy);
			scoreItem += 100;
			scoreDistance += 1500;
			enemyKO += 10;
			lives++;
			robotCounter++;
			if (robotCounter == 10) Game.GAME.addEvenListener(new Event("TENROBOTSOUT"));
		}
		
		private function livesDown(evt:Event):void
		{
			lives--;
			resetPlasmaBomb();
		}

//////////////////////////////////////// GAME LOOP ////////////////////////////////////////////		
		private function onGameTick(event:Event):void
		{
			switch(gameState)
			{
				case "idle":
					// Take off
					if (hero.x < STAGEWIDTH * 0.5 * 0.5)
					{
						hero.x += ((STAGEWIDTH * 0.5 * 0.5 + 10) - hero.x) * 0.05;
						hero.y = STAGEHEIGHT * 0.5;
						
						playerSpeed += (MIN_SPEED - playerSpeed) * 0.05;
					}
					else
					{
						gameState = "flying";
						timerItems.start();
					}
					break;
				case "flying":
					// Check the System
					checkHero();
					counter();
					initObstacle();
					animateObstacles();
					animateItems();
					checkMissiles();
					if (powerUp) animatePowerUp();
					if (counterTimer % 1000 == 0 && counterTimer != 0) createPowerUp();
					if(scoreDistance % 10000 == 0 && scoreDistance != 0) {
						changeState();
						gameState = "robot";
					}
					break;
				case "robot":
					// Check the System
					robotArmy.blendMode = BlendMode.NORMAL;
					checkHero();
					counter();
					animateItems();
					checkMissiles();
					moveRobot();
					
					if(robotHit == 30) {
						robotHit = 0;
						robotArmy.alreadyHit = true;
						gameState = "flying";
					}
					break;
				case "over":
					// End the Game
					stopIt();
					CaptainVeggie.MAIN.SM.playSound("../sounds/HeroDead.mp3");
					break;
			}
			
			counterTimer++;
			checkRatioBullet();
			
		}
		
		private function checkRatioBullet():void
		{
			if(scoreDistance % 3000 == 0 && scoreDistance != 0) {
				if (bulletEnemyRatio == 60) return;
				else bulletEnemyRatio -= 5;
			}
		}
		
		private function checkMissiles():void
		{
			if(bulletVec.length > 0) {
				moveMissiles();
				checkBulletsNow = true;
			}
		}
		
		private function checkHero():void
		{
			if (lives == 0) gameState = "over";
			if (hitObstacle <= 0)
			{
				hero.y -= (hero.y - touchY) * 0.1;
				hero.x -= (hero.x - touchX) * 0.1;
				
				
				if (-(hero.y - touchY) < 150 && -(hero.y - touchY) > -150)
				{
					hero.rotation = deg2rad(-(hero.y - touchY) * 0.03);
				}
				
				if (hero.y > gameArea.bottom - hero.height * 0.5)
				{
					hero.y = gameArea.bottom - hero.height * 0.5;
					hero.rotation = deg2rad(0);
				}
				if (hero.y < gameArea.top + hero.height * 0.5)
				{
					hero.y = gameArea.top + hero.height * 0.5;
					hero.rotation = deg2rad(0);
				}
				if (hero.x > STAGEWIDTH * 0.5 + hero.width * 1.5)
				{
					hero.x = STAGEWIDTH * 0.5 + hero.width * 1.5;
					hero.rotation = deg2rad(0);
				}
				if (hero.x < 0 + hero.width * 1.5)
				{
					hero.x = 0 + hero.width * 1.5;
					hero.rotation = deg2rad(0);
				}
				if (fireNow) {
					
					timerBullets.start();
				}
				
			}
			else
			{
				hitObstacle--;
				cameraShake();
			}
			
		}
		
		private function counter():void
		{
			playerSpeed -= (playerSpeed - MIN_SPEED) * 0.01;
			if(gameState == "flying") scoreDistance += (playerSpeed * elapsed) * 0.1;
			scoreText.text = "Score: " + scoreItem;
			distanceText.text = "Distance: " + scoreDistance;
			livesText.text = "Lives: " + lives;
		}
		
		private function resetPlasmaBomb():void {
			powerBar.width = 2;
			if (fireNow) {
				fireNow = false;
				timerBullets.stop();
				bulletCount = 0;
			}
		}

//////////////////////////////////////// CREATE POWER UPS ////////////////////////////////////////////		
		
		private function createPowerUp():void
		{
			powerUp = new PowerUps(Math.ceil(Math.random() * 2));
			
			powerUp.y = int(Math.random() * (gameArea.bottom - gameArea.top));
			powerUp.x = STAGEWIDTH + powerUp.width;
			addChild(powerUp);
		}
		
		private function fn_powerUp(evt:TimerEvent):void
		{
			
			if(powerUpLasting == 6) CaptainVeggie.MAIN.SM.playSound("../sounds/Tick.mp3");
			if(powerUpLasting == 8) {
				
				magnetPower = false;
				deflectPower = false;
				hero.blendMode = BlendMode.NORMAL;
				powerUpLasting = 0;
				powerUpTimer.stop();
				
			}
			else powerUpLasting++;

		}
		
		private function animatePowerUp():void
		{

			if (hero.bounds.intersects(powerUp.bounds)) {
				powerUp.y = 0;
				removeChild(powerUp, true);
				if(powerUp.powerUpType == 1) magnetPower = true;
				if(powerUp.powerUpType == 2) {
					deflectPower = true;
					hero.blendMode = BlendMode.MULTIPLY;
				}
				powerUpTimer.start();
				CaptainVeggie.MAIN.SM.playSound("../sounds/Pickup_Coin.mp3");
			}
			else powerUp.x -= playerSpeed * elapsed;
		}
		
		
		
//////////////////////////////////////// ROBOT EVENTS ////////////////////////////////////////////				
		private function changeState():void
		{
			GameBackground.GAMEBG.dispatchEvent( new Event("CHANGEY"));
			CaptainVeggie.MAIN.SM.playSound("../sounds/AlarmRobot.mp3");
			if(powerUp) {
				removeChild(powerUp, true);
				hero.blendMode = BlendMode.NORMAL;
			}
			
			if(obstaclesToAnimate.length > 0) {
				for (var l:int=obstaclesToAnimate.length-1; l>=0; l--) {
					
					removeChild(obstaclesToAnimate[l],true);
					obstaclesToAnimate.splice(l,1);
				}
			}
			
			if(bulletVec.length > 0) {
				for (var j:int=bulletVec.length-1; j>=0; j--) {
					removeBullet(j)
				}
			}
			
			robotArmy = robotPool.getSprite() as RobotArmy;
			robotArmy.x = STAGEWIDTH + robotArmy.width/2;
			robotArmy.y = 50;
			this.addChild(robotArmy);
			
			var t:Tween = new Tween(robotArmy, 3);
			t.delay = 1;
			t.moveTo(550, robotArmy.y);
			Starling.juggler.add(t);
			t.onComplete = fn_robotShot;
			
			Game.GAME.dispatchEvent( new Event("TENTHOUSAND"));

		}
		
		private function fn_robotShot():void
		{
			robotShot = true;
		}
		
		private function moveRobot():void
		{
			if(!changeDirection) robotArmy.y += 1;
			if(changeDirection) robotArmy.y -= 1;
			if(robotArmy.y <= 40) changeDirection = false;
			if(robotArmy.y >= STAGEHEIGHT/2) changeDirection = true;
			// SHOT BULLET
			if (counterTimer % 80 == 0 && robotShot == true) {
				var bulletGun:BulletPlasma = new BulletPlasma(4);
				bulletGun.x = robotArmy.x;
				bulletGun.y = robotArmy.y + robotArmy.height/2;
				addChild(bulletGun);
				bulletVec.push(bulletGun);
			}
			if(robotArmy.bounds.intersects(hero.bounds)) {
				robotArmy.blendMode = BlendMode.MULTIPLY;
				hero.x -= 50;
				tweenBack();
				resetPlasmaBomb();
				hitObstacle = 30;
				playerSpeed *= 0.5;
				CaptainVeggie.MAIN.SM.playSound("../sounds/FirePunchImpact.mp3");
			}
		}
		
		private function tweenBack():void
		{
			var t1:Tween = new Tween(hero, 1, Transitions.EASE_OUT_ELASTIC);
			t1.moveTo(300, hero.y);
			Starling.juggler.add(t1);
		}
		
//////////////////////////////////////// CREATE AND MOVE THE ITEMS ////////////////////////////////////////////		
		private function createFoodItems(evt:TimerEvent):void
		{
			
			if(counterTimer % 2 == 0) thisDeg = thisDeg + (elapsed * 100);
			else thisDeg = - thisDeg - (elapsed * 100);
			
			var itemToTrack:Item = pool.getSprite() as Item;
			itemToTrack.x = STAGEWIDTH + 50;
			
			this.addChild(itemToTrack);
			setChildIndex(itemToTrack, 1);
				
			itemsToAnimate.push(itemToTrack);
			
			if(changeNow == 1) itemToTrack.y = 50 + currentY;
			else if(changeNow == 2) itemToTrack.y = int(Math.random() * (gameArea.bottom - gameArea.top));
			else if(changeNow == 3) {
				itemToTrack.y = 50 + currentY;
				addX();
			}
			else if(changeNow == 4) {
				itemToTrack.y = 50 + currentY;
				addZ();
			}
			else {
				itemToTrack.y = 50 + currentY;
				addY();
			}
		}
		
		private function addX():void
		{
			if (invertOrder)
			{
				if (currentY < 50) invertOrder = false;
					
				else currentY -=  80 + elapsed * 10;
			}
			else if (currentY > 450) invertOrder = true;
				
			else currentY +=  80 + elapsed * 10;
		}
		
		private function addY():void
		{
			if (invertOrder)
			{
				if (currentY < 50) invertOrder = false;
					
				else currentY -=  30 + elapsed * 10;;
			}
			else if (currentY > 450) invertOrder = true;
				
			else currentY +=  30 + elapsed * 10;
		}
		
		private function addZ():void
		{
			if (invertOrder)
			{
				if (currentY < 50) invertOrder = false;
					
				else currentY -=  5 + elapsed * 10;
			}
			else if (currentY > 450) invertOrder = true;
				
			else currentY +=  5 + elapsed * 10;
		}
		
		private function animateItems():void
		{
			var itemToTrack:Item;
			var myAtan2:Number;
			if (scoreDistance % 100 == 0) changeNow = Math.ceil(Math.random() * 5);
			for(var i:uint = 0; i < itemsToAnimate.length; i++)
			{
				itemToTrack = itemsToAnimate[i];
				
				if(magnetPower) {
					
					myAtan2 = Math.atan2((hero.y - hero.height/2) - itemToTrack.y, (hero.x - hero.width/2) - itemToTrack.x);
					itemToTrack.x += Math.cos(myAtan2) * 20;
					itemToTrack.y += Math.sin(myAtan2) * 20;
					
				}
				else itemToTrack.x -= playerSpeed * elapsed;
				
				if (itemToTrack.bounds.intersects(hero.bounds))
				{
					scoreItem += 5;
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
					pool.returnSprite(itemToTrack);
					var randomNumber:Number = Math.ceil(Math.random() * 8);
					CaptainVeggie.MAIN.SM.playSound("../sounds/Note" + String(randomNumber) + ".mp3");
					CaptainVeggie.MAIN.SM.setVolume(0.6,"../sounds/Note" + String(randomNumber) + ".mp3");
					if(powerBar.width == 119) {
						
						fireNow = true;
						powerBar.blendMode = BlendMode.MULTIPLY;
					}
					else {
						
						powerBar.scaleX += 0.5;
					}
				}
				
				if (itemToTrack.x < -50)
				{
					itemsToAnimate.splice(i, 1);
					this.removeChild(itemToTrack);
					pool.returnSprite(itemToTrack);
				}
			}
		}
		

//////////////////////////////////////// CREATE THE OBSTACLES ////////////////////////////////////////////				
		private function initObstacle():void
		{
			if (obstacleGapCount < 1200)
			{
				obstacleGapCount += playerSpeed * elapsed;
			}
			else if (obstacleGapCount != 0)
			{
				obstacleGapCount = 0;
				createObstacle(Math.ceil(Math.random() * 5), Math.random() * 1000 + 200);
			}
		}
		
		private function createObstacle(type:Number, distance:Number):void
		{
			var obstacle:RedBirdsArmy = new RedBirdsArmy(type, distance, true, 300);
			obstacle.x = stage.stageWidth;
			this.addChild(obstacle);
			setChildIndex(obstacle, 2);
			
			if (type <= 3)
			{
				if (Math.random() > 0.5)
				{
					obstacle.y = gameArea.top;
					obstacle.position = "top";
				}
				else
				{
					obstacle.y = int(Math.random() * (gameArea.bottom - obstacle.height - gameArea.top)) + gameArea.top;
					obstacle.position = "middle";
				}
			}
			else
			{
				obstacle.y = gameArea.bottom - obstacle.height;
				obstacle.position = "bottom";
			}
			obstaclesToAnimate.push(obstacle);
		}

//////////////////////////////////////// ANIMATE THE OBSTACLES ////////////////////////////////////////////		
		private function animateObstacles():void
		{
			var obstacleToTrack:RedBirdsArmy;
			var myAtan2:Number;
			
			for (var i:int=obstaclesToAnimate.length-1; i>=0; i--)
			{
				obstacleToTrack = obstaclesToAnimate[i];
				
				if (obstacleToTrack.alreadyHit == false && obstacleToTrack.bounds.intersects(hero.bounds) && !deflectPower)
				{
					obstacleToTrack.alreadyHit = true;
					obstacleToTrack.downLife = true;
					hitObstacle = 30;
					playerSpeed *= 0.5;
					CaptainVeggie.MAIN.SM.playSound("../sounds/FirePunchImpact.mp3");
					CaptainVeggie.MAIN.SM.playSound("../sounds/Explosion.mp3");
				}
				
				if (obstacleToTrack.distance > 0)
				{
					obstacleToTrack.distance -= playerSpeed * elapsed;
				}
				else
				{
					if (obstacleToTrack.watchOut)
					{
						obstacleToTrack.watchOut = false;
					}
					obstacleToTrack.x -= (playerSpeed + obstacleToTrack.speed) * elapsed;
					if(deflectPower) {
						
						myAtan2 = Math.atan2((hero.y - hero.height/2) - obstacleToTrack.y, (hero.x - hero.width/2) - obstacleToTrack.x);
						obstacleToTrack.x -= Math.cos(myAtan2) * 5;
						obstacleToTrack.y -= Math.sin(myAtan2) * 5;
						
					}
					if (obstacleToTrack.alreadyHit == false) {
						if (obstacleToTrack.type == 4) {
							if (counterTimer % bulletEnemyRatio == 0 && !deflectPower) {
								CaptainVeggie.MAIN.SM.playSound("../sounds/GunShot.mp3");
								var bulletGun:BulletPlasma = new BulletPlasma(1);
								bulletGun.x = obstacleToTrack.x;
								bulletGun.y = obstacleToTrack.y - 20;
								addChild(bulletGun);
								bulletVec.push(bulletGun);
							}
						}
						if (obstacleToTrack.type == 5) {
							if (counterTimer % bulletEnemyRatio == 0 && !deflectPower) {
								CaptainVeggie.MAIN.SM.playSound("../sounds/Rocket.mp3");
								var bulletLauncher:BulletPlasma = new BulletPlasma(2);
								bulletLauncher.x = obstacleToTrack.x;
								bulletLauncher.y = obstacleToTrack.y - 20;
								addChild(bulletLauncher);
								bulletVec.push(bulletLauncher);
							}
						}
					}

				}
		
				if (obstacleToTrack.x < -obstacleToTrack.width || gameState == "over")
				{
					obstacleToTrack.deleteMe = true;
					obstaclesToAnimate.splice(i, 1);
					this.removeChild(obstacleToTrack, true);
				}
				if(checkBulletsNow) {
					for (var j:int=bulletVec.length-1; j>=0; j--)
					{
						if (obstacleToTrack.alreadyHit == false && obstacleToTrack.bounds.intersects(bulletVec[j].bounds) && bulletVec[j].type == 3)
						{
							obstacleToTrack.alreadyHit = true;
							scoreItem += 20;
							enemyKO++;
							removeBullet(j);
							CaptainVeggie.MAIN.SM.playSound("../sounds/Explosion.mp3");
						}
					}
				}
			}
		}
//////////////////////////////////////// CREATE THE BULLETS ////////////////////////////////////////////		
				
		private function makeBullets(evt:TimerEvent):void
		{
			CaptainVeggie.MAIN.SM.playSound("../sounds/Laser_Shoot.mp3");
			CaptainVeggie.MAIN.SM.setVolume(0.5,"../sounds/Laser_Shoot.mp3");
			plasmaBullet = new BulletPlasma(3);
			plasmaBullet.x = hero.x;
			plasmaBullet.y = hero.y - 30;
			// add to stage and array
			this.addChild(plasmaBullet);
			bulletVec.push(plasmaBullet);
			
			if(bulletCount == 20) {
				
				fireNow = false;
				timerBullets.stop();
				powerBar.width = 2;
				bulletCount = 0;
				checkBulletsNow = false;
				powerBar.blendMode = BlendMode.NORMAL;
			}
			else bulletCount++;
		}
		
		private function moveMissiles():void
		{
			var thisBullet:BulletPlasma;

			for (var i:int=bulletVec.length-1; i>=0; i--)
			{
				thisBullet = bulletVec[i];
				
				if (thisBullet.type == 3) thisBullet.x += speedBullet;
				
				else if (thisBullet.type == 1) {
					
					thisBullet.rotation = deg2rad(-90)
					thisBullet.y -= 10;
				}
				else if (thisBullet.type == 2) {
					
					thisBullet.rotation = deg2rad(-150);
					var constX:Number = Math.cos(Math.PI * thisBullet.rotation);
					var constY:Number = Math.sin(Math.PI * thisBullet.rotation);
					thisBullet.x -= constX + speedBullet * 1.5;
					thisBullet.y += constY * speedBullet * .5;
				}
				else if (thisBullet.type == 4) {
					
					thisBullet.rotation = deg2rad(thisDeg);
					var constX2:Number = Math.cos(Math.PI * thisBullet.rotation);
					var constY2:Number = Math.sin(Math.PI * thisBullet.rotation);
					thisBullet.x -= constX2 + speedBullet * 1.2;
					thisBullet.y += constY2 * speedBullet * .5;
				}
				if (thisBullet.bounds.intersects(hero.bounds)) {
					
					if(thisBullet.type == 4) lives--;
					resetPlasmaBomb();
					hitObstacle = 30;
					playerSpeed *= 0.5;
					removeBullet(i);
					CaptainVeggie.MAIN.SM.playSound("../sounds/FirePunchImpact.mp3");
					break;
				}
				if (gameState == "robot" && thisBullet.bounds.intersects(robotArmy.bounds) && thisBullet.x > STAGEWIDTH - robotArmy.width/2) {
					
					removeBullet(i);
					robotArmy.blendMode = BlendMode.SCREEN;
					robotHit++;
				}
				if (thisBullet.x > STAGEWIDTH || thisBullet.x < 0 || thisBullet.y < 0)
				{
					removeBullet(i);
				}
			}
		}
		
		public function removeBullet(idx:int):void
		{
			removeChild(bulletVec[idx], true);
			bulletVec.splice(idx,1);
		}
		
		private function stopIt():void
		{
			hero.hideArt = true;
			hero.deadAni = true;
			this.x = 0;
			this.y = 0;
			timerItems.stop();
			timerBullets.stop();
			timerBullets.removeEventListener(TimerEvent.TIMER, makeBullets);
			timerItems.removeEventListener(TimerEvent.TIMER, createFoodItems);
			pool.clearMe();
			robotPool.clearMe();
			
			this.removeEventListener(Event.ENTER_FRAME, checkElapsed);
			this.removeEventListener(TouchEvent.TOUCH, onTouch);
			this.removeEventListener(Event.ENTER_FRAME, onGameTick);
			this.removeEventListener("LIVES", livesDown);
			this.removeEventListener("ROBOT", removeRobot);
			
			if(robotArmy) resetBack();
			
			clearTheStage();
		}
		
		private function clearTheStage():void
		{
			for (var i:int=itemsToAnimate.length-1; i>=0; i--)
			{
				removeChild(itemsToAnimate[i],true);
				itemsToAnimate.splice(i,1);
			}
			
			for (var j:int=bulletVec.length-1; j>=0; j--) {
				
				removeBullet(j)
			}
			for (var l:int=obstaclesToAnimate.length-1; l>=0; l--) {
				
				removeChild(obstaclesToAnimate[l],true);
				obstaclesToAnimate.splice(l,1);
			}
			
			var t:Tween = new Tween(textContainer, 2, Transitions.EASE_OUT_ELASTIC);
			t.delay = 1;
			t.moveTo(0,-100);
			t.onComplete = gameOverScreen;
			Starling.juggler.add(t);
			if(powerUp) removeChild(powerUp,true);
			
		}
		
		private function gameOverScreen():void
		{
			gameOver = new GameOver(scoreItem, scoreDistance, enemyKO);
			addChild(gameOver);
			if(enemyKO >= 20) Game.GAME.dispatchEvent( new Event("SENDENEMIESKO"));
			if(!Welcome.WELCOME.captainVeggieSO.data.score && !Welcome.WELCOME.captainVeggieSO.data.distance) {
				Welcome.WELCOME.captainVeggieSO.data.score = scoreItem;
				Welcome.WELCOME.captainVeggieSO.data.distance = scoreDistance;
				Welcome.WELCOME.captainVeggieSO.flush();
			}
			
			if(Welcome.WELCOME.captainVeggieSO.data.score <= scoreItem) {
				Welcome.WELCOME.captainVeggieSO.data.score = scoreItem;
				Welcome.WELCOME.captainVeggieSO.flush();
				Game.GAME.dispatchEvent( new Event("SENDBESTSCORE"));
			}
			if(Welcome.WELCOME.captainVeggieSO.data.distance <= scoreDistance ) {
				Welcome.WELCOME.captainVeggieSO.data.distance = scoreDistance;
				Welcome.WELCOME.captainVeggieSO.flush();
			}
			CaptainVeggie.MAIN.SM.mute();
			
		}
		
		public function resetAllTheGame():void {
			
			removeChild(gameOver, true);
			removeChild(startButton, true);
			bulletVec.splice(0, bulletVec.length);
			itemsToAnimate.splice(0, itemsToAnimate.length);
			obstaclesToAnimate.splice(0, obstaclesToAnimate.length);
			
		}
		
	}
}
package
{
	import com.milkmangames.nativeextensions.ios.GameCenter;
	import com.milkmangames.nativeextensions.ios.events.GameCenterErrorEvent;
	import com.milkmangames.nativeextensions.ios.events.GameCenterEvent;
	
	import events.NavigationEvent;
	
	import recipes.Croquettes;
	import recipes.Eggrooms;
	import recipes.Zucchini;
	
	import screens.About;
	import screens.InGame;
	import screens.RecipeBook;
	import screens.Welcome;
	
	import starling.animation.Tween;
	import starling.core.*;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var screenWelcome:Welcome;
		private var screenInGame:InGame;
		private var screenAbout:About;
		private var screenRecipe:RecipeBook;
		private var zucchini:Zucchini;
		private var eggrooms:Eggrooms;
		private var croquettes:Croquettes;
		private var blackRect:Quad;
		private var gameCenter:GameCenter;
		
		public var iOS:Boolean;
		
		public static var GAME:Object;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ENTER_FRAME, checkLoaded);
			
			
			GAME = this;
		}
		
		private function checkLoaded(evt:Event):void
		{
			if(TheAtlasLoader.getInstance()._allLoaded) {
				
				init();
				this.removeEventListener(Event.ENTER_FRAME, checkLoaded);
				
			}
		}
		
		private function init():void {
			
			this.addEventListener(events.NavigationEvent.CHANGE_SCREEN, onChangeScreen);
			
			screenInGame = new InGame();
			screenInGame.disposeTemporarily();
			this.addChild(screenInGame);
			
			screenWelcome = new Welcome();
			this.addChild(screenWelcome);
			screenWelcome.initialize();
			
			screenAbout = new About();
			screenAbout.disposeTemporarily();
			this.addChild(screenAbout);
			
			if (!GameCenter.isSupported())
			{
				trace("this device doesn't have gamecenter.");
				return;
			}
				
			else addGameCenter();
		}
		
		
		private function addGameCenter():void {
			
			gameCenter = GameCenter.create();
			
			iOS = true;
			// GameCenter doesn't work on iOS versions < 4.1, so always check this first!
			if(!GameCenter.gameCenter.isGameCenterAvailable())
			{
				trace("this device doesn't have gamecenter.");
				return;
			}
			
			// ios5.0+ can show achievement notifications in the native UI.  
			if (GameCenter.gameCenter.areBannersAvailable())
			{
				GameCenter.gameCenter.showAchievementBanners(true);
			}
			GameCenter.gameCenter.authenticateLocalUser();
			
			this.addEventListener("SENDBESTSCORE", sendBestScore);
			this.addEventListener("TENTHOUSAND", sendTenThousand);
			this.addEventListener("TENROBOTSOUT", sendTenRobots);
			this.addEventListener("SENDENEMIESKO", sendEnemies);
			
		}
		
		protected function sendBestScore(event:Event):void
		{
			if (!checkAuthentication()) return;
			GameCenter.gameCenter.reportScoreForCategory(int(Welcome.WELCOME.captainVeggieSO.data.score),"TheBestScore");
		}
		
		protected function sendTenThousand(event:Event):void
		{
			if (!checkAuthentication()) return;
			GameCenter.gameCenter.reportAchievement("TenThousandMiles",100.0);
		}
		
		protected function sendTenRobots(event:Event):void
		{
			if (!checkAuthentication()) return;
			GameCenter.gameCenter.reportAchievement("TenRobotsOut",100.0);
		}
		
		protected function sendEnemies(event:Event):void
		{
			if (!checkAuthentication()) return;
			GameCenter.gameCenter.reportAchievement("TwentyArmyOut",100.0);
		}
		
		
		private function checkAuthentication():Boolean
		{
			if (!GameCenter.gameCenter.isUserAuthenticated())
			{
				return false;
			}
			return true;
		}
		
		private function createTransition():void {
			
			blackRect = new Quad(stage.stageWidth, stage.stageWidth, 0x000000);
			addChild(blackRect);
			var t:Tween = new Tween(blackRect, 1);
			t.animate("alpha", 0);
			Starling.juggler.add(t);
			t.onComplete = deleteMe;
		}
		
		private function deleteMe():void
		{
			removeChild(blackRect,true);
		}
		
		private function onChangeScreen(event:NavigationEvent):void
		{
			switch (event.params.id)
			{
				case "play":
					screenWelcome.disposeTemporarily();
					screenInGame.initialize();
					createTransition();
					break;
				case "mainFromGameOver":
					createTransition();
					screenInGame.disposeTemporarily();
					screenWelcome.initialize();
					screenInGame.resetAllTheGame();
					screenInGame.drawGame();
					break;
				case "about":
					screenWelcome.disposeTemporarily();
					createTransition();
					screenAbout.initialize();
					break;
				case "mainFromAbout":
					createTransition();
					screenAbout.disposeTemporarily();
					screenWelcome.initialize();
					break;
				case "recipe":
					screenWelcome.disposeTemporarily();
					screenRecipe = new RecipeBook();
					addChild(screenRecipe);
					createTransition();
					break;
				case "mainFromCookBook":
					createTransition();
					removeChild(screenRecipe);
					screenWelcome.initialize();
					break;
				case "mainFromRecipe":
					createTransition();
					screenRecipe.initialize();
					break;
				case "Zucchini's Pizza":
					screenRecipe.disposeTemporarily();
					zucchini = new Zucchini();
					addChild(zucchini);
					createTransition();
					break;
				case "Eggrooms":
					screenRecipe.disposeTemporarily();
					eggrooms = new Eggrooms();
					addChild(eggrooms);
					createTransition();
					break;
				case "Croquettes":
					screenRecipe.disposeTemporarily();
					croquettes = new Croquettes();
					addChild(croquettes);
					createTransition();
					break;
			}
		}
	}
}
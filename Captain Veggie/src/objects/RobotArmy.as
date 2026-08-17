package objects
{
	import screens.InGame;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class RobotArmy extends Sprite
	{
		private var robotArt:MovieClip;
		private var _deleteMe:Boolean;
		private var _alreadyHit:Boolean;
		private var _resetMe:Boolean;
		private var particle:PDParticleSystem;
		
		public function RobotArmy()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			_deleteMe = false;
			_alreadyHit = false;
			_resetMe = false;
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createRobotArt();
		}
		
		public function get resetMe():Boolean
		{
			return _resetMe;
		}
		
		public function set reseteMe(value:Boolean):void
		{
			_resetMe = value;
			
			if (value)
			{
				robotArt.visible = true;
			}
		}
		
		public function get deleteMe():Boolean
		{
			return _deleteMe;
		}
		
		public function set deleteMe(value:Boolean):void
		{
			_deleteMe = value;
			
			if (value)
			{
				removeChild(particle, true);
			}
		}
		
		public function get alreadyHit():Boolean
		{
			return _alreadyHit;
		}
		
		public function set alreadyHit(value:Boolean):void
		{
			_alreadyHit = value;
			
			if (value)
			{
				createParticleCrash();
				robotArt.visible = false;
				InGame.INGAME.dispatchEvent( new Event("ROBOT") );
			}
			
		}
		
		private function createRobotArt():void
		{
			robotArt = new MovieClip(Assets.getRobotAtlas().getTextures("Robot"), 30);
			robotArt.x = 0;
			robotArt.y = 0;
			starling.core.Starling.juggler.add(robotArt);
			this.addChild(robotArt);
		}
		
		private function createParticleCrash():void
		{
			particle = new PDParticleSystem(XML(new AssetsParticles.ParticleXML()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
			Starling.juggler.add(particle);
			this.addChild(particle);
			particle.pivotX = -this.width/2;
			particle.pivotY = -this.height/2
			particle.scaleX = particle.scaleY = 1.5;
			particle.start(0.25);
			
		}
	}
}
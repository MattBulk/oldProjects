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
	
	public class RedBirdsArmy extends Sprite
	{
		
		private var _type:int;
		private var _speed:int;
		private var _distance:int;
		private var frameRate:int;
		private var _watchOut:Boolean;
		private var _alreadyHit:Boolean;
		private var _downLife:Boolean;
		private var _deleteMe:Boolean;
		private var _position:String;
		private var obstacleImage:Image;
		private var obstacleCrashImage:Image;
		private var obstacleAnimation:MovieClip;
		private var watchOutAnimation:MovieClip;
		private var particle:PDParticleSystem;
		
		public function RedBirdsArmy(_type:int, _distance:int, _watchOut:Boolean = true, _speed:int = 0)
		{
			super();
			
			this._type = _type;
			this._distance = _distance;
			this._watchOut = _watchOut;
			this._speed = _speed;
			
			_alreadyHit = false;
			_deleteMe = false;
			_downLife = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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
		
		public function get downLife():Boolean
		{
			return _downLife;
		}
		
		public function set downLife(value:Boolean):void
		{
			_downLife = value;
			
			if (value)
			{
				InGame.INGAME.dispatchEvent( new Event("LIVES") );
			}
		}

		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
		
		public function get distance():int
		{
			return _distance;
		}
		
		public function set distance(value:int):void
		{
			_distance = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		
		public function get position():String
		{
			return _position;
		}
		
		public function set position(value:String):void
		{
			_position = value;
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
				obstacleAnimation.visible = false;
			}
		}
		
		public function get watchOut():Boolean
		{
			return _watchOut;
		}
		
		public function set watchOut(value:Boolean):void
		{
			_watchOut = value;
			
			if (watchOutAnimation)
			{
				if (value) watchOutAnimation.visible = true;
				else {
					watchOutAnimation.visible = false;
					removeChild(watchOutAnimation, true);
				}
			}
		}
		
		private function onAddedToStage(evt:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			createObstacleArt();
			createWatchOutAnimation();
			
		}
		
		private function createObstacleArt():void
		{
			
			switch(_type) {
				
				case 1:
					frameRate = 40;
				break;
				case 2:
				case 3:
					frameRate = 20;
				break;
				case 4:
				case 5:
					frameRate = 15;
				break;
			}
			obstacleAnimation = new MovieClip(Assets.getBackgroundAtlas().getTextures("ArmyType" + _type + "_0"), frameRate);
			Starling.juggler.add(obstacleAnimation);
			obstacleAnimation.x = 0;
			obstacleAnimation.y = 0;
			this.addChild(obstacleAnimation);
			
		}
		
		private function createParticleCrash():void
		{
			particle = new PDParticleSystem(XML(new AssetsParticles.ParticleXML()), Texture.fromBitmap(new AssetsParticles.ParticleTexture()));
			Starling.juggler.add(particle);
			this.addChild(particle);
			particle.pivotX = -this.width/2;
			particle.pivotY = -this.height/2
			particle.scaleX = particle.scaleY = 0.6;
			particle.start(0.25);
		}
		
		private function createWatchOutAnimation():void
		{
			watchOutAnimation = new MovieClip(Assets.getBackgroundAtlas().getTextures("watchout"), 10);
			Starling.juggler.add(watchOutAnimation);
			watchOutAnimation.x = -watchOutAnimation.texture.width * 1.5;
			watchOutAnimation.y = obstacleAnimation.y + (obstacleAnimation.texture.height * 0.5) - (watchOutAnimation.texture.height * 0.5);
			
			this.addChild(watchOutAnimation);
		}
	}
}
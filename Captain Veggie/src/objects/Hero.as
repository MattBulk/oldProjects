package objects
{
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class Hero extends Sprite
	{
		private var heroArt:MovieClip;
		private var particle:PDParticleSystem;
		private var _deadAni:Boolean;
		private var _hideArt:Boolean;
		
		public function Hero()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
			
			_deadAni = false;
			_hideArt = false;
		}
		
		public function get hideArt():Boolean
		{
			return _deadAni;
		}
		
		public function set hideArt(value:Boolean):void
		{
			_hideArt = value;
			
			if (value)
			{
				heroArt.visible = false;
			}
			else heroArt.visible = true;
		}
		
		public function get deadAni():Boolean
		{
			return _deadAni;
		}
		
		public function set deadAni(value:Boolean):void
		{
			_deadAni = value;
			
			if (value)
			{
				createParticleCrash();
			}
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createHeroArt();
		}
		
		private function createHeroArt():void
		{
			heroArt = new MovieClip(Assets.getBackgroundAtlas().getTextures("Captain"), 30);
			heroArt.x = Math.ceil(-heroArt.width);
			heroArt.y = Math.ceil(-heroArt.height);
			starling.core.Starling.juggler.add(heroArt);
			this.addChild(heroArt);
		}
		
		public function createParticleCrash():void
		{
			particle = new PDParticleSystem(XML(new AssetsParticles.HeroDeadXML()), Texture.fromBitmap(new AssetsParticles.ParticleTextureHero()));
			Starling.juggler.add(particle);
			this.addChild(particle);
			particle.pivotX = -this.width/2;
			particle.pivotY = -this.height/2
			particle.scaleX = particle.scaleY = 0.6;
			particle.start(0.50);
		}
	}
}
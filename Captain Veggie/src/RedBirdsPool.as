package
{
	import starling.display.DisplayObject;
	
	public class RedBirdsPool extends DisplayObject
	{
		private var pool:Array;
		private var counter:int;
		
		public function RedBirdsPool(type:Class, len:int)
		{
			pool = new Array();
			counter = len;
			
			var i:int = len;
			while(--i > -1)
				pool[i] = new type(Math.random() * 5, Math.random() * 1000 + 200, true, 300);
		}
		
		public function getSprite():DisplayObject
		{
			if(counter > 0)
				return pool[--counter];
			else
				throw new Error("You exhausted the pool!");
		}
		
		public function returnSprite(s:DisplayObject):void
		{
			pool[counter++] = s;
		}
		
		public function clearMe():void
		{
			for (var i:int = 0; i<pool.length;i++) {
				
				pool.splice(i,1);
			} 
		}
	}
}
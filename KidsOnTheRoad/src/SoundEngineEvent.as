﻿package {	import flash.events.Event;		/**	 *	SoundEngineEvent - Events broadcast by the SoundEngine class.	 *	 *	@langversion ActionScript 3.0	 *	@playerversion Flash 9.0	 *	 *	@author Christopher Griffith	 *	@since  20.10.2008	 */	public class SoundEngineEvent extends Event {				//--------------------------------------		// CLASS CONSTANTS		//--------------------------------------		static public const SOUND_COMPLETE:String = "soundComplete";		static public const SOUND_STOPPED:String = "soundStopped";		static public const SOUND_ERROR:String = "soundError";				protected var _name:String;				/**		 *	@constructor		 */		public function SoundEngineEvent( type:String, name:String, bubbles:Boolean=false, cancelable:Boolean=false ){			_name = name;			super(type, bubbles, cancelable);		}				//--------------------------------------		//  PUBLIC METHODS		//--------------------------------------		override public function clone() : Event {			return new SoundEngineEvent(type, name, bubbles, cancelable);		}				/**		 * Returns the name of the sound object to which the event corresponds.		 */		public function get name():String {			return _name;		}					}	}
/**
 * Created with IntelliJ IDEA.
 * User: 22BoX
 * Date: 7/25/13
 * Time: 11:05 AM
 * To change this template use File | Settings | File Templates.
 */
package utils {

import flash.filesystem.File;
import flash.filesystem.FileStream;
import flash.events.IOErrorEvent;
import flash.filesystem.FileMode;
import flash.events.ProgressEvent;
import flash.events.OutputProgressEvent;
import flash.utils.ByteArray;

public class WriteTheFile {

    private static var instance:WriteTheFile = new WriteTheFile();

    private var _theFIle:File;
    private var stream:FileStream;

    public var worldsRoomsXML:XML;

    public var loadedCurrentRoom:XML;

    public function WriteTheFile() {

        if ( instance ) throw Error("Library Class is Singleton.");

    }

    public static function getInstance():WriteTheFile {
        return instance;
    }


    //************************************************** INIT THE WORLDS ROOMS ***********************************************

    public function initTheWorlds():void {

        _theFIle = File.documentsDirectory.resolvePath("worldsRooms.xml");

        stream = new FileStream();
        stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
        stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
        stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

        if(_theFIle.exists) {
            stream.open(_theFIle, FileMode.READ);
            worldsRoomsXML = new XML(stream.readUTFBytes(stream.bytesAvailable));
        }

        else {

            var xml:XML = <xml>
                <world lock="false" levelCompleted="0">
                    <room icon="ITEM_DEFAULT"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                </world>
                <world lock="true" levelCompleted="0">
                    <room icon="ITEM_DEFAULT"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                </world>
                <world lock="true" levelCompleted="0">
                    <room icon="ITEM_DEFAULT"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                    <room icon="ITEM_DEFAULT_LOCKED"></room>
                </world>
            </xml>;

            stream.openAsync(_theFIle, FileMode.UPDATE);
            stream.writeUTFBytes(xml);

            worldsRoomsXML = new XML(xml);
        }

        stream.close();
        stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
        stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);
    }

    //************************************************** WRITE FILE ***********************************************

    private function onProgress(Event:ProgressEvent):void {
        trace("onProgress");
    }

    private function onProgressComplete(Event:OutputProgressEvent):void {

        trace("onProgressComplete");
    }

    private function onIOError(evt:IOErrorEvent):void
    {
        trace(evt);
    }

    public function writeXML(theTempFile:String, theString:String):void {

        _theFIle = File.documentsDirectory.resolvePath(theTempFile);

        stream = new FileStream();
        stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
        stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
        stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

        stream.openAsync(_theFIle, FileMode.WRITE);
        stream.writeUTFBytes(theString);

        stream.close();
        stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
        stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);

    }

    public function deleteSession(id:uint):void {

        const path:String = worldsRoomsXML.session[id].@dir;

        _theFIle = File.documentsDirectory.resolvePath(path);
        _theFIle.deleteDirectory(true);

        delete worldsRoomsXML.session[id];

        writeXML("worldsRooms.xml", worldsRoomsXML);
    }

    //************************************************** WRITE DIR ***********************************************



    //************************************************** READ FILE ***********************************************

    public function loadSceneXML(theSceneFile:String):void {

        _theFIle = File.applicationDirectory.resolvePath(theSceneFile);

        stream = new FileStream();
        stream.addEventListener(IOErrorEvent.IO_ERROR, onIOError, false, 0, true);
        stream.addEventListener(ProgressEvent.PROGRESS, onProgress, false, 0, true);
        stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete, false, 0, true);

        if(_theFIle.exists) {
            stream.open(_theFIle, FileMode.READ);
            loadedCurrentRoom = new XML(stream.readUTFBytes(stream.bytesAvailable));
        }

        stream.close();
        stream.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
        stream.removeEventListener(ProgressEvent.PROGRESS, onProgress);
        stream.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, onProgressComplete);
    }
}
}

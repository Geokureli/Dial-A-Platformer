package ui;

import openfl.events.Event;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

class UIWrapper {
    
    public var enabled(default, set):Bool;
    function set_enabled(value:Bool):Bool { return enabled = value; }
    
    public var saveValue(get, never):Dynamic;
    function get_saveValue():Dynamic { return null; }
    
    public function new () {}
    
    public function addChangeListener(listener:Event->Void) { }
    
    public function removeChangeListener(listener:Event->Void) { }
    
    public function setSavedValue(value:Dynamic):Void { }
    
    @:generic
    inline function get<T:DisplayObject>(parent:DisplayObjectContainer, path:String, defaultValue:T = null):T {
        
        return aGet(parent, path.split("."), defaultValue);
    }
    
    @:generic
    inline function aGet<T:DisplayObject>(parent:DisplayObjectContainer, path:Array<String>, defaultValue:T = null):T {
        
        var child = null;
        var logName = path.join(".");
        while (path.length > 0 && parent != null) {
            
            child = parent.getChildByName(path.shift());
            parent = null;
            if (Std.is(child, DisplayObjectContainer))
                parent = cast child;
        }
        
        if (path.length == 0)
            return cast child;
        
        return defaultValue;
    }
}

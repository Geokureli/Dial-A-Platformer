package utils;

import flixel.FlxG;

class Save {
    
    inline static var LOG = true;
    
    inline static function init():Void {
        
        if (FlxG.save.name != "day17")
            FlxG.save.bind("day17");
    }
    
    static public function get(name:String):Dynamic {
        
        init();
        
        var data = Reflect.field(FlxG.save.data, name);
        if (LOG)
            trace("get", name, data);
        return data;
    }
    
    static public function set(name:String, data:Dynamic):Bool {
        
        init();
        
        if (LOG)
            trace("set", name, data);
        
        Reflect.setField(FlxG.save.data, name, data);
        return flush();
    }
    
    static function flush():Bool {
        
        return FlxG.save.flush();
    }
}
package ui;

import openfl.events.Event;
import flixel.FlxG;
import openfl.events.MouseEvent;
import openfl.display.MovieClip;

class CheckBoxWrapper extends UIWrapper {
    
    public var value(default, set) = false;
    
    var _target:MovieClip;
    var _check:MovieClip;
    var _down = false;
    var _over = false;
    var _defaultValue = false;
    
    public function new (target:MovieClip, defaultValue:Bool) {
        super();
        
        _target = target;
        _target.gotoAndStop("up");
        _check = get(_target, 'check');
        value = _defaultValue = defaultValue;
        
        _target.addEventListener(MouseEvent.MOUSE_OVER, onMouseChange);
        _target.addEventListener(MouseEvent.MOUSE_OUT , onMouseChange);
        _target.addEventListener(MouseEvent.MOUSE_DOWN, onMouseChange);
        FlxG.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseChange);
        
        _target.addEventListener(MouseEvent.CLICK, onClick);
    }
    
    override public function addChangeListener(listener:Event->Void) {
        
        _target.addEventListener(Event.CHANGE, listener);
    }
    
    override public function removeChangeListener(listener:Event->Void) {
        
        _target.removeEventListener(Event.CHANGE, listener);
    }
    
    function onClick(e:MouseEvent):Void {
        
        value = !value;
        _target.dispatchEvent(new Event(Event.CHANGE));
    }
    
    function onMouseChange(e:MouseEvent):Void {
        
        if (e.type == MouseEvent.MOUSE_UP)
            _down = false;
        else if (e.type == MouseEvent.MOUSE_DOWN)
            _down = true;
        else
            _over = e.type == MouseEvent.MOUSE_OVER;
        
        _target.gotoAndStop(_over ? (_down ? "down" : "over") : "up");
    }
    
    function set_value(v:Bool):Bool { return value = _check.visible = v; }
    
    override function get_saveValue():Dynamic {
        
        if (value != _defaultValue)
            return value;
        
        return null;
    }
    
    override function setSavedValue(value:Dynamic) {
        
        if (value != null) {
            
            this.value = value == true;
        }
    }
}
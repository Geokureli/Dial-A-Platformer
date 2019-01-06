package ;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
// import openfl.text.TextFormat;
// import openfl.text.TextField;
import openfl.events.ProgressEvent;
import openfl.events.Event;

@:keep @:bitmap("assets/images/Play.png")
private class Play extends BitmapData {}

@:keep @:bitmap("assets/images/Loading0.png")
private class Loading0 extends BitmapData {}

@:keep @:bitmap("assets/images/Loading1.png")
private class Loading1 extends BitmapData {}

// @:keep @:font("assets/fonts/nokiafc22.ttf")
// private class Font extends openfl.text.Font {}

class Preloader extends DefaultPreloader {
    
    static inline var SCALE = 8;
    
    var _play:Bitmap;
    var _loading0:Bitmap;
    var _loading1:Bitmap;
    
    override public function new():Void { super(#if debug 1 #end); }
    
    override function onInit():Void {
        super.onInit();
        
        // addChild(_play = new TextField());
        // _play.embedFonts = true;
        // _play.defaultTextFormat = new TextFormat
        //     ( openfl.Assets.getFont("fonts/nokiafc22.ttf").fontName
            // , 12
            // , 0xFFFFFF
            //, true
            // );
        // _play.text = "PLAY";
        // _play.background = true;
        // _play.backgroundColor = stage.color;
        // _play.border = true;
        // _play.borderColor = 0xFFFFFF;
        // _play.selectable = false;
        // _play.width  = _play.textWidth  + 4;
        // _play.height = _play.textHeight + 4;
        
        addChild(_play = new Bitmap(new Play(27, 11)));
        _play.scaleX = _play.scaleY = SCALE;
        _play.smoothing = false;
        
        _play.x = (stage.stageWidth  - 27 * SCALE) / 2;
        _play.y = (stage.stageHeight - 11 * SCALE) / 2;
        _play.visible = false;
        
        addChild(_loading1 = new Bitmap(new Loading1(41, 9)));
        _loading1.scaleX = _loading1.scaleY = SCALE;
        _loading1.smoothing = false;
        _loading1.x = (stage.stageWidth  - 41 * SCALE) / 2;
        _loading1.y = (stage.stageHeight - 9  * SCALE) / 2;
        _loading1.scrollRect = new Rectangle(0, 0, 41, 9);
        
        addChild(_loading0 = new Bitmap(new Loading0(43, 11)));
        _loading0.scaleX = _loading0.scaleY = SCALE;
        _loading0.smoothing = false;
        _loading0.x = (stage.stageWidth  - 43 * SCALE) / 2;
        _loading0.y = (stage.stageHeight - 11 * SCALE) / 2;
        _loading0.scrollRect = new Rectangle(0, 0, 43, 11);
    }
    
    override function update(percent:Float):Void {
        
        // Animate load bar
        var rect = _loading1.scrollRect;
        var percent43 = Std.int(43 * percent);
        rect.width = percent43;
        _loading1.scrollRect = rect;
        
        rect = _loading0.scrollRect;
        rect.x = percent43;
        _loading0.scrollRect = rect;
        _loading0.x = _loading1.x - SCALE + percent43 * SCALE;
        
        super.update(percent);
    }
    
    override function startOutro(callback:Void->Void) {
        
        _play.visible = true;
        _loading0.visible = false;
        _loading1.visible = false;
        stage.addEventListener(MouseEvent.CLICK, (_) -> callback());
    }
    
    override function destroy():Void {
        
        removeChild(_play);
        
        super.destroy();
    }
}

private class DefaultPreloader extends openfl.display.Sprite {
    
    var _loaded:Bool;
    var _waited:Bool;
    var _loadPercent:Float;
    var _startTime:Float;
    var _waitTime:Float;
    
    public function new(minDisplayTime:Float = 0) 
    {
        _waitTime = minDisplayTime;
        _waited = false;
        _loaded = false;
        super();
        
        addEventListener
            ( Event.ADDED_TO_STAGE
            , function onAddedToStage(_) {
                
                removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
                
                onInit();
                updateByteProgess(loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
                
                addEventListener(ProgressEvent.PROGRESS, onProgress);
                addEventListener(Event.COMPLETE, onComplete);
                
                _startTime = Date.now().getTime();
                addEventListener(Event.ENTER_FRAME, onEnterFrame);
            }
        );
        
    }
    
    
    
    function onInit() {}
    
    @:noCompletion
    function updateByteProgess(bytesLoaded:Int, bytesTotal:Int):Void {
        
        _loadPercent = 0.0;
        if (bytesTotal > 0) {
            
            _loadPercent = bytesLoaded / bytesTotal;
            if (_loadPercent > 1)
                _loadPercent = 1;
        }
    }
    
    @:noCompletion
    function onEnterFrame(event:Event):Void {
        
        
        var time = Date.now().getTime() - _startTime;
        if (time > _waitTime * 1000.0) {
            
            time = _waitTime * 1000.0;
            if (!_waited) {
                
                _waited = true;
                checkForOutro();
            }
        }
        
        var percent = _loadPercent;
        if (_waitTime > 0)
            percent *= time / _waitTime / 1000.0;
        
        update(percent);
    }
    
    function update(percent:Float):Void { }
    
    function onProgress(event:ProgressEvent):Void {
        
        updateByteProgess(Std.int(event.bytesLoaded), Std.int(event.bytesTotal));
    }
    
    function onComplete(event:Event):Void {
        
        updateByteProgess(loaderInfo.bytesLoaded, loaderInfo.bytesTotal);
        
        event.preventDefault();
        removeEventListener(ProgressEvent.PROGRESS, onProgress);
        removeEventListener(Event.COMPLETE, onComplete);
        
        _loaded = true;
        checkForOutro();
    }
    
    function checkForOutro():Void {
        
        if (_loaded && _waited)
            startOutro(endOutro);
    }
    
    function startOutro(callback:Void->Void):Void {
        
        callback();
    }
    
    function endOutro():Void {
        
        destroy();
        dispatchEvent(new Event(Event.UNLOAD));
    }
    
    function destroy():Void {
        
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
}

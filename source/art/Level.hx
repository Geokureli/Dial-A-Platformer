package art;

import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.tile.FlxTilemap.GraphicAuto;

class Level extends EditorLevel {
    
    public function new () {
        super();
        
        _editingEnabled = true;
        
        loadMapFromCSV("assets/level.csv", "assets/images/Tiles.png", 8, 8, AUTO);
    }
    
    public function initWorld():Void {
        
        FlxG.worldBounds.set(x, y, width, height);
        FlxG.camera.minScrollX = x;
        FlxG.camera.minScrollY = y;
        FlxG.camera.maxScrollX = x + width;
        FlxG.camera.maxScrollY = y + height;
    }
}
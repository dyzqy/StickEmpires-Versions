package com.brockw.stickwar.engine.Ai.command
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.Entity;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.display.*;
      
      public class NukeCommand extends UnitCommand
      {
            
            public static const actualButtonBitmap:Bitmap = new Bitmap(new MagikillFireballs());
             
            
            private var nukeArea:Number;
            
            private var nukeRange:Number;
            
            public function NukeCommand(game:StickWar)
            {
                  super();
                  this.game = game;
                  type = UnitCommand.NUKE;
                  hotKey = 81;
                  _hasCoolDown = true;
                  _intendedEntityType = Unit.U_MAGIKILL;
                  requiresMouseInput = true;
                  isSingleSpell = true;
                  buttonBitmap = actualButtonBitmap;
                  cursor = new nukeCursor();
                  if(game != null)
                  {
                        this.loadXML(game.xml.xml.Order.Units.magikill.nuke);
                        this.nukeArea = game.xml.xml.Order.Units.magikill.nuke.area;
                        this.nukeRange = game.xml.xml.Order.Units.magikill.nuke.range;
                  }
            }
            
            override public function cleanUpPreClick(canvas:Sprite) : void
            {
                  super.cleanUpPreClick(canvas);
                  if(canvas.contains(cursor))
                  {
                        canvas.removeChild(cursor);
                  }
            }
            
            override public function drawCursorPreClick(canvas:Sprite, gameScreen:GameScreen) : Boolean
            {
                  while(canvas.numChildren != 0)
                  {
                        canvas.removeChildAt(0);
                  }
                  canvas.addChild(cursor);
                  cursor.x = gameScreen.game.battlefield.mouseX;
                  cursor.y = gameScreen.game.battlefield.mouseY;
                  cursor.width = this.nukeArea;
                  cursor.height = 0.7 * this.nukeArea * gameScreen.game.getPerspectiveScale(gameScreen.game.battlefield.mouseY);
                  if(cursor.y + cursor.height < 0)
                  {
                        cursor.alpha = 1 - Math.abs(cursor.y) / 200;
                  }
                  else
                  {
                        cursor.alpha = 1;
                  }
                  cursor.gotoAndStop(1);
                  this.drawRangeIndicators(canvas,this.nukeRange,true,gameScreen);
                  return true;
            }
            
            override public function drawCursorPostClick(canvas:Sprite, game:GameScreen) : Boolean
            {
                  super.drawCursorPostClick(canvas,game);
                  return true;
            }
            
            override public function coolDownTime(entity:Entity) : Number
            {
                  return Magikill(entity).nukeCooldown();
            }
            
            override public function isFinished(unit:Unit) : Boolean
            {
                  return Magikill(unit).nukeCooldown() == 0;
            }
            
            override public function inRange(entity:Entity) : Boolean
            {
                  return Math.pow(realX - entity.px,2) + Math.pow(realY - entity.py,2) < Math.pow(this.nukeRange,2);
            }
      }
}

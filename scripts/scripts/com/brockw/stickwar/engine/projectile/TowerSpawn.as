package com.brockw.stickwar.engine.projectile
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.*;
      import flash.display.*;
      
      public class TowerSpawn extends Projectile
      {
             
            
            internal var spellMc:MovieClip;
            
            public function TowerSpawn(game:StickWar)
            {
                  super();
                  type = TOWER_SPAWN;
                  this.spellMc = new spawnTowerMc();
                  this.addChild(this.spellMc);
            }
            
            override public function cleanUp() : void
            {
                  super.cleanUp();
                  removeChild(this.spellMc);
                  this.spellMc = null;
            }
            
            override public function update(game:StickWar) : void
            {
                  Util.animateMovieClip(this.spellMc,4);
                  this.scaleX = 1 * team.direction;
                  this.scaleY = 1;
            }
            
            override public function isReadyForCleanup() : Boolean
            {
                  return this.spellMc.mc.currentFrame == this.spellMc.mc.totalFrames;
            }
            
            override public function isInFlight() : Boolean
            {
                  return this.spellMc.mc.currentFrame != this.spellMc.mc.totalFrames;
            }
      }
}

package com.brockw.stickwar.engine
{
      import flash.display.*;
      import flash.geom.ColorTransform;
      
      public class FogOfWar extends Entity
      {
            
            private static const TARGET_ALPHA:Number = 0.7;
             
            
            private var X_SIZE:Number = 100;
            
            private var Y_SIZE:Number = 700;
            
            private var VISION_LENGTH:int;
            
            private var oldForwardPosition:Number;
            
            private var movingFog:Array;
            
            internal var fog:_fog;
            
            internal var fogBlur:_fogFade;
            
            internal var xPos:Number;
            
            public var isFogOn:Boolean;
            
            private var blockMc:MovieClip;
            
            public function FogOfWar(game:StickWar)
            {
                  super();
                  this.xPos = 0;
                  this.isFogOn = true;
                  this.fog = new _fog();
                  this.fog.y = 0;
                  this.setTint(this.fog,0,0.9);
                  this.fog.alpha = TARGET_ALPHA;
                  addChild(this.fog);
                  this.VISION_LENGTH = game.xml.xml.visionSize;
                  this.fog.cacheAsBitmap = true;
            }
            
            internal function setTint(displayObject:DisplayObject, tintColor:uint, tintMultiplier:Number) : void
            {
                  var colTransform:ColorTransform = new ColorTransform();
                  colTransform.redMultiplier = colTransform.greenMultiplier = colTransform.blueMultiplier = 1 - tintMultiplier;
                  colTransform.redOffset = Math.round(((tintColor & 16711680) >> 16) * tintMultiplier);
                  colTransform.greenOffset = Math.round(((tintColor & 65280) >> 8) * tintMultiplier);
                  colTransform.blueOffset = Math.round((tintColor & 255) * tintMultiplier);
                  displayObject.transform.colorTransform = colTransform;
            }
            
            public function update(game:StickWar) : void
            {
                  if(game.team == game.teamB)
                  {
                        this.fog.scaleX = -1;
                  }
                  else
                  {
                        this.fog.scaleX = 1;
                  }
                  var forwardPosition:* = game.team.getVisionRange();
                  if(!this.isFogOn)
                  {
                        forwardPosition = game.team.enemyTeam.homeX + game.team.direction * 1000;
                  }
                  if(this.xPos == 0)
                  {
                        this.xPos = forwardPosition;
                  }
                  this.xPos += (forwardPosition - this.xPos) * 1;
                  if(game.team.direction == 1)
                  {
                        this.fog.x = Math.max(this.xPos,game.screenX);
                  }
                  else
                  {
                        this.fog.x = Math.min(this.xPos,game.screenX + game.map.screenWidth);
                  }
            }
      }
}

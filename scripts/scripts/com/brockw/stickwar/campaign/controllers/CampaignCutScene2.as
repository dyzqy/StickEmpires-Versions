package com.brockw.stickwar.campaign.controllers
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.InGameMessage;
      import com.brockw.stickwar.engine.Ai.command.MoveCommand;
      import com.brockw.stickwar.engine.units.Medusa;
      import com.brockw.stickwar.engine.units.Statue;
      import com.brockw.stickwar.engine.units.Unit;
      
      public class CampaignCutScene2 extends CampaignController
      {
            
            private static const S_BEFORE_CUTSCENE:int = -1;
            
            private static const S_ENTER_MEDUSA:int = 0;
            
            private static const S_MEDUSA_YOU_MUST_ALL_DIE:int = 1;
            
            private static const S_SCROLLING_STONE:int = 2;
            
            private static const S_DONE:int = 3;
             
            
            private var state:int;
            
            private var counter:int = 0;
            
            private var message:InGameMessage;
            
            private var scrollingStoneX:Number;
            
            private var gameScreen:GameScreen;
            
            public function CampaignCutScene2(gameScreen:GameScreen)
            {
                  super(gameScreen);
                  this.gameScreen = gameScreen;
                  this.state = S_BEFORE_CUTSCENE;
                  this.counter = 0;
            }
            
            override public function update(gameScreen:GameScreen) : void
            {
                  var u1:Unit = null;
                  var m:MoveCommand = null;
                  var freezePoint:Number = NaN;
                  if(Boolean(this.message))
                  {
                        this.message.update();
                  }
                  gameScreen.team.enemyTeam.statue.health = 100;
                  if(this.state == S_BEFORE_CUTSCENE)
                  {
                        if(gameScreen.team.enemyTeam.statue.health < 750)
                        {
                              gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                              gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                              gameScreen.userInterface.isSlowCamera = true;
                              u1 = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
                              gameScreen.team.enemyTeam.spawn(u1,gameScreen.game);
                              Medusa(u1).enableSuperMedusa();
                              u1.pz = 0;
                              u1.y = gameScreen.game.map.height / 2;
                              u1.px = gameScreen.team.enemyTeam.homeX;
                              u1.x = u1.px;
                              m = new MoveCommand(gameScreen.game);
                              m.realX = m.goalX = u1.px - 200;
                              m.realY = m.goalY = u1.py;
                              u1.ai.setCommand(gameScreen.game,m);
                              this.state = S_ENTER_MEDUSA;
                              this.counter = 0;
                        }
                  }
                  else if(this.state == S_ENTER_MEDUSA)
                  {
                        gameScreen.game.fogOfWar.isFogOn = false;
                        gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        if(this.counter++ > 90)
                        {
                              this.state = S_MEDUSA_YOU_MUST_ALL_DIE;
                              this.counter = 0;
                              gameScreen.game.soundManager.playSoundFullVolume("youMustAllDie");
                        }
                  }
                  else if(this.state == S_MEDUSA_YOU_MUST_ALL_DIE)
                  {
                        gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        if(this.counter++ > 150)
                        {
                              this.state = S_SCROLLING_STONE;
                              this.scrollingStoneX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        }
                  }
                  else if(this.state == S_SCROLLING_STONE)
                  {
                        gameScreen.game.targetScreenX = this.scrollingStoneX;
                        this.scrollingStoneX -= 15;
                        freezePoint = gameScreen.game.screenX + gameScreen.game.map.screenWidth / 2;
                        gameScreen.game.spatialHash.mapInArea(freezePoint - 100,0,freezePoint + 100,gameScreen.game.map.height,this.freezeUnit);
                        if(freezePoint < gameScreen.team.homeX)
                        {
                              this.state = S_DONE;
                        }
                  }
                  super.update(gameScreen);
            }
            
            private function freezeUnit(u:Unit) : void
            {
                  if(u.team == this.gameScreen.team && !(u is Statue))
                  {
                        u.stoneAttack(10000);
                  }
            }
      }
}

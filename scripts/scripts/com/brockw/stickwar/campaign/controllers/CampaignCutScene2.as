package com.brockw.stickwar.campaign.controllers
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.campaign.InGameMessage;
      import com.brockw.stickwar.engine.Ai.command.StandCommand;
      import com.brockw.stickwar.engine.units.Bomber;
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
            
            private var medusa:Unit;
            
            private var spawnNumber:int;
            
            public function CampaignCutScene2(gameScreen:GameScreen)
            {
                  super(gameScreen);
                  this.gameScreen = gameScreen;
                  this.state = S_BEFORE_CUTSCENE;
                  this.counter = 0;
                  this.medusa = null;
                  this.spawnNumber = 0;
            }
            
            override public function update(gameScreen:GameScreen) : void
            {
                  var u1:Unit = null;
                  var m:StandCommand = null;
                  var freezePoint:Number = NaN;
                  var spawn:Array = null;
                  var numToSpawn:int = 0;
                  var i:int = 0;
                  if(Boolean(this.message))
                  {
                        this.message.update();
                  }
                  if(this.state != S_BEFORE_CUTSCENE)
                  {
                        gameScreen.team.enemyTeam.statue.health = 750;
                        gameScreen.team.enemyTeam.gold = 0;
                        gameScreen.team.enemyTeam.mana = 200;
                  }
                  if(this.state == S_BEFORE_CUTSCENE)
                  {
                        if(gameScreen.team.enemyTeam.statue.health < 750)
                        {
                              gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                              gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                              gameScreen.userInterface.isSlowCamera = true;
                              u1 = Medusa(gameScreen.game.unitFactory.getUnit(Unit.U_MEDUSA));
                              this.medusa = u1;
                              gameScreen.team.enemyTeam.spawn(u1,gameScreen.game);
                              Medusa(u1).enableSuperMedusa();
                              u1.pz = 0;
                              u1.y = gameScreen.game.map.height / 2;
                              u1.px = gameScreen.team.enemyTeam.homeX - 200;
                              u1.x = u1.px;
                              m = new StandCommand(gameScreen.game);
                              u1.ai.setCommand(gameScreen.game,m);
                              this.state = S_ENTER_MEDUSA;
                              this.counter = 0;
                        }
                  }
                  else if(this.state == S_ENTER_MEDUSA)
                  {
                        m = new StandCommand(gameScreen.game);
                        this.medusa.ai.setCommand(gameScreen.game,m);
                        gameScreen.game.fogOfWar.isFogOn = false;
                        gameScreen.game.targetScreenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        gameScreen.game.screenX = gameScreen.game.team.enemyTeam.statue.x - 325;
                        if(this.counter++ > 20)
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
                        if(this.counter == 75)
                        {
                              Medusa(this.medusa).stone(null);
                        }
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
                              spawn = [];
                              spawn.push(Unit.U_MINER);
                              spawn.push(Unit.U_MINER);
                              spawn.push(Unit.U_MINER);
                              spawn.push(Unit.U_MINER);
                              spawn.push(Unit.U_SPEARTON);
                              spawn.push(Unit.U_SPEARTON);
                              spawn.push(Unit.U_SPEARTON);
                              spawn.push(Unit.U_SPEARTON);
                              spawn.push(Unit.U_SPEARTON);
                              spawn.push(Unit.U_SPEARTON);
                              spawn.push(Unit.U_MAGIKILL);
                              spawn.push(Unit.U_MONK);
                              spawn.push(Unit.U_MONK);
                              spawn.push(Unit.U_MONK);
                              spawn.push(Unit.U_ENSLAVED_GIANT);
                              gameScreen.team.spawnUnitGroup(spawn);
                              gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                              gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                              gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                              gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                              gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                              gameScreen.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                        }
                  }
                  if(this.state == S_DONE)
                  {
                        if(!this.medusa.isAlive())
                        {
                              gameScreen.team.enemyTeam.statue.health = 0;
                        }
                        else if(gameScreen.game.frame % (30 * 10) == 0 && gameScreen.game.team.enemyTeam.attackingForcePopulation < 20)
                        {
                              numToSpawn = Math.min(this.spawnNumber / 2,4);
                              for(i = 0; i < numToSpawn; i++)
                              {
                                    u1 = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                                    gameScreen.team.enemyTeam.spawn(u1,gameScreen.game);
                                    u1.px = this.medusa.px + 75;
                                    u1.py = this.medusa.py - 50 + 100 * (i / numToSpawn);
                                    u1.ai.setCommand(gameScreen.game,new StandCommand(gameScreen.game));
                                    gameScreen.team.enemyTeam.population += 1;
                                    gameScreen.game.projectileManager.initTowerSpawn(this.medusa.px + 75,this.medusa.py,gameScreen.game.team.enemyTeam,0.6);
                              }
                              ++this.spawnNumber;
                        }
                  }
                  gameScreen.game.team.enemyTeam.attack(true);
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

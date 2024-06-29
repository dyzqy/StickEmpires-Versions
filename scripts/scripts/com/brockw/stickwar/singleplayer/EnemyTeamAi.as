package com.brockw.stickwar.singleplayer
{
      import com.brockw.stickwar.BaseMain;
      import com.brockw.stickwar.engine.*;
      import com.brockw.stickwar.engine.Ai.*;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.Team.Team;
      import com.brockw.stickwar.engine.multiplayer.moves.*;
      import com.brockw.stickwar.engine.units.*;
      import flash.utils.Dictionary;
      
      public class EnemyTeamAi
      {
             
            
            protected var isAttacking:Boolean;
            
            protected var team:Team;
            
            protected var unitComposition:Dictionary;
            
            private var mines:Array;
            
            private var isCreatingUnits:Boolean;
            
            public function EnemyTeamAi(team:Team, main:BaseMain, game:StickWar, isCreatingUnits:* = true)
            {
                  super();
                  this.team = team;
                  this.isCreatingUnits = isCreatingUnits;
                  this.isAttacking = false;
            }
            
            public function update(game:StickWar) : void
            {
                  this.team.calculateStatistics();
                  this.team.enemyTeam.calculateStatistics();
                  this.updateMiners(game);
                  this.rebalanceMiners(game);
                  this.updateGlobalStrategy(game);
                  if(this.isCreatingUnits)
                  {
                        this.updateUnitCreation(game);
                  }
                  this.updateSpellCasters(game);
            }
            
            protected function updateMiners(game:StickWar) : void
            {
                  var miner:Miner = null;
                  var i:int = 0;
                  for each(miner in this.team.unitGroups[this.team.getMinerType()])
                  {
                        this.updateMiner(miner,game,i++);
                  }
            }
            
            protected function rebalanceMiners(game:StickWar) : void
            {
                  var miner:Miner = null;
                  var theoreticalMinersOnStatue:int = 0;
                  var minersOnGold:Array = [];
                  var minersOnStatue:Array = [];
                  var i:int = 0;
                  for each(miner in this.team.unitGroups[this.team.getMinerType()])
                  {
                        if(MinerAi(miner.ai).targetOre is Statue)
                        {
                              minersOnStatue.push(miner);
                        }
                        else if(MinerAi(miner.ai).targetOre != null)
                        {
                              minersOnGold.push(miner);
                        }
                  }
                  theoreticalMinersOnStatue = Math.floor((minersOnStatue.length + minersOnGold.length) / 3);
                  if(minersOnStatue.length + minersOnGold.length > 0)
                  {
                        if(minersOnStatue.length < theoreticalMinersOnStatue)
                        {
                              miner = minersOnGold[0];
                              MinerAi(miner.ai).targetOre.releaseMiningSpot(miner);
                              miner.team.statue.getMiningSpot(miner);
                              MinerAi(miner.ai).targetOre = miner.team.statue;
                        }
                        else if(minersOnStatue.length > theoreticalMinersOnStatue)
                        {
                              miner = minersOnStatue[0];
                              MinerAi(miner.ai).targetOre.releaseMiningSpot(miner);
                              this.iterateOverFreeMines(miner,game);
                        }
                  }
            }
            
            protected function updateMiner(miner:Miner, game:StickWar, index:int) : void
            {
                  var target:Unit = null;
                  var m:UnitMove = null;
                  if(MinerAi(miner.ai).targetOre == null || MinerAi(miner.ai).targetOre && !MinerAi(miner.ai).targetOre.hasMiningSpot(miner))
                  {
                        target = MinerAi(miner.ai).getClosestTarget();
                        if(target != null && miner.team.direction * target.px < miner.team.direction * (miner.px - miner.team.direction * 100))
                        {
                              m = new UnitMove();
                              m.moveType = UnitCommand.ATTACK_MOVE;
                              m.units.push(miner.id);
                              m.owner = this.team.id;
                              m.arg0 = target.px;
                              m.arg1 = target.py;
                              m.execute(this.team.game);
                        }
                        else
                        {
                              this.iterateOverFreeMines(miner,game);
                        }
                  }
            }
            
            protected function iterateOverFreeMines(miner:Miner, game:StickWar) : void
            {
                  var i:int = 0;
                  var gold:Ore = null;
                  if(this.team.direction == 1)
                  {
                        for(i = 0; i < game.map.gold.length; i++)
                        {
                              gold = game.map.gold[i];
                              if(this.getFreeMine(miner,game,gold))
                              {
                                    break;
                              }
                        }
                  }
                  else
                  {
                        for(i = game.map.gold.length - 1; i >= 0; i--)
                        {
                              gold = game.map.gold[i];
                              if(this.getFreeMine(miner,game,gold))
                              {
                                    break;
                              }
                        }
                  }
            }
            
            protected function getFreeMine(miner:Miner, game:StickWar, gold:Ore) : Boolean
            {
                  if(!gold.isMineFull())
                  {
                        gold.getMiningSpot(miner);
                        MinerAi(miner.ai).targetOre = gold;
                        return true;
                  }
                  return false;
            }
            
            protected function attackMoveGroupTo(x:Number) : void
            {
                  var unit:String = null;
                  var u:Unit = null;
                  var m:UnitMove = null;
                  this.isAttacking = true;
                  var attackMoveUnits:* = new UnitMove();
                  attackMoveUnits.moveType = UnitCommand.ATTACK_MOVE;
                  var moveUnits:* = new UnitMove();
                  moveUnits.moveType = UnitCommand.MOVE;
                  for(unit in this.team.units)
                  {
                        u = this.team.units[unit];
                        if((u.type == Unit.U_MINER || u.type == Unit.U_CHAOS_MINER) && MinerAi(u.ai).targetOre != null)
                        {
                              m = new UnitMove();
                              m.moveType = UnitCommand.MOVE;
                              m.units.push(u.id);
                              m.owner = this.team.id;
                              m.arg4 = MinerAi(u.ai).targetOre.id;
                              m.arg0 = MinerAi(u.ai).targetOre.x;
                              m.arg1 = MinerAi(u.ai).targetOre.y;
                              m.execute(this.team.game);
                        }
                        else if(u.isRejoiningFormation && this.team.direction * x <= this.team.direction * u.px)
                        {
                              moveUnits.units.push(u.id);
                              if(Math.abs(u.px - x) < 50)
                              {
                                    u.isRejoiningFormation = false;
                              }
                        }
                        else
                        {
                              attackMoveUnits.units.push(u.id);
                              if(Math.abs(u.px - x) > 1000)
                              {
                                    u.isRejoiningFormation = true;
                              }
                        }
                  }
                  attackMoveUnits.owner = this.team.id;
                  attackMoveUnits.arg0 = x;
                  attackMoveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
                  attackMoveUnits.execute(this.team.game);
                  moveUnits.owner = this.team.id;
                  moveUnits.arg0 = x;
                  moveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
                  moveUnits.execute(this.team.game);
            }
            
            protected function garrisonGroup() : void
            {
                  var unit:String = null;
                  this.isAttacking = false;
                  var u:UnitMove = new UnitMove();
                  u.moveType = UnitCommand.GARRISON;
                  for(unit in this.team.units)
                  {
                        u.units.push(this.team.units[unit].id);
                  }
                  u.owner = this.team.id;
                  u.arg0 = 0;
                  u.arg1 = this.team.game.map.height / 2;
                  u.execute(this.team.game);
            }
            
            protected function defendGroup() : void
            {
                  var unit:String = null;
                  var u:Unit = null;
                  var m:UnitMove = null;
                  this.isAttacking = false;
                  var attackMoveUnits:* = new UnitMove();
                  attackMoveUnits.moveType = UnitCommand.ATTACK_MOVE;
                  var moveUnits:* = new UnitMove();
                  moveUnits.moveType = UnitCommand.MOVE;
                  for(unit in this.team.units)
                  {
                        u = this.team.units[unit];
                        if((u.type == Unit.U_MINER || u.type == Unit.U_CHAOS_MINER) && MinerAi(u.ai).targetOre != null)
                        {
                              m = new UnitMove();
                              m.moveType = UnitCommand.MOVE;
                              m.units.push(u.id);
                              m.owner = this.team.id;
                              m.arg0 = MinerAi(u.ai).targetOre.x;
                              m.arg1 = MinerAi(u.ai).targetOre.y;
                              m.arg4 = MinerAi(u.ai).targetOre.id;
                              m.execute(this.team.game);
                        }
                        else if(!u.isHome)
                        {
                              moveUnits.units.push(u.id);
                        }
                        else
                        {
                              attackMoveUnits.units.push(u.id);
                        }
                  }
                  moveUnits.owner = this.team.id;
                  moveUnits.arg0 = this.team.homeX + this.team.direction * 600;
                  moveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
                  attackMoveUnits.owner = this.team.id;
                  attackMoveUnits.arg0 = this.team.homeX + this.team.direction * 600;
                  attackMoveUnits.arg1 = this.team.game.gameScreen.game.map.height / 2;
                  attackMoveUnits.execute(this.team.game);
                  moveUnits.execute(this.team.game);
            }
            
            protected function updateGlobalStrategy(game:StickWar) : void
            {
                  var movePos:Number = NaN;
                  if(this.enemyIsWeak())
                  {
                        this.attackMoveGroupTo(this.team.medianPosition + this.team.direction * 250);
                  }
                  else if(this.enemyIsEvenStrength() || Unit.U_GIANT in this.team.unitGroups)
                  {
                        movePos = this.team.medianPosition + this.team.direction * 250;
                        if(this.team.direction * movePos > this.team.direction * this.team.game.map.width / 2)
                        {
                              movePos = this.team.game.map.width / 2;
                        }
                        this.attackMoveGroupTo(movePos);
                  }
                  else if(this.enemyIsAttacking())
                  {
                        this.defendGroup();
                  }
                  else if(this.enemyAtMiddle())
                  {
                        this.defendGroup();
                  }
                  else
                  {
                        this.attackMoveGroupTo(this.team.game.map.width / 2);
                  }
            }
            
            protected function updateUnitCreation(game:StickWar) : void
            {
            }
            
            protected function updateSpellCasters(game:StickWar) : void
            {
            }
            
            protected function enemyIsWeak() : Boolean
            {
                  var addOnTheArchers:int = this.team.enemyTeam.castleDefence.units.length * 4 + this.team.enemyTeam.attackingForcePopulation;
                  return addOnTheArchers < this.team.attackingForcePopulation;
            }
            
            protected function enemyIsEvenStrength() : Boolean
            {
                  if(this.team.population == 0)
                  {
                        return false;
                  }
                  return Math.abs(this.team.enemyTeam.attackingForcePopulation - this.team.attackingForcePopulation) / this.team.attackingForcePopulation < 0.1;
            }
            
            protected function agressionMetric() : Number
            {
                  var m:Number = this.team.enemyTeam.medianPosition / this.team.game.map.width;
                  if(this.team.direction == 1)
                  {
                        m = (this.team.game.map.width - this.team.enemyTeam.medianPosition) / this.team.game.map.width;
                  }
                  return m;
            }
            
            protected function enemyAtHome() : Boolean
            {
                  return this.agressionMetric() < 0.4;
            }
            
            protected function enemyAtMiddle() : Boolean
            {
                  return this.agressionMetric() > 0.4 && this.agressionMetric() < 0.6;
            }
            
            protected function enemyIsAttacking() : Boolean
            {
                  return this.agressionMetric() >= 0.6;
            }
      }
}

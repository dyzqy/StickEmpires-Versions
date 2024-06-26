package com.brockw.stickwar.engine.units
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.ActionInterface;
      import com.brockw.stickwar.engine.Ai.SwordwrathAi;
      import com.brockw.stickwar.engine.Ai.command.*;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.Team.Tech;
      import com.brockw.stickwar.market.*;
      import flash.display.MovieClip;
      import flash.filters.GlowFilter;
      
      public class Swordwrath extends Unit
      {
            
            private static var WEAPON_REACH:int;
            
            private static var RAGE_COOLDOWN:int;
            
            private static var RAGE_EFFECT:int;
             
            
            private var healthLoss:int;
            
            private var damageIncrease:Number;
            
            private var rageSpell:SpellCooldown;
            
            private var rageSpellGlow:GlowFilter;
            
            private var normalMaxVelocity:Number;
            
            private var rageMaxVelocity:Number;
            
            public function Swordwrath(game:StickWar)
            {
                  super(game);
                  _mc = new _swordwrath();
                  this.init(game);
                  addChild(_mc);
                  ai = new SwordwrathAi(this);
                  initSync();
                  firstInit();
                  this.rageSpellGlow = new GlowFilter();
                  this.rageSpellGlow.color = 16711680;
                  this.rageSpellGlow.blurX = 10;
                  this.rageSpellGlow.blurY = 10;
            }
            
            public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
            {
                  var m:_swordwrath = _swordwrath(mc);
                  if(Boolean(m.mc.sword))
                  {
                        if(weapon != "")
                        {
                              m.mc.sword.gotoAndStop(weapon);
                        }
                  }
            }
            
            override public function init(game:StickWar) : void
            {
                  initBase();
                  WEAPON_REACH = game.xml.xml.Order.Units.swordwrath.weaponReach;
                  population = game.xml.xml.Order.Units.swordwrath.population;
                  RAGE_COOLDOWN = game.xml.xml.Order.Units.swordwrath.rage.cooldown;
                  RAGE_EFFECT = game.xml.xml.Order.Units.swordwrath.rage.effect;
                  this.healthLoss = game.xml.xml.Order.Units.swordwrath.rage.healthLoss;
                  this.damageIncrease = game.xml.xml.Order.Units.swordwrath.rage.damageIncrease;
                  _mass = game.xml.xml.Order.Units.swordwrath.mass;
                  _maxForce = game.xml.xml.Order.Units.swordwrath.maxForce;
                  _dragForce = game.xml.xml.Order.Units.swordwrath.dragForce;
                  _scale = game.xml.xml.Order.Units.swordwrath.scale;
                  _maxVelocity = game.xml.xml.Order.Units.swordwrath.maxVelocity;
                  damageToDeal = game.xml.xml.Order.Units.swordwrath.baseDamage;
                  this.createTime = game.xml.xml.Order.Units.swordwrath.cooldown;
                  maxHealth = health = game.xml.xml.Order.Units.swordwrath.health;
                  loadDamage(game.xml.xml.Order.Units.swordwrath);
                  type = Unit.U_SWORDWRATH;
                  this.normalMaxVelocity = _maxVelocity;
                  this.rageMaxVelocity = game.xml.xml.Order.Units.swordwrath.rage.rageMaxVelocity;
                  this.rageSpell = new SpellCooldown(RAGE_EFFECT,RAGE_COOLDOWN,game.xml.xml.Order.Units.swordwrath.rage.mana);
                  _mc.stop();
                  _mc.width *= _scale;
                  _mc.height *= _scale;
                  _state = S_RUN;
                  MovieClip(_mc.mc.gotoAndPlay(1));
                  MovieClip(_mc.gotoAndStop(1));
                  drawShadow();
            }
            
            override public function setBuilding() : void
            {
                  building = team.buildings["BarracksBuilding"];
            }
            
            override public function getDamageToDeal() : Number
            {
                  if(this.rageSpell.inEffect())
                  {
                        return 2 * damageToDeal;
                  }
                  return damageToDeal;
            }
            
            override public function update(game:StickWar) : void
            {
                  this.rageSpell.update();
                  updateCommon(game);
                  if(this.rageSpell.inEffect())
                  {
                        this.rageSpellGlow.blurX = 9 + 6 * Util.sin(20 * Math.PI * this.rageSpell.timeRunning() / RAGE_EFFECT);
                        this.rageSpellGlow.blurY = 10;
                        this.mc.filters = [this.rageSpellGlow];
                        _maxVelocity = this.rageMaxVelocity;
                  }
                  else
                  {
                        this.mc.filters = [];
                        _maxVelocity = this.normalMaxVelocity;
                  }
                  if(!isDieing)
                  {
                        if(_isDualing)
                        {
                              _mc.gotoAndStop(_currentDual.attackLabel);
                              moveDualPartner(_dualPartner,_currentDual.xDiff);
                              if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                              {
                                    _mc.gotoAndStop("run");
                                    _isDualing = false;
                                    _state = S_RUN;
                                    px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                                    dx = 0;
                                    dy = 0;
                              }
                        }
                        else if(_state == S_RUN)
                        {
                              if(isFeetMoving())
                              {
                                    _mc.gotoAndStop("run");
                              }
                              else
                              {
                                    _mc.gotoAndStop("stand");
                              }
                        }
                        else if(_state == S_ATTACK)
                        {
                              if(MovieClip(mc.mc).currentFrameLabel == "swing")
                              {
                                    team.game.soundManager.playSound("swordwrathSwing1",px,py);
                              }
                              if(!hasHit)
                              {
                                    hasHit = this.checkForHit();
                              }
                              if(this.rageSpell.inEffect())
                              {
                                    MovieClip(_mc.mc).nextFrame();
                              }
                              if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                              {
                                    _state = S_RUN;
                              }
                        }
                        updateMotion(game);
                  }
                  else if(isDead == false)
                  {
                        if(_isDualing)
                        {
                              _mc.gotoAndStop(_currentDual.defendLabel);
                              if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                              {
                                    isDualing = false;
                                    mc.filters = [];
                                    this.team.removeUnit(this,game);
                                    isDead = true;
                              }
                        }
                        else
                        {
                              _mc.gotoAndStop(getDeathLabel(game));
                              this.team.removeUnit(this,game);
                              isDead = true;
                        }
                  }
                  if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                  {
                        MovieClip(_mc.mc).gotoAndStop(1);
                  }
                  Util.animateMovieClip(_mc,0);
                  Swordwrath.setItem(_swordwrath(mc),team.loadout.getItem(this.type,MarketItem.T_WEAPON),"","");
            }
            
            override public function get damageToArmour() : Number
            {
                  if(this.rageSpell.inEffect())
                  {
                        return _damageToArmour + this.damageIncrease;
                  }
                  return _damageToArmour;
            }
            
            override public function get damageToNotArmour() : Number
            {
                  if(this.rageSpell.inEffect())
                  {
                        return _damageToNotArmour + this.damageIncrease;
                  }
                  return _damageToNotArmour;
            }
            
            override public function setActionInterface(a:ActionInterface) : void
            {
                  super.setActionInterface(a);
                  if(team.tech.isResearched(Tech.SWORDWRATH_RAGE))
                  {
                        a.setAction(0,0,UnitCommand.SWORDWRATH_RAGE);
                  }
            }
            
            public function rageCooldown() : Number
            {
                  return this.rageSpell.cooldown();
            }
            
            public function rage() : void
            {
                  if(health > 10 && team.tech.isResearched(Tech.SWORDWRATH_RAGE))
                  {
                        if(this.rageSpell.spellActivate(team))
                        {
                              health -= this.healthLoss;
                        }
                  }
            }
            
            override public function attack() : void
            {
                  var id:int = 0;
                  if(_state != S_ATTACK)
                  {
                        id = team.game.random.nextInt() % this._attackLabels.length;
                        _mc.gotoAndStop("attack_" + this._attackLabels[id]);
                        MovieClip(_mc.mc).gotoAndStop(1);
                        _state = S_ATTACK;
                        hasHit = false;
                  }
            }
            
            override public function mayAttack(target:Unit) : Boolean
            {
                  if(isIncapacitated())
                  {
                        return false;
                  }
                  if(target == null)
                  {
                        return false;
                  }
                  if(this.isDualing == true)
                  {
                        return false;
                  }
                  if(_state == S_RUN)
                  {
                        if(Math.abs(px - target.px) < WEAPON_REACH && Math.abs(py - target.py) < 40 && this.getDirection() == Util.sgn(target.px - px))
                        {
                              return true;
                        }
                  }
                  return false;
            }
      }
}

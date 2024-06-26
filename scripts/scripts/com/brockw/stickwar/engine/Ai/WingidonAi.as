package com.brockw.stickwar.engine.Ai
{
      import com.brockw.game.Util;
      import com.brockw.stickwar.engine.Ai.command.UnitCommand;
      import com.brockw.stickwar.engine.StickWar;
      import com.brockw.stickwar.engine.units.Unit;
      import com.brockw.stickwar.engine.units.Wingidon;
      
      public class WingidonAi extends UnitAi
      {
             
            
            public function WingidonAi(s:Wingidon)
            {
                  super();
                  unit = s;
            }
            
            override public function update(game:StickWar) : void
            {
                  checkNextMove(game);
                  var target:Unit = this.getClosestTarget();
                  if(currentCommand.type == UnitCommand.WINGIDON_SPEED)
                  {
                        Wingidon(unit).speedSpell();
                        restoreMove(game);
                        baseUpdate(game);
                  }
                  Wingidon(unit).aim(target);
                  if(target != null && mayAttack && Wingidon(unit).inRange(target))
                  {
                        unit.faceDirection(Util.sgn(target.px - unit.px));
                  }
                  if(mayAttack && unit.mayAttack(target))
                  {
                        Wingidon(unit).shoot(game,target);
                  }
                  else if(mayMoveToAttack && target != null && Wingidon(unit).inRange(target))
                  {
                        unit.walk((target.px - unit.px - 100 * unit.team.direction) / 100,0,intendedX);
                  }
                  else if(mayMove)
                  {
                        unit.walk((goalX - unit.px) / 100,(goalY - unit.py) / 100,intendedX);
                  }
            }
      }
}

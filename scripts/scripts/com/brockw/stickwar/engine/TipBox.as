package com.brockw.stickwar.engine
{
      import flash.display.*;
      import flash.text.TextField;
      
      public class TipBox extends Sprite
      {
             
            
            private var _toolBox:toolBoxMc;
            
            private var showCount:int;
            
            private var toolBoxShowTime:int;
            
            private var isShowing:Boolean;
            
            public function TipBox(game:StickWar)
            {
                  super();
                  this.toolBox = new toolBoxMc();
                  this.showCount = 0;
                  this.toolBoxShowTime = game.xml.xml.toolBoxShowTime;
                  this.isShowing = false;
            }
            
            public function update(game:StickWar) : void
            {
                  if(this.isShowing)
                  {
                        ++this.showCount;
                        if(this.showCount > this.toolBoxShowTime)
                        {
                              removeChild(this.toolBox);
                              this.isShowing = false;
                        }
                  }
            }
            
            private function setField(data:String, field:TextField) : void
            {
                  field.text = data;
                  field.visible = true;
            }
            
            public function displayTip(title:String, info:String, time:int, gold:int, mana:int, population:int) : void
            {
                  this.setField(info,this.toolBox.text);
                  this.setField(title,this.toolBox.title);
                  this.setField("" + gold,this.toolBox.gold);
                  this.setField("" + time,this.toolBox.time);
                  this.setField("" + mana,this.toolBox.mana);
                  if(population == 0)
                  {
                        this.toolBox.population.visible = false;
                        this.toolBox.populationSymbol.visible = false;
                  }
                  else
                  {
                        this.toolBox.population.visible = true;
                        this.toolBox.populationSymbol.visible = true;
                        this.setField("" + population,this.toolBox.population);
                  }
                  if(!this.contains(this.toolBox))
                  {
                        addChild(this.toolBox);
                  }
                  this.showCount = 0;
                  this.isShowing = true;
            }
            
            public function get toolBox() : toolBoxMc
            {
                  return this._toolBox;
            }
            
            public function set toolBox(value:toolBoxMc) : void
            {
                  this._toolBox = value;
            }
      }
}

package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import flash.events.Event;
      import flash.external.ExternalInterface;
      
      public class VersionMismatchScreen extends Screen
      {
             
            
            private var mc:versionMismatchMc;
            
            private var framesLeft:int;
            
            public function VersionMismatchScreen()
            {
                  super();
                  this.mc = new versionMismatchMc();
                  addChild(this.mc);
            }
            
            override public function enter() : void
            {
                  this.framesLeft = 30 * 5;
                  addEventListener(Event.ENTER_FRAME,this.update);
            }
            
            private function update(evt:Event) : void
            {
                  --this.framesLeft;
                  var time:int = Math.floor(this.framesLeft / 30);
                  if(time < 0)
                  {
                        time = 0;
                  }
                  this.mc.refreshText.text = "Refresh your browser to fix this. Auto refresh in (" + time + ")";
                  if(time <= 0)
                  {
                        if(ExternalInterface.available)
                        {
                              ExternalInterface.call("history.go",0);
                        }
                  }
            }
      }
}

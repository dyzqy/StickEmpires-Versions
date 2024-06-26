package com.brockw.stickwar.engine.replay
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.Main;
      import com.smartfoxserver.v2.requests.*;
      import flash.events.Event;
      import flash.events.MouseEvent;
      import flash.text.*;
      
      public class ReplayLoaderScreen extends Screen
      {
             
            
            private var main:Main;
            
            private var mc:replayLoaderMc;
            
            internal var txtReplayInput:GenericTextInput;
            
            public function ReplayLoaderScreen(main:Main)
            {
                  super();
                  this.main = main;
                  this.mc = new replayLoaderMc();
                  addChild(this.mc);
            }
            
            override public function enter() : void
            {
                  this.mc.viewReplay.addEventListener(MouseEvent.CLICK,this.startReplay);
            }
            
            private function startReplay(ext:Event) : void
            {
                  this.main.replayGameScreen.replayString = this.mc.replayText.text.text;
                  this.main.showScreen("replayGame");
            }
            
            override public function leave() : void
            {
                  this.mc.viewReplay.removeEventListener(MouseEvent.CLICK,this.startReplay);
            }
      }
}

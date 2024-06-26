package com.brockw.stickwar.engine
{
      import com.brockw.stickwar.GameScreen;
      import com.brockw.stickwar.engine.multiplayer.moves.ForfeitMove;
      import flash.events.Event;
      import flash.events.MouseEvent;
      import flash.net.URLRequest;
      import flash.net.navigateToURL;
      
      public class CampaignPauseMenu extends PauseMenu
      {
             
            
            private var mc:pauseMenuCampaign;
            
            private var isConfirming:Boolean;
            
            public function CampaignPauseMenu(gameScreen:GameScreen)
            {
                  super(gameScreen);
                  this.gameScreen = gameScreen;
                  this.mc = new pauseMenuCampaign();
                  addChild(this.mc);
                  tabEnabled = false;
                  tabChildren = false;
                  this.isConfirming = false;
                  this.mc.buttons.backButton.addEventListener(MouseEvent.CLICK,this.backButton);
                  this.mc.buttons.howToPlayButton.addEventListener(MouseEvent.CLICK,this.howToPlayButton);
                  this.mc.buttons.restartButton.addEventListener(MouseEvent.CLICK,this.restartButton);
                  this.mc.buttons.quitButton.addEventListener(MouseEvent.CLICK,this.quitButton);
                  this.mc.soundToggle.buttonMode = true;
                  this.mc.musicToggle.buttonMode = true;
                  this.mc.visible = false;
            }
            
            private function quitButton(evt:Event) : void
            {
                  var f:ForfeitMove = new ForfeitMove();
                  gameScreen.doMove(f,gameScreen.team.id);
            }
            
            private function restartButton(evt:Event) : void
            {
                  gameScreen.main.showScreen(gameScreen.main.currentScreen(),true);
            }
            
            private function backButton(evt:Event) : void
            {
                  this.hideMenu();
            }
            
            private function howToPlayButton(evt:Event) : void
            {
                  var url:URLRequest = new URLRequest("http://www.stickpage.com");
                  navigateToURL(url,"_blank");
            }
            
            override public function cleanUp() : void
            {
                  this.mc.buttons.backButton.removeEventListener(MouseEvent.CLICK,this.backButton);
                  this.mc.buttons.howToPlayButton.removeEventListener(MouseEvent.CLICK,this.howToPlayButton);
                  this.mc.buttons.restartButton.removeEventListener(MouseEvent.CLICK,this.restartButton);
                  this.mc.buttons.quitButton.removeEventListener(MouseEvent.CLICK,this.quitButton);
            }
            
            override public function update() : void
            {
                  super.update();
                  if(isShowing)
                  {
                        this.mc.visible = true;
                        this.gameScreen.isPaused = true;
                        this.mc.buttons.visible = true;
                        this.mc.confirmation.visible = false;
                        if(this.isConfirming)
                        {
                              this.mc.buttons.visible = false;
                              this.mc.confirmation.visible = true;
                        }
                        if(gameScreen.userInterface.isSound)
                        {
                              this.mc.soundToggle.gotoAndStop(1);
                        }
                        else
                        {
                              this.mc.soundToggle.gotoAndStop(3);
                        }
                        if(gameScreen.userInterface.isMusic)
                        {
                              this.mc.musicToggle.gotoAndStop(1);
                        }
                        else
                        {
                              this.mc.musicToggle.gotoAndStop(3);
                        }
                        if(this.mc.soundToggle.hitTestPoint(stage.mouseX,stage.mouseY))
                        {
                              if(gameScreen.userInterface.mouseState.mouseDown)
                              {
                                    gameScreen.userInterface.isSound = !gameScreen.userInterface.isSound;
                                    gameScreen.userInterface.mouseState.mouseDown = false;
                              }
                        }
                        if(this.mc.musicToggle.hitTestPoint(stage.mouseX,stage.mouseY))
                        {
                              if(gameScreen.userInterface.mouseState.mouseDown)
                              {
                                    gameScreen.userInterface.isMusic = !gameScreen.userInterface.isMusic;
                                    gameScreen.userInterface.mouseState.mouseDown = false;
                              }
                        }
                        return;
                  }
                  this.mc.visible = false;
                  this.gameScreen.isPaused = false;
            }
      }
}

package com.brockw.stickwar.campaign
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      import flash.display.MovieClip;
      import flash.events.*;
      
      public class CampaignScreen extends Screen
      {
             
            
            private var main:BaseMain;
            
            private var txtDisplayLevel:GenericText;
            
            private var btnNextLevel:GenericButton;
            
            private var btnMainMenu:GenericButton;
            
            private var mc:campaignMap;
            
            public function CampaignScreen(main:BaseMain)
            {
                  super();
                  this.main = main;
                  this.mc = new campaignMap();
                  addChild(this.mc);
                  this.mc.x = -657.7;
                  this.mc.y = -584.9;
            }
            
            override public function maySwitchOnDisconnect() : Boolean
            {
                  return false;
            }
            
            override public function enter() : void
            {
                  if(this.main.campaign.currentLevel != 0)
                  {
                        this.mc.gotoAndStop("level" + this.main.campaign.currentLevel);
                  }
                  else
                  {
                        this.mc.gotoAndStop(1);
                        this.mc.map.stop();
                  }
                  addEventListener(Event.ENTER_FRAME,this.update);
                  addEventListener(MouseEvent.CLICK,this.click);
                  this.mc.story.gotoAndStop(1);
                  this.mc.bottomPanel.campaignButtons.saveGame.addEventListener(MouseEvent.CLICK,this.saveButtonClick);
                  this.mc.saveGamePrompt.visible = false;
                  this.mc.saveGamePrompt.okButton.addEventListener(MouseEvent.CLICK,this.okButton);
            }
            
            private function okButton(even:Event) : void
            {
                  this.mc.saveGamePrompt.visible = false;
            }
            
            private function saveButtonClick(evt:Event) : void
            {
                  this.main.campaign.save();
                  this.mc.saveGamePrompt.visible = true;
                  this.mc.saveGamePrompt.messageText.text = "Game saved at " + this.main.campaign.getCurrentLevel().title;
            }
            
            private function click(evt:MouseEvent) : void
            {
                  if(evt.target == this.mc.map.playbuttonflag && this.mc.currentFrameLabel == "level" + (this.main.campaign.currentLevel + 1))
                  {
                        this.clickPlay(null);
                  }
            }
            
            public function update(evt:Event) : void
            {
                  this.mc.stop();
                  if(this.mc.currentFrameLabel != "level" + (this.main.campaign.currentLevel + 1))
                  {
                        this.mc.nextFrame();
                        this.mc.map.playbuttonflag.turning.visible = false;
                  }
                  else
                  {
                        this.mc.map.playbuttonflag.turning.visible = true;
                        this.mc.story.y += (609 - this.mc.story.y) * 1;
                        this.mc.story.nextFrame();
                        this.mc.story.text.text = this.main.campaign.getCurrentLevel().storyName;
                        this.mc.story.title.text = this.main.campaign.getCurrentLevel().title;
                        this.mc.bottomPanel.y += (1192.15 - this.mc.bottomPanel.y) * 1;
                  }
                  MovieClip(this.mc.map.playbuttonflag.turning).mouseEnabled = false;
                  MovieClip(this.mc.map.playbuttonflag.turning).mouseChildren = false;
                  MovieClip(this.mc.map.playbuttonflag).buttonMode = true;
                  this.mc.map.gotoAndStop(this.mc.currentFrame);
            }
            
            override public function leave() : void
            {
                  removeEventListener(Event.ENTER_FRAME,this.update);
                  removeEventListener(MouseEvent.CLICK,this.click);
                  this.mc.saveGamePrompt.okButton.removeEventListener(MouseEvent.CLICK,this.okButton);
            }
            
            private function clickMainMenu(evt:MouseEvent) : void
            {
                  this.main.showScreen("login");
            }
            
            private function clickPlay(evt:MouseEvent) : void
            {
                  this.main.showScreen("campaignGameScreen",false,true);
            }
      }
}

package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.stickwar.Main;
      import com.smartfoxserver.v2.entities.data.*;
      import com.smartfoxserver.v2.requests.*;
      import com.smartfoxserver.v2.requests.buddylist.*;
      import flash.events.Event;
      
      public class BuddyChatTab extends buddyChatMc
      {
             
            
            public var id:int;
            
            private var _isMinimized:Boolean;
            
            internal var main:Main;
            
            private var _buddy:Buddy;
            
            public function BuddyChatTab(id:int, main:Main)
            {
                  super();
                  this.main = main;
                  this._isMinimized = false;
                  this.id = id;
                  this.chatWindow.visible = true;
                  this.chatWindow.chatInput.addEventListener(Event.CHANGE,this.sendChatMessage);
                  this.chatWindow.chatInput.text = "";
                  this.chatWindow.chatOutput.text = "";
                  this.buddyText.mouseEnabled = false;
                  this.buddy = null;
            }
            
            public function minimize() : void
            {
                  this.chatWindow.visible = false;
                  this._isMinimized = true;
            }
            
            public function toggleChat() : void
            {
                  if(this._isMinimized)
                  {
                        this.chatWindow.visible = true;
                  }
                  else
                  {
                        this.chatWindow.visible = false;
                  }
                  this._isMinimized = !this._isMinimized;
            }
            
            private function sendChatMessage(evt:Event) : void
            {
                  var params:SFSObject = null;
                  var txt:String = String(this.chatWindow.chatInput.text);
                  if(txt.charCodeAt(txt.length - 1) == 13)
                  {
                        txt = txt.slice(0,txt.length - 1);
                        params = new SFSObject();
                        params.putInt("id",this.id);
                        params.putUtfString("m",txt);
                        params.putUtfString("n",this.main.sfs.mySelf.name);
                        this.main.sfs.send(new ExtensionRequest("buddyChat",params));
                        this.chatWindow.chatInput.text = "";
                  }
            }
            
            public function get buddy() : Buddy
            {
                  return this._buddy;
            }
            
            public function set buddy(value:Buddy) : void
            {
                  this._buddy = value;
            }
      }
}

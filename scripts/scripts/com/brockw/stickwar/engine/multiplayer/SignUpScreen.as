package com.brockw.stickwar.engine.multiplayer
{
      import com.brockw.game.Screen;
      import com.brockw.stickwar.BaseMain;
      
      public class SignUpScreen extends Screen
      {
             
            
            public var signUpForm:PreRegisterForm;
            
            public function SignUpScreen(main:BaseMain)
            {
                  super();
                  addChild(this.signUpForm = new PreRegisterForm(main));
            }
            
            override public function enter() : void
            {
                  this.signUpForm.enter();
            }
            
            override public function leave() : void
            {
                  this.signUpForm.leave();
            }
      }
}

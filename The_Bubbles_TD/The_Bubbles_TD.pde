/*
******************************************
HomeLESS: The Bubbles TD
Home Laser Shooting Simulator: The Bubbles TD
version 0.5a
by Laabicz
laabicz@gmail.com

www.homeless-eng.webnode.com

last rev. 2014-10-22  (yyyy-mm-dd)
******************************************
*/


import ddf.minim.*;



Minim minim;
AudioSample sound_shoot, sound_reload;

void setup()
{
  frameRate(30);
  size(i_window_ressolution_X, i_window_ressolution_Y);
  smooth();
  background(200);
  
  udp = new UDP( this, i_Source_port, s_Source_IP_addres );
  udp.log( false );        // <-- printout the connection activity
  udp.listen( true );
  
  minim = new Minim(this);

  sound_shoot = minim.loadSample( "hit.mp3", 512); // filename , buffer size
  
  balls_init(i_number_of_balls);
  bullet_init(i_number_of_bullets); 
  
  //start with
  stop_shooting();

}

void draw()
{
  //refresh border of area of interest window
  fill(200);
  rect(0, 0, i_area_of_interest_offset_X + i_area_of_interest_width + 5, i_window_ressolution_Y);
  //refresh area of interest
  fill(i_area_of_interest_background);
  rect(i_area_of_interest_offset_X, i_area_of_interest_offset_Y, i_area_of_interest_width, i_area_of_interest_height);
  
  //balls...
  for (int i = 0; i < i_number_of_balls;i++)
  {
    myBall[i].collision_check();
    
    //only unhit ball can move
    if ( !myBall[i].hit) 
    {
      myBall[i].move();
    }
    myBall[i].display(); 
  }
  
  
  //timer
  if(b_timer && (i_ball_left > 0))
  {
    i_time_of_shooting_millis = millis();
    i_time_of_shooting_millis -= i_time_of_shooting_millis_started;
    f_time_of_shooting = (i_time_of_shooting_millis/1000.0) + i_time_of_penalty;
    //System.out.println("Time: " + nf(f_time_of_shooting,3,2));
  }
  else //get time of start of shooting
  {
    i_time_of_shooting_millis_started = millis();
  }
  
  
  //reload rectangle
  if(i_ball_left == 0)
  {
    draw_reload_rectangle(i_reload_rectangle_position_X, i_reload_rectangle_position_Y, i_reload_rectangle_size_X, i_reload_rectangle_size_Y);
  }
  
  
  for (int i = 0; i < i_bullets_left_counter; i++)
  {
    myBullet[i].display();
  }
  
  //autoreload
  if(i_bullets_left_counter == 0)
  {
     bullet_reload();
  }
  
  //check time limit
  if(f_time_of_shooting > f_time_of_shoting_maximum)
  {
    for (int i = 0; i < i_number_of_balls;i++)
    {
      myBall[i].hit = true;
      i_ball_left = 0;
      f_time_of_shooting = 10;
    }
  }
  
  draw_stats();
}












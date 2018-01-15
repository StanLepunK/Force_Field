
/**
FORCE FIELD
2017-2018
by Stan le Punk
http://stanlepunk.xyz/
v 0.1.0
*/
/**
Force Field is a refactoring Flow field from The Nature of Code by Daniel Shiffman
http://natureofcode.com

Flow Field Following / Force Field / Vector field 
the link below is not up to date
Via Reynolds: http://www.red3d.com/cwr/steer/FlowFollow.html

Stable fluids from Jos Stam's work on the Navier-Stokes equation
*/
boolean pause_is ;
boolean use_leapmotion = false;

boolean fullScreen_is = false;
boolean change_size_window_is = true;
boolean fullfit_image_is = false;

boolean display_result = true;

boolean hide_menu_bar = false;


PGraphics pg ;

int type_field;

int which_cam = 0 ; // 0 is the camera fullsize / max frameRate by default if there is camera plug is the external cam is catch

// Using this variable to decide whether to draw all the stuff
void settings() {
  if(fullScreen_is) {
    // fullScreen(P2D,1);
    fullScreen(P2D);      
  } else {
    size(900,600,P2D);
    //size(1600,870,P2D); // 2eme écran macbook
    // size(1900,1200,P2D); // 2 recopie écran macbook
  }
  set_cell_grid_ff(10);
  // type_field = r.FLUID;
  //  type_field = r.GRAVITY; /* you can also use HOLE constant */
  // type_field = r.MAGNETIC;
  //type_field = r.PERLIN;
  // type_field = r.CHAOS;
 type_field = IMAGE;

  if(hide_menu_bar) PApplet.hideMenuBar();
}








/**
SETUP

*/
void setup() {
  background(0);
  // noCursor();
  // warp_instruction();

  if(use_leapmotion) leap_setup();

  /**
  force field setting
  Choice which vector you want use
  */



  /**
  warp force field
  */
  warp_setup();

  /**
  classic build
  */

  // build_force_field(type_field,size_cell);
  // num_spot_force_field(2); 

  /**
  vehicle example
  */
  
  /*
  int num_vehicle = 1000;
  build_vehicle(num_vehicle);
  */
  set_info(false);
  interface_setup(Vec2(0), Vec2(250,height));
  warp_instruction(); 
}


/**
DRAW

*/
void draw() {
  if(hide_menu_bar) PApplet.hideMenuBar();
  // cursor(CROSS);
  if(use_leapmotion) leap_update();

  /*
  update force field
  */
  /* 
  condition to update force field
  */
  boolean run_is = true;
  boolean inside_gui = inside(get_pos_interface(), get_size_interface(), Vec2(mouseX,mouseY));

  if(interface_is() && inside_gui) {
    run_is = false ;  
  } else if(!interface_is()) {
    run_is = true ;
  } 

  if(use_leapmotion) run_is = true ;
  if(pause_is) run_is = false ;
  if(run_is) { 
    if(use_leapmotion) {
      force_field_spot_condition_leapmotion();
      force_field_spot_coord_leapmotion();
    } else {
      force_field_spot_condition(true);
      force_field_spot_coord(iVec2(mouseX,mouseY),mousePressed);
    }

    if(get_type_ff() == r.FLUID) {
      //
    } else if(get_type_ff() == r.MAGNETIC) {
      force_field_spot_diam();
      force_field_spot_tesla();
    } else if(get_type_ff() == r.GRAVITY) {
      force_field_spot_diam();
      force_field_spot_mass();
    } 
    update_ff(); 
  }




  /*
  warp management
  */
  warp_init(type_field, get_size_cell_ff(), which_cam, change_size_window_is, fullfit_image_is);
  num_spot_ff(get_num_spot_gui()); 
  /*
  warp result
  */
  if(display_result) {
    tint(g.colorModeX,g.colorModeY,g.colorModeZ,get_alpha_bg());
    warp_draw(get_tempo_refresh_gui(), get_rgba_channel_gui(), get_warp_power_gui());
  } else {
    if(get_alpha_bg() > 0 ) background_rope(0,get_alpha_bg());
  }
   
   /**
   INFO
   */
  info(display_field, display_grid, display_pole);

  if(force_field != null) force_field.reverse_flow(false);
  /**
  interface gui
  */
  get_controller_gui();
  update_gui_value();
  interface_display(use_leapmotion, force_field);

  if(!ff_is()) {
    println("new force field grid, with cell size:", get_size_cell_ff());
    init_ff(get_type_ff(),get_size_cell_ff(),g);
  }
  
  if(get_type_ff() == IMAGE) {
    if(!sort_channel_is()) {
      force_field_init_is = false ;
      build_ff(force_field.get_type(), get_resultion_ff(), warp.get_image(), get_sorting_channel_ff_2D());
      update_ff();
    }
  }

  cursor_manager(interface_is());

  diaporama(240);
}
/**
END DRAW
*/


























Vec2 [] pos_finger ;
void force_field_spot_coord_leapmotion() {
  // init var
  if(pos_finger == null && get_spot_num_ff() > 0) {
    pos_finger = new Vec2[get_spot_num_ff()];
    for(int i = 0 ; i < pos_finger.length ; i++) {
      pos_finger[i] = Vec2(width/2,height/2);
    }
  }

  if(finger.is() && pos_finger != null) {
    for(int i = 0 ; i < get_spot_num_ff() ; i++) {
      if(finger.visible()[i]) {
        float x = finger.get_pos()[i].x;
        float y = finger.get_pos()[i].y;
        y = map(y,0,1,1,0);
        pos_finger[i] = Vec2(x,y);
        pos_finger[i].mult(width,height);
      } else {
        // pos_finger[i] = Vec2(-width,-height);
      }
    }
    /*
    for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() && i < pos_finger.length; i++) {
      if(finger.visible()[i]) {
        float x = finger.get_pos()[i].x;
        float y = finger.get_pos()[i].y;
        y = map(y,0,1,1,0);
        pos_finger[i] = Vec2(x,y);
        pos_finger[i].mult(width,height);
      }
    }
    */
    update_spot_ff_coord(pos_finger);
  }
}


void force_field_spot_condition_leapmotion() {
  if(get_spot_num_ff() > 0) {
    boolean [] bool = new boolean[get_spot_num_ff()];
    for(int i = 0 ; i < bool.length ; i++) {
      bool[i] = false ;
    }
    if(finger.is()) {
      for(int i = 0 ; i < finger.get_num() && i < get_spot_num_ff() ; i++) {
        if(finger.visible()[i]) bool[i] = true ; else bool[i] = false ;
      }
    }
    update_spot_ff_is(bool);
  }
}

float distance ;
iVec2 ref_pos ;
void force_field_spot_coord(iVec2 ipos, boolean is) {
  if(get_spot_num_ff() > 0) {
    Vec2 [] pos = new Vec2[get_spot_num_ff()];
    // case 1
    if(get_spot_num_ff() == 1 && is) {
      pos[0] = Vec2(ipos.x, ipos.y);
    }
    // case 2
    if(get_spot_num_ff() == 2 && is) {
      pos[0] = Vec2(ipos.x, ipos.y);
      pos[1] = Vec2(width -ipos.x, height -ipos.y);
    }
    // case 3
    if(get_spot_num_ff() > 2) {
      int num_spot = get_spot_num_ff();
      float range_angle = TAU - get_angle_mouse();
      float step_angle = range_angle /num_spot;

      distance += get_speed_mouse(); 
      float final_angle = 0 ;
      float radius = height /4 ;
      for(int i = 0 ; i < pos.length ; i++) {
        /*
        growth system
        final_angle += step_angle ; 
        final_angle += distance;
        Vec2 proj = projection(final_angle, get_radius_mouse());
        */
        final_angle = step_angle *i ; 
        final_angle += distance;
        Vec2 proj = projection(final_angle, get_radius_mouse());
       
        pos[i] = Vec2(proj);
        if(is) {
          if(ref_pos == null) {
            ref_pos = iVec2(mouseX,mouseY);
          } else {
            ref_pos.set(mouseX,mouseY);
          }
        }
        pos[i].add(ref_pos);        
      }
    }
    update_spot_ff_coord(pos);
  }
}

void force_field_spot_condition(boolean is) {
  if(get_spot_num_ff() > 0) {
    boolean [] bool = new boolean[get_spot_num_ff()];
    for(int i = 0 ; i < bool.length ; i++) {
      bool[i] = false ;
    }
    // if(mousePressed && mouseButton == LEFT) bool_1 = true ;
    // if(mousePressed && mouseButton == RIGHT) bool_2 = true ;
    if(is) {
      for(int i = 0 ; i < bool.length ; i++) {
        bool[i] = true ;
      }
    }
    update_spot_ff_is(bool);
  }
}


void force_field_spot_diam() {
  int diam_spot = get_resultion_ff()/2 ;
  if(get_spot_num_ff() > 0) {
    int [] diam = new int[get_spot_num_ff()];
    for(int i = 0 ; i < diam.length ; i++) {
      diam[i] = diam_spot ; 
    }
    update_spot_ff_diam(diam);
  }
}

void force_field_spot_tesla() {
  int charge_tesla = 10 ;
  if(get_spot_num_ff() > 0) {
    int [] tsl = new int[get_spot_num_ff()];
    for(int i = 0 ; i < tsl.length ; i++) {
      if(i%2 == 0) tsl[i] = charge_tesla ; else tsl[i] = -charge_tesla;
    }
    update_spot_ff_tesla(tsl);
  }
}

void force_field_spot_mass() {
  int mass = 10 ;
  if(get_spot_num_ff() > 0) {
    int [] m = new int[get_spot_num_ff()];
    for(int i = 0 ; i < m.length ; i++) {
      if(i%2 == 0) m[i] = mass ; else m[i] = mass *3;
    }
    update_spot_ff_mass(m);
  }
}






















/**
KEYPRESSED

*/


void keyPressed() {
  println("keyPressed", frameCount);
  if(key == 'a') {
    // @see if(key == 'n')
    warp_add_media_folder();
    play_video(false);
  }

  if(key == 'b') manage_border();

  if(key == 'c') hide_interface();

  if(key == 'd') diaporama_is();

  if(key == 'f') display_field();

  if(key == 'g') display_grid();

  if(key == 'h') display_pole();

  if(key == 'i') display_info();

  if(key == 'k') display_result();

  if(key == 'l') change_cursor_controller();

  if(key == 'n') {
    // @see if(key == 'a')
   warp_change_media_folder();
   play_video(false);
  }

  if(key == 'p') {
    println("export jpg");
    saveFrame();   
  }

  if(key == 'r') {
    reset_vehicle();
    warp.reset();  
    if(force_field.get_type() == IMAGE) {
      force_field_init_is = false ;
      build_ff(force_field.get_type(), get_resultion_ff(), warp.get_image(), get_sorting_channel_ff_2D());
    }
    force_field.refresh();
  }


  if(key == 'v') play_video_switch();

  if(key == 'w') {
    if(shader_filter_is) shader_filter_is = false ; else shader_filter_is = true ;
  }

  if(key == 'x') change_type_ff() ;

  if(key == 'z') {
    force_field.reset();
  }

  if(key == ' ') {
    if(pause_is) pause_is = false ; else pause_is = true ;
  }
  

  // navigation in the media movie or picture
  if(keyCode == UP) { 
    which_img--;
    /*
    we don't use 0 to the first element of the array because this one is use for G / surface
    see void warp_init(int type_field, int size_cell) 
    */
    if(which_img < 1) which_img = warp.library_size() -1 ;
    if(movie_warp_list != null) {
      which_movie--;
      if(which_movie < 0) which_movie = movie_warp_list.size() -1 ;
    }   
  }

  if(keyCode == DOWN) { 
    which_img++; 
    /*
    we don't use 0 to the first element of the array because this one is use for G / surface
    see void warp_init(int type_field, int size_cell) 
    */
    if(which_img >= warp.library_size()) which_img = 1 ;
    if(movie_warp_list != null) {
      which_movie++;
      if(which_movie >= movie_warp_list.size()) which_movie = 0 ;
    }    
  }
}
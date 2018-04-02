/**
external GUI Force
2017-2018
http://stanlepunk.xyz/
v 0.1.0
*/
import oscP5.*;
import netP5.*;

OscP5 osc ;
NetAddress destination;
int port = 12_000;

boolean use_leapmotion = false;


void setup() {
	size(500,550,P2D);
	surface.setLocation(30,30);
	osc = new OscP5(this,port);
	destination = new NetAddress("127.0.0.1",port);

	mode = new boolean[num_mode];
	gui_setup(Vec2(0), Vec2(250,height));

}

void draw() {
	background(0);
	send_value_controller();
	show_gui();
	set_controller_from_outside();
	if(mousePressed) update_media_list();
	load_data_from_app_force(240, !mousePressed);

	if(misc_curtain_is()) {
		set_state_button(gui_button, display_method_name[0], true);
		for(int i = 1 ; i < display_method_name.length ; i++) {
			set_state_button(gui_button, display_method_name[i], false);
		} 		
	}
}




void update_media_list() {
	String[] medias = loadStrings(sketchPath(1)+"/save/path_media.txt");
  for(int i = 0 ; i < medias.length ; i++) {
  	String [] s = split(medias[i], "/");
  	medias[i] = s[s.length -1];
  }
	if(medias != null) {
		media.clear();
		for(int i = 1 ; i < medias.length ;i++) {
			media.addItem(medias[i],i-1);
		}
		// media.addItems(medias);
	} else {
		printErr("method update_media_list() don't find a file to update");
	}
}








float ref_value_slider ;
void send_value_controller() {
	float current_value_slider = sum_slider();
	if(!misc_curtain_is() && (current_value_slider != ref_value_slider || state_button_is()) ) {
		state_button(false);
		send();
		ref_value_slider = current_value_slider ;
	}
}




float pos_slider_y(int space, float start_pos, int from) {
	float pos_y = 0 ;
	if(from == BOTTOM || from == DOWN) {
		pos_y = height -(space *start_pos);
	} else {
		pos_y = space *start_pos;
	}
	return pos_y ;
}


